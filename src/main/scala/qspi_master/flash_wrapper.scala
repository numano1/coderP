package qspi_master

import chisel3._
import chisel3.experimental.{Analog}
import chisel3.util.HasBlackBoxResource

class FlashWrapper extends BlackBox with HasBlackBoxResource {
  override def desiredName: String = "flash_wrapper"
  val io = IO(new Bundle {
    val debug_state_i = Input(UInt(3.W))
    val spi_wr_i      = Input(Bool())
    val quad_mode_i   = Input(Bool())
    val cs_i          = Input(Bool())
    val spi_clk_i     = Input(Bool())
    val sdi0_i        = Input(Bool())
    val sdi1_i        = Input(Bool())
    val sdi2_i        = Input(Bool())
    val sdi3_i        = Input(Bool())
    val flash_reset_i = Input(Bool())
    val sdo0_o        = Output(Bool())
    val sdo1_o        = Output(Bool())
    val sdo2_o        = Output(Bool())
    val sdo3_o        = Output(Bool())
  })
  addResource("/flash_wrapper.v")
}