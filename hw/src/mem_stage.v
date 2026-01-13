`timescale 1ns / 1ps
`include "defines.vh"

// MEM stage for 1-cycle synchronous Dmem:
// - store_cvt: combinational, drives Dmem request in the *current* cycle
// - Dmem returns read data 1 cycle later on dmem_dout_i
// - load_cvt: combinational, converts dmem_dout_i using the *latched* request metadata
// - MEM/WB regs capture (latched control/ALU/PC) + (converted load data) together

module mem_stage (
  input  wire        clk_i,
  input  wire        rst_i,

  // Inputs from EX/MEM stage
  input  wire        mem_we_i,
  input  wire        mem_en_i,
  input  wire [2:0]  mem_width_se_i,

  input  wire [31:0] mem_alu_result_i,
  input  wire [31:0] mem_data_i,

  input  wire        mem_regwrite_i,
  input  wire [4:0]  mem_rd_addr_i,
  input  wire [1:0]  mem_wb_se_i,
  input  wire [31:0] mem_pc_plus_i,

  // Memory interface (1-cycle)
  output wire        dmem_en_o,
  output wire [3:0]  dmem_we_o,
  output wire [31:0] dmem_addr_o,
  output wire [31:0] dmem_din_o,
  input  wire [31:0] dmem_dout_i,

  // Outputs to WB stage (MEM/WB registers)
  output reg         memwb_regwrite_o,
  output reg  [4:0]  memwb_rd_addr_o,
  output reg  [1:0]  memwb_wb_se_o,
  output reg  [31:0] memwb_pc_plus_o,
  output reg  [31:0] memwb_alu_result_o,
  output wire [31:0] memwb_mem_data_o,

  output reg  [1:0]  mem_stage_err_r,
  output reg stall_by_mem
);

  // ------------------------------------------------------------
  // Current-cycle request to Dmem (combinational)
  // ------------------------------------------------------------
  wire [31:0] address_w = mem_en_i ? mem_alu_result_i : 32'b0;

  wire        write_error_w;

  store_cvt store_cvt_u (
    .addr_i      (address_w),
    .data_i      (mem_data_i),
    .width_se_i  (mem_width_se_i),
    .we_i        (mem_we_i),
    .en_i        (mem_en_i),
    .write_error (write_error_w),

    // dmem interface
    .dmem_en_o   (dmem_en_o),
    .dmem_we_o   (dmem_we_o),
    .dmem_addr_o (dmem_addr_o),
    .dmem_din_o  (dmem_din_o)
  );

  // ------------------------------------------------------------
  // Latch request metadata (1 cycle) to match dmem_dout_i latency
  // ------------------------------------------------------------
  reg [1:0]  op_r;           // addr[1:0] of the request (byte offset)
  reg [2:0]  width_se_r;     // width + sign/zero-ext info
  reg        we_r;
  reg        en_r;
  reg        write_error_r;

  // Also latch the WB-related signals for the same request
  reg [31:0] alu_result_r;
  reg        regwrite_r;
  reg [4:0]  rd_addr_r;
  reg [1:0]  wb_se_r;
  reg [31:0] pc_plus_r;

  always @(negedge clk_i) begin
    if (rst_i) begin 
      stall_by_mem <= 0;
    end else begin
      if ((mem_en_i == 1) && (mem_we_i == 0)) begin
        if (stall_by_mem == 1) stall_by_mem <= 0;
        else stall_by_mem <= 1;
      end else begin 
        stall_by_mem <= 0;
      end
    end
  end

  always @(posedge clk_i) begin
    if (rst_i) begin
      op_r          <= 2'b00;
      width_se_r    <= 3'b000;
      we_r          <= 1'b0;
      en_r          <= 1'b0;
      write_error_r <= 1'b0;

      alu_result_r  <= 32'b0;
      regwrite_r    <= 1'b0;
      rd_addr_r     <= 5'b0;
      wb_se_r       <= 2'b0;
      pc_plus_r     <= (`RESET_PC + 32'h4);
    end else begin
      op_r          <= mem_alu_result_i[1:0];
      width_se_r    <= mem_width_se_i;
      we_r          <= mem_we_i;
      en_r          <= mem_en_i;
      write_error_r <= write_error_w;

      alu_result_r  <= mem_alu_result_i;
      regwrite_r    <= mem_regwrite_i;
      rd_addr_r     <= mem_rd_addr_i;
      wb_se_r       <= mem_wb_se_i;
      pc_plus_r     <= mem_pc_plus_i;
    end
  end

  // ------------------------------------------------------------
  // Convert the *returned* read data (combinational)
  // dmem_dout_i corresponds to the request captured in *_r above.
  // ------------------------------------------------------------
  wire [31:0] load_data_w_raw;
  wire        read_error_w;

  load_cvt load_cvt_u (
    .op_i         (op_r),
    .width_se_i   (width_se_r),
    .we_i         (we_r),
    .en_i         (en_r),
    .read_error_o (read_error_w),

    .dmem_dout_i  (dmem_dout_i),
    .data_o       (load_data_w_raw)
  );

  // Optional safety gate: only forward load data when it was a load.
  // (If your load_cvt already outputs 0 for non-load, this gate is harmless.)
  wire is_load_r = en_r & ~we_r;
  wire [31:0] load_data_w = is_load_r ? load_data_w_raw : 32'b0;

  // Error encoding (aligned to the returned data/control)
  wire [1:0] mem_stage_err_w =
      (write_error_r) ? 2'b01 :
      (read_error_w)  ? 2'b10 :
                        2'b00;

  // ------------------------------------------------------------
  // MEM/WB pipeline register (captures aligned control + load data)
  // ------------------------------------------------------------
  reg [31:0] memwb_mem_data_r;
  assign memwb_mem_data_o = memwb_mem_data_r;

  always @(posedge clk_i) begin
    if (rst_i) begin
      memwb_regwrite_o   <= 1'b0;
      memwb_rd_addr_o    <= 5'b0;
      memwb_wb_se_o      <= 2'b0;
      memwb_pc_plus_o    <= (`RESET_PC + 32'h4);
      memwb_alu_result_o <= 32'b0;
      memwb_mem_data_r   <= 32'b0;
      mem_stage_err_r    <= 2'b00;
    end else begin
      // The *_r regs still hold the previous cycle's request info here (NBA semantics),
      // so these assignments are aligned to dmem_dout_i conversion.
      memwb_regwrite_o   <= regwrite_r;
      memwb_rd_addr_o    <= rd_addr_r;
      memwb_wb_se_o      <= wb_se_r;
      memwb_pc_plus_o    <= pc_plus_r;
      memwb_alu_result_o <= alu_result_r;
      memwb_mem_data_r   <= load_data_w;
      mem_stage_err_r    <= mem_stage_err_w;
    end
  end

endmodule
