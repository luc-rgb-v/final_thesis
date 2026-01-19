`timescale 10ns / 1ps

module system_wrapper (
    input  wire        clk,
    input  wire        rst,

    // --------------------------
    // Control
    // --------------------------
    input  wire        if_flush,
    input  wire        stall,

    // --------------------------
    // UART
    // --------------------------
    output wire        txd,
    output wire        uart_tx_busy,
    output wire        uart_tx_data_ready,

    // --------------------------
    // I2C
    // --------------------------
    inout  wire        i2c_sda,
    inout  wire        i2c_scl,
    output wire        i2c_ready,

    // --------------------------
    // Error
    // --------------------------
    output wire [1:0]  mem_err
);

  // ============================================================
  // Instruction memory signals
  // ============================================================
  wire        imem_en;
  wire [31:0] imem_addr;
  wire [31:0] imem_instr;

  // ============================================================
  // Data memory signals
  // ============================================================
  wire        dmem_en;
  wire [3:0]  dmem_we;
  wire [31:0] dmem_addr;
  wire [31:0] dmem_w_data;
  wire [31:0] dmem_r_data;

  // ============================================================
  // Register file interconnect
  // ============================================================
  wire [4:0]  rs1_addr;
  wire [4:0]  rs2_addr;
  wire [31:0] rs1_data;
  wire [31:0] rs2_data;
  wire        reg_write;
  wire [4:0]  rd_addr;
  wire [31:0] rd_data;

  // ============================================================
  // CPU Core
  // ============================================================
  top_system u_top_dut (
    .clk_i              (clk),
    .rst_i              (rst),

    // Instruction memory
    .imem_en_o          (imem_en),
    .imem_addr_o        (imem_addr),
    .imem_instr_i       (imem_instr),

    // Data memory
    .dmem_en_o          (dmem_en),
    .dmem_we_o          (dmem_we),
    .dmem_addr_o        (dmem_addr),
    .dmem_w_data_o      (dmem_w_data),
    .dmem_r_data_i      (dmem_r_data),

    // Register file
    .rs1_addr           (rs1_addr),
    .rs2_addr           (rs2_addr),
    .rs1_data           (rs1_data),
    .rs2_data           (rs2_data),
    .reg_write          (reg_write),
    .rd_addr            (rd_addr),
    .rd_data            (rd_data),

    // I2C
    .i2c_sda_io         (i2c_sda),
    .i2c_scl_io         (i2c_scl),
    .i2c_ready_o        (i2c_ready),

    // UART
    .txd_o              (txd),
    .uart_busy_o        (uart_tx_busy),
    .uart_data_ready_o  (uart_tx_data_ready),

    // Control
    .if_flush_i         (if_flush),
    .stall_i            (stall),

    // Error
    .mem_err_o          (mem_err)
  );

  // ============================================================
  // Register File
  // ============================================================
  registers_file dut_reg_file (
    .clk       (clk),
    .rst       (rst),
    .rs1_addr  (rs1_addr),
    .rs2_addr  (rs2_addr),
    .rs1_data  (rs1_data),
    .rs2_data  (rs2_data),
    .reg_write (reg_write),
    .rd_addr   (rd_addr),
    .rd_data   (rd_data)
  );

  // ============================================================
  // Data Memory IP
  // ============================================================
  dmem_ip dut_dmem (
    .clka   (clk),
    .ena    (dmem_en),
    .wea    (dmem_we),
    .addra  (dmem_addr[11:2]), // word aligned
    .dina   (dmem_w_data),
    .douta  (dmem_r_data)
  );

  // ============================================================
  // Instruction Memory IP (ROM)
  // ============================================================
  imem_ip dut_imem (
    .clka   (clk),
    .ena    (imem_en),
    .wea    (4'b0000),
    .addra  (imem_addr[11:2]), // word aligned
    .dina   (32'b0),
    .douta  (imem_instr)
  );

endmodule
