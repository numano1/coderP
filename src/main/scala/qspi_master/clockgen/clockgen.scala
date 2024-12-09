package clockgen

import chisel3._
import chisel3.util._
import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}

// Define the IO for the clock generator
class clockgenIO extends Bundle {
  val en = Input(Bool())
  val clk_div_valid = Input(Bool())
  val clk_div = Input(UInt(8.W))
  val spi_clk = Output(Bool())  // Changed to Bool
  val spi_fall = Output(Bool())
  val spi_rise = Output(Bool())
}

// Define the clock generator module
class clockgen extends Module {
  val io = IO(new clockgenIO)

  // Internal registers
  val counter_target = RegInit(0.U(8.W))
  val counter = RegInit(0.U(8.W))
  val spi_clk_reg = RegInit(false.B)
  val running = RegInit(false.B)

  // Wires
  val counter_target_next = WireDefault(counter_target) // Default initialization
  val counter_next = WireDefault(counter)              // Default initialization
  val spi_clk_next = WireDefault(spi_clk_reg)          // Default initialization

  // Default values for outputs
  io.spi_rise := false.B
  io.spi_fall := false.B

  // Update target counter
  counter_target_next := Mux(io.clk_div_valid, io.clk_div, counter_target)

  // Main clock toggling logic
  when(counter === counter_target) {
    counter_next := 0.U
    spi_clk_next := !spi_clk_reg
    when(spi_clk_reg === false.B) {
      io.spi_rise := running
    }.otherwise {
      io.spi_fall := running
    }
  }.elsewhen(counter =/= counter_target) {
    counter_next := counter + 1.U
    spi_clk_next := spi_clk_reg
  }

  // Sequential updates
  counter_target := counter_target_next
  when(!(spi_clk_reg === false.B && !io.en)) {
    running := true.B
    spi_clk_reg := spi_clk_next
    counter := counter_next
  }.otherwise {
    running := false.B
  }

  // Assign spi_clk as Bool
  io.spi_clk := spi_clk_reg
}

/** Generates Verilog or SystemVerilog */
object clockgen extends App {
  // Generate Verilog
  val annos = Seq(ChiselGeneratorAnnotation(() => new clockgen()))
  (new ChiselStage).execute(args, annos)
}
