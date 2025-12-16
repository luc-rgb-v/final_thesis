`timescale 1ns / 1ps
module top_connect (
    input wire clk_i,
    input wire rst_i
);

    // Wires between master and slave
    wire        stb;
    wire        cyc;
    wire        we;
    wire        en;
    wire [31:0] adr;
    wire [31:0] dat_m2s;
    wire [31:0] dat_s2m;
    wire [2:0]  width_se;
    wire        ack;
    wire        err;

    // -----------------------
    // CPU / Wishbone Master
    // -----------------------
    riscv_top_wb_m risc_wb_uut (
        .clk_i(clk_i),
        .rst_i(rst_i),

        // Wishbone master out
        .stb_o(stb),
        .cyc_o(cyc),
        .we_o(we),
        .en_o(en),              // custom enable signal
        .adr_o(adr),
        .dat_o(dat_m2s),
        .width_se_o(width_se),

        // Wishbone master in
        .dat_i(dat_s2m),
        .ack_i(ack),
        .err_i(err)
    );

    // -----------------------
    // DMEM Wishbone Slave
    // -----------------------
    dmem_wb dmem_wb_uut (
        .clk_i(clk_i),
        .rst_i(rst_i),

        .addr_i(adr[7:0]),      // memory is only 256 bytes → 8-bit address
        .data_i(dat_m2s),
        .data_o(dat_s2m),
        .width_se_i(width_se),
        .we_i(we),

        .stb_i(stb),
        .ack_o(ack),
        .err_o(err),
        .cyc_i(cyc)
    );

endmodule
