package qspi_master

import chisel3._
import chisel3.experimental.{ExtModule, Analog}
import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}

class FlashWrapper extends BlackBox {
  override def desiredName: String = "flash_module"
  val io = IO(new Bundle {
    val S         = Input(Bool())
    val C         = Input(Bool())
    val HOLD_DQ3  = Analog(1.W)
    val DQ0       = Analog(1.W)
    val DQ1       = Analog(1.W)
    val Vcc       = Input(UInt(32.W))
    val Vpp_W_DQ2 = Analog(1.W)
    val RESET2    = Input(Bool())
  })
}