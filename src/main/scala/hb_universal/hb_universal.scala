// Finitie impulse filter
package hb_universal
import config._
import config.{hbConfig}

import java.io.File

import chisel3._
import chisel3.experimental.FixedPoint
import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.util.ShiftRegister
import dsptools._
import dsptools.numbers.DspComplex

class hb_universalCTRL(gainBits: Int) extends Bundle {
    val scale  = Input(UInt(gainBits.W))
    val convmode = Input(UInt(1.W))
    val output_switch = Input(UInt(1.W))
    val enable_clk_div= Input(UInt(1.W))
}

class hb_universalIO(resolution: Int, gainBits: Int) extends Bundle {
    val control = new hb_universalCTRL(gainBits)
    val in = new Bundle {
        val iptr_A = Input(DspComplex(SInt(resolution.W), SInt(resolution.W)))
    }
    val out = new Bundle {
        val Z = Output(DspComplex(SInt(resolution.W), SInt(resolution.W)))
    }
}

class hb_universal(config: hbConfig) extends Module {
    val io = IO(new hb_universalIO(resolution=config.resolution, gainBits=config.gainBits))
    val data_reso = config.resolution
    val calc_reso = config.resolution * 2

    // Inner clk div
    val en_reg =  withClockAndReset((!(clock.asUInt)).asClock,ShiftRegister(reset,2,0.B,true.B).asBool){RegInit(0.U(1.W))} 
    en_reg := io.control.enable_clk_div
    val fb_reg = withClockAndReset((clock.asBool && en_reg.asBool).asClock,reset){RegInit(0.U(1.W)) }
    val clk_div_2_reg = withClockAndReset((clock.asBool && en_reg.asBool).asClock,reset){RegInit(0.U(1.W)) }
    withClockAndReset((clock.asBool && en_reg.asBool).asClock,reset){ 
      fb_reg := !fb_reg
      clk_div_2_reg := !fb_reg
    }
   
    //The half clock rate domain
    val coeff1_len=(config.H.indices.filter(_ % 2 == 0).map(config.H(_))).size
    val coeff2_len=(config.H.indices.filter(_ % 2 == 1).map(config.H(_))).size
    println("even coeffs count:")
    println(coeff1_len)
    println("odd coeffs count:")
    println(coeff2_len)
    val registerchain2 = withClock (clk_div_2_reg.asBool.asClock){RegInit(VecInit(Seq.fill(coeff2_len + 1)(DspComplex.wire(0.S(calc_reso.W), 0.S(calc_reso.W)))))}
    val registerchain1 = withClock(clk_div_2_reg.asBool.asClock){RegInit(VecInit(Seq.fill(coeff1_len + 1)(DspComplex.wire(0.S(calc_reso.W), 0.S(calc_reso.W)))))}
    val subfil2 = registerchain2(coeff2_len)
    val subfil1 = registerchain1(coeff1_len)


    val clk_mux_input = Mux(io.control.convmode.asBool,clock.asUInt.asBool,clk_div_2_reg.asBool).asClock
    val clk_mux_output = Mux(io.control.convmode.asBool,clk_div_2_reg.asBool,clock.asUInt.asBool).asClock


    val inregs = withClock(clk_mux_input){RegInit(VecInit(Seq.fill(2)(DspComplex.wire(0.S(data_reso.W), 0.S(data_reso.W)))))} //registers for sampling rate reduction
    withClock(clk_mux_input){
        inregs(0):= io.in.iptr_A
        inregs(1):=inregs(0)
    }
    
    val outreg =withClock(clk_mux_output){ RegInit(DspComplex.wire(0.S(data_reso.W), 0.S(data_reso.W)))}
    withClock(clk_mux_output){ 
        when(io.control.convmode.asBool){
            outreg.real := ((subfil1.real + subfil2.real) << io.control.scale)(calc_reso - 1, calc_reso - data_reso).asSInt
            outreg.imag := ((subfil1.imag + subfil2.imag) << io.control.scale)(calc_reso - 1, calc_reso - data_reso).asSInt
        
        }.otherwise{
            when ((clk_div_2_reg ^ io.control.output_switch) === true.B) { 
                outreg.real := (subfil1.real << io.control.scale)(calc_reso - 1, calc_reso - data_reso).asSInt
                outreg.imag := (subfil1.imag << io.control.scale)(calc_reso - 1, calc_reso - data_reso).asSInt
            }.elsewhen ((clk_div_2_reg ^ io.control.output_switch) === false.B) { 
                outreg.real := (subfil2.real << io.control.scale)(calc_reso - 1, calc_reso - data_reso).asSInt
                outreg.imag := (subfil2.imag << io.control.scale)(calc_reso - 1, calc_reso - data_reso).asSInt
            }
        }
    }

    io.out.Z := outreg

    withClock (clk_div_2_reg.asBool.asClock){
        val slowregs  = RegInit(VecInit(Seq.fill(2)(DspComplex.wire(0.S(data_reso.W), 0.S(data_reso.W))))) //registers for sampling rate reduction

        when(io.control.convmode.asBool){
            slowregs(0):=inregs(0)
        }.otherwise{
            slowregs(0):=inregs(1)
        }
        slowregs(1):=inregs(1)

        val sub1coeffs = config.H.indices.filter(_ % 2 == 0).map(config.H(_)) //Even coeffs for Fir1
        println("HB even coeffs")
        println(sub1coeffs)

        val tapped1 = sub1coeffs.reverse.map(tap => slowregs(0) * tap)

        for ( i <- 0 until tapped1.length) {
            if (i == 0) {
                registerchain1(i + 1) := tapped1(i)
            } else {
                registerchain1(i + 1).real := registerchain1(i).real + tapped1(i).real
                registerchain1(i + 1).imag := registerchain1(i).imag + tapped1(i).imag
            }
        }
        
        val sub2coeffs=config.H.indices.filter(_ % 2 == 1).map(config.H(_)) //Odd coeffs for Fir 2
        println("HB odd coeffs")
        println(sub2coeffs)

        val tapped2 = sub2coeffs.reverse.map(tap => slowregs(1) * tap)

        for ( i <- 0 until tapped2.length) {
            if (i == 0) {
                registerchain2(i + 1) := tapped2(i)
            } else {
                registerchain2(i + 1).real := registerchain2(i).real + tapped2(i).real
                registerchain2(i + 1).imag := registerchain2(i).imag + tapped2(i).imag
            }
        }
    }    
}



/** Generates verilog or sv*/
object hb_universal extends App with OptionParser {
  // Parse command-line arguments
  val (options, arguments) = getopts(default_opts, args.toList)
  printopts(options, arguments)

  val config_file = options("config_file")
  val target_dir = options("td")
  var hb_config: Option[hbConfig] = None
  hbConfig.loadFromFile(config_file) match {
    case Left(config) => {
      hb_config = Some(config)
    }
    case Right(err) => {
      System.err.println(s"\nCould not load FIR configuration from file:\n${err.msg}")
      System.exit(-1)
    }
  }

  // Generate verilog
  val annos = Seq(ChiselGeneratorAnnotation(() => new hb_universal(config=hb_config.get)))
  //(new ChiselStage).execute(arguments.toArray, annos)
  val sysverilog = (new ChiselStage).emitSystemVerilog(
    new hb_universal(config=hb_config.get),
     
    //args
    Array("--target-dir", target_dir))
}



/** Module-specific command-line option parser */
trait OptionParser {
  // Module specific command-line option flags
  val available_opts: List[String] = List(
      "-config_file",
      "-td"
  )

  // Default values for the command-line options
  val default_opts : Map[String, String] = Map(
    "config_file"->"fir-config.yml",
    "td"->"verilog/"
  )

  /** Recursively parse option flags from command line args
   * @param options Map of command line option names to their respective values.
   * @param arguments List of arguments to parse.
   * @return a tuple whose first element is the map of parsed options to their values 
   *         and the second element is the list of arguments that don't take any values.
   */
  def getopts(options: Map[String, String], arguments: List[String]) : (Map[String, String], List[String]) = {
    val usage = s"""
      |Usage: ${this.getClass.getName.replace("$","")} [-<option> <argument>]
      |
      | Options
      |     -config_file        [String]  : Generator YAML configuration file name. Default "fir-config.yml".
      |     -td                 [String]  : Target dir for building. Default "verilog/".
      |     -h                            : Show this help message.
      """.stripMargin

    // Parse next elements in argument list
    arguments match {
      case "-h" :: tail => {
        println(usage)
        sys.exit()
      }
      case option :: value :: tail if available_opts contains option => {
        val (newopts, newargs) = getopts(
            options ++ Map(option.replace("-","") -> value), tail
        )
        (newopts, newargs)
      }
      case argument :: tail => {
        val (newopts, newargs) = getopts(options, tail)
        (newopts, argument.toString +: newargs)
      }
      case Nil => (options, arguments)
    }
  }

  /** Print parsed options and arguments to stdout */
  def printopts(options: Map[String, String], arguments: List[String]) = {
    println("\nCommand line options:")
    options.nonEmpty match {
      case true => for ((k,v) <- options) {
        println(s"  $k = $v")
      }
      case _ => println("  None")
    }
    println("\nCommand line arguments:")
    arguments.nonEmpty match {
      case true => for (arg <- arguments) {
        println(s"  $arg")
      }
      case _ => println("  None")
    }
  }
}

