`timescale 1ns / 1ps
`include "defines.vh"
// signal converting 
module store_cvt (
  // signal from EX stage
  input wire [31:0] addr_i,
  input wire [31:0] data_i,
  input wire [2:0] width_se_i,
  input wire we_i,
  input wire en_i,
  output reg write_error,

  // dmem interface
  output reg dmem_en_o,
  output reg [3:0] dmem_we_o,
  output wire [31:0] dmem_addr_o,
  output reg [31:0] dmem_din_o
);

  wire [1:0] op = addr_i[1:0];
  assign dmem_addr_o = addr_i;

  always @ (*) begin
    dmem_we_o = 4'b0000;
    dmem_din_o = 32'b0;
    write_error = 1'b0;
    dmem_en_o = 1'b0;
  if (en_i) begin
    dmem_en_o = 1'b1;
    if (we_i) begin
      case (width_se_i)
        `SB: begin
          if (op == 2'b00) begin dmem_we_o = 4'b0001; dmem_din_o[7:0] = data_i[7:0]; end
          else if (op == 2'b01) begin dmem_we_o = 4'b0010; dmem_din_o[15:8] = data_i[7:0]; end
          else if (op == 2'b10) begin dmem_we_o = 4'b0100; dmem_din_o[23:16] = data_i[7:0]; end
          else begin dmem_we_o = 4'b1000; dmem_din_o[31:24] = data_i[7:0]; end
        end
        `SH: begin
          if (op == 2'b00) begin dmem_we_o = 4'b0011; dmem_din_o[15:0] = data_i[15:0]; end
          else if (op == 2'b10) begin dmem_we_o = 4'b1100; dmem_din_o[31:16] = data_i[15:0]; end
          else begin
            dmem_we_o = 4'b0000;
            write_error = 1;
          end
        end
        `SW: begin
          if (op == 2'b00) begin
            dmem_we_o = 4'b1111;
            dmem_din_o = data_i;
          end else write_error = 1;
        end
        default: begin
          write_error = 1;
          dmem_din_o = 32'b0;
        end
      endcase
    end 
    end else begin
      dmem_en_o = 1'b0;
      dmem_we_o = 4'b0000;
      dmem_din_o = 32'b0;
      write_error = 1'b0;
    end
  end

endmodule
