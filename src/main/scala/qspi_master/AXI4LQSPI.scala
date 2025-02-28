package qspi_master

import chisel3._
import chisel3.util._
import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}
import amba.axi4l._
import chisel3.experimental._
import amba.common._



class AXI4LQSPI(
    val addr_width: Int = 32,
    val data_width: Int = 32,
    tx_fifo_depth: Int = 16,
    rx_fifo_depth: Int = 16
) extends RawModule
    with AXI4LSlaveLogic
    with AXI4LSlave {

  

  
  val io = IO(new Bundle {
    val spi_clk = Output(Bool())
    val cs = Output(Bool())
    val sdo0 = Output(Bool())
    val sdo1 = Output(Bool())
    val sdo2 = Output(Bool())
    val sdo3 = Output(Bool())
    val sdi0 = Input(Bool())
    val sdi1 = Input(Bool())
    val sdi2 = Input(Bool())
    val sdi3 = Input(Bool())
    val state = Output(UInt(3.W))
    val quad_mode = Output(Bool())
    val flash_reset = Output(Bool())
    val write = Output(Bool())
  })

  // QSPI Master instance
  val QSPIMASTER = withClockAndReset(clk_rst.ACLK, ~clk_rst.ARESETn) {
    Module(new qspi_master())
  }

  
  io.spi_clk := QSPIMASTER.io.spi_clk
  io.cs := QSPIMASTER.io.cs
  io.sdo0 := QSPIMASTER.io.sdo0
  io.sdo1 := QSPIMASTER.io.sdo1
  io.sdo2 := QSPIMASTER.io.sdo2
  io.sdo3 := QSPIMASTER.io.sdo3
  QSPIMASTER.io.sdi0 := io.sdi0
  QSPIMASTER.io.sdi1 := io.sdi1
  QSPIMASTER.io.sdi2 := io.sdi2
  QSPIMASTER.io.sdi3 := io.sdi3
  io.state := QSPIMASTER.io.state
  io.quad_mode := QSPIMASTER.io.quad_mode
  



  //memory-mapped registers
  val clk_div = WireInit(0.U(8.W))
  val clk_div_valid = WireInit(false.B)
  

  val addr = WireInit(0.U(32.W))
  val addr_len = WireInit(0.U(6.W))

  val cmd = WireInit(0.U(32.W))
  val cmd_len = WireInit(0.U(6.W))

  val dummy_len = WireInit(0.U(16.W))

  val data_len = WireInit(0.U(16.W))
  val data_tx = WireInit(0.U(32.W))
  val data_rx = WireInit(0.U(32.W))

  
  val single_read = WireInit(false.B)
  val single_write = WireInit(false.B)
  val quad_read = WireInit(false.B)
  val quad_write = WireInit(false.B)
  val flash_reset = WireInit(false.B)



  val tx_fifo = withClockAndReset(clk_rst.ACLK, !clk_rst.ARESETn) {Module(new Queue(UInt(32.W), entries = tx_fifo_depth))}
  val rx_fifo = withClockAndReset(clk_rst.ACLK, !clk_rst.ARESETn) {Module(new Queue(UInt(32.W), entries = rx_fifo_depth))}

  val tx_fifoAlmostFull = withClockAndReset(clk_rst.ACLK, !clk_rst.ARESETn) {RegNext(tx_fifo.io.count >= (tx_fifo_depth - 2).U)}
 
 



  // Memory-mapped registers
   val memory_map = withClockAndReset(clk_rst.ACLK, !clk_rst.ARESETn) {Map[Data, MemoryRange](
    clk_div -> MemoryRange(begin = 0, end = 3, mode = MemoryMode.RW),
    clk_div_valid -> MemoryRange(begin = 4, end = 7, mode = MemoryMode.RW),
    addr -> MemoryRange(begin = 8, end = 11, mode = MemoryMode.RW),
    addr_len -> MemoryRange(begin = 12, end = 15, mode = MemoryMode.RW),
    cmd -> MemoryRange(begin = 16, end = 19, mode = MemoryMode.RW),
    cmd_len -> MemoryRange(begin = 20, end = 23, mode = MemoryMode.RW),
    dummy_len -> MemoryRange(begin = 24, end = 27, mode = MemoryMode.RW),
    data_len -> MemoryRange(begin = 28, end = 31, mode = MemoryMode.RW),
    data_tx -> MemoryRange(begin = 32, end = 35, mode = MemoryMode.RW, write_stall_sig = (tx_fifoAlmostFull)),
    data_rx -> MemoryRange(begin = 36, end = 39, mode = MemoryMode.R, decoupled = true, decoupled_inst = Some(rx_fifo.io.deq)),
    single_write -> MemoryRange(begin = 40, end = 43, mode = MemoryMode.RW), 
    single_read -> MemoryRange(begin = 44, end = 47, mode = MemoryMode.RW),
    quad_write -> MemoryRange(begin = 48, end = 51, mode = MemoryMode.RW),
    quad_read -> MemoryRange(begin = 52, end = 55, mode = MemoryMode.RW),
    flash_reset -> MemoryRange(begin = 56, end = 59, mode = MemoryMode.RW)
   
  )
  }

withClockAndReset(clk_rst.ACLK, !clk_rst.ARESETn) {

    buildAxi4LiteSlaveLogic()

    tx_fifo.io.enq.bits := data_tx
    /* Write strobe asserts when data_tx is being written.If valid is not asserted, the FIFO will not accept the data.
    Thus, the writeStrobe signal acts as the bridge between the AXI4-Lite interface and the FIFO's enq.valid*/
    tx_fifo.io.enq.valid := memory_map(data_tx).writeStrobe
    // Pop data from the FIFO when UART FSM is ready and transmitter is enabled
    tx_fifo.io.deq.ready := QSPIMASTER.io.data_tx.ready

    QSPIMASTER.io.data_tx.valid := tx_fifo.io.deq.valid
    
    QSPIMASTER.io.clk_div := clk_div
    QSPIMASTER.io.clk_div_valid := clk_div_valid
    QSPIMASTER.io.addr := addr
    QSPIMASTER.io.addr_len := addr_len
    QSPIMASTER.io.cmd := cmd
    QSPIMASTER.io.cmd_len := cmd_len
    QSPIMASTER.io.dummy_len := dummy_len
    QSPIMASTER.io.data_len := data_len
    QSPIMASTER.io.data_tx.bits := tx_fifo.io.deq.bits
    QSPIMASTER.io.single_read := single_read
    QSPIMASTER.io.single_write := single_write
    QSPIMASTER.io.quad_read := quad_read
    QSPIMASTER.io.quad_write := quad_write

   
    data_rx := rx_fifo.io.deq.bits
    //rx_fifo.io.deq.ready := memory_map(data_rx).readStrobe
    rx_fifo.io.enq.bits := QSPIMASTER.io.data_rx.bits
    rx_fifo.io.enq.valid := QSPIMASTER.io.data_rx.valid
    QSPIMASTER.io.data_rx.ready := rx_fifo.io.enq.ready
    io.flash_reset := flash_reset
    io.write := single_write || quad_write
    
  }


}

object AXI4LQSPI extends App {
  // Generate Verilog
  val annos = Seq(ChiselGeneratorAnnotation(() => new AXI4LQSPI()))
  (new ChiselStage).execute(args, annos)
}


