`timescale 1ns / 1ps
`include "defines.vh"
// signal converting 
module load_cvt (
  // signal from EX stage
  input wire [1:0] op_i,
  input wire [2:0] width_se_i,
  input wire we_i,
  input wire en_i,
  output reg read_error_o,

  // dmem interface
  input wire [31:0] dmem_dout_i,

  // output to mem/wb stage
  output reg [31:0] data_o

);

  always @ (*) begin
    data_o = 32'b0;
    read_error_o = 1'b0;
  if (en_i) begin
    if (!we_i) begin
      case(width_se_i)
        `LB: begin
          if (op_i == 2'b00) data_o = {{24{dmem_dout_i[7]}}, dmem_dout_i[7:0]};
          else if (op_i == 2'b01) data_o = {{24{dmem_dout_i[15]}}, dmem_dout_i[15:8]};
          else if (op_i == 2'b10) data_o = {{24{dmem_dout_i[23]}}, dmem_dout_i[23:16]};
          else data_o = {{24{dmem_dout_i[31]}}, dmem_dout_i[31:24]};
        end
        `LH: begin
          if (op_i == 2'b00) data_o = {{16{dmem_dout_i[15]}}, dmem_dout_i[15:0]};
          else if (op_i == 2'b10) data_o = {{16{dmem_dout_i[31]}}, dmem_dout_i[31:16]};
          else begin
            data_o = 32'b0;
            read_error_o = 1;
          end
        end
        `LW: begin
          if (op_i == 2'b00) data_o = dmem_dout_i;
          else begin
            data_o = 32'b0;
            read_error_o = 1;
          end
        end
        `LBU: begin
          if (op_i == 2'b00) data_o = {24'b0, dmem_dout_i[7:0]};
          else if (op_i == 2'b01) data_o = {24'b0, dmem_dout_i[15:8]};
          else if (op_i == 2'b10) data_o = {24'b0, dmem_dout_i[23:16]};
          else data_o = {24'b0, dmem_dout_i[31:24]};
        end
        `LHU: begin
          if (op_i == 2'b00) data_o = {16'b0, dmem_dout_i[15:0]};
          else if (op_i == 2'b10) data_o = {16'b0, dmem_dout_i[31:16]};
          else begin
            data_o = 32'b0;
            read_error_o = 1;
          end
        end
        default: begin
            read_error_o = 1;
            data_o = 32'b0;
        end
      endcase
    end
    end else begin
      data_o = 32'b0;
    end
  end

endmodule
