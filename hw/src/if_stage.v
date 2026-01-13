`timescale 1ns / 1ps
`include "defines.vh"

module if_stage (
  input  wire        clk_i,
  input  wire        rst_i,

  input  wire        flush_i,
  input  wire        stall_i,

  input  wire        if_bj_taken_i,
  input  wire [31:0] if_pc_bj_i,

  // imem interface
  output wire        imem_en_o,
  output wire [31:0] imem_addr_o,
  input  wire [31:0] imem_instr_i,

  // IF/ID pipeline outputs
  output wire [31:0] ifid_pc_o,
  output wire [31:0] ifid_instruction_o
);

  wire [31:0] if_pc_w;
  wire [31:0] if_pc_next_w;
  wire [31:0] pc_sub_w;

  reg [31:0] pc_r;
  reg [31:0] ifid_pc_r;
  reg [31:0] ifid_instruction_r;
  reg [31:0] pc_sub_r;

  reg imem_en_r;
  // assignments
  assign pc_sub_w = pc_sub_r;
  assign if_pc_w = pc_r;
  assign imem_addr_o = if_pc_w;
  assign imem_en_o = imem_en_r;

  assign ifid_pc_o = ifid_pc_r;
  assign ifid_instruction_o = ifid_instruction_r;

  assign if_pc_next_w = if_bj_taken_i ? if_pc_bj_i : (if_pc_w + 32'h4);

  reg zero_1;
  reg zero_2;

  always @(negedge clk_i) begin
    if (rst_i) begin
      zero_1 <= 1'b0;
      zero_2 <= 1'b0;
    end else begin
      zero_1 <= if_bj_taken_i;
      zero_2 <= zero_1;
    end
  end

  wire [31:0] mux_pc = (zero_2 | if_bj_taken_i) ? `RESET_PC : pc_sub_w;
  wire [31:0] mux_instr = (zero_2 | if_bj_taken_i) ? `NOP_INSTR : imem_instr_i;

  // PC register
  always @(posedge clk_i) begin
    if (rst_i)
      pc_r <= `RESET_PC;
    else if (~stall_i)
      pc_r <= if_pc_next_w;
  end

  // imem enable
  always @(*) begin
    if (stall_i || rst_i)
      imem_en_r = 1'b0;
    else
      imem_en_r = 1'b1;
  end

  // pc_sub register
  always @(posedge clk_i) begin
    if (rst_i)
      pc_sub_r <= `RESET_PC;
    else if (~stall_i)
      pc_sub_r <= if_pc_w;
  end

  // IF/ID register
  always @(posedge clk_i) begin
    if (rst_i || flush_i || if_bj_taken_i) begin
      ifid_pc_r <= `RESET_PC;
      ifid_instruction_r <= `NOP_INSTR;
    end else if (~stall_i) begin
      ifid_instruction_r <= (^mux_instr === 1'bX) ? `NOP_INSTR : mux_instr;
      ifid_pc_r <= mux_pc;
    end
  end

endmodule
