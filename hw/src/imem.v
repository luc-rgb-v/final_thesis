`timescale 1ns / 1ps
module imem (
  input wire clk_i,
  input wire en_i,
  input wire [9:0] instr_addr_i,
  output reg [31:0] instruction_o
);
  reg [31:0] instructions_r [0:1023];
  always @ (posedge clk_i) begin
    if (en_i) instruction_o <= instructions_r[instr_addr_i];
  end
endmodule
