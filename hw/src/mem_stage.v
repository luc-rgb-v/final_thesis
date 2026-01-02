`timescale 1ns / 1ps
module mem_stage (
  input wire clk_i,
  input wire rst_i,

  // Inputs from EX/MEM stage or data memory
  input wire mem_we_i,
  input wire mem_en_i,
  input wire [2:0] mem_width_se_i,

  input wire [31:0] mem_alu_result_i,
  input wire [31:0] mem_data_i,

  input wire mem_regwrite_i,
  input wire [4:0] mem_rd_addr_i,
  input wire [1:0] mem_wb_se_i,
  input wire [31:0] mem_pc_plus_i,

  // Memory interface
  output wire dmem_en_o,
  output wire [3:0] dmem_we_o,
  output wire [31:0] dmem_addr_o,
  output wire [31:0] dmem_din_o,
  input wire [31:0] dmem_dout_i,

  // Outputs to WB stage (MEM/WB registers)
  output reg memwb_regwrite_o,
  output reg [4:0] memwb_rd_addr_o,
  output reg [1:0] memwb_wb_se_o,
  output reg [31:0] memwb_pc_plus_o,
  output reg [31:0] memwb_alu_result_o,
  output wire [31:0] memwb_mem_data_o,

  output reg [1:0] mem_stage_err_r
);

  reg [1:0] op_r;
  reg [2:0] width_se_r;
  reg we_r, en_r, write_error_r;

/*
  reg [31:0] sub_alu_result_r;
  reg sub_regwrite_r;
  reg [4:0] sub_rd_addr_r;
  reg [1:0] sub_wb_se_r;
  reg [31:0] sub_pc_plus_r;
*/

  wire [31:0] address_w = mem_en_i ? mem_alu_result_i : 31'b0;
  wire [31:0] load_data_w;
  wire read_error_w;
  wire write_error_w;
  wire [1:0] op_w = mem_en_i ? mem_alu_result_i[1:0] : 2'b0;
  wire [1:0] mem_stage_err_w = write_error_r ? 2'b01 : read_error_w ? 2'b10 : 2'b00;

  load_cvt load_cvt_u (
      // signals from EX stage
      .op_i         (op_r),
      .width_se_i   (width_se_r),
      .we_i         (we_r),
      .en_i         (en_r),
      .read_error_o (read_error_w),

      // dmem interface
      .dmem_dout_i  (dmem_dout_i),

      // output to MEM/WB stage
      .data_o       (load_data_w)
  );

  store_cvt store_cvt_u (
      .addr_i       (address_w),
      .data_i       (mem_data_i),
      .width_se_i   (mem_width_se_i),
      .we_i         (mem_we_i),
      .en_i         (mem_en_i),
      .write_error  (write_error_w),

      // dmem interface
      .dmem_en_o    (dmem_en_o),
      .dmem_we_o    (dmem_we_o),
      .dmem_addr_o  (dmem_addr_o),
      .dmem_din_o   (dmem_din_o)
  );

  // sub latch signal for memory access
  always @ (posedge clk_i) begin
    if (rst_i) begin
      op_r <= 2'b0;
      width_se_r <= 3'b0;
      we_r <= 1'b0;
      en_r <= 1'b0;
      write_error_r <= 1'b0;
    end else begin
      op_r <= op_w;
      width_se_r <= mem_width_se_i;
      we_r <= mem_we_i;
      en_r <= mem_en_i;
      write_error_r <= write_error_w;
    end
  end

/*
  // sub latch signal for wb stage
  always @(posedge clk_i) begin
    if (rst_i) begin
      sub_alu_result_r <= 32'b0;
      sub_regwrite_r <= 1'b0;
      sub_rd_addr_r <= 5'b0;
      sub_wb_se_r <= 2'b0;
      sub_pc_plus_r <= 32'b0;
    end else begin
      sub_alu_result_r <= mem_alu_result_i;
      sub_regwrite_r <= mem_regwrite_i;
      sub_rd_addr_r <= mem_rd_addr_i;
      sub_wb_se_r <= mem_wb_se_i;
      sub_pc_plus_r <= mem_pc_plus_i;
    end
  end
  */

  // ------------------------------------------------------------
  // MEM → WB pipeline register
  // ------------------------------------------------------------
  always @(posedge clk_i) begin
    if (rst_i) begin
      memwb_regwrite_o   <= 1'b0;
      memwb_rd_addr_o    <= 5'b0;
      memwb_wb_se_o      <= 2'b0;
      memwb_pc_plus_o    <= 32'b0;
      memwb_alu_result_o <= 32'b0;
      //memwb_mem_data_o   <= 32'b0;
      mem_stage_err_r    <= 2'b0;
    end else begin
      /*
      memwb_regwrite_o   <= sub_regwrite_r;
      memwb_rd_addr_o    <= sub_rd_addr_r;
      memwb_wb_se_o      <= sub_wb_se_r;
      memwb_pc_plus_o    <= sub_pc_plus_r;
      memwb_alu_result_o <= sub_alu_result_r;
      */
      
      memwb_regwrite_o   <= mem_regwrite_i;
      memwb_rd_addr_o    <= mem_rd_addr_i;
      memwb_wb_se_o      <= mem_wb_se_i;
      memwb_pc_plus_o    <= mem_pc_plus_i;
      memwb_alu_result_o <= mem_alu_result_i;
      
      //memwb_mem_data_o   <= load_data_w; // from bram
      mem_stage_err_r    <= mem_stage_err_w;
    end
  end
assign memwb_mem_data_o = load_data_w;
endmodule
