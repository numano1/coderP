`timescale 1ns/1ps

module tb_qspi_master;
    // Testbench signals
    reg clock;
    reg reset;
    reg [7:0] io_clk_div;
    reg io_clk_div_valid;
    reg [31:0] io_addr;
    reg [5:0] io_addr_len;
    reg [31:0] io_cmd;
    reg [5:0] io_cmd_len;
    reg [15:0] io_dummy_len;
    reg [15:0] io_data_len;
    wire io_data_tx_ready;
    reg io_data_tx_valid;
    reg [31:0] io_data_tx_bits;
    reg io_data_rx_ready;
    wire io_data_rx_valid;
    wire [31:0] io_data_rx_bits;
    reg io_spi_rd;
    reg io_spi_wr;
    reg io_spi_qrd;
    reg io_spi_qwr;
    wire io_spi_clk;
    wire io_cs;
    wire sdo0;
    wire sdo1;
    wire sdo2;
    wire sdo3;
    wire sdi0;
    wire sdi1;
    wire sdi2;
    wire sdi3;
    wire [2:0] io_debug_state;
    wire io_quad_mode;
    reg flash_reset;
    wire [3:0] DQ;
    reg [31:0] Vcc_flash; 
    

    // Assignments for DQ with single drivers
assign DQ[3] = (((io_debug_state >= 1) && (io_debug_state <= 6)) || ((io_debug_state == 0) && (io_spi_wr == 1))) && io_quad_mode ? sdo3 :
               (((io_debug_state >= 1) && (io_debug_state <= 6)) || ((io_debug_state == 0)) && !io_quad_mode) ? 1'b1 : 1'bz;

assign DQ[2] = (((io_debug_state >= 1) && (io_debug_state <= 6)) || ((io_debug_state == 0))) && io_quad_mode ? sdo2 : 1'bz;

assign DQ[1] = (((io_debug_state >= 1) && (io_debug_state <= 6)) || ((io_debug_state == 0))) && io_quad_mode ? sdo1 : 1'bz;

assign DQ[0] = (((io_debug_state >= 1) && (io_debug_state <= 6)) || ((io_debug_state == 0))) ? sdo0 : 1'bz;


    // Assignments for io_spi_sdiX with single drivers
    assign sdi3 = (io_debug_state == 5 && io_quad_mode) ? DQ[3] :
                  io_debug_state == 5 ? 1'b1 : 1'b0;
    assign sdi2 = (io_debug_state == 5 && io_quad_mode) ? DQ[2] : 1'b0;
    assign sdi1 = (io_debug_state == 5 && io_quad_mode) ? DQ[1] : 1'b0;
    assign sdi0 = io_debug_state == 5 ? DQ[0] : 1'b0;

    // DUT Instantiation
    qspi_master uut (
        .clock(clock),
        .reset(reset),
        .io_clk_div(io_clk_div),
        .io_clk_div_valid(io_clk_div_valid),
        .io_addr(io_addr),
        .io_addr_len(io_addr_len),
        .io_cmd(io_cmd),
        .io_cmd_len(io_cmd_len),
        .io_dummy_len(io_dummy_len),
        .io_data_len(io_data_len),
        .io_data_tx_ready(io_data_tx_ready),
        .io_data_tx_valid(io_data_tx_valid),
        .io_data_tx_bits(io_data_tx_bits),
        .io_data_rx_ready(io_data_rx_ready),
        .io_data_rx_valid(io_data_rx_valid),
        .io_data_rx_bits(io_data_rx_bits),
        .io_single_read(io_spi_rd),
        .io_single_write(io_spi_wr),
        .io_quad_read(io_spi_qrd),
        .io_quad_write(io_spi_qwr),
        .io_spi_clk(io_spi_clk),
        .io_cs(io_cs),
        .io_sdo0(sdo0),
        .io_sdo1(sdo1),
        .io_sdo2(sdo2),
        .io_sdo3(sdo3),
        .io_sdi0(sdi0),
        .io_sdi1(sdi1),
        .io_sdi2(sdi2),
        .io_sdi3(sdi3),
        .io_state(io_debug_state),
        .io_quad_mode(io_quad_mode)
    );

    // Flash Module Instantiation
    flash_module flash (
        .S(io_cs),         // Connect io_cs from qspi_master to S
        .C(io_spi_clk),    // Connect io_spi_clk from qspi_master to C
        .HOLD_DQ3(DQ[3]),  // Unconnected
        .DQ0(DQ[0]),       // Unconnected
        .DQ1(DQ[1]),       // Corrected here
        .Vcc(32'h00000BB8),   // Use Vcc_flash to drive Vcc
        .Vpp_W_DQ2(DQ[2]), // Set to default
        .RESET2(flash_reset) // Set to default
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Generate a clock with 10 ns period
    end

    // Stimulus
    initial begin
        // Initialize all signals
        reset = 1;
        io_clk_div = 8'h0;
        io_clk_div_valid = 0;
        io_addr = 32'h0;
        io_addr_len = 6'h0;
        io_cmd = 32'h0;
        io_cmd_len = 6'h0;
        io_dummy_len = 16'h0;
        io_data_len = 16'h0;
        io_data_tx_valid = 0;
        io_data_tx_bits = 32'h0;
        io_data_rx_ready = 0;
        io_spi_rd = 0;
        io_spi_wr = 0;
        io_spi_qrd = 0;
        io_spi_qwr = 0;
        Vcc_flash = 32'h00000000;

        // Reset sequence
        #20 reset = 0;

        // Set clock divider
        #10 io_clk_div_valid = 1;
        io_clk_div = 8'h1;

        // Simulate a write command
        #10 io_clk_div_valid = 0;
        io_cmd = 32'h06000000; //WRITE ENABLE
        io_cmd_len = 6'd8;
        io_spi_wr = 1;
        #10
        io_cmd = 32'h00000000;
        io_cmd_len = 6'd0;
        io_spi_wr = 0;
        

        #340
        io_spi_wr = 1;
        io_cmd = 32'hB1000000; //WRITE NON_VLOATILE REGISTER
        io_cmd_len = 6'd8;
        #10
        io_cmd = 32'h00000000;
        io_cmd_len = 6'd0;
        //io_spi_wr = 0;
        
        
       
        
        

         
        
        #300
        //io_spi_wr = 1'b1;
        io_data_len = 16'd16;
        io_data_tx_bits = 32'hF7AF0000; //DUMMY CYCLE 10 AND QUAD MODE
        io_data_tx_valid = 1'b1;
        #10
        io_data_len = 16'd0;
        io_data_tx_bits = 32'h00000000;
        io_data_tx_valid = 1'b0;
        io_spi_wr = 1'b0;
        #640
         flash_reset =1'b0; // TO UPDATE VOLATILE REGISTER YOU NEED TO POWER OFF AFTER THIS TO UPDATE ENHANCED VOLATILE REGISTER
        #20
        flash_reset =1'b1;
        io_cmd = 32'h70000000; //READ STATUS REGISTER
        io_cmd_len= 6'd8;
        io_spi_qwr =1'b1;
        #10
        io_cmd = 32'h00000000;
        io_cmd_len= 6'd0;
        io_spi_qwr =1'b0;
        #50
        io_spi_qrd = 1'b1; //IT TAKES ONE CLOCK CYCLE FOR DO_RX TO BE UPDATED
        #10
        
        io_data_len =32'd8;
        io_data_rx_ready = 1'b1;
        #10 
        io_data_len = 32'd0;
        io_spi_qrd = 1'b0;
        

        /*WRITTING DATA IN QUAD MODE INTO THE FLASH 1.WRITE ENABLE COMMAND 2.WRITE INTO THE FLASH IN QUAD MODE COMMAND 3.THE DATA*/
        #90
        io_cmd = 32'h06000000; //WRITE ENABLE
        io_cmd_len = 6'd8;
        io_spi_qwr = 1;
        #10
        io_cmd = 32'h00000000;
        io_cmd_len = 6'd0;
        io_spi_qwr = 0;
        #90 
        io_cmd = 32'h02000000; //WRTIE in quad mode
        io_cmd_len = 6'd8;
        io_spi_qwr = 1;
        #10
        io_cmd = 32'h00000000;
        io_cmd_len = 6'd0;
        //io_spi_qwr = 0;
        #60 
        io_addr =32'h80000600;
        io_addr_len =6'd24;
        #10
        io_addr =32'd0;
        io_addr_len =6'd0;
        #230
        io_data_len = 32'd32;
        io_data_tx_bits =32'h12345678;
        io_data_tx_valid = 1'b1;
        #10
        io_data_len = 32'b0;
        io_data_tx_bits =32'h0;
        io_data_tx_valid = 1'b0;
        io_spi_qwr = 0;
        
        #1500000
        io_cmd = 32'h0B000000; // FAST READ
        io_cmd_len = 32'd8;
        io_spi_qwr= 1;
        #10
        io_cmd = 32'h00000000;
        io_cmd_len = 6'd0;
        //io_spi_qwr = 0;
        #60 
        io_addr =32'h80000600;
        io_addr_len =6'd24;
        #10
        io_addr =32'd0;
        io_addr_len =6'd0;
        io_spi_qwr = 0;
        io_spi_qrd =1;
        #230
        io_data_len = 32'd32;
        io_data_rx_ready=1'b1;
        io_dummy_len =16'd40;
        #400
        io_dummy_len =16'd0;
        //io_data_len =32'd0;
        //io_spi_qrd =0;
        #300
        io_spi_qrd =0;
        io_data_len =32'd0;
        
        
        
        
        
        
    end

    
    
endmodule


