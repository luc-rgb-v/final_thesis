`timescale 1ns / 1ps
module dmem (
  input  wire       clka,
  input  wire       ena,
  input  wire       wea,
  input  wire [7:0] addra,
  input  wire [7:0] dina,
  output reg  [7:0] douta
);

  reg [7:0] mem [0:255];
  always @(posedge clka) begin
    if (ena) begin
      if (wea)
        mem[addra] <= dina;
      douta <= mem[addra];
    end
  end
endmodule
