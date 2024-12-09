module clockgen(
  input        clock,
  input        reset,
  input        io_en,
  input        io_clk_div_valid,
  input  [7:0] io_clk_div,
  output       io_spi_clk,
  output       io_spi_fall,
  output       io_spi_rise
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] counter_target; // @[clockgen.scala 22:31]
  reg [7:0] counter; // @[clockgen.scala 23:24]
  reg  spi_clk_reg; // @[clockgen.scala 24:28]
  reg  running; // @[clockgen.scala 25:24]
  wire  _spi_clk_next_T = ~spi_clk_reg; // @[clockgen.scala 42:21]
  wire  _GEN_0 = _spi_clk_next_T & running; // @[clockgen.scala 33:15 43:35 44:19]
  wire  _GEN_1 = _spi_clk_next_T ? 1'h0 : running; // @[clockgen.scala 34:15 43:35 46:19]
  wire [7:0] _counter_next_T_1 = counter + 8'h1; // @[clockgen.scala 49:29]
  wire  _T_6 = ~(_spi_clk_next_T & ~io_en); // @[clockgen.scala 55:8]
  assign io_spi_clk = spi_clk_reg; // @[clockgen.scala 64:14]
  assign io_spi_fall = counter == counter_target & _GEN_1; // @[clockgen.scala 34:15 40:36]
  assign io_spi_rise = counter == counter_target & _GEN_0; // @[clockgen.scala 33:15 40:36]
  always @(posedge clock) begin
    if (reset) begin // @[clockgen.scala 22:31]
      counter_target <= 8'h0; // @[clockgen.scala 22:31]
    end else if (io_clk_div_valid) begin // @[clockgen.scala 37:29]
      counter_target <= io_clk_div;
    end
    if (reset) begin // @[clockgen.scala 23:24]
      counter <= 8'h0; // @[clockgen.scala 23:24]
    end else if (~(_spi_clk_next_T & ~io_en)) begin // @[clockgen.scala 55:46]
      if (counter == counter_target) begin // @[clockgen.scala 40:36]
        counter <= 8'h0; // @[clockgen.scala 41:18]
      end else if (counter != counter_target) begin // @[clockgen.scala 48:42]
        counter <= _counter_next_T_1; // @[clockgen.scala 49:18]
      end
    end
    if (reset) begin // @[clockgen.scala 24:28]
      spi_clk_reg <= 1'h0; // @[clockgen.scala 24:28]
    end else if (~(_spi_clk_next_T & ~io_en)) begin // @[clockgen.scala 55:46]
      if (counter == counter_target) begin // @[clockgen.scala 40:36]
        spi_clk_reg <= ~spi_clk_reg; // @[clockgen.scala 42:18]
      end
    end
    if (reset) begin // @[clockgen.scala 25:24]
      running <= 1'h0; // @[clockgen.scala 25:24]
    end else begin
      running <= _T_6;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  counter_target = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  counter = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  spi_clk_reg = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  running = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module receiver(
  input         clock,
  input         reset,
  input         io_en,
  input         io_rx_edge,
  output        io_rx_done,
  input         io_sdi0,
  input         io_sdi1,
  input         io_sdi2,
  input         io_sdi3,
  input         io_en_quad_in,
  input  [15:0] io_counter_in,
  input         io_counter_in_upd,
  input         io_data_ready,
  output        io_data_valid,
  output [31:0] io_data_bits,
  output        io_clk_en_o
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[receiver.scala 31:22]
  reg [15:0] counter; // @[receiver.scala 32:24]
  reg [15:0] counterTrgt; // @[receiver.scala 33:28]
  reg [31:0] dataInt; // @[receiver.scala 34:24]
  wire  regDone = ~io_en_quad_in & counter[4:0] == 5'h1f | io_en_quad_in & counter[2:0] == 3'h7; // @[receiver.scala 43:66]
  wire [15:0] _done_T_1 = counterTrgt - 16'h1; // @[receiver.scala 44:40]
  wire  done = counter == _done_T_1 & io_rx_edge; // @[receiver.scala 44:48]
  wire [15:0] _counterTrgt_T_1 = {2'h0,io_counter_in[15:2]}; // @[Cat.scala 33:92]
  wire [15:0] _counter_T_1 = counter + 16'h1; // @[receiver.scala 64:28]
  wire [31:0] _dataInt_T_1 = {dataInt[27:0],io_sdi3,io_sdi2,io_sdi1,io_sdi0}; // @[Cat.scala 33:92]
  wire [31:0] _dataInt_T_3 = {dataInt[30:0],io_sdi0}; // @[Cat.scala 33:92]
  wire [31:0] _dataInt_T_4 = io_en_quad_in ? _dataInt_T_1 : _dataInt_T_3; // @[receiver.scala 65:23]
  wire [1:0] _GEN_2 = io_data_ready ? 2'h0 : 2'h2; // @[receiver.scala 70:31 71:19 73:19]
  wire [1:0] _GEN_3 = ~io_data_ready ? 2'h3 : state; // @[receiver.scala 77:32 78:19 31:22]
  wire [1:0] _GEN_5 = regDone ? _GEN_3 : state; // @[receiver.scala 31:22 75:29]
  wire [15:0] _GEN_6 = done ? 16'h0 : _counter_T_1; // @[receiver.scala 64:17 67:20 68:19]
  wire  _GEN_7 = done | regDone; // @[receiver.scala 67:20 69:25]
  wire [1:0] _GEN_8 = done ? _GEN_2 : _GEN_5; // @[receiver.scala 67:20]
  wire  _GEN_11 = io_rx_edge & _GEN_7; // @[receiver.scala 38:17 63:24]
  wire [1:0] _GEN_13 = io_data_ready ? 2'h0 : state; // @[receiver.scala 85:27 86:15 31:22]
  wire [1:0] _GEN_14 = io_data_ready ? 2'h1 : state; // @[receiver.scala 91:27 92:15 31:22]
  wire [1:0] _GEN_16 = 2'h3 == state ? _GEN_14 : state; // @[receiver.scala 54:17 31:22]
  wire  _GEN_17 = 2'h2 == state | 2'h3 == state; // @[receiver.scala 54:17 84:21]
  wire  _GEN_22 = 2'h1 == state ? _GEN_11 : _GEN_17; // @[receiver.scala 54:17]
  assign io_rx_done = counter == _done_T_1 & io_rx_edge; // @[receiver.scala 44:48]
  assign io_data_valid = 2'h0 == state ? 1'h0 : _GEN_22; // @[receiver.scala 38:17 54:17]
  assign io_data_bits = dataInt; // @[receiver.scala 39:16]
  assign io_clk_en_o = 2'h0 == state ? 1'h0 : 2'h1 == state; // @[receiver.scala 54:17 56:19]
  always @(posedge clock) begin
    if (reset) begin // @[receiver.scala 31:22]
      state <= 2'h0; // @[receiver.scala 31:22]
    end else if (2'h0 == state) begin // @[receiver.scala 54:17]
      if (io_en) begin // @[receiver.scala 57:19]
        state <= 2'h1; // @[receiver.scala 58:15]
      end
    end else if (2'h1 == state) begin // @[receiver.scala 54:17]
      if (io_rx_edge) begin // @[receiver.scala 63:24]
        state <= _GEN_8;
      end
    end else if (2'h2 == state) begin // @[receiver.scala 54:17]
      state <= _GEN_13;
    end else begin
      state <= _GEN_16;
    end
    if (reset) begin // @[receiver.scala 32:24]
      counter <= 16'h0; // @[receiver.scala 32:24]
    end else if (!(2'h0 == state)) begin // @[receiver.scala 54:17]
      if (2'h1 == state) begin // @[receiver.scala 54:17]
        if (io_rx_edge) begin // @[receiver.scala 63:24]
          counter <= _GEN_6;
        end
      end
    end
    if (reset) begin // @[receiver.scala 33:28]
      counterTrgt <= 16'h8; // @[receiver.scala 33:28]
    end else if (io_counter_in_upd) begin // @[receiver.scala 49:27]
      if (io_en_quad_in) begin // @[receiver.scala 50:23]
        counterTrgt <= _counterTrgt_T_1;
      end else begin
        counterTrgt <= io_counter_in;
      end
    end
    if (reset) begin // @[receiver.scala 34:24]
      dataInt <= 32'h0; // @[receiver.scala 34:24]
    end else if (!(2'h0 == state)) begin // @[receiver.scala 54:17]
      if (2'h1 == state) begin // @[receiver.scala 54:17]
        if (io_rx_edge) begin // @[receiver.scala 63:24]
          dataInt <= _dataInt_T_4; // @[receiver.scala 65:17]
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  counter = _RAND_1[15:0];
  _RAND_2 = {1{`RANDOM}};
  counterTrgt = _RAND_2[15:0];
  _RAND_3 = {1{`RANDOM}};
  dataInt = _RAND_3[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module transceiver(
  input         clock,
  input         reset,
  input         io_en,
  input         io_tx_edge,
  output        io_tx_done,
  output        io_sdo0,
  output        io_sdo1,
  output        io_sdo2,
  output        io_sdo3,
  input         io_en_quad_in,
  input  [15:0] io_counter_in,
  input         io_counter_in_upd,
  output        io_data_ready,
  input         io_data_valid,
  input  [31:0] io_data_bits,
  output        io_clk_en_o
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] dataInt; // @[transceiver.scala 29:24]
  reg [15:0] counter; // @[transceiver.scala 30:24]
  reg [15:0] counterTrgt; // @[transceiver.scala 31:28]
  reg  state; // @[transceiver.scala 32:22]
  wire [15:0] _counter_next_T_1 = counter + 16'h1; // @[transceiver.scala 40:31]
  wire [15:0] _done_T_1 = counterTrgt - 16'h1; // @[transceiver.scala 49:37]
  wire  done = counter == _done_T_1 & io_tx_edge; // @[transceiver.scala 49:45]
  wire [15:0] _GEN_0 = done ? 16'h0 : _counter_next_T_1; // @[transceiver.scala 41:18 40:20 42:20]
  wire [15:0] _GEN_1 = io_tx_edge ? _GEN_0 : counter; // @[transceiver.scala 38:16 39:22]
  wire  regDone = ~io_en_quad_in & counter[4:0] == 5'h1f | io_en_quad_in & counter[2:0] == 3'h7; // @[transceiver.scala 48:63]
  wire [15:0] _counterTrgt_T_1 = {2'h0,io_counter_in[15:2]}; // @[Cat.scala 33:92]
  wire  _T_1 = io_en & io_data_valid; // @[transceiver.scala 69:18]
  wire  _GEN_5 = io_en & io_data_valid | state; // @[transceiver.scala 69:36 72:15 32:22]
  wire [31:0] _dataInt_T_1 = {dataInt[27:0],4'h0}; // @[Cat.scala 33:92]
  wire [31:0] _dataInt_T_3 = {dataInt[30:0],1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _dataInt_T_4 = io_en_quad_in ? _dataInt_T_1 : _dataInt_T_3; // @[transceiver.scala 79:23]
  wire [31:0] _GEN_6 = _T_1 ? io_data_bits : _dataInt_T_4; // @[transceiver.scala 79:17 83:40 84:21]
  wire [31:0] _GEN_8 = io_data_valid ? io_data_bits : _dataInt_T_4; // @[transceiver.scala 79:17 92:31 93:21]
  wire  _GEN_10 = io_data_valid & state; // @[transceiver.scala 32:22 92:31 97:19]
  wire [31:0] _GEN_11 = regDone ? _GEN_8 : _dataInt_T_4; // @[transceiver.scala 79:17 91:30]
  wire  _GEN_12 = regDone & io_data_valid; // @[transceiver.scala 53:17 91:30]
  wire  _GEN_13 = regDone ? io_data_valid : 1'h1; // @[transceiver.scala 76:19 91:30]
  wire  _GEN_14 = regDone ? _GEN_10 : state; // @[transceiver.scala 32:22 91:30]
  wire [31:0] _GEN_16 = done ? _GEN_6 : _GEN_11; // @[transceiver.scala 81:20]
  wire  _GEN_17 = done ? _T_1 : _GEN_12; // @[transceiver.scala 81:20]
  wire  _GEN_18 = done ? _T_1 : _GEN_14; // @[transceiver.scala 81:20]
  wire  _GEN_19 = done ? _T_1 : _GEN_13; // @[transceiver.scala 81:20]
  wire  _GEN_22 = io_tx_edge & _GEN_17; // @[transceiver.scala 53:17 77:24]
  wire  _GEN_24 = io_tx_edge ? _GEN_19 : 1'h1; // @[transceiver.scala 76:19 77:24]
  wire  _GEN_25 = state & _GEN_24; // @[transceiver.scala 58:15 66:17]
  wire  _GEN_28 = state & _GEN_22; // @[transceiver.scala 53:17 66:17]
  assign io_tx_done = counter == _done_T_1 & io_tx_edge; // @[transceiver.scala 49:45]
  assign io_sdo0 = io_en_quad_in ? dataInt[28] : dataInt[31]; // @[transceiver.scala 54:17]
  assign io_sdo1 = dataInt[29]; // @[transceiver.scala 55:21]
  assign io_sdo2 = dataInt[30]; // @[transceiver.scala 56:21]
  assign io_sdo3 = dataInt[31]; // @[transceiver.scala 57:21]
  assign io_data_ready = ~state ? _T_1 : _GEN_28; // @[transceiver.scala 66:17]
  assign io_clk_en_o = ~state ? 1'h0 : _GEN_25; // @[transceiver.scala 66:17 68:19]
  always @(posedge clock) begin
    if (reset) begin // @[transceiver.scala 29:24]
      dataInt <= 32'h0; // @[transceiver.scala 29:24]
    end else if (~state) begin // @[transceiver.scala 66:17]
      if (io_en & io_data_valid) begin // @[transceiver.scala 69:36]
        dataInt <= io_data_bits; // @[transceiver.scala 70:17]
      end
    end else if (state) begin // @[transceiver.scala 66:17]
      if (io_tx_edge) begin // @[transceiver.scala 77:24]
        dataInt <= _GEN_16;
      end
    end
    if (reset) begin // @[transceiver.scala 30:24]
      counter <= 16'h0; // @[transceiver.scala 30:24]
    end else if (~state) begin // @[transceiver.scala 66:17]
      counter <= _GEN_1;
    end else if (state) begin // @[transceiver.scala 66:17]
      if (io_tx_edge) begin // @[transceiver.scala 77:24]
        counter <= _GEN_0;
      end else begin
        counter <= _GEN_1;
      end
    end else begin
      counter <= _GEN_1;
    end
    if (reset) begin // @[transceiver.scala 31:28]
      counterTrgt <= 16'h8; // @[transceiver.scala 31:28]
    end else if (io_counter_in_upd) begin // @[transceiver.scala 61:27]
      if (io_en_quad_in) begin // @[transceiver.scala 62:23]
        counterTrgt <= _counterTrgt_T_1;
      end else begin
        counterTrgt <= io_counter_in;
      end
    end
    if (reset) begin // @[transceiver.scala 32:22]
      state <= 1'h0; // @[transceiver.scala 32:22]
    end else if (~state) begin // @[transceiver.scala 66:17]
      state <= _GEN_5;
    end else if (state) begin // @[transceiver.scala 66:17]
      if (io_tx_edge) begin // @[transceiver.scala 77:24]
        state <= _GEN_18;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  dataInt = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  counter = _RAND_1[15:0];
  _RAND_2 = {1{`RANDOM}};
  counterTrgt = _RAND_2[15:0];
  _RAND_3 = {1{`RANDOM}};
  state = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module qspi_master(
  input         clock,
  input         reset,
  input  [7:0]  io_clk_div,
  input         io_clk_div_valid,
  input  [31:0] io_addr,
  input  [5:0]  io_addr_len,
  input  [31:0] io_cmd,
  input  [5:0]  io_cmd_len,
  input  [15:0] io_dummy_len,
  input  [15:0] io_data_len,
  output        io_data_tx_ready,
  input         io_data_tx_valid,
  input  [31:0] io_data_tx_bits,
  input         io_data_rx_ready,
  output        io_data_rx_valid,
  output [31:0] io_data_rx_bits,
  input         io_spi_rd,
  input         io_spi_wr,
  input         io_spi_qrd,
  input         io_spi_qwr,
  output        io_spi_clk,
  output        io_cs,
  output        io_spi_sdo0,
  output        io_spi_sdo1,
  output        io_spi_sdo2,
  output        io_spi_sdo3,
  input         io_spi_sdi0,
  input         io_spi_sdi1,
  input         io_spi_sdi2,
  input         io_spi_sdi3,
  output [2:0]  io_debug_state,
  output        io_quad_mode,
  output        io_tx_en,
  output        io_rx_en,
  output        io_Tx_done,
  output        io_Rx_done,
  output [6:0]  io_spi_status
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  wire  clock_generator_clock; // @[qspi_master.scala 99:31]
  wire  clock_generator_reset; // @[qspi_master.scala 99:31]
  wire  clock_generator_io_en; // @[qspi_master.scala 99:31]
  wire  clock_generator_io_clk_div_valid; // @[qspi_master.scala 99:31]
  wire [7:0] clock_generator_io_clk_div; // @[qspi_master.scala 99:31]
  wire  clock_generator_io_spi_clk; // @[qspi_master.scala 99:31]
  wire  clock_generator_io_spi_fall; // @[qspi_master.scala 99:31]
  wire  clock_generator_io_spi_rise; // @[qspi_master.scala 99:31]
  wire  receiver_clock; // @[qspi_master.scala 100:24]
  wire  receiver_reset; // @[qspi_master.scala 100:24]
  wire  receiver_io_en; // @[qspi_master.scala 100:24]
  wire  receiver_io_rx_edge; // @[qspi_master.scala 100:24]
  wire  receiver_io_rx_done; // @[qspi_master.scala 100:24]
  wire  receiver_io_sdi0; // @[qspi_master.scala 100:24]
  wire  receiver_io_sdi1; // @[qspi_master.scala 100:24]
  wire  receiver_io_sdi2; // @[qspi_master.scala 100:24]
  wire  receiver_io_sdi3; // @[qspi_master.scala 100:24]
  wire  receiver_io_en_quad_in; // @[qspi_master.scala 100:24]
  wire [15:0] receiver_io_counter_in; // @[qspi_master.scala 100:24]
  wire  receiver_io_counter_in_upd; // @[qspi_master.scala 100:24]
  wire  receiver_io_data_ready; // @[qspi_master.scala 100:24]
  wire  receiver_io_data_valid; // @[qspi_master.scala 100:24]
  wire [31:0] receiver_io_data_bits; // @[qspi_master.scala 100:24]
  wire  receiver_io_clk_en_o; // @[qspi_master.scala 100:24]
  wire  transmitter_clock; // @[qspi_master.scala 101:27]
  wire  transmitter_reset; // @[qspi_master.scala 101:27]
  wire  transmitter_io_en; // @[qspi_master.scala 101:27]
  wire  transmitter_io_tx_edge; // @[qspi_master.scala 101:27]
  wire  transmitter_io_tx_done; // @[qspi_master.scala 101:27]
  wire  transmitter_io_sdo0; // @[qspi_master.scala 101:27]
  wire  transmitter_io_sdo1; // @[qspi_master.scala 101:27]
  wire  transmitter_io_sdo2; // @[qspi_master.scala 101:27]
  wire  transmitter_io_sdo3; // @[qspi_master.scala 101:27]
  wire  transmitter_io_en_quad_in; // @[qspi_master.scala 101:27]
  wire [15:0] transmitter_io_counter_in; // @[qspi_master.scala 101:27]
  wire  transmitter_io_counter_in_upd; // @[qspi_master.scala 101:27]
  wire  transmitter_io_data_ready; // @[qspi_master.scala 101:27]
  wire  transmitter_io_data_valid; // @[qspi_master.scala 101:27]
  wire [31:0] transmitter_io_data_bits; // @[qspi_master.scala 101:27]
  wire  transmitter_io_clk_en_o; // @[qspi_master.scala 101:27]
  reg [2:0] state; // @[qspi_master.scala 58:22]
  reg  en_quad_reg; // @[qspi_master.scala 95:28]
  reg  do_rx; // @[qspi_master.scala 96:22]
  wire  _T = io_spi_qrd | io_spi_qwr; // @[qspi_master.scala 104:19]
  wire  _T_1 = state == 3'h0; // @[qspi_master.scala 106:20]
  wire  _GEN_0 = state == 3'h0 ? 1'h0 : en_quad_reg; // @[qspi_master.scala 106:30 107:17 95:28]
  wire  _GEN_1 = io_spi_qrd | io_spi_qwr | _GEN_0; // @[qspi_master.scala 104:34 105:17]
  wire  _GEN_2 = _T_1 ? 1'h0 : do_rx; // @[qspi_master.scala 112:30 113:11 96:22]
  wire  _GEN_3 = io_spi_rd | io_spi_qrd | _GEN_2; // @[qspi_master.scala 110:33 111:11]
  wire  _T_7 = io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr; // @[qspi_master.scala 184:49]
  wire  _T_9 = io_addr_len != 6'h0; // @[qspi_master.scala 194:32]
  wire  _T_10 = io_data_len != 16'h0; // @[qspi_master.scala 201:32]
  wire  _T_12 = io_dummy_len != 16'h0; // @[qspi_master.scala 203:31]
  wire [2:0] _GEN_6 = io_dummy_len != 16'h0 ? 3'h1 : 3'h0; // @[qspi_master.scala 203:40 206:24 86:29]
  wire [2:0] _GEN_12 = io_spi_qrd ? _GEN_6 : 3'h4; // @[qspi_master.scala 202:42 218:22]
  wire [2:0] _GEN_18 = io_data_len != 16'h0 ? _GEN_12 : 3'h0; // @[qspi_master.scala 201:41 86:29]
  wire [2:0] _GEN_24 = io_addr_len != 6'h0 ? 3'h3 : _GEN_18; // @[qspi_master.scala 194:41 197:20]
  wire [2:0] _GEN_31 = io_cmd_len != 6'h0 ? 3'h2 : _GEN_24; // @[qspi_master.scala 187:34 190:20]
  wire [2:0] _GEN_40 = io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr ? _GEN_31 : 3'h0; // @[qspi_master.scala 184:64 86:29]
  wire  tx_done = transmitter_io_tx_done; // @[qspi_master.scala 136:11 80:21]
  wire [2:0] _GEN_53 = do_rx ? _GEN_6 : 3'h4; // @[qspi_master.scala 243:23 259:22]
  wire [2:0] _GEN_59 = _T_10 ? _GEN_53 : 3'h0; // @[qspi_master.scala 242:41 86:29]
  wire [2:0] _GEN_65 = _T_9 ? 3'h3 : _GEN_59; // @[qspi_master.scala 235:35 238:20]
  wire [2:0] _GEN_72 = tx_done ? _GEN_65 : 3'h0; // @[qspi_master.scala 234:21 86:29]
  wire [2:0] _GEN_98 = tx_done ? _GEN_59 : 3'h0; // @[qspi_master.scala 276:21 86:29]
  wire [2:0] _GEN_108 = do_rx ? 3'h0 : 3'h4; // @[qspi_master.scala 313:23 321:22 86:29]
  wire [2:0] _GEN_114 = _T_10 ? _GEN_108 : 3'h0; // @[qspi_master.scala 312:35 86:29]
  wire [2:0] _GEN_120 = tx_done ? _GEN_114 : 3'h0; // @[qspi_master.scala 311:21 86:29]
  wire [2:0] _GEN_139 = 3'h4 == state ? 3'h4 : 3'h0; // @[qspi_master.scala 181:19 338:16 86:29]
  wire [2:0] _GEN_152 = 3'h3 == state ? _GEN_120 : _GEN_139; // @[qspi_master.scala 181:19]
  wire [2:0] _GEN_159 = 3'h2 == state ? _GEN_98 : _GEN_152; // @[qspi_master.scala 181:19]
  wire [2:0] _GEN_171 = 3'h1 == state ? _GEN_72 : _GEN_159; // @[qspi_master.scala 181:19]
  wire [2:0] selector = 3'h0 == state ? _GEN_40 : _GEN_171; // @[qspi_master.scala 181:19]
  wire  _data_to_tx_bits_T = selector == 3'h0; // @[qspi_master.scala 159:15]
  wire  _data_to_tx_bits_T_1 = selector == 3'h1; // @[qspi_master.scala 160:15]
  wire  _data_to_tx_bits_T_2 = selector == 3'h2; // @[qspi_master.scala 161:15]
  wire  _data_to_tx_bits_T_3 = selector == 3'h3; // @[qspi_master.scala 162:15]
  wire  _data_to_tx_bits_T_4 = selector == 3'h4; // @[qspi_master.scala 163:15]
  wire [31:0] _data_to_tx_bits_T_5 = _data_to_tx_bits_T_4 ? io_data_tx_bits : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _data_to_tx_bits_T_6 = _data_to_tx_bits_T_3 ? io_addr : _data_to_tx_bits_T_5; // @[Mux.scala 101:16]
  wire [31:0] _data_to_tx_bits_T_7 = _data_to_tx_bits_T_2 ? io_cmd : _data_to_tx_bits_T_6; // @[Mux.scala 101:16]
  wire [31:0] _data_to_tx_bits_T_8 = _data_to_tx_bits_T_1 ? 32'h0 : _data_to_tx_bits_T_7; // @[Mux.scala 101:16]
  wire  _GEN_32 = io_cmd_len != 6'h0 | _T_9; // @[qspi_master.scala 187:34 191:22]
  wire  _GEN_41 = (io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr) & _GEN_32; // @[qspi_master.scala 184:64 87:31]
  wire  _GEN_73 = tx_done & _T_9; // @[qspi_master.scala 234:21 87:31]
  wire  _GEN_107 = do_rx ? 1'h0 : 1'h1; // @[qspi_master.scala 313:23 320:28 74:35]
  wire  _GEN_113 = _T_10 & _GEN_107; // @[qspi_master.scala 312:35 74:35]
  wire  _GEN_119 = tx_done & _GEN_113; // @[qspi_master.scala 311:21 74:35]
  wire  _GEN_151 = 3'h3 == state & _GEN_119; // @[qspi_master.scala 181:19 74:35]
  wire  _GEN_165 = 3'h2 == state ? 1'h0 : _GEN_151; // @[qspi_master.scala 181:19 87:31]
  wire  _GEN_172 = 3'h1 == state ? _GEN_73 : _GEN_165; // @[qspi_master.scala 181:19]
  wire  data_valid = 3'h0 == state ? _GEN_41 : _GEN_172; // @[qspi_master.scala 181:19]
  wire  _data_to_tx_valid_T_6 = _data_to_tx_bits_T_3 ? data_valid : _data_to_tx_bits_T_4 & io_data_tx_valid; // @[Mux.scala 101:16]
  wire  _data_to_tx_valid_T_7 = _data_to_tx_bits_T_2 ? data_valid : _data_to_tx_valid_T_6; // @[Mux.scala 101:16]
  wire  data_to_tx_ready = transmitter_io_data_ready; // @[qspi_master.scala 133:23 77:24]
  wire [15:0] _GEN_4 = io_dummy_len != 16'h0 ? io_dummy_len : 16'h0; // @[qspi_master.scala 203:40 204:26 73:31]
  wire [2:0] _GEN_7 = io_dummy_len != 16'h0 ? 3'h3 : 3'h5; // @[qspi_master.scala 203:40 208:21 213:21]
  wire [15:0] _GEN_8 = io_dummy_len != 16'h0 ? 16'h0 : io_data_len; // @[qspi_master.scala 203:40 210:26 75:31]
  wire  _GEN_9 = io_dummy_len != 16'h0 ? 1'h0 : 1'h1; // @[qspi_master.scala 203:40 211:30 76:35]
  wire [15:0] _GEN_10 = io_spi_qrd ? _GEN_4 : io_data_len; // @[qspi_master.scala 202:42 216:24]
  wire  _GEN_11 = io_spi_qrd ? _T_12 : 1'h1; // @[qspi_master.scala 202:42 217:28]
  wire [2:0] _GEN_13 = io_spi_qrd ? _GEN_7 : 3'h4; // @[qspi_master.scala 202:42 221:19]
  wire [15:0] _GEN_14 = io_spi_qrd ? _GEN_8 : 16'h0; // @[qspi_master.scala 202:42 75:31]
  wire  _GEN_15 = io_spi_qrd & _GEN_9; // @[qspi_master.scala 202:42 76:35]
  wire [15:0] _GEN_16 = io_data_len != 16'h0 ? _GEN_10 : 16'h0; // @[qspi_master.scala 201:41 73:31]
  wire  _GEN_17 = io_data_len != 16'h0 & _GEN_11; // @[qspi_master.scala 201:41 74:35]
  wire [2:0] _GEN_19 = io_data_len != 16'h0 ? _GEN_13 : 3'h0; // @[qspi_master.scala 201:41 225:17]
  wire [15:0] _GEN_20 = io_data_len != 16'h0 ? _GEN_14 : 16'h0; // @[qspi_master.scala 201:41 75:31]
  wire  _GEN_21 = io_data_len != 16'h0 & _GEN_15; // @[qspi_master.scala 201:41 76:35]
  wire [15:0] _GEN_22 = io_addr_len != 6'h0 ? {{10'd0}, io_addr_len} : _GEN_16; // @[qspi_master.scala 194:41 195:22]
  wire  _GEN_23 = io_addr_len != 6'h0 | _GEN_17; // @[qspi_master.scala 194:41 196:26]
  wire [2:0] _GEN_26 = io_addr_len != 6'h0 ? 3'h2 : _GEN_19; // @[qspi_master.scala 194:41 200:17]
  wire [15:0] _GEN_27 = io_addr_len != 6'h0 ? 16'h0 : _GEN_20; // @[qspi_master.scala 194:41 75:31]
  wire  _GEN_28 = io_addr_len != 6'h0 ? 1'h0 : _GEN_21; // @[qspi_master.scala 194:41 76:35]
  wire [15:0] _GEN_29 = io_cmd_len != 6'h0 ? {{10'd0}, io_cmd_len} : _GEN_22; // @[qspi_master.scala 187:34 188:22]
  wire  _GEN_30 = io_cmd_len != 6'h0 | _GEN_23; // @[qspi_master.scala 187:34 189:26]
  wire [15:0] _GEN_34 = io_cmd_len != 6'h0 ? 16'h0 : _GEN_27; // @[qspi_master.scala 187:34 75:31]
  wire  _GEN_35 = io_cmd_len != 6'h0 ? 1'h0 : _GEN_28; // @[qspi_master.scala 187:34 76:35]
  wire  _GEN_36 = io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr ? 1'h0 : 1'h1; // @[qspi_master.scala 184:64 185:17 67:28]
  wire [15:0] _GEN_38 = io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr ? _GEN_29 : 16'h0; // @[qspi_master.scala 184:64 73:31]
  wire  _GEN_39 = (io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr) & _GEN_30; // @[qspi_master.scala 184:64 74:35]
  wire [15:0] _GEN_43 = io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr ? _GEN_34 : 16'h0; // @[qspi_master.scala 184:64 75:31]
  wire  _GEN_44 = (io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr) & _GEN_35; // @[qspi_master.scala 184:64 76:35]
  wire [15:0] _GEN_51 = do_rx ? _GEN_4 : io_data_len; // @[qspi_master.scala 243:23 257:24]
  wire  _GEN_52 = do_rx ? _T_12 : 1'h1; // @[qspi_master.scala 243:23 258:28]
  wire [2:0] _GEN_54 = do_rx ? _GEN_7 : 3'h4; // @[qspi_master.scala 243:23 262:19]
  wire [15:0] _GEN_55 = do_rx ? _GEN_8 : 16'h0; // @[qspi_master.scala 243:23 75:31]
  wire  _GEN_56 = do_rx & _GEN_9; // @[qspi_master.scala 243:23 76:35]
  wire [15:0] _GEN_57 = _T_10 ? _GEN_51 : 16'h0; // @[qspi_master.scala 242:41 73:31]
  wire  _GEN_58 = _T_10 & _GEN_52; // @[qspi_master.scala 242:41 74:35]
  wire [2:0] _GEN_60 = _T_10 ? _GEN_54 : 3'h0; // @[qspi_master.scala 242:41 265:17]
  wire [15:0] _GEN_61 = _T_10 ? _GEN_55 : 16'h0; // @[qspi_master.scala 242:41 75:31]
  wire  _GEN_62 = _T_10 & _GEN_56; // @[qspi_master.scala 242:41 76:35]
  wire [15:0] _GEN_63 = _T_9 ? {{10'd0}, io_addr_len} : _GEN_57; // @[qspi_master.scala 235:35 236:22]
  wire  _GEN_64 = _T_9 | _GEN_58; // @[qspi_master.scala 235:35 237:26]
  wire [2:0] _GEN_67 = _T_9 ? 3'h2 : _GEN_60; // @[qspi_master.scala 235:35 241:17]
  wire [15:0] _GEN_68 = _T_9 ? 16'h0 : _GEN_61; // @[qspi_master.scala 235:35 75:31]
  wire  _GEN_69 = _T_9 ? 1'h0 : _GEN_62; // @[qspi_master.scala 235:35 76:35]
  wire [15:0] _GEN_70 = tx_done ? _GEN_63 : 16'h0; // @[qspi_master.scala 234:21 73:31]
  wire  _GEN_71 = tx_done & _GEN_64; // @[qspi_master.scala 234:21 74:35]
  wire  _GEN_74 = tx_done ? _GEN_64 : 1'h1; // @[qspi_master.scala 234:21 268:15]
  wire [15:0] _GEN_76 = tx_done ? _GEN_68 : 16'h0; // @[qspi_master.scala 234:21 75:31]
  wire  _GEN_77 = tx_done & _GEN_69; // @[qspi_master.scala 234:21 76:35]
  wire [15:0] _GEN_96 = tx_done ? _GEN_57 : 16'h0; // @[qspi_master.scala 276:21 73:31]
  wire  _GEN_97 = tx_done & _GEN_58; // @[qspi_master.scala 276:21 74:35]
  wire  _GEN_99 = tx_done ? _GEN_58 : 1'h1; // @[qspi_master.scala 276:21 303:15]
  wire [2:0] _GEN_100 = tx_done ? _GEN_60 : state; // @[qspi_master.scala 276:21 58:22]
  wire [15:0] _GEN_101 = tx_done ? _GEN_61 : 16'h0; // @[qspi_master.scala 276:21 75:31]
  wire  _GEN_102 = tx_done & _GEN_62; // @[qspi_master.scala 276:21 76:35]
  wire [15:0] _GEN_103 = do_rx ? io_data_len : 16'h0; // @[qspi_master.scala 313:23 314:24 75:31]
  wire [2:0] _GEN_105 = do_rx ? 3'h5 : 3'h4; // @[qspi_master.scala 313:23 317:19 324:19]
  wire [15:0] _GEN_106 = do_rx ? 16'h0 : io_data_len; // @[qspi_master.scala 313:23 319:24 73:31]
  wire [15:0] _GEN_109 = _T_10 ? _GEN_103 : 16'h0; // @[qspi_master.scala 312:35 75:31]
  wire  _GEN_110 = _T_10 & do_rx; // @[qspi_master.scala 312:35 76:35]
  wire [2:0] _GEN_111 = _T_10 ? _GEN_105 : 3'h0; // @[qspi_master.scala 312:35 327:17]
  wire [15:0] _GEN_112 = _T_10 ? _GEN_106 : 16'h0; // @[qspi_master.scala 312:35 73:31]
  wire [15:0] _GEN_115 = tx_done ? _GEN_109 : 16'h0; // @[qspi_master.scala 311:21 75:31]
  wire  _GEN_116 = tx_done & _GEN_110; // @[qspi_master.scala 311:21 76:35]
  wire [2:0] _GEN_117 = tx_done ? _GEN_111 : state; // @[qspi_master.scala 311:21 58:22]
  wire [15:0] _GEN_118 = tx_done ? _GEN_112 : 16'h0; // @[qspi_master.scala 311:21 73:31]
  wire  _GEN_121 = tx_done ? _GEN_113 : 1'h1; // @[qspi_master.scala 311:21 330:15]
  wire [2:0] _GEN_122 = tx_done ? 3'h0 : 3'h4; // @[qspi_master.scala 340:21 341:15 344:15]
  wire  tx_clock_en = transmitter_io_clk_en_o; // @[qspi_master.scala 137:15 84:25]
  wire  _GEN_123 = tx_done ? 1'h0 : tx_clock_en; // @[qspi_master.scala 336:16 340:21 342:18]
  wire  rx_done = receiver_io_rx_done; // @[qspi_master.scala 152:11 82:21]
  wire [2:0] _GEN_124 = rx_done ? 3'h6 : 3'h5; // @[qspi_master.scala 352:21 353:15 355:15]
  wire  _GEN_125 = rx_done ? 1'h0 : 1'h1; // @[qspi_master.scala 352:21 356:15 70:26]
  wire  spi_fall = clock_generator_io_spi_fall; // @[qspi_master.scala 124:12 88:22]
  wire [2:0] _GEN_126 = spi_fall ? 3'h0 : 3'h6; // @[qspi_master.scala 364:22 365:15 367:15]
  wire [6:0] _GEN_127 = 3'h6 == state ? 7'h7 : 7'h0; // @[qspi_master.scala 181:19 361:18 92:31]
  wire  _GEN_129 = 3'h6 == state ? 1'h0 : 1'h1; // @[qspi_master.scala 181:19 363:15 67:28]
  wire [2:0] _GEN_130 = 3'h6 == state ? _GEN_126 : state; // @[qspi_master.scala 181:19 58:22]
  wire [6:0] _GEN_131 = 3'h5 == state ? 7'h6 : _GEN_127; // @[qspi_master.scala 181:19 349:18]
  wire  rx_clock_en = receiver_io_clk_en_o; // @[qspi_master.scala 154:15 85:25]
  wire  _GEN_132 = 3'h5 == state ? rx_clock_en : 3'h6 == state; // @[qspi_master.scala 181:19 350:16]
  wire  _GEN_133 = 3'h5 == state ? 1'h0 : _GEN_129; // @[qspi_master.scala 181:19 351:15]
  wire [2:0] _GEN_134 = 3'h5 == state ? _GEN_124 : _GEN_130; // @[qspi_master.scala 181:19]
  wire [6:0] _GEN_136 = 3'h4 == state ? 7'h5 : _GEN_131; // @[qspi_master.scala 181:19 335:18]
  wire  _GEN_137 = 3'h4 == state ? _GEN_123 : _GEN_132; // @[qspi_master.scala 181:19]
  wire  _GEN_138 = 3'h4 == state ? 1'h0 : _GEN_133; // @[qspi_master.scala 181:19 337:15]
  wire [2:0] _GEN_141 = 3'h4 == state ? _GEN_122 : _GEN_134; // @[qspi_master.scala 181:19]
  wire  _GEN_142 = 3'h4 == state ? 1'h0 : 3'h5 == state & _GEN_125; // @[qspi_master.scala 181:19 70:26]
  wire  _GEN_143 = 3'h3 == state | _GEN_137; // @[qspi_master.scala 181:19 308:16]
  wire [6:0] _GEN_144 = 3'h3 == state ? 7'h4 : _GEN_136; // @[qspi_master.scala 181:19 309:18]
  wire  _GEN_145 = 3'h3 == state ? 1'h0 : _GEN_138; // @[qspi_master.scala 181:19 310:15]
  wire [15:0] _GEN_146 = 3'h3 == state ? _GEN_115 : 16'h0; // @[qspi_master.scala 181:19 75:31]
  wire  _GEN_147 = 3'h3 == state & _GEN_116; // @[qspi_master.scala 181:19 76:35]
  wire  _GEN_148 = 3'h3 == state ? _GEN_116 : _GEN_142; // @[qspi_master.scala 181:19]
  wire [2:0] _GEN_149 = 3'h3 == state ? _GEN_117 : _GEN_141; // @[qspi_master.scala 181:19]
  wire [15:0] _GEN_150 = 3'h3 == state ? _GEN_118 : 16'h0; // @[qspi_master.scala 181:19 73:31]
  wire  _GEN_153 = 3'h3 == state ? _GEN_121 : 3'h4 == state; // @[qspi_master.scala 181:19]
  wire [6:0] _GEN_154 = 3'h2 == state ? 7'h3 : _GEN_144; // @[qspi_master.scala 181:19 273:18]
  wire  _GEN_155 = 3'h2 == state | _GEN_143; // @[qspi_master.scala 181:19 274:16]
  wire  _GEN_156 = 3'h2 == state ? 1'h0 : _GEN_145; // @[qspi_master.scala 181:19 275:15]
  wire [15:0] _GEN_157 = 3'h2 == state ? _GEN_96 : _GEN_150; // @[qspi_master.scala 181:19]
  wire  _GEN_158 = 3'h2 == state ? _GEN_97 : _GEN_151; // @[qspi_master.scala 181:19]
  wire  _GEN_160 = 3'h2 == state ? _GEN_99 : _GEN_153; // @[qspi_master.scala 181:19]
  wire [15:0] _GEN_162 = 3'h2 == state ? _GEN_101 : _GEN_146; // @[qspi_master.scala 181:19]
  wire  _GEN_163 = 3'h2 == state ? _GEN_102 : _GEN_147; // @[qspi_master.scala 181:19]
  wire  _GEN_164 = 3'h2 == state ? _GEN_102 : _GEN_148; // @[qspi_master.scala 181:19]
  wire [6:0] _GEN_166 = 3'h1 == state ? 7'h2 : _GEN_154; // @[qspi_master.scala 181:19 231:18]
  wire  _GEN_167 = 3'h1 == state | _GEN_155; // @[qspi_master.scala 181:19 232:16]
  wire  _GEN_168 = 3'h1 == state ? 1'h0 : _GEN_156; // @[qspi_master.scala 181:19 233:15]
  wire [15:0] _GEN_169 = 3'h1 == state ? _GEN_70 : _GEN_157; // @[qspi_master.scala 181:19]
  wire  _GEN_170 = 3'h1 == state ? _GEN_71 : _GEN_158; // @[qspi_master.scala 181:19]
  wire  _GEN_173 = 3'h1 == state ? _GEN_74 : _GEN_160; // @[qspi_master.scala 181:19]
  wire [15:0] _GEN_175 = 3'h1 == state ? _GEN_76 : _GEN_162; // @[qspi_master.scala 181:19]
  wire  _GEN_176 = 3'h1 == state ? _GEN_77 : _GEN_163; // @[qspi_master.scala 181:19]
  wire  _GEN_177 = 3'h1 == state ? _GEN_77 : _GEN_164; // @[qspi_master.scala 181:19]
  clockgen clock_generator ( // @[qspi_master.scala 99:31]
    .clock(clock_generator_clock),
    .reset(clock_generator_reset),
    .io_en(clock_generator_io_en),
    .io_clk_div_valid(clock_generator_io_clk_div_valid),
    .io_clk_div(clock_generator_io_clk_div),
    .io_spi_clk(clock_generator_io_spi_clk),
    .io_spi_fall(clock_generator_io_spi_fall),
    .io_spi_rise(clock_generator_io_spi_rise)
  );
  receiver receiver ( // @[qspi_master.scala 100:24]
    .clock(receiver_clock),
    .reset(receiver_reset),
    .io_en(receiver_io_en),
    .io_rx_edge(receiver_io_rx_edge),
    .io_rx_done(receiver_io_rx_done),
    .io_sdi0(receiver_io_sdi0),
    .io_sdi1(receiver_io_sdi1),
    .io_sdi2(receiver_io_sdi2),
    .io_sdi3(receiver_io_sdi3),
    .io_en_quad_in(receiver_io_en_quad_in),
    .io_counter_in(receiver_io_counter_in),
    .io_counter_in_upd(receiver_io_counter_in_upd),
    .io_data_ready(receiver_io_data_ready),
    .io_data_valid(receiver_io_data_valid),
    .io_data_bits(receiver_io_data_bits),
    .io_clk_en_o(receiver_io_clk_en_o)
  );
  transceiver transmitter ( // @[qspi_master.scala 101:27]
    .clock(transmitter_clock),
    .reset(transmitter_reset),
    .io_en(transmitter_io_en),
    .io_tx_edge(transmitter_io_tx_edge),
    .io_tx_done(transmitter_io_tx_done),
    .io_sdo0(transmitter_io_sdo0),
    .io_sdo1(transmitter_io_sdo1),
    .io_sdo2(transmitter_io_sdo2),
    .io_sdo3(transmitter_io_sdo3),
    .io_en_quad_in(transmitter_io_en_quad_in),
    .io_counter_in(transmitter_io_counter_in),
    .io_counter_in_upd(transmitter_io_counter_in_upd),
    .io_data_ready(transmitter_io_data_ready),
    .io_data_valid(transmitter_io_data_valid),
    .io_data_bits(transmitter_io_data_bits),
    .io_clk_en_o(transmitter_io_clk_en_o)
  );
  assign io_data_tx_ready = _data_to_tx_bits_T_4 & data_to_tx_ready; // @[Mux.scala 101:16]
  assign io_data_rx_valid = receiver_io_data_valid; // @[qspi_master.scala 153:14]
  assign io_data_rx_bits = receiver_io_data_bits; // @[qspi_master.scala 153:14]
  assign io_spi_clk = clock_generator_io_spi_clk; // @[qspi_master.scala 127:11 90:28]
  assign io_cs = 3'h0 == state ? _GEN_36 : _GEN_168; // @[qspi_master.scala 181:19]
  assign io_spi_sdo0 = transmitter_io_sdo0; // @[qspi_master.scala 138:15]
  assign io_spi_sdo1 = transmitter_io_sdo1; // @[qspi_master.scala 139:15]
  assign io_spi_sdo2 = transmitter_io_sdo2; // @[qspi_master.scala 140:15]
  assign io_spi_sdo3 = transmitter_io_sdo3; // @[qspi_master.scala 141:15]
  assign io_debug_state = state; // @[qspi_master.scala 62:18]
  assign io_quad_mode = _T | en_quad_reg; // @[qspi_master.scala 116:39]
  assign io_tx_en = 3'h0 == state ? _GEN_39 : _GEN_173; // @[qspi_master.scala 181:19]
  assign io_rx_en = 3'h0 == state ? _GEN_44 : _GEN_177; // @[qspi_master.scala 181:19]
  assign io_Tx_done = transmitter_io_tx_done; // @[qspi_master.scala 136:11 80:21]
  assign io_Rx_done = receiver_io_rx_done; // @[qspi_master.scala 152:11 82:21]
  assign io_spi_status = 3'h0 == state ? 7'h1 : _GEN_166; // @[qspi_master.scala 181:19 183:18]
  assign clock_generator_clock = clock;
  assign clock_generator_reset = reset;
  assign clock_generator_io_en = 3'h0 == state ? _T_7 : _GEN_167; // @[qspi_master.scala 181:19]
  assign clock_generator_io_clk_div_valid = io_clk_div_valid; // @[qspi_master.scala 122:36]
  assign clock_generator_io_clk_div = io_clk_div; // @[qspi_master.scala 123:30]
  assign receiver_clock = clock;
  assign receiver_reset = reset;
  assign receiver_io_en = 3'h0 == state ? _GEN_44 : _GEN_177; // @[qspi_master.scala 181:19]
  assign receiver_io_rx_edge = clock_generator_io_spi_rise; // @[qspi_master.scala 125:11 89:22]
  assign receiver_io_sdi0 = io_spi_sdi0; // @[qspi_master.scala 146:20]
  assign receiver_io_sdi1 = io_spi_sdi1; // @[qspi_master.scala 147:20]
  assign receiver_io_sdi2 = io_spi_sdi2; // @[qspi_master.scala 148:20]
  assign receiver_io_sdi3 = io_spi_sdi3; // @[qspi_master.scala 149:20]
  assign receiver_io_en_quad_in = _T | en_quad_reg; // @[qspi_master.scala 116:39]
  assign receiver_io_counter_in = 3'h0 == state ? _GEN_43 : _GEN_175; // @[qspi_master.scala 181:19]
  assign receiver_io_counter_in_upd = 3'h0 == state ? _GEN_44 : _GEN_176; // @[qspi_master.scala 181:19]
  assign receiver_io_data_ready = io_data_rx_ready; // @[qspi_master.scala 153:14]
  assign transmitter_clock = clock;
  assign transmitter_reset = reset;
  assign transmitter_io_en = 3'h0 == state ? _GEN_39 : _GEN_173; // @[qspi_master.scala 181:19]
  assign transmitter_io_tx_edge = clock_generator_io_spi_fall; // @[qspi_master.scala 124:12 88:22]
  assign transmitter_io_en_quad_in = _T | en_quad_reg; // @[qspi_master.scala 116:39]
  assign transmitter_io_counter_in = 3'h0 == state ? _GEN_38 : _GEN_169; // @[qspi_master.scala 181:19]
  assign transmitter_io_counter_in_upd = 3'h0 == state ? _GEN_39 : _GEN_170; // @[qspi_master.scala 181:19]
  assign transmitter_io_data_valid = _data_to_tx_bits_T ? 1'h0 : _data_to_tx_bits_T_1 | _data_to_tx_valid_T_7; // @[Mux.scala 101:16]
  assign transmitter_io_data_bits = _data_to_tx_bits_T ? 32'h0 : _data_to_tx_bits_T_8; // @[Mux.scala 101:16]
  always @(posedge clock) begin
    if (reset) begin // @[qspi_master.scala 58:22]
      state <= 3'h0; // @[qspi_master.scala 58:22]
    end else if (3'h0 == state) begin // @[qspi_master.scala 181:19]
      if (io_spi_rd | io_spi_wr | io_spi_qrd | io_spi_qwr) begin // @[qspi_master.scala 184:64]
        if (io_cmd_len != 6'h0) begin // @[qspi_master.scala 187:34]
          state <= 3'h1; // @[qspi_master.scala 193:17]
        end else begin
          state <= _GEN_26;
        end
      end
    end else if (3'h1 == state) begin // @[qspi_master.scala 181:19]
      if (tx_done) begin // @[qspi_master.scala 234:21]
        state <= _GEN_67;
      end
    end else if (3'h2 == state) begin // @[qspi_master.scala 181:19]
      state <= _GEN_100;
    end else begin
      state <= _GEN_149;
    end
    if (reset) begin // @[qspi_master.scala 95:28]
      en_quad_reg <= 1'h0; // @[qspi_master.scala 95:28]
    end else begin
      en_quad_reg <= _GEN_1;
    end
    if (reset) begin // @[qspi_master.scala 96:22]
      do_rx <= 1'h0; // @[qspi_master.scala 96:22]
    end else begin
      do_rx <= _GEN_3;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[2:0];
  _RAND_1 = {1{`RANDOM}};
  en_quad_reg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  do_rx = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
