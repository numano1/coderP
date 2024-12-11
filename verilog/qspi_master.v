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
module rx(
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
  reg [1:0] state; // @[rx.scala 31:22]
  reg [15:0] counter; // @[rx.scala 32:24]
  reg [15:0] counterTrgt; // @[rx.scala 33:28]
  reg [31:0] dataInt; // @[rx.scala 34:24]
  wire  word_Done = ~io_en_quad_in & counter[4:0] == 5'h1f | io_en_quad_in & counter[2:0] == 3'h7; // @[rx.scala 43:68]
  wire [15:0] _done_T_1 = counterTrgt - 16'h1; // @[rx.scala 44:40]
  wire  done = counter == _done_T_1 & io_rx_edge; // @[rx.scala 44:48]
  wire [15:0] _counterTrgt_T_1 = {2'h0,io_counter_in[15:2]}; // @[Cat.scala 33:92]
  wire [15:0] _counter_T_1 = counter + 16'h1; // @[rx.scala 64:28]
  wire [31:0] _dataInt_T_1 = {dataInt[27:0],io_sdi3,io_sdi2,io_sdi1,io_sdi0}; // @[Cat.scala 33:92]
  wire [31:0] _dataInt_T_3 = {dataInt[30:0],io_sdi0}; // @[Cat.scala 33:92]
  wire [31:0] _dataInt_T_4 = io_en_quad_in ? _dataInt_T_1 : _dataInt_T_3; // @[rx.scala 65:23]
  wire [1:0] _GEN_2 = io_data_ready ? 2'h0 : 2'h2; // @[rx.scala 70:31 71:19 73:19]
  wire [1:0] _GEN_3 = ~io_data_ready ? 2'h3 : state; // @[rx.scala 77:32 78:19 31:22]
  wire [1:0] _GEN_5 = word_Done ? _GEN_3 : state; // @[rx.scala 31:22 75:31]
  wire [15:0] _GEN_6 = done ? 16'h0 : _counter_T_1; // @[rx.scala 64:17 67:20 68:19]
  wire  _GEN_7 = done | word_Done; // @[rx.scala 67:20 69:25]
  wire [1:0] _GEN_8 = done ? _GEN_2 : _GEN_5; // @[rx.scala 67:20]
  wire  _GEN_11 = io_rx_edge & _GEN_7; // @[rx.scala 38:17 63:24]
  wire [1:0] _GEN_13 = io_data_ready ? 2'h0 : state; // @[rx.scala 85:27 86:15 31:22]
  wire [1:0] _GEN_14 = io_data_ready ? 2'h1 : state; // @[rx.scala 91:27 92:15 31:22]
  wire [1:0] _GEN_16 = 2'h3 == state ? _GEN_14 : state; // @[rx.scala 54:17 31:22]
  wire  _GEN_17 = 2'h2 == state | 2'h3 == state; // @[rx.scala 54:17 84:21]
  wire  _GEN_22 = 2'h1 == state ? _GEN_11 : _GEN_17; // @[rx.scala 54:17]
  assign io_rx_done = counter == _done_T_1 & io_rx_edge; // @[rx.scala 44:48]
  assign io_data_valid = 2'h0 == state ? 1'h0 : _GEN_22; // @[rx.scala 38:17 54:17]
  assign io_data_bits = dataInt; // @[rx.scala 39:16]
  assign io_clk_en_o = 2'h0 == state ? 1'h0 : 2'h1 == state; // @[rx.scala 54:17 56:19]
  always @(posedge clock) begin
    if (reset) begin // @[rx.scala 31:22]
      state <= 2'h0; // @[rx.scala 31:22]
    end else if (2'h0 == state) begin // @[rx.scala 54:17]
      if (io_en) begin // @[rx.scala 57:19]
        state <= 2'h1; // @[rx.scala 58:15]
      end
    end else if (2'h1 == state) begin // @[rx.scala 54:17]
      if (io_rx_edge) begin // @[rx.scala 63:24]
        state <= _GEN_8;
      end
    end else if (2'h2 == state) begin // @[rx.scala 54:17]
      state <= _GEN_13;
    end else begin
      state <= _GEN_16;
    end
    if (reset) begin // @[rx.scala 32:24]
      counter <= 16'h0; // @[rx.scala 32:24]
    end else if (!(2'h0 == state)) begin // @[rx.scala 54:17]
      if (2'h1 == state) begin // @[rx.scala 54:17]
        if (io_rx_edge) begin // @[rx.scala 63:24]
          counter <= _GEN_6;
        end
      end
    end
    if (reset) begin // @[rx.scala 33:28]
      counterTrgt <= 16'h8; // @[rx.scala 33:28]
    end else if (io_counter_in_upd) begin // @[rx.scala 49:27]
      if (io_en_quad_in) begin // @[rx.scala 50:23]
        counterTrgt <= _counterTrgt_T_1;
      end else begin
        counterTrgt <= io_counter_in;
      end
    end
    if (reset) begin // @[rx.scala 34:24]
      dataInt <= 32'h0; // @[rx.scala 34:24]
    end else if (!(2'h0 == state)) begin // @[rx.scala 54:17]
      if (2'h1 == state) begin // @[rx.scala 54:17]
        if (io_rx_edge) begin // @[rx.scala 63:24]
          dataInt <= _dataInt_T_4; // @[rx.scala 65:17]
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
module tx(
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
  reg [31:0] dataInt; // @[tx.scala 28:24]
  reg [15:0] counter; // @[tx.scala 29:24]
  reg [15:0] counterTrgt; // @[tx.scala 30:28]
  reg  state; // @[tx.scala 31:22]
  wire [15:0] _counter_next_T_1 = counter + 16'h1; // @[tx.scala 39:31]
  wire [15:0] _done_T_1 = counterTrgt - 16'h1; // @[tx.scala 48:37]
  wire  done = counter == _done_T_1 & io_tx_edge; // @[tx.scala 48:45]
  wire [15:0] _GEN_0 = done ? 16'h0 : _counter_next_T_1; // @[tx.scala 40:18 39:20 41:20]
  wire [15:0] _GEN_1 = io_tx_edge ? _GEN_0 : counter; // @[tx.scala 37:16 38:22]
  wire  regDone = ~io_en_quad_in & counter[4:0] == 5'h1f | io_en_quad_in & counter[2:0] == 3'h7; // @[tx.scala 47:63]
  wire [15:0] _counterTrgt_T_1 = {2'h0,io_counter_in[15:2]}; // @[Cat.scala 33:92]
  wire  _T_1 = io_en & io_data_valid; // @[tx.scala 68:18]
  wire  _GEN_5 = io_en & io_data_valid | state; // @[tx.scala 68:36 71:15 31:22]
  wire [31:0] _dataInt_T_1 = {dataInt[27:0],4'h0}; // @[Cat.scala 33:92]
  wire [31:0] _dataInt_T_3 = {dataInt[30:0],1'h0}; // @[Cat.scala 33:92]
  wire [31:0] _dataInt_T_4 = io_en_quad_in ? _dataInt_T_1 : _dataInt_T_3; // @[tx.scala 78:23]
  wire [31:0] _GEN_6 = _T_1 ? io_data_bits : _dataInt_T_4; // @[tx.scala 78:17 82:40 83:21]
  wire [31:0] _GEN_8 = io_data_valid ? io_data_bits : _dataInt_T_4; // @[tx.scala 78:17 91:31 92:21]
  wire  _GEN_10 = io_data_valid & state; // @[tx.scala 31:22 91:31 96:19]
  wire [31:0] _GEN_11 = regDone ? _GEN_8 : _dataInt_T_4; // @[tx.scala 78:17 90:30]
  wire  _GEN_12 = regDone & io_data_valid; // @[tx.scala 52:17 90:30]
  wire  _GEN_13 = regDone ? io_data_valid : 1'h1; // @[tx.scala 75:19 90:30]
  wire  _GEN_14 = regDone ? _GEN_10 : state; // @[tx.scala 31:22 90:30]
  wire [31:0] _GEN_16 = done ? _GEN_6 : _GEN_11; // @[tx.scala 80:20]
  wire  _GEN_17 = done ? _T_1 : _GEN_12; // @[tx.scala 80:20]
  wire  _GEN_18 = done ? _T_1 : _GEN_14; // @[tx.scala 80:20]
  wire  _GEN_19 = done ? _T_1 : _GEN_13; // @[tx.scala 80:20]
  wire  _GEN_22 = io_tx_edge & _GEN_17; // @[tx.scala 52:17 76:24]
  wire  _GEN_24 = io_tx_edge ? _GEN_19 : 1'h1; // @[tx.scala 75:19 76:24]
  wire  _GEN_25 = state & _GEN_24; // @[tx.scala 57:15 65:17]
  wire  _GEN_28 = state & _GEN_22; // @[tx.scala 52:17 65:17]
  assign io_tx_done = counter == _done_T_1 & io_tx_edge; // @[tx.scala 48:45]
  assign io_sdo0 = io_en_quad_in ? dataInt[28] : dataInt[31]; // @[tx.scala 53:17]
  assign io_sdo1 = dataInt[29]; // @[tx.scala 54:21]
  assign io_sdo2 = dataInt[30]; // @[tx.scala 55:21]
  assign io_sdo3 = dataInt[31]; // @[tx.scala 56:21]
  assign io_data_ready = ~state ? _T_1 : _GEN_28; // @[tx.scala 65:17]
  assign io_clk_en_o = ~state ? 1'h0 : _GEN_25; // @[tx.scala 65:17 67:19]
  always @(posedge clock) begin
    if (reset) begin // @[tx.scala 28:24]
      dataInt <= 32'h0; // @[tx.scala 28:24]
    end else if (~state) begin // @[tx.scala 65:17]
      if (io_en & io_data_valid) begin // @[tx.scala 68:36]
        dataInt <= io_data_bits; // @[tx.scala 69:17]
      end
    end else if (state) begin // @[tx.scala 65:17]
      if (io_tx_edge) begin // @[tx.scala 76:24]
        dataInt <= _GEN_16;
      end
    end
    if (reset) begin // @[tx.scala 29:24]
      counter <= 16'h0; // @[tx.scala 29:24]
    end else if (~state) begin // @[tx.scala 65:17]
      counter <= _GEN_1;
    end else if (state) begin // @[tx.scala 65:17]
      if (io_tx_edge) begin // @[tx.scala 76:24]
        counter <= _GEN_0;
      end else begin
        counter <= _GEN_1;
      end
    end else begin
      counter <= _GEN_1;
    end
    if (reset) begin // @[tx.scala 30:28]
      counterTrgt <= 16'h8; // @[tx.scala 30:28]
    end else if (io_counter_in_upd) begin // @[tx.scala 60:27]
      if (io_en_quad_in) begin // @[tx.scala 61:23]
        counterTrgt <= _counterTrgt_T_1;
      end else begin
        counterTrgt <= io_counter_in;
      end
    end
    if (reset) begin // @[tx.scala 31:22]
      state <= 1'h0; // @[tx.scala 31:22]
    end else if (~state) begin // @[tx.scala 65:17]
      state <= _GEN_5;
    end else if (state) begin // @[tx.scala 65:17]
      if (io_tx_edge) begin // @[tx.scala 76:24]
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
  input         io_single_read,
  input         io_single_write,
  input         io_quad_read,
  input         io_quad_write,
  output        io_spi_clk,
  output        io_cs,
  output        io_sdo0,
  output        io_sdo1,
  output        io_sdo2,
  output        io_sdo3,
  input         io_sdi0,
  input         io_sdi1,
  input         io_sdi2,
  input         io_sdi3,
  output [2:0]  io_state,
  output        io_quad_mode
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  wire  clock_generator_clock; // @[qspi_master.scala 114:31]
  wire  clock_generator_reset; // @[qspi_master.scala 114:31]
  wire  clock_generator_io_en; // @[qspi_master.scala 114:31]
  wire  clock_generator_io_clk_div_valid; // @[qspi_master.scala 114:31]
  wire [7:0] clock_generator_io_clk_div; // @[qspi_master.scala 114:31]
  wire  clock_generator_io_spi_clk; // @[qspi_master.scala 114:31]
  wire  clock_generator_io_spi_fall; // @[qspi_master.scala 114:31]
  wire  clock_generator_io_spi_rise; // @[qspi_master.scala 114:31]
  wire  receiver_clock; // @[qspi_master.scala 115:24]
  wire  receiver_reset; // @[qspi_master.scala 115:24]
  wire  receiver_io_en; // @[qspi_master.scala 115:24]
  wire  receiver_io_rx_edge; // @[qspi_master.scala 115:24]
  wire  receiver_io_rx_done; // @[qspi_master.scala 115:24]
  wire  receiver_io_sdi0; // @[qspi_master.scala 115:24]
  wire  receiver_io_sdi1; // @[qspi_master.scala 115:24]
  wire  receiver_io_sdi2; // @[qspi_master.scala 115:24]
  wire  receiver_io_sdi3; // @[qspi_master.scala 115:24]
  wire  receiver_io_en_quad_in; // @[qspi_master.scala 115:24]
  wire [15:0] receiver_io_counter_in; // @[qspi_master.scala 115:24]
  wire  receiver_io_counter_in_upd; // @[qspi_master.scala 115:24]
  wire  receiver_io_data_ready; // @[qspi_master.scala 115:24]
  wire  receiver_io_data_valid; // @[qspi_master.scala 115:24]
  wire [31:0] receiver_io_data_bits; // @[qspi_master.scala 115:24]
  wire  receiver_io_clk_en_o; // @[qspi_master.scala 115:24]
  wire  transmitter_clock; // @[qspi_master.scala 116:27]
  wire  transmitter_reset; // @[qspi_master.scala 116:27]
  wire  transmitter_io_en; // @[qspi_master.scala 116:27]
  wire  transmitter_io_tx_edge; // @[qspi_master.scala 116:27]
  wire  transmitter_io_tx_done; // @[qspi_master.scala 116:27]
  wire  transmitter_io_sdo0; // @[qspi_master.scala 116:27]
  wire  transmitter_io_sdo1; // @[qspi_master.scala 116:27]
  wire  transmitter_io_sdo2; // @[qspi_master.scala 116:27]
  wire  transmitter_io_sdo3; // @[qspi_master.scala 116:27]
  wire  transmitter_io_en_quad_in; // @[qspi_master.scala 116:27]
  wire [15:0] transmitter_io_counter_in; // @[qspi_master.scala 116:27]
  wire  transmitter_io_counter_in_upd; // @[qspi_master.scala 116:27]
  wire  transmitter_io_data_ready; // @[qspi_master.scala 116:27]
  wire  transmitter_io_data_valid; // @[qspi_master.scala 116:27]
  wire [31:0] transmitter_io_data_bits; // @[qspi_master.scala 116:27]
  wire  transmitter_io_clk_en_o; // @[qspi_master.scala 116:27]
  reg [2:0] state; // @[qspi_master.scala 53:22]
  reg  en_quad_reg; // @[qspi_master.scala 109:28]
  reg  do_rx; // @[qspi_master.scala 111:22]
  wire  _T = io_quad_read | io_quad_write; // @[qspi_master.scala 119:21]
  wire  _T_1 = state == 3'h0; // @[qspi_master.scala 121:20]
  wire  _GEN_0 = state == 3'h0 ? 1'h0 : en_quad_reg; // @[qspi_master.scala 121:30 122:17 109:28]
  wire  _GEN_1 = io_quad_read | io_quad_write | _GEN_0; // @[qspi_master.scala 119:39 120:17]
  wire  _GEN_2 = _T_1 ? 1'h0 : do_rx; // @[qspi_master.scala 127:30 128:11 111:22]
  wire  _GEN_3 = io_quad_read | io_single_read | _GEN_2; // @[qspi_master.scala 125:40 126:11]
  wire  _T_7 = io_single_read | io_single_write | io_quad_read | io_quad_write; // @[qspi_master.scala 198:62]
  wire  _T_9 = io_addr_len != 6'h0; // @[qspi_master.scala 208:32]
  wire  _T_10 = io_data_len != 16'h0; // @[qspi_master.scala 215:32]
  wire  _T_12 = io_dummy_len != 16'h0; // @[qspi_master.scala 217:31]
  wire [2:0] _GEN_6 = io_dummy_len != 16'h0 ? 3'h1 : 3'h0; // @[qspi_master.scala 217:40 220:24 94:29]
  wire [2:0] _GEN_12 = io_single_read | io_quad_read ? _GEN_6 : 3'h4; // @[qspi_master.scala 216:48 232:22]
  wire [2:0] _GEN_18 = io_data_len != 16'h0 ? _GEN_12 : 3'h0; // @[qspi_master.scala 215:41 94:29]
  wire [2:0] _GEN_24 = io_addr_len != 6'h0 ? 3'h3 : _GEN_18; // @[qspi_master.scala 208:41 211:20]
  wire [2:0] _GEN_31 = io_cmd_len != 6'h0 ? 3'h2 : _GEN_24; // @[qspi_master.scala 201:34 204:20]
  wire [2:0] _GEN_40 = io_single_read | io_single_write | io_quad_read | io_quad_write ? _GEN_31 : 3'h0; // @[qspi_master.scala 198:80 94:29]
  wire  tx_done = transmitter_io_tx_done; // @[qspi_master.scala 151:11 85:21]
  wire [2:0] _GEN_53 = do_rx ? _GEN_6 : 3'h4; // @[qspi_master.scala 255:23 271:22]
  wire [2:0] _GEN_59 = _T_10 ? _GEN_53 : 3'h0; // @[qspi_master.scala 254:41 94:29]
  wire [2:0] _GEN_65 = _T_9 ? 3'h3 : _GEN_59; // @[qspi_master.scala 247:35 250:20]
  wire [2:0] _GEN_72 = tx_done ? _GEN_65 : 3'h0; // @[qspi_master.scala 246:21 94:29]
  wire [2:0] _GEN_98 = tx_done ? _GEN_59 : 3'h0; // @[qspi_master.scala 288:21 94:29]
  wire [2:0] _GEN_108 = do_rx ? 3'h0 : 3'h4; // @[qspi_master.scala 323:23 331:22 94:29]
  wire [2:0] _GEN_114 = _T_10 ? _GEN_108 : 3'h0; // @[qspi_master.scala 322:35 94:29]
  wire [2:0] _GEN_120 = tx_done ? _GEN_114 : 3'h0; // @[qspi_master.scala 321:21 94:29]
  wire [2:0] _GEN_136 = 3'h4 == state ? 3'h4 : 3'h0; // @[qspi_master.scala 196:19 348:16 94:29]
  wire [2:0] _GEN_148 = 3'h3 == state ? _GEN_120 : _GEN_136; // @[qspi_master.scala 196:19]
  wire [2:0] _GEN_154 = 3'h2 == state ? _GEN_98 : _GEN_148; // @[qspi_master.scala 196:19]
  wire [2:0] _GEN_165 = 3'h1 == state ? _GEN_72 : _GEN_154; // @[qspi_master.scala 196:19]
  wire [2:0] selector = 3'h0 == state ? _GEN_40 : _GEN_165; // @[qspi_master.scala 196:19]
  wire  _data_to_tx_bits_T = selector == 3'h0; // @[qspi_master.scala 174:15]
  wire  _data_to_tx_bits_T_1 = selector == 3'h1; // @[qspi_master.scala 175:15]
  wire  _data_to_tx_bits_T_2 = selector == 3'h2; // @[qspi_master.scala 176:15]
  wire  _data_to_tx_bits_T_3 = selector == 3'h3; // @[qspi_master.scala 177:15]
  wire  _data_to_tx_bits_T_4 = selector == 3'h4; // @[qspi_master.scala 178:15]
  wire [31:0] _data_to_tx_bits_T_5 = _data_to_tx_bits_T_4 ? io_data_tx_bits : 32'h0; // @[Mux.scala 101:16]
  wire [31:0] _data_to_tx_bits_T_6 = _data_to_tx_bits_T_3 ? io_addr : _data_to_tx_bits_T_5; // @[Mux.scala 101:16]
  wire [31:0] _data_to_tx_bits_T_7 = _data_to_tx_bits_T_2 ? io_cmd : _data_to_tx_bits_T_6; // @[Mux.scala 101:16]
  wire [31:0] _data_to_tx_bits_T_8 = _data_to_tx_bits_T_1 ? 32'h0 : _data_to_tx_bits_T_7; // @[Mux.scala 101:16]
  wire  _GEN_32 = io_cmd_len != 6'h0 | _T_9; // @[qspi_master.scala 201:34 205:22]
  wire  _GEN_41 = (io_single_read | io_single_write | io_quad_read | io_quad_write) & _GEN_32; // @[qspi_master.scala 198:80 96:31]
  wire  _GEN_73 = tx_done & _T_9; // @[qspi_master.scala 246:21 96:31]
  wire  _GEN_107 = do_rx ? 1'h0 : 1'h1; // @[qspi_master.scala 323:23 330:28 73:35]
  wire  _GEN_113 = _T_10 & _GEN_107; // @[qspi_master.scala 322:35 73:35]
  wire  _GEN_119 = tx_done & _GEN_113; // @[qspi_master.scala 321:21 73:35]
  wire  _GEN_147 = 3'h3 == state & _GEN_119; // @[qspi_master.scala 196:19 73:35]
  wire  _GEN_160 = 3'h2 == state ? 1'h0 : _GEN_147; // @[qspi_master.scala 196:19 96:31]
  wire  _GEN_166 = 3'h1 == state ? _GEN_73 : _GEN_160; // @[qspi_master.scala 196:19]
  wire  data_valid = 3'h0 == state ? _GEN_41 : _GEN_166; // @[qspi_master.scala 196:19]
  wire  _data_to_tx_valid_T_6 = _data_to_tx_bits_T_3 ? data_valid : _data_to_tx_bits_T_4 & io_data_tx_valid; // @[Mux.scala 101:16]
  wire  _data_to_tx_valid_T_7 = _data_to_tx_bits_T_2 ? data_valid : _data_to_tx_valid_T_6; // @[Mux.scala 101:16]
  wire  data_to_tx_ready = transmitter_io_data_ready; // @[qspi_master.scala 148:23 79:24]
  wire [15:0] _GEN_4 = io_dummy_len != 16'h0 ? io_dummy_len : 16'h0; // @[qspi_master.scala 217:40 218:26 71:31]
  wire [2:0] _GEN_7 = io_dummy_len != 16'h0 ? 3'h3 : 3'h5; // @[qspi_master.scala 217:40 222:21 227:21]
  wire [15:0] _GEN_8 = io_dummy_len != 16'h0 ? 16'h0 : io_data_len; // @[qspi_master.scala 217:40 224:26 75:31]
  wire  _GEN_9 = io_dummy_len != 16'h0 ? 1'h0 : 1'h1; // @[qspi_master.scala 217:40 225:30 77:35]
  wire [15:0] _GEN_10 = io_single_read | io_quad_read ? _GEN_4 : io_data_len; // @[qspi_master.scala 216:48 230:24]
  wire  _GEN_11 = io_single_read | io_quad_read ? _T_12 : 1'h1; // @[qspi_master.scala 216:48 231:28]
  wire [2:0] _GEN_13 = io_single_read | io_quad_read ? _GEN_7 : 3'h4; // @[qspi_master.scala 216:48 234:19]
  wire [15:0] _GEN_14 = io_single_read | io_quad_read ? _GEN_8 : 16'h0; // @[qspi_master.scala 216:48 75:31]
  wire  _GEN_15 = (io_single_read | io_quad_read) & _GEN_9; // @[qspi_master.scala 216:48 77:35]
  wire [15:0] _GEN_16 = io_data_len != 16'h0 ? _GEN_10 : 16'h0; // @[qspi_master.scala 215:41 71:31]
  wire  _GEN_17 = io_data_len != 16'h0 & _GEN_11; // @[qspi_master.scala 215:41 73:35]
  wire [2:0] _GEN_19 = io_data_len != 16'h0 ? _GEN_13 : 3'h0; // @[qspi_master.scala 215:41 238:17]
  wire [15:0] _GEN_20 = io_data_len != 16'h0 ? _GEN_14 : 16'h0; // @[qspi_master.scala 215:41 75:31]
  wire  _GEN_21 = io_data_len != 16'h0 & _GEN_15; // @[qspi_master.scala 215:41 77:35]
  wire [15:0] _GEN_22 = io_addr_len != 6'h0 ? {{10'd0}, io_addr_len} : _GEN_16; // @[qspi_master.scala 208:41 209:22]
  wire  _GEN_23 = io_addr_len != 6'h0 | _GEN_17; // @[qspi_master.scala 208:41 210:26]
  wire [2:0] _GEN_26 = io_addr_len != 6'h0 ? 3'h2 : _GEN_19; // @[qspi_master.scala 208:41 214:17]
  wire [15:0] _GEN_27 = io_addr_len != 6'h0 ? 16'h0 : _GEN_20; // @[qspi_master.scala 208:41 75:31]
  wire  _GEN_28 = io_addr_len != 6'h0 ? 1'h0 : _GEN_21; // @[qspi_master.scala 208:41 77:35]
  wire [15:0] _GEN_29 = io_cmd_len != 6'h0 ? {{10'd0}, io_cmd_len} : _GEN_22; // @[qspi_master.scala 201:34 202:22]
  wire  _GEN_30 = io_cmd_len != 6'h0 | _GEN_23; // @[qspi_master.scala 201:34 203:26]
  wire [15:0] _GEN_34 = io_cmd_len != 6'h0 ? 16'h0 : _GEN_27; // @[qspi_master.scala 201:34 75:31]
  wire  _GEN_35 = io_cmd_len != 6'h0 ? 1'h0 : _GEN_28; // @[qspi_master.scala 201:34 77:35]
  wire  _GEN_36 = io_single_read | io_single_write | io_quad_read | io_quad_write ? 1'h0 : 1'h1; // @[qspi_master.scala 198:80 199:17 63:28]
  wire [15:0] _GEN_38 = io_single_read | io_single_write | io_quad_read | io_quad_write ? _GEN_29 : 16'h0; // @[qspi_master.scala 198:80 71:31]
  wire  _GEN_39 = (io_single_read | io_single_write | io_quad_read | io_quad_write) & _GEN_30; // @[qspi_master.scala 198:80 73:35]
  wire [15:0] _GEN_43 = io_single_read | io_single_write | io_quad_read | io_quad_write ? _GEN_34 : 16'h0; // @[qspi_master.scala 198:80 75:31]
  wire  _GEN_44 = (io_single_read | io_single_write | io_quad_read | io_quad_write) & _GEN_35; // @[qspi_master.scala 198:80 77:35]
  wire [15:0] _GEN_51 = do_rx ? _GEN_4 : io_data_len; // @[qspi_master.scala 255:23 269:24]
  wire  _GEN_52 = do_rx ? _T_12 : 1'h1; // @[qspi_master.scala 255:23 270:28]
  wire [2:0] _GEN_54 = do_rx ? _GEN_7 : 3'h4; // @[qspi_master.scala 255:23 274:19]
  wire [15:0] _GEN_55 = do_rx ? _GEN_8 : 16'h0; // @[qspi_master.scala 255:23 75:31]
  wire  _GEN_56 = do_rx & _GEN_9; // @[qspi_master.scala 255:23 77:35]
  wire [15:0] _GEN_57 = _T_10 ? _GEN_51 : 16'h0; // @[qspi_master.scala 254:41 71:31]
  wire  _GEN_58 = _T_10 & _GEN_52; // @[qspi_master.scala 254:41 73:35]
  wire [2:0] _GEN_60 = _T_10 ? _GEN_54 : 3'h0; // @[qspi_master.scala 254:41 277:17]
  wire [15:0] _GEN_61 = _T_10 ? _GEN_55 : 16'h0; // @[qspi_master.scala 254:41 75:31]
  wire  _GEN_62 = _T_10 & _GEN_56; // @[qspi_master.scala 254:41 77:35]
  wire [15:0] _GEN_63 = _T_9 ? {{10'd0}, io_addr_len} : _GEN_57; // @[qspi_master.scala 247:35 248:22]
  wire  _GEN_64 = _T_9 | _GEN_58; // @[qspi_master.scala 247:35 249:26]
  wire [2:0] _GEN_67 = _T_9 ? 3'h2 : _GEN_60; // @[qspi_master.scala 247:35 253:17]
  wire [15:0] _GEN_68 = _T_9 ? 16'h0 : _GEN_61; // @[qspi_master.scala 247:35 75:31]
  wire  _GEN_69 = _T_9 ? 1'h0 : _GEN_62; // @[qspi_master.scala 247:35 77:35]
  wire [15:0] _GEN_70 = tx_done ? _GEN_63 : 16'h0; // @[qspi_master.scala 246:21 71:31]
  wire  _GEN_71 = tx_done & _GEN_64; // @[qspi_master.scala 246:21 73:35]
  wire  _GEN_74 = tx_done ? _GEN_64 : 1'h1; // @[qspi_master.scala 246:21 280:15]
  wire [15:0] _GEN_76 = tx_done ? _GEN_68 : 16'h0; // @[qspi_master.scala 246:21 75:31]
  wire  _GEN_77 = tx_done & _GEN_69; // @[qspi_master.scala 246:21 77:35]
  wire [15:0] _GEN_96 = tx_done ? _GEN_57 : 16'h0; // @[qspi_master.scala 288:21 71:31]
  wire  _GEN_97 = tx_done & _GEN_58; // @[qspi_master.scala 288:21 73:35]
  wire  _GEN_99 = tx_done ? _GEN_58 : 1'h1; // @[qspi_master.scala 288:21 314:15]
  wire [2:0] _GEN_100 = tx_done ? _GEN_60 : state; // @[qspi_master.scala 288:21 53:22]
  wire [15:0] _GEN_101 = tx_done ? _GEN_61 : 16'h0; // @[qspi_master.scala 288:21 75:31]
  wire  _GEN_102 = tx_done & _GEN_62; // @[qspi_master.scala 288:21 77:35]
  wire [15:0] _GEN_103 = do_rx ? io_data_len : 16'h0; // @[qspi_master.scala 323:23 324:24 75:31]
  wire [2:0] _GEN_105 = do_rx ? 3'h5 : 3'h4; // @[qspi_master.scala 323:23 327:19 334:19]
  wire [15:0] _GEN_106 = do_rx ? 16'h0 : io_data_len; // @[qspi_master.scala 323:23 329:24 71:31]
  wire [15:0] _GEN_109 = _T_10 ? _GEN_103 : 16'h0; // @[qspi_master.scala 322:35 75:31]
  wire  _GEN_110 = _T_10 & do_rx; // @[qspi_master.scala 322:35 77:35]
  wire [2:0] _GEN_111 = _T_10 ? _GEN_105 : 3'h0; // @[qspi_master.scala 322:35 337:17]
  wire [15:0] _GEN_112 = _T_10 ? _GEN_106 : 16'h0; // @[qspi_master.scala 322:35 71:31]
  wire [15:0] _GEN_115 = tx_done ? _GEN_109 : 16'h0; // @[qspi_master.scala 321:21 75:31]
  wire  _GEN_116 = tx_done & _GEN_110; // @[qspi_master.scala 321:21 77:35]
  wire [2:0] _GEN_117 = tx_done ? _GEN_111 : state; // @[qspi_master.scala 321:21 53:22]
  wire [15:0] _GEN_118 = tx_done ? _GEN_112 : 16'h0; // @[qspi_master.scala 321:21 71:31]
  wire  _GEN_121 = tx_done ? _GEN_113 : 1'h1; // @[qspi_master.scala 321:21 340:15]
  wire [2:0] _GEN_122 = tx_done ? 3'h0 : 3'h4; // @[qspi_master.scala 350:21 351:15 354:15]
  wire  tx_clock_en = transmitter_io_clk_en_o; // @[qspi_master.scala 152:15 90:25]
  wire  _GEN_123 = tx_done ? 1'h0 : tx_clock_en; // @[qspi_master.scala 346:16 350:21 352:18]
  wire  rx_done = receiver_io_rx_done; // @[qspi_master.scala 167:11 88:21]
  wire [2:0] _GEN_124 = rx_done ? 3'h6 : 3'h5; // @[qspi_master.scala 361:21 362:15 364:15]
  wire  _GEN_125 = rx_done ? 1'h0 : 1'h1; // @[qspi_master.scala 361:21 365:15 67:26]
  wire  spi_fall = clock_generator_io_spi_fall; // @[qspi_master.scala 139:12 98:22]
  wire [2:0] _GEN_126 = spi_fall ? 3'h0 : 3'h6; // @[qspi_master.scala 372:22 373:15 375:15]
  wire  _GEN_128 = 3'h6 == state ? 1'h0 : 1'h1; // @[qspi_master.scala 196:19 371:15 63:28]
  wire [2:0] _GEN_129 = 3'h6 == state ? _GEN_126 : state; // @[qspi_master.scala 196:19 53:22]
  wire  rx_clock_en = receiver_io_clk_en_o; // @[qspi_master.scala 169:15 92:25]
  wire  _GEN_130 = 3'h5 == state ? rx_clock_en : 3'h6 == state; // @[qspi_master.scala 196:19 359:16]
  wire  _GEN_131 = 3'h5 == state ? 1'h0 : _GEN_128; // @[qspi_master.scala 196:19 360:15]
  wire [2:0] _GEN_132 = 3'h5 == state ? _GEN_124 : _GEN_129; // @[qspi_master.scala 196:19]
  wire  _GEN_134 = 3'h4 == state ? _GEN_123 : _GEN_130; // @[qspi_master.scala 196:19]
  wire  _GEN_135 = 3'h4 == state ? 1'h0 : _GEN_131; // @[qspi_master.scala 196:19 347:15]
  wire [2:0] _GEN_138 = 3'h4 == state ? _GEN_122 : _GEN_132; // @[qspi_master.scala 196:19]
  wire  _GEN_139 = 3'h4 == state ? 1'h0 : 3'h5 == state & _GEN_125; // @[qspi_master.scala 196:19 67:26]
  wire  _GEN_140 = 3'h3 == state | _GEN_134; // @[qspi_master.scala 196:19 319:16]
  wire  _GEN_141 = 3'h3 == state ? 1'h0 : _GEN_135; // @[qspi_master.scala 196:19 320:15]
  wire [15:0] _GEN_142 = 3'h3 == state ? _GEN_115 : 16'h0; // @[qspi_master.scala 196:19 75:31]
  wire  _GEN_143 = 3'h3 == state & _GEN_116; // @[qspi_master.scala 196:19 77:35]
  wire  _GEN_144 = 3'h3 == state ? _GEN_116 : _GEN_139; // @[qspi_master.scala 196:19]
  wire [2:0] _GEN_145 = 3'h3 == state ? _GEN_117 : _GEN_138; // @[qspi_master.scala 196:19]
  wire [15:0] _GEN_146 = 3'h3 == state ? _GEN_118 : 16'h0; // @[qspi_master.scala 196:19 71:31]
  wire  _GEN_149 = 3'h3 == state ? _GEN_121 : 3'h4 == state; // @[qspi_master.scala 196:19]
  wire  _GEN_150 = 3'h2 == state | _GEN_140; // @[qspi_master.scala 196:19 286:16]
  wire  _GEN_151 = 3'h2 == state ? 1'h0 : _GEN_141; // @[qspi_master.scala 196:19 287:15]
  wire [15:0] _GEN_152 = 3'h2 == state ? _GEN_96 : _GEN_146; // @[qspi_master.scala 196:19]
  wire  _GEN_153 = 3'h2 == state ? _GEN_97 : _GEN_147; // @[qspi_master.scala 196:19]
  wire  _GEN_155 = 3'h2 == state ? _GEN_99 : _GEN_149; // @[qspi_master.scala 196:19]
  wire [15:0] _GEN_157 = 3'h2 == state ? _GEN_101 : _GEN_142; // @[qspi_master.scala 196:19]
  wire  _GEN_158 = 3'h2 == state ? _GEN_102 : _GEN_143; // @[qspi_master.scala 196:19]
  wire  _GEN_159 = 3'h2 == state ? _GEN_102 : _GEN_144; // @[qspi_master.scala 196:19]
  wire  _GEN_161 = 3'h1 == state | _GEN_150; // @[qspi_master.scala 196:19 244:16]
  wire  _GEN_162 = 3'h1 == state ? 1'h0 : _GEN_151; // @[qspi_master.scala 196:19 245:15]
  wire [15:0] _GEN_163 = 3'h1 == state ? _GEN_70 : _GEN_152; // @[qspi_master.scala 196:19]
  wire  _GEN_164 = 3'h1 == state ? _GEN_71 : _GEN_153; // @[qspi_master.scala 196:19]
  wire  _GEN_167 = 3'h1 == state ? _GEN_74 : _GEN_155; // @[qspi_master.scala 196:19]
  wire [15:0] _GEN_169 = 3'h1 == state ? _GEN_76 : _GEN_157; // @[qspi_master.scala 196:19]
  wire  _GEN_170 = 3'h1 == state ? _GEN_77 : _GEN_158; // @[qspi_master.scala 196:19]
  wire  _GEN_171 = 3'h1 == state ? _GEN_77 : _GEN_159; // @[qspi_master.scala 196:19]
  clockgen clock_generator ( // @[qspi_master.scala 114:31]
    .clock(clock_generator_clock),
    .reset(clock_generator_reset),
    .io_en(clock_generator_io_en),
    .io_clk_div_valid(clock_generator_io_clk_div_valid),
    .io_clk_div(clock_generator_io_clk_div),
    .io_spi_clk(clock_generator_io_spi_clk),
    .io_spi_fall(clock_generator_io_spi_fall),
    .io_spi_rise(clock_generator_io_spi_rise)
  );
  rx receiver ( // @[qspi_master.scala 115:24]
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
  tx transmitter ( // @[qspi_master.scala 116:27]
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
  assign io_data_rx_valid = receiver_io_data_valid; // @[qspi_master.scala 168:14]
  assign io_data_rx_bits = receiver_io_data_bits; // @[qspi_master.scala 168:14]
  assign io_spi_clk = clock_generator_io_spi_clk; // @[qspi_master.scala 102:28 142:11]
  assign io_cs = 3'h0 == state ? _GEN_36 : _GEN_162; // @[qspi_master.scala 196:19]
  assign io_sdo0 = transmitter_io_sdo0; // @[qspi_master.scala 153:11]
  assign io_sdo1 = transmitter_io_sdo1; // @[qspi_master.scala 154:11]
  assign io_sdo2 = transmitter_io_sdo2; // @[qspi_master.scala 155:11]
  assign io_sdo3 = transmitter_io_sdo3; // @[qspi_master.scala 156:11]
  assign io_state = state; // @[qspi_master.scala 57:12]
  assign io_quad_mode = _T | en_quad_reg; // @[qspi_master.scala 131:44]
  assign clock_generator_clock = clock;
  assign clock_generator_reset = reset;
  assign clock_generator_io_en = 3'h0 == state ? _T_7 : _GEN_161; // @[qspi_master.scala 196:19]
  assign clock_generator_io_clk_div_valid = io_clk_div_valid; // @[qspi_master.scala 137:36]
  assign clock_generator_io_clk_div = io_clk_div; // @[qspi_master.scala 138:30]
  assign receiver_clock = clock;
  assign receiver_reset = reset;
  assign receiver_io_en = 3'h0 == state ? _GEN_44 : _GEN_171; // @[qspi_master.scala 196:19]
  assign receiver_io_rx_edge = clock_generator_io_spi_rise; // @[qspi_master.scala 100:22 140:11]
  assign receiver_io_sdi0 = io_sdi0; // @[qspi_master.scala 161:20]
  assign receiver_io_sdi1 = io_sdi1; // @[qspi_master.scala 162:20]
  assign receiver_io_sdi2 = io_sdi2; // @[qspi_master.scala 163:20]
  assign receiver_io_sdi3 = io_sdi3; // @[qspi_master.scala 164:20]
  assign receiver_io_en_quad_in = _T | en_quad_reg; // @[qspi_master.scala 131:44]
  assign receiver_io_counter_in = 3'h0 == state ? _GEN_43 : _GEN_169; // @[qspi_master.scala 196:19]
  assign receiver_io_counter_in_upd = 3'h0 == state ? _GEN_44 : _GEN_170; // @[qspi_master.scala 196:19]
  assign receiver_io_data_ready = io_data_rx_ready; // @[qspi_master.scala 168:14]
  assign transmitter_clock = clock;
  assign transmitter_reset = reset;
  assign transmitter_io_en = 3'h0 == state ? _GEN_39 : _GEN_167; // @[qspi_master.scala 196:19]
  assign transmitter_io_tx_edge = clock_generator_io_spi_fall; // @[qspi_master.scala 139:12 98:22]
  assign transmitter_io_en_quad_in = _T | en_quad_reg; // @[qspi_master.scala 131:44]
  assign transmitter_io_counter_in = 3'h0 == state ? _GEN_38 : _GEN_163; // @[qspi_master.scala 196:19]
  assign transmitter_io_counter_in_upd = 3'h0 == state ? _GEN_39 : _GEN_164; // @[qspi_master.scala 196:19]
  assign transmitter_io_data_valid = _data_to_tx_bits_T ? 1'h0 : _data_to_tx_bits_T_1 | _data_to_tx_valid_T_7; // @[Mux.scala 101:16]
  assign transmitter_io_data_bits = _data_to_tx_bits_T ? 32'h0 : _data_to_tx_bits_T_8; // @[Mux.scala 101:16]
  always @(posedge clock) begin
    if (reset) begin // @[qspi_master.scala 53:22]
      state <= 3'h0; // @[qspi_master.scala 53:22]
    end else if (3'h0 == state) begin // @[qspi_master.scala 196:19]
      if (io_single_read | io_single_write | io_quad_read | io_quad_write) begin // @[qspi_master.scala 198:80]
        if (io_cmd_len != 6'h0) begin // @[qspi_master.scala 201:34]
          state <= 3'h1; // @[qspi_master.scala 207:17]
        end else begin
          state <= _GEN_26;
        end
      end
    end else if (3'h1 == state) begin // @[qspi_master.scala 196:19]
      if (tx_done) begin // @[qspi_master.scala 246:21]
        state <= _GEN_67;
      end
    end else if (3'h2 == state) begin // @[qspi_master.scala 196:19]
      state <= _GEN_100;
    end else begin
      state <= _GEN_145;
    end
    if (reset) begin // @[qspi_master.scala 109:28]
      en_quad_reg <= 1'h0; // @[qspi_master.scala 109:28]
    end else begin
      en_quad_reg <= _GEN_1;
    end
    if (reset) begin // @[qspi_master.scala 111:22]
      do_rx <= 1'h0; // @[qspi_master.scala 111:22]
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
