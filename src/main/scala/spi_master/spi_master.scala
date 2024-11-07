package spi_master

import chisel3._
import chisel3.util._
import chisel3.util.{log2Ceil}
import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}

class spi_masterIO(dataWidth: Int) extends Bundle {
  val cpol = Input(Bool())
  val cpha = Input(Bool())
  val mosi = Output(Bool())
  val miso = Input(Bool())
  val sclk = Output(Clock())
  val cs   = Output(Bool())

  val slaveData = Input(UInt(dataWidth.W))   // Data to transmit
  val slaveDataValid = Input(Bool())         // Signal to start transmission

  val masterData = Output(UInt(dataWidth.W)) // Data received
}

class spi_master(ClockPrescaler: Int = 2, dataWidth: Int = 8) extends Module {
  val io = IO(new spi_masterIO(dataWidth))

  val idle :: halfCycle :: sampleAndPrepare :: shift :: Nil = Enum(4)
  val state = RegInit(idle)

  val CLKPRE = ClockPrescaler.U

  val bitIndexWidth = log2Ceil(dataWidth)
  val bitIndex = RegInit(0.U(bitIndexWidth.W))
  val regout = RegInit(0.U(dataWidth.W))
  val regin = RegInit(0.U(dataWidth.W))

 
  val count = RegInit(0.U(ClockPrescaler.W))

  val cpolReg = RegInit(false.B)
  val cphaReg = RegInit(false.B)

  // Chip Select - Make it active low only during transaction
  io.cs := state === idle


  switch(state){
    is(idle){
      cpolReg := io.cpol
      cphaReg := io.cpha

      when(io.slaveDataValid){
        regout := io.slaveData
        bitIndex := (dataWidth - 1).U
        count := CLKPRE-1.U

        when(io.cpha){
          state := halfCycle
        }.otherwise {
          state := sampleAndPrepare
        }
      }
      regin := 0.U
    }

    is(halfCycle){
      when(count > 0.U){
        count := count - 1.U
      }.otherwise{
        count := CLKPRE -1.U
        state := sampleAndPrepare
      }
    }

    is(sampleAndPrepare){
      when(count > 0.U){
        count := count - 1.U
      }.otherwise{
        count := CLKPRE -1.U
        state := shift
        regin := Cat(regin(dataWidth - 2, 0), io.miso)
      }
    }

    is(shift){
      when(count > 0.U){
        count := count - 1.U
      }.otherwise{
        when(bitIndex > 0.U){
          count := CLKPRE -1.U
          bitIndex := bitIndex - 1.U
          state := sampleAndPrepare
        }.otherwise{
          state := idle
        }
      }
    }
  }

  // Output assignments
  io.masterData := regin

  // Generate sclk signal
  // io.sclk := cphaReg ^ cpolReg
  //}.elsewhen(state === shift){
   // io.sclk := ~(cphaReg ^ cpolReg)
  //}.otherwise{
   // io.sclk := cpolReg
  //}
  // Generate sclk signal only if cs is active (low)
  io.sclk := Mux(!io.cs, Mux(state === sampleAndPrepare, cphaReg ^ cpolReg, ~(cphaReg ^ cpolReg)), cpolReg).asClock()

  // Generate mosi signal
  //when(state === idle){
    //io.mosi := false.B
  //}.otherwise{
    //io.mosi := regout(bitIndex)
 // }
  // Generate mosi signal only if cs is active (low)
  io.mosi := Mux(!io.cs && state =/= idle, regout(bitIndex), false.B)
  
}




/** Generates verilog or sv*/
object spi_master extends App{
  // Generate verilog
  val annos = Seq(ChiselGeneratorAnnotation(() => new spi_master()))
  //(new ChiselStage).execute(arguments.toArray, annos)
  val sysverilog = (new ChiselStage).emitSystemVerilog(
    new spi_master)
}