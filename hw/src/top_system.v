`timescale 1ns / 1ps
`include "defines.vh"
`define _STALL_DEBUG_
module top_system (
  input wire clk_i,
  input wire rst_i,
  // Imem interface
  output wire imem_en_o,
  output wire [31:0] imem_addr_o,
  input wire [31:0] imem_instr_i,
  // Dmem interface
  output wire dmem_en_o,
  output wire [3:0] dmem_we_o,
  output wire [31:0] dmem_addr_o,
  output wire [31:0] dmem_w_data_o,
  input wire [31:0] dmem_r_data_i,
  // Register file interface
  output wire [4:0] rs1_addr,
  output wire [4:0] rs2_addr,
  input wire [31:0] rs1_data,
  input wire [31:0] rs2_data,
  output wire reg_write,
  output wire [4:0] rd_addr,
  output wire [31:0] rd_data,

  // I2C
  inout wire i2c_sda_io,
  inout wire i2c_scl_io,
  output wire i2c_ready_o,
  
  // UART
  output wire txd_o,
  output wire uart_busy_o,
  output wire uart_data_ready_o,

  input wire if_flush_i,
  input wire stall_i,
  output wire [1:0] mem_err_o //write_error_r ? 2'b01 : read_error_w ? 2'b10 
);

  // ------------------------------------------------------------
  // IF stage wires
  // ------------------------------------------------------------
  wire if_flush_w;
  wire if_stall_w;

  wire id_flush_w;
  wire id_stall_w;

  wire ex_flush_w;
  wire ex_stall_w;

  // ------------------------------------------------------------
  // ID stage wires
  // ------------------------------------------------------------
  wire [4:0] rs1_addr_w;
  wire [4:0] rs2_addr_w;
  wire [31:0] rs1_data_w;
  wire [31:0] rs2_data_w;

  assign rs1_addr = rs1_addr_w;
  assign rs2_addr = rs2_addr_w;
  assign rs1_data_w = rs1_data;
  assign rs2_data_w = rs2_data;

  // From IF/ID
  wire [31:0] ifid_pc_w;
  wire [31:0] ifid_instruction_w;

  // From WB (register file writeback)
  wire        rf_reg_write_w;
  wire [4:0]  rf_rd_addr_w;
  wire [31:0] rf_rd_data_w;

  assign reg_write = rf_reg_write_w;
  assign rd_addr = rf_rd_addr_w;
  assign rd_data = rf_rd_data_w;

  // ------------------------------------------------------------
  // EX stage wires
  // ------------------------------------------------------------

  // From ID/EX
  wire [31:0] idex_pc_w;
  wire [31:0] idex_imm_w;
  wire [31:0] idex_rs1_data_w;
  wire [31:0] idex_rs2_data_w;

  wire        idex_jal_w;
  wire        idex_jalr_w;
  wire        idex_se_alu_src1_w;
  wire        idex_se_alu_src2_w;
  wire [3:0]  idex_aluop_w;
  wire        idex_mem_we_w;
  wire        idex_mem_en_w;
  wire [2:0]  idex_width_se_w;
  wire [1:0]  idex_wb_se_w;
  wire        idex_regwrite_w;
  wire [4:0]  idex_rd_addr_w;

  // EX → IF
  wire [31:0] exif_pc_bj_w;
  wire        exif_bj_taken_w;

  assign id_flush_w = exif_bj_taken_w;
  assign ex_flush_w = exif_bj_taken_w;

  wire [4:0] idex_rs1_addr_w;
  wire [4:0] idex_rs2_addr_w;

  assign if_flush_w = if_flush_i;

  // ------------------------------------------------------------
  // Data memory convert (DMEM_CVT) wires
  // ------------------------------------------------------------

  // From EX/MEM stage
  wire [2:0] exmem_width_se_w;
  wire       exmem_mem_we_w;
  wire       exmem_mem_en_w;
  wire [1:0] mem_stage_err_w;

  //wire mem_read_async;
  //assign mem_read_async = exmem_mem_en_w & ~exmem_mem_we_w;
  assign if_stall_w = stall_i;
  assign id_stall_w = stall_i;
  assign ex_stall_w = stall_i;

  assign mem_err_o = mem_stage_err_w;

  // ------------------------------------------------------------
  // MEM stage wires
  // ------------------------------------------------------------

  // From EX/MEM
  wire        exmem_regwrite_w;
  wire [4:0]  exmem_rd_addr_w;
  wire [1:0]  exmem_wb_se_w;
  wire [31:0] exmem_pc_plus_w;
  wire [31:0] exmem_alu_result_w;
  wire [31:0] exmem_rs2_data_w;

  // MEM/WB
  wire        memwb_regwrite_w;
  wire [4:0]  memwb_rd_addr_w;
  wire [1:0]  memwb_wb_se_w;
  wire [31:0] memwb_pc_plus_w;
  wire [31:0] memwb_alu_result_w;
  wire [31:0] memwb_mem_data_w;

  // mem stage external interface
  wire mem_en_w;
  wire [3:0] mem_we_w;
  wire [3:0] mem_addr_w;
  wire [31:0] mem_w_data_w;
  wire [31:0] mem_r_data_w;

  wire [31:0] forward_src_1_w, forward_src_2_w;
  // ------------------------------------------------------------
  // WB stage wires
  // ------------------------------------------------------------

  wire [31:0] wb_data_w;
  assign wb_data_w = (memwb_wb_se_w == 2'b00) ? memwb_alu_result_w :
                     (memwb_wb_se_w == 2'b01) ? memwb_mem_data_w   :
                     (memwb_wb_se_w == 2'b10) ? memwb_pc_plus_w    : 32'b0;

  assign rf_reg_write_w = memwb_regwrite_w;
  assign rf_rd_addr_w = memwb_rd_addr_w;
  assign rf_rd_data_w = wb_data_w;

  // UART reg
  reg [7:0] tx_data_r;
  reg tx_valid_r;
  reg [15:0] uart_prescale_r;

  // UART status
  wire uart_data_ready_w;
  wire uart_busy_w;

  assign uart_data_ready_o = uart_data_ready_w;
  assign uart_busy_o = uart_busy_w;

  // I2C reg
  reg [6:0] i2c_addr_r;
  reg [7:0] i2c_wdata_r;
  reg i2c_enable_r;
  reg i2c_rw_r;

  // I2C wire
  wire [7:0] i2c_rdata_w;
  wire i2c_ready_w;

  assign i2c_ready_o = i2c_ready_w;

  // ------------------------------------------------------------
  // IF stage
  // ------------------------------------------------------------
  if_stage u_if_stage (
    .clk_i              (clk_i),
    .rst_i              (rst_i),

    .flush_i            (if_flush_w),
    .stall_i            (if_stall_w),

    .if_bj_taken_i      (exif_bj_taken_w),
    .if_pc_bj_i         (exif_pc_bj_w),

    // Instruction memory
    .imem_en_o          (imem_en_o),
    .imem_addr_o        (imem_addr_o),
    .imem_instr_i       (imem_instr_i),

    // IF/ID pipeline
    .ifid_pc_o          (ifid_pc_w),
    .ifid_instruction_o (ifid_instruction_w)
  );

  // ------------------------------------------------------------
  // ID stage
  // ------------------------------------------------------------
  id_stage u_id_stage (
    .clk_i                  (clk_i),
    .rst_i                  (rst_i),

    .ifid_pc_i              (ifid_pc_w),
    .ifid_instruction_i     (ifid_instruction_w),

    .flush_i                (id_flush_w),
    .stall_i                (id_stall_w),

    .rf_rs1_addr_o          (rs1_addr_w),
    .rf_rs2_addr_o          (rs2_addr_w),
    .rf_rs1_data_i          (rs1_data_w),
    .rf_rs2_data_i          (rs2_data_w),

    // ID/EX outputs
    .idex_jal_o              (idex_jal_w),
    .idex_jalr_o             (idex_jalr_w),
    .idex_se_alu_src1_o      (idex_se_alu_src1_w),
    .idex_se_alu_src2_o      (idex_se_alu_src2_w),
    .idex_aluop_o            (idex_aluop_w),
    .idex_rs1_data_o         (idex_rs1_data_w),
    .idex_rs2_data_o         (idex_rs2_data_w),
    .idex_imm_o              (idex_imm_w),
    .idex_rs1_addr_o         (idex_rs1_addr_w),
    .idex_rs2_addr_o         (idex_rs2_addr_w),
    .idex_mem_we_o           (idex_mem_we_w),
    .idex_mem_en_o           (idex_mem_en_w),
    .idex_width_se_o         (idex_width_se_w),
    .idex_wb_se_o            (idex_wb_se_w),
    .idex_regwrite_o         (idex_regwrite_w),
    .idex_rd_addr_o          (idex_rd_addr_w),
    .idex_pc_o               (idex_pc_w)
  );

  // ------------------------------------------------------------
  // EX stage
  // ------------------------------------------------------------
  ex_stage u_ex_stage (
    .clk_i                (clk_i),
    .rst_i                (rst_i),

    .flush_i              (ex_flush_w),
    .stall_i              (ex_stall_w),

    // ID/EX inputs
    .ex_pc_i              (idex_pc_w),
    .ex_imm_i             (idex_imm_w),
    .ex_rs1_data_i        (forward_src_1_w),
    .ex_rs2_data_i        (forward_src_2_w),

    .ex_jal_i             (idex_jal_w),
    .ex_jalr_i            (idex_jalr_w),
    .ex_alu_src1_i        (idex_se_alu_src1_w),
    .ex_alu_src2_i        (idex_se_alu_src2_w),
    .ex_aluop_i           (idex_aluop_w),
    .ex_mem_we_i          (idex_mem_we_w),
    .ex_mem_en_i          (idex_mem_en_w),
    .ex_width_se_i        (idex_width_se_w),
    .ex_wb_se_i           (idex_wb_se_w),
    .ex_regwrite_i        (idex_regwrite_w),
    .ex_rd_addr_i         (idex_rd_addr_w),

    // EX → IF
    .exif_pc_bj_o         (exif_pc_bj_w),
    .exif_bj_taken_o      (exif_bj_taken_w),

    // EX/MEM
    .exmem_mem_we_o       (exmem_mem_we_w),
    .exmem_mem_en_o       (exmem_mem_en_w),
    .exmem_width_se_o     (exmem_width_se_w),
    .exmem_wb_se_o        (exmem_wb_se_w),
    .exmem_regwrite_o     (exmem_regwrite_w),
    .exmem_rd_addr_o      (exmem_rd_addr_w),
    .exmem_alu_result_o   (exmem_alu_result_w),
    .exmem_rs2_data_o     (exmem_rs2_data_w),
    .exmem_pc_plus_o      (exmem_pc_plus_w)
  );

  // ------------------------------------------------------------
  // MEM stage
  // ------------------------------------------------------------

  mem_stage u_mem_stage (
    .clk_i               (clk_i),
    .rst_i               (rst_i),

    // EX/MEM inputs
    .mem_we_i            (exmem_mem_we_w),
    .mem_en_i            (exmem_mem_en_w),
    .mem_width_se_i      (exmem_width_se_w),

    .mem_alu_result_i    (exmem_alu_result_w),
    .mem_data_i          (exmem_rs2_data_w),

    .mem_regwrite_i      (exmem_regwrite_w),
    .mem_rd_addr_i       (exmem_rd_addr_w),
    .mem_wb_se_i         (exmem_wb_se_w),
    .mem_pc_plus_i       (exmem_pc_plus_w),

    // Data memory interface
    .dmem_en_o           (mem_en_w),
    .dmem_we_o           (mem_we_w),
    .dmem_addr_o         (mem_addr_w),
    .dmem_din_o          (mem_w_data_w),
    .dmem_dout_i         (mem_r_data_w),

    // MEM/WB outputs
    .memwb_regwrite_o    (memwb_regwrite_w),
    .memwb_rd_addr_o     (memwb_rd_addr_w),
    .memwb_wb_se_o       (memwb_wb_se_w),
    .memwb_pc_plus_o     (memwb_pc_plus_w),
    .memwb_alu_result_o  (memwb_alu_result_w),
    .memwb_mem_data_o    (memwb_mem_data_w),

    // Error/status
    .mem_stage_err_r     (mem_stage_err_w)
  );

  // ------------------------------------------------------------
  // Forwarding unit
  // ------------------------------------------------------------
  forwarding u_forwarding (
    .ex_rs1_addr      (idex_rs1_addr_w),
    .ex_rs2_addr      (idex_rs2_addr_w),
    .ex_rs1_data      (idex_rs1_data_w),
    .ex_rs2_data      (idex_rs2_data_w),

    .exmem_regwrite   (exmem_regwrite_w),
    .exmem_rd_addr    (exmem_rd_addr_w),
    .exmem_wb_se      (exmem_wb_se_w),
    .exmem_alu_result (exmem_alu_result_w),
    .exmem_pc_plus    (exmem_pc_plus_w),

    .memwb_regwrite   (memwb_regwrite_w),
    .memwb_rd_addr    (memwb_rd_addr_w),
    .memwb_wb_se      (memwb_wb_se_w),
    .memwb_alu_result (memwb_alu_result_w),
    .memwb_mem_data   (dmem_w_data_o),
    .memwb_pc_plus    (memwb_pc_plus_w),

    .forward_src_1    (forward_src_1_w),
    .forward_src_2    (forward_src_2_w)
  );

  // valid read data
  assign mem_r_data_w = (exmem_alu_result_w[31:30] == 2'b10) ? dmem_r_data_i : 
                               (exmem_alu_result_w[31:30] == 2'b01) ? {24'b0, i2c_rdata_w} : 32'b0;

  // valid dmem interface 32'h80000000 30 bit
  assign dmem_en_o = (exmem_alu_result_w[31:30] == 2'b10) ? mem_en_w : 1'b0;
  assign dmem_we_o = (exmem_alu_result_w[31:30] == 2'b10) ? mem_we_w : 4'b0;
  assign dmem_addr_o = (exmem_alu_result_w[31:30] == 2'b10) ? mem_addr_w : 32'b0;
  assign dmem_w_data_o = (exmem_alu_result_w[31:30] == 2'b10) ? mem_w_data_w : 32'b0;

  // valid uart interface
  wire uart_en_w = (exmem_alu_result_w[31:30] == 2'b11) ? mem_en_w : 1'b0;
  wire [1:0] uart_we_w = (exmem_alu_result_w[31:30] == 2'b11) ? mem_we_w[1:0] : 2'b0;

  // valid i2c interface
  wire i2c_en_w = (exmem_alu_result_w[31:30] == 2'b01) ? mem_en_w : 1'b0;
  wire i2c_we_w = (exmem_alu_result_w[31:30] == 2'b01) ? mem_we_w[0] : 1'b0;

  // ------------------------------------------------------------
  // UART master 32'hC0000000 30 bit of address space
  // ------------------------------------------------------------
  always @(posedge clk_i) begin
    if (rst_i) begin
      tx_valid_r <= 1'b0;
      uart_prescale_r <= 16'd0;
      tx_data_r <= 1'b0;
    end else begin
      if (uart_en_w && (uart_we_w == 4'b11)) begin
        case(exmem_alu_result_w)
          `UART_DATA: tx_data_r <= mem_w_data_w[7:0];
          `UART_PRESCALE: uart_prescale_r <= mem_w_data_w[15:0];
          `UART_VALID: tx_valid_r <= mem_w_data_w[0];
        endcase
      end
    end
  end

  // uart tx instantiate
  uart_tx uart_tx_inst (
    .clk        (clk_i),
    .rst        (rst_i),

    .data_8bit  (tx_data_r),
    .data_valid (tx_valid_r),
    .data_ready (uart_data_ready_w),

    .txd        (txd_o),
    .busy       (uart_busy_w),
    .prescale   (uart_prescale_r)
  );

  // ------------------------------------------------------------
  // I2C master 32'h40000000 30 bit of address space
  // ------------------------------------------------------------
  always @(posedge clk_i) begin
    if (rst_i) begin 
      i2c_addr_r <= 7'b0;
      i2c_wdata_r <= 8'b0;
      i2c_enable_r <= 1'b0;
      i2c_rw_r <= 1'b0;
    end else begin
      if(i2c_en_w && (i2c_we_w == 1'b1)) begin
        case (exmem_alu_result_w)
        `I2C_WDATA: i2c_addr_r <= mem_w_data_w[6:0];
        `I2C_ADDR: i2c_wdata_r <= mem_w_data_w[7:0];
        `I2C_RW: i2c_enable_r <= mem_w_data_w[1];
        `I2C_ENABLE: i2c_rw_r <= mem_w_data_w[1];
        endcase
      end
    end
  end

  // i2c master instantiate
  i2c_master i2c_master_inst (
    .clk               (clk_i),
    .rst               (rst_i),
    .addr              (i2c_addr_r),
    .data_write_master (i2c_wdata_r),
    .enable            (i2c_enable_r),
    .rw                (i2c_rw_r),

    .data_read_master  (i2c_rdata_w), // this is reg
    .ready             (i2c_ready_w),

    .i2c_sda            (i2c_sda_io),
    .i2c_scl            (i2c_scl_io)
  );

endmodule
