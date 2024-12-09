package receiver

import chisel3._
import chisel3.util._
import chisel3.util.{log2Ceil}
import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}


class receiverIO extends Bundle {
  val en = Input(Bool())
  val rx_edge = Input(Bool())
  val rx_done = Output(Bool())
  val sdi0 = Input(Bool())
  val sdi1 = Input(Bool())
  val sdi2 = Input(Bool())
  val sdi3 = Input(Bool())
  val en_quad_in = Input(Bool())
  val counter_in = Input(UInt(16.W))
  val counter_in_upd = Input(Bool())
  val data = Decoupled(UInt(32.W)) // Decoupled interface for output data
  val clk_en_o = Output(Bool())
}

class receiver extends Module {
  val io = IO(new receiverIO)

  // State definitions
  val idle :: receive :: wait_rx_done :: wait_reg_done :: Nil = Enum(4)

  // Registers for sequential logic
  val state = RegInit(idle) // Current state
  val counter = RegInit(0.U(16.W))
  val counterTrgt = RegInit(8.U(16.W))
  val dataInt = RegInit(0.U(32.W))

  // Default output values
  io.rx_done := false.B
  io.data.valid := false.B
  io.data.bits := dataInt
  io.clk_en_o := false.B

  // Signals
  val regDone = (!io.en_quad_in && counter(4, 0) === "b11111".U) || (io.en_quad_in && counter(2, 0) === "b111".U)
  val done = (counter === (counterTrgt - 1.U)) && io.rx_edge

  io.rx_done := done

  // Update counter target on counter_in_upd
  when(io.counter_in_upd) {
    counterTrgt := Mux(io.en_quad_in, Cat(0.U(2.W), io.counter_in(15, 2)), io.counter_in)
  }

  // FSM next-state logic
  switch(state) {
    is(idle) {
      io.clk_en_o := false.B
      when(io.en) {
        state := receive
      }
    }
    is(receive) {
      io.clk_en_o := true.B
      when(io.rx_edge) {
        counter := counter + 1.U
        dataInt := Mux(io.en_quad_in, Cat(dataInt(27, 0), io.sdi3, io.sdi2, io.sdi1, io.sdi0), Cat(dataInt(30, 0), io.sdi0))

        when(done) {
          counter := 0.U
          io.data.valid := true.B
          when(io.data.ready) { // Check if output is ready to accept data
            state := idle
          } .otherwise {
            state := wait_rx_done
          }
        }.elsewhen(regDone) {
          io.data.valid := true.B
          when(!io.data.ready) {
            state := wait_reg_done
          }
        }
      }
    }
    is(wait_rx_done) {
      io.data.valid := true.B
      when(io.data.ready) {
        state := idle
      }
    }
    is(wait_reg_done) {
      io.data.valid := true.B
      when(io.data.ready) {
        state := receive
      }
    }
  }
}

  




/** Generates verilog or sv*/
object receiver extends App{
  // Generate verilog
  val annos = Seq(ChiselGeneratorAnnotation(() => new receiver()))
  //(new ChiselStage).execute(arguments.toArray, annos)
  val sysverilog = (new ChiselStage).emitSystemVerilog(
    new receiver)
}