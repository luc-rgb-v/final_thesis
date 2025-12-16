`timescale 1ns / 1ps
// data memory wishbone slave
module dmem_wb (
  input wire clk_i,
  input wire rst_i,
  input wire [9:0] addr_i,
  input wire [31:0] data_i,
  output reg [31:0] data_o,
  input wire [2:0] width_se_i,
  input wire we_i,
  input wire stb_i,
  output reg ack_o,
  output reg err_o
  //input wire cyc_i
);

  // load operations
  localparam LB  = 3'b000;
  localparam LH  = 3'b001;
  localparam LW  = 3'b010;
  localparam LBU = 3'b100;
  localparam LHU = 3'b101;
  // store operations
  localparam SB  = 3'b000;
  localparam SH  = 3'b001;
  localparam SW  = 3'b010;
  // wishbone state
  localparam IDLE = 2'b00;
  localparam PROCESS = 2'b01;
  localparam END_PHASE = 2'b11;

  reg [31:0] dina;
  reg ena;
  reg [3:0] wea;
  reg write_error;
  reg read_error;
  wire [31:0] douta;
  wire [1:0] op = addr_i[1:0];

  reg [1:0] state;

  always @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      state <= IDLE;
      ack_o <= 1'b0;
      err_o <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (stb_i) begin
            ack_o <= 1'b0;
            err_o <= 1'b0;
            state <= PROCESS;
          end
        end
        PROCESS: begin
          if (!write_error && !read_error) begin
            ack_o <= 1'b1;
            err_o <= 1'b0;
          end else 
          state <= END_PHASE;
        end
        END_PHASE: begin
          if (~stb_i) begin
            ack_o <= 1'b0;
            err_o <= 1'b0;
            state <= IDLE;
          end
        end
        default: begin
          state <= IDLE;
          ack_o <= 1'b0;
          err_o <= 1'b0;
        end
      endcase
    end
  end

  dmem_wrab dmem_uut(
    .clka(clk_i),
    .ena(ena),
    .wea(wea),
    .addra(addr_i[9:2]),
    .dina(dina),
    .douta(douta)
  );

  always @ (*) begin
    wea    = 4'b0000;
    data_o = 32'b0;
    dina   = 32'b0;
    read_error = 1'b0;
    write_error = 1'b0;
  if (stb_i) begin
    ena = 1'b1;
    if (we_i) begin
      case (width_se_i)
        SB: begin
          if (op == 2'b00) begin wea = 4'b0001; dina[7:0] = data_i[7:0]; end
          else if (op == 2'b01) begin wea = 4'b0010; dina[15:8] = data_i[7:0]; end
          else if (op == 2'b10) begin wea = 4'b0100; dina[23:16] = data_i[7:0]; end
          else begin wea = 4'b1000; dina[31:24] = data_i[7:0]; end
        end
        SH: begin
          if (op == 2'b00) begin wea = 4'b0011; dina[15:0] = data_i[15:0]; end
          else if (op == 2'b10) begin wea = 4'b1100; dina[31:16] = data_i[15:0]; end
          else begin
            wea = 4'b0000;
            write_error = 1;
          end
        end
        SW: begin
          if (op == 2'b00) begin
            wea = 4'b1111;
            dina = data_i;
          end else write_error = 1;
        end
        default: begin
          write_error = 1;
        end
      endcase
    end else begin
      case(width_se_i)
        LB: begin
          if (op == 2'b00) data_o = {{24{douta[7]}}, douta[7:0]};
          else if (op == 2'b01) data_o = {{24{douta[15]}}, douta[15:8]};
          else if (op == 2'b10) data_o = {{24{douta[23]}}, douta[23:16]};
          else data_o = {{24{douta[31]}}, douta[31:24]};
        end
        LH: begin
          if (op == 2'b00) data_o = {{16{douta[15]}}, douta[15:0]};
          else if (op == 2'b10) data_o = {{16{douta[31]}}, douta[31:16]};
          else begin
            data_o = 32'b0;
            read_error = 1;
          end
        end
        LW: begin
          if (op == 2'b00) data_o = douta;
          else begin
            data_o = 32'b0;
            read_error = 1;
          end
        end
        LBU: begin
          if (op == 2'b00) data_o = {24'b0, douta[7:0]};
          else if (op == 2'b01) data_o = {24'b0, douta[15:8]};
          else if (op == 2'b10) data_o = {24'b0, douta[23:16]};
          else data_o = {24'b0, douta[31:24]};
        end
        LHU: begin
          if (op == 2'b00) data_o = {16'b0, douta[15:0]};
          else if (op == 2'b10) data_o = {16'b0, douta[31:16]};
          else begin
            data_o = 32'b0;
            read_error = 1;
          end
        end
        default: begin
            read_error = 1;
        end
      endcase
    end
    end else begin
      ena = 1'b0;
      data_o = 32'b0;
    end
  end

endmodule
