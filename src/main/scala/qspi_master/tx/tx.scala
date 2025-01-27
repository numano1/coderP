package tx

import chisel3._
import chisel3.util._
import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}

class txIO extends Bundle {
  val en = Input(Bool())
  val tx_edge = Input(Bool())
  val tx_done = Output(Bool())
  val sdo0 = Output(Bool())
  val sdo1 = Output(Bool())
  val sdo2 = Output(Bool())
  val sdo3 = Output(Bool())
  val en_quad_in = Input(Bool())
  val counter_in = Input(UInt(16.W))
  val counter_in_upd = Input(Bool())
  val data = Flipped(Decoupled(UInt(32.W))) // Using Decoupled for data with ready-valid
  val clk_en_o = Output(Bool())
}
class tx extends Module {
  val io = IO(new txIO)

  // States
  val idle :: transmit :: Nil = Enum(2)

  // Registers
  val dataInt = RegInit(0.U(32.W))
  val counter = RegInit(0.U(16.W))
  val counterTrgt = RegInit(8.U(16.W)) // default value of counter_trgt
  val state = RegInit(idle) 

  // Wires
  val done = Wire(Bool())
  val regDone = Wire(Bool())
  val counter_next = Wire(UInt(16.W))
  counter_next := counter // Default assignment
    when(io.tx_edge) {
      counter_next := counter + 1.U
      when(done) {
      counter_next := 0.U
      }
   }
counter := counter_next

  // Signals
  regDone := (!io.en_quad_in && counter(4, 0) === "b11111".U) || (io.en_quad_in && counter(2, 0) === "b111".U)
  done := (counter === (counterTrgt - 1.U)) && io.tx_edge

  // Default assignments
  io.tx_done := done
  io.data.ready := false.B
  io.sdo0 := Mux(io.en_quad_in, dataInt(28), dataInt(31))
  io.sdo1 := dataInt(29)
  io.sdo2 := dataInt(30)
  io.sdo3 := dataInt(31)
  io.clk_en_o := false.B

  // Update counter target on counter_in_upd signal
  when(io.counter_in_upd) {
    counterTrgt := Mux(io.en_quad_in, Cat(0.U(2.W), io.counter_in(15, 2)), io.counter_in)
  }

  // FSM
  switch(state) {
    is(idle) {
      io.clk_en_o := false.B
      when(io.en && io.data.valid) {
        dataInt := io.data.bits
        io.data.ready := true.B
        state := transmit
      }
    }
    is(transmit) {
      io.clk_en_o := true.B
      when(io.tx_edge) {
        counter_next := counter + 1.U
        dataInt := Mux(io.en_quad_in, Cat(dataInt(27, 0), 0.U(4.W)), Cat(dataInt(30, 0), 0.U(1.W)))


         

        when(done) {
          counter_next := 0.U
          when(io.en && io.data.valid) {
            dataInt := io.data.bits
            io.data.ready := true.B
            state := transmit
          } .otherwise {
            io.clk_en_o := false.B
            state := idle
          }
        } .elsewhen(regDone) {
          when(io.data.valid) {
            dataInt := io.data.bits
            io.data.ready := true.B
          } .otherwise {
            io.clk_en_o := false.B
            state := idle
          }
        }
      }
    }
  }
}

object tx extends App {
  // Generate Verilog
  val annos = Seq(ChiselGeneratorAnnotation(() => new tx()))
  (new ChiselStage).execute(args, annos)
}

