package qspi_master

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest.WriteVcdAnnotation  // Use only this for VCD generation


class Qspi_MasterSpec extends AnyFlatSpec with ChiselScalatestTester {
  "Qspi_master" should "initialize and process commands correctly" in {
   test(new qspi_master).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Initialize inputs
  dut.io.clk_div.poke(1.U) // Set clock divider
  dut.io.clk_div_valid.poke(true.B) // Enable clock divider
  dut.io.cmd.poke("hAA000000".U)
  dut.io.addr.poke("hAAAAAAAA".U)
  dut.io.data_tx.bits.poke("hAAAAAAAA".U)

  // Configure SPI command
  dut.io.spi_rd.poke(false.B)
  dut.io.spi_wr.poke(false.B)
  dut.io.spi_qrd.poke(false.B)
  dut.io.spi_qwr.poke(false.B)

  dut.clock.step(2)
  dut.io.spi_wr.poke(true.B)
  dut.io.cmd_len.poke(8.U)  
  dut.clock.step(1)


  // Provide command details
  dut.io.cmd_len.poke(0.U)
  dut.io.spi_wr.poke(false.B)

  dut.clock.step(1)
 
  
  dut.clock.step(29)
  dut.io.addr_len.poke(32.U)
  dut.clock.step(1)
  dut.io.addr_len.poke(0.U)
  dut.clock.step(127)
  dut.io.data_len.poke(64.U)
  dut.io.data_tx.valid.poke(true.B)
  dut.clock.step(1)
  dut.io.data_len.poke(0.U)
  dut.io.data_tx.valid.poke(false.B)
  dut.clock.step(127)
  dut.io.data_len.poke(64.U)
  dut.io.data_tx.valid.poke(true.B) // Corrected valid signal usage
  dut.clock.step(1)
  dut.io.data_len.poke(0.U)
  dut.io.data_tx.valid.poke(false.B)

  // Run the clock for enough cycles to generate waveforms
  dut.clock.step(500) // Simulate for 500 cyclesulate for 500 cycles

      // End of the test
    }
  }


// New Test for Quad Mode
  "Qspi_master" should "initialize and process commands in quad mode" in {
    test(new qspi_master).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      // Initialize inputs for quad mode
      dut.io.clk_div.poke(1.U) // Set clock divider
      dut.io.clk_div_valid.poke(true.B) // Enable clock divider
      dut.io.cmd.poke("hA5000000".U) // Quad mode command (example value)
      dut.io.addr.poke("hA5A5A5A5".U) // Address
      dut.io.data_tx.bits.poke("hA5A5A5A5".U) // Data to transmit

      // Configure SPI for quad mode write
      dut.io.spi_rd.poke(false.B)
      dut.io.spi_wr.poke(false.B)
      dut.io.spi_qrd.poke(false.B)
      dut.io.spi_qwr.poke(true.B) // Quad mode write enabled

      // Provide command details
      dut.io.cmd_len.poke(8.U) // Command length
      dut.clock.step(1)
      dut.io.spi_qwr.poke(false.B)
      dut.io.cmd_len.poke(0.U)
      dut.clock.step(5)

      // Provide address
      dut.io.addr_len.poke(32.U)
      dut.clock.step(1)
      dut.io.addr_len.poke(0.U)
      dut.clock.step(31)

      // Provide data for quad write
      dut.io.data_len.poke(64.U) // Length of data to transmit
      dut.io.data_tx.valid.poke(true.B)
      dut.clock.step(1)
      dut.io.data_len.poke(0.U)
      dut.io.data_tx.valid.poke(false.B)
      dut.clock.step(31)
      dut.io.data_tx.valid.poke(true.B)
      dut.clock.step(1)
      dut.io.data_len.poke(0.U)
      dut.io.data_tx.valid.poke(false.B)


      // Run the clock for enough cycles to generate waveforms
      dut.clock.step(200)

      
    }
  }



  
}
