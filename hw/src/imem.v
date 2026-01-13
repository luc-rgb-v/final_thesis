`timescale 1ns / 1ps
module imem (
  //input wire clk_i,
  input wire en_i,
  input wire [9:0] instr_addr_i,
  output wire [31:0] instruction_o
);
  reg [31:0] instructions_r [0:1023];
  assign instruction_o = (en_i == 1) ? instructions_r[instr_addr_i] : 32'h00000013;
/*
  always @ (posedge clk_i) begin
    if (en_i) instruction_o <= instructions_r[instr_addr_i];
  end
*/

endmodule
