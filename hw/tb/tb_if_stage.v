`timescale 1ns / 1ps
`include "defines.vh"
//`define _IP_
module tb_if_stage;

  // --------------------------------------------------
  // Clock & Reset
  // --------------------------------------------------
  reg clk;
  reg rst;

  always #20 clk = ~clk;   // 20ns clock (50 MHz)

  // --------------------------------------------------
  // IF stage signals
  // --------------------------------------------------
  reg         stall_i;
  reg         flush_i;
  reg         if_bj_taken_i;
  reg [31:0]  if_pc_bj_i;
  wire [31:0] current_pc_r;
  wire        imem_en_o;
  wire [31:0] imem_addr_o;
  wire [31:0] imem_instr_i;

  wire [31:0] ifid_pc_o;
  wire [31:0] ifid_instruction_o;
  assign current_pc_r = dut_if_stage.pc_r;

  // --------------------------------------------------
  // DUT: IF stage
  // --------------------------------------------------
  if_stage dut_if_stage (
    .clk_i                (clk),
    .rst_i                (rst),
    .flush_i              (flush_i),
    .stall_i              (stall_i),
    .if_bj_taken_i        (if_bj_taken_i),
    .if_pc_bj_i           (if_pc_bj_i),
    .imem_en_o            (imem_en_o),
    .imem_addr_o          (imem_addr_o),
    .imem_instr_i         (imem_instr_i),
    .ifid_pc_o            (ifid_pc_o),
    .ifid_instruction_o   (ifid_instruction_o)
  );

  // --------------------------------------------------
  // Instruction Memory
  // --------------------------------------------------
`ifdef _IP_
  imem_ip dut_imem (
    .clka  (clk),
    .ena   (imem_en_o),
    .wea   (4'b0),
    .addra (imem_addr_o[11:2]),
    .dina  (32'b0),
    .douta (imem_instr_i)
  );
`else
  imem dut_imem (
    .en_i          (imem_en_o),
    .instr_addr_i  (imem_addr_o[11:2]),
    .instruction_o (imem_instr_i)
  );
`endif

  initial begin
    $readmemh("instructions.mem", dut_imem.instructions_r);
    $dumpfile("IF_stage_dump.vcd");
    $dumpvars(0,tb_if_stage);
  end

  // --------------------------------------------------
  // Test Sequence
  // --------------------------------------------------
  initial begin
    // init
    clk = 0;
    rst = 1;
    stall_i = 0;
    flush_i = 0;
    if_bj_taken_i = 0;
    if_pc_bj_i = 32'h00000008;
    #40;
    rst = 0;

    #80;
    stall_i = 1;
    #40;
    stall_i = 0;
    #80;
    flush_i = 1;
    #40;
    flush_i = 0;
    #120;
    if_bj_taken_i = 1;
    #40;
    if_bj_taken_i = 0;
    #80;
    stall_i = 1;
    #40;
    if_bj_taken_i = 1;
    #40;
    if_bj_taken_i = 0;
    #40;
    stall_i = 0;

    #200;

    $finish;
  end

endmodule
