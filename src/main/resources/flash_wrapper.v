//`default_nettype none

module flash_wrapper(
    input [2:0] debug_state_i,
    input       spi_wr_i,
    input       quad_mode_i,
    input       cs_i,
    input       spi_clk_i,
    input       sdi0_i,
    input       sdi1_i,
    input       sdi2_i,
    input       sdi3_i,
    input       flash_reset_i,
    output      sdo0_o,
    output      sdo1_o,
    output      sdo2_o,
    output      sdo3_o
);

    wire [3:0] DQ;
    wire sdo0;
    wire sdo1;
    wire sdo2;
    wire sdo3;
    wire sdi0;
    wire sdi1;
    wire sdi2;
    wire sdi3;
    assign sdo0 = sdi0_i;
    assign sdo1 = sdi1_i;
    assign sdo2 = sdi2_i;
    assign sdo3 = sdi3_i;

    assign sdo0_o = sdi0;
    assign sdo1_o = sdi1;
    assign sdo2_o = sdi2;
    assign sdo3_o = sdi3;

    // Assignments for DQ with single drivers
    assign DQ[3] = (((debug_state_i >= 1) && (debug_state_i <= 6)) || ((debug_state_i == 0) && (spi_wr_i == 1))) && quad_mode_i ? sdo3 :
                   (((debug_state_i >= 1) && (debug_state_i <= 6)) || ((debug_state_i == 0)) && !quad_mode_i) ? 1'b1 : 1'bz;
    assign DQ[2] = (((debug_state_i >= 1) && (debug_state_i <= 6)) || ((debug_state_i == 0))) && quad_mode_i ? sdo2 : 1'bz;
    assign DQ[1] = (((debug_state_i >= 1) && (debug_state_i <= 6)) || ((debug_state_i == 0))) && quad_mode_i ? sdo1 : 1'bz;
    assign DQ[0] = (((debug_state_i >= 1) && (debug_state_i <= 6)) || ((debug_state_i == 0))) ? sdo0 : 1'bz;


    // Assignments for io_spi_sdiX with single drivers
    assign sdi3 = (debug_state_i == 5 && quad_mode_i) ? DQ[3] :
                  debug_state_i == 5 ? 1'b1 : 1'b0;
    assign sdi2 = (debug_state_i == 5 && quad_mode_i) ? DQ[2] : 1'b0;
    assign sdi1 = (debug_state_i == 5 && quad_mode_i) ? DQ[1] : 1'b0;
    assign sdi0 = debug_state_i == 5 ? DQ[0] : 1'b0;

    // Flash Module Instantiation
    flash_module flash (
        .S(cs_i),              // Connect io_cs from qspi_master to S
        .C(spi_clk_i),         // Connect io_spi_clk from qspi_master to C
        .HOLD_DQ3(DQ[3]),      // Unconnected
        .DQ0(DQ[0]),           // Unconnected
        .DQ1(DQ[1]),           // Corrected here
        .Vcc(32'h00000BB8),    // Use Vcc_flash to drive Vcc
        .Vpp_W_DQ2(DQ[2]),     // Set to default
        .RESET2(flash_reset_i) // Set to default
    );
    
endmodule