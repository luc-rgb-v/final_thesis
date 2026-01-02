`timescale 1ns / 1ps
`define _DMEM_IP_
module tb_system_top;
  reg clk = 0;
  reg rst = 0;
  reg if_flush = 0;
  reg stall = 0;
  //wire [31:0] pc_r = u_top_dut.u_if_stage.pc_r;

  wire imem_en;
  wire [31:0] imem_addr;
  wire [31:0] imem_instr;

  //wire [31:0] ifid_pc_o = u_top_dut.u_if_stage.ifid_pc_o;
  //wire [31:0] ifid_instruction_o = u_top_dut.u_if_stage.ifid_instruction_o;

  //wire rf_reg_write = u_top_dut.rf_reg_write_w;
  //wire [4:0] rf_rd_addr = u_top_dut.rf_rd_addr_w;
  //wire [31:0] rf_rd_data = u_top_dut.rf_rd_data_w;
  
  wire dmem_en;
  wire [3:0] dmem_we;
  wire [31:0] dmem_addr;
  wire [31:0] dmem_w_data;
  wire [31:0] dmem_r_data;

  wire [1:0] mem_err;

  // Register file interface
  wire [4:0] rs1_addr;
  wire [4:0] rs2_addr;
  wire [31:0] rs1_data;
  wire [31:0] rs2_data;
  wire reg_write;
  wire [4:0] rd_addr;
  wire [31:0] rd_data;

  // I2C
  wire i2c_ready;
  wire i2c_sda;
  wire i2c_scl;
  wire [7:0] data_read_slave;

  reg  [7:0] data_write_slave;

  // UART
  reg [15:0] uart_prescale = 0;
  wire uart_tx_busy;
  wire uart_tx_data_ready;
  wire txd;
  wire [7:0] uart_rx_data;
  wire uart_rx_valid;
  wire uart_rx_busy;

  // ============================================================
  // DUT Instantiation
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

  i2c_slave i2c_slave_dut (
    .sda              (i2c_sda),
    .scl              (i2c_scl),
    .data_write_slave (data_write_slave),
    .data_read_slave  (data_read_slave)
  );

  uart_rx u_uart_rx (
      .clk        (clk),
      .rst        (rst),
      .rxd        (txd),
      .data_8bit  (uart_rx_data),
      .data_valid (uart_rx_valid),
      .busy       (uart_rx_busy),
      .prescale   (uart_prescale)
  );




`ifdef _DMEM_IP_
  dmem_ip dut_dmem (
    .clka   (clk),
    .ena    (dmem_en),
    .wea    (dmem_we),
    .addra  (dmem_addr[11:2]),
    .dina   (dmem_w_data),
    .douta  (dmem_r_data)
  );
`else
  dmem_wrab dut_dmem (
    .clka   (clk),
    .ena    (dmem_en),
    .wea    (dmem_we),
    .addra  (dmem_addr[11:2]),
    .dina   (dmem_w_data),
    .douta  (dmem_r_data)
  );
`endif

  // --------------------------------------------------
  // Instruction Memory
  // --------------------------------------------------
`ifdef _IP_
  imem_ip dut_imem (
    .clka  (clk),
    .ena   (imem_en),
    .wea   (4'b0),
    .addra (imem_addr[11:2]),
    .dina  (32'b0),
    .douta (imem_instr)
  );
`else
  imem dut_imem (
    .clk_i         (clk),
    .en_i          (imem_en),
    .instr_addr_i  (imem_addr[11:2]),
    .instruction_o (imem_instr)
  );
`endif

  registers_file dut_reg_file(
    .clk      (clk),
    .rst      (rst),

    .rs1_addr (rs1_addr),
    .rs2_addr (rs2_addr),
    .rs1_data (rs1_data),
    .rs2_data (rs2_data),

    .reg_write(reg_write),
    .rd_addr  (rd_addr),
    .rd_data  (rd_data)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;

    repeat (2) @(negedge clk);
    rst = 0;
    #1000;
    $display("REG[1] = %h", dut_reg_file.registers[12]);
    //$display("REG[1] = %h", dut_reg_file.registers[12]);
    //$display("REG[1] = %h", dut_reg_file.registers[12]);
    //$display("REG[1] = %h", dut_reg_file.registers[12]);
    $writememh("regfile_dump_king.txt", dut_reg_file.registers);
    $finish;
  end

endmodule
