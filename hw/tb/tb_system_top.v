`timescale 1ns / 1ps
//`define _IMEM_IP_
//`define _DMEM_IP_
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
  //wire [1:0] memwb_wb_se_w = u_top_dut.memwb_wb_se_w;
  wire [4:0] rd_addr;
  wire [31:0] rd_data;
  //wire [31:0] memwb_pc_plus_w = u_top_dut.memwb_pc_plus_w;
  //wire [31:0] memwb_alu_result_w = u_top_dut.memwb_alu_result_w;
  //wire [31:0] memwb_mem_data_w = u_top_dut.memwb_mem_data_w;
  //wire [31:0] mem_r_data_w = u_top_dut.mem_r_data_w;
  
  //wire uart_en_w = u_top_dut.uart_en_w;
  //wire [1:0] uart_we_w = u_top_dut.uart_we_w;
  
  //wire [31:0] exmem_alu_result_w = u_top_dut.exmem_alu_result_w;
  //wire [31:0] mem_w_data_w = u_top_dut.mem_w_data_w;
  
  //wire tx_valid_r = u_top_dut.tx_valid_r;
  //wire [16:0] uart_prescale_r = u_top_dut.uart_prescale_r;
  //wire [7:0] tx_data_r = u_top_dut.tx_data_r;
  
  //wire [31:0] i2c_addr_r = u_top_dut.i2c_addr_r;
  //wire [31:0] i2c_wdata_r = u_top_dut.i2c_wdata_r;
  //wire [31:0] i2c_enable_r = u_top_dut.i2c_enable_r;
  //wire [31:0] i2c_rw_r = u_top_dut.i2c_rw_r;
  //wire [31:0] mem_r_data_w = u_top_dut.mem_r_data_w;

  // EX stage sources
  /*
  wire [4:0]  ex_rs1_addr_w      = u_top_dut.idex_rs1_addr_w;
  wire [4:0]  ex_rs2_addr_w      = u_top_dut.idex_rs2_addr_w;
  wire [31:0] ex_rs1_data_w      = u_top_dut.idex_rs1_data_w;
  wire [31:0] ex_rs2_data_w      = u_top_dut.idex_rs2_data_w;

  // EX/MEM stage
  wire        exmem_regwrite_w   = u_top_dut.exmem_regwrite_w;
  wire [4:0]  exmem_rd_addr_w    = u_top_dut.exmem_rd_addr_w;
  wire [1:0]  exmem_wb_se_w      = u_top_dut.exmem_wb_se_w;
  wire [31:0] exmem_alu_result_w = u_top_dut.exmem_alu_result_w;
  wire [31:0] exmem_pc_plus_w    = u_top_dut.exmem_pc_plus_w;

  // MEM/WB stage
  wire        memwb_regwrite_w   = u_top_dut.memwb_regwrite_w;
  wire [4:0]  memwb_rd_addr_w    = u_top_dut.memwb_rd_addr_w;
  wire [1:0]  memwb_wb_se_w      = u_top_dut.memwb_wb_se_w;
  wire [31:0] memwb_alu_result_w = u_top_dut.memwb_alu_result_w;
  wire [31:0] memwb_mem_data_w   = u_top_dut.dmem_w_data_o;
  wire [31:0] memwb_pc_plus_w    = u_top_dut.memwb_pc_plus_w;

  wire [31:0] forward_src_1_w = u_top_dut.forward_src_1_w;
  wire [31:0] forward_src_2_w = u_top_dut.forward_src_2_w;
*/
  // I2C
  wire i2c_ready;
  wire i2c_sda;
  wire i2c_scl;
  
  pullup (i2c_scl);
  pullup (i2c_sda);
  
  wire [7:0] data_read_slave;
  reg  [7:0] data_write_slave = 8'h55;
  wire rx_valid;
  wire addressed;

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
    .rst              (rst),
    .data_write_slave (data_write_slave),
    .data_read_slave  (data_read_slave),
    .rx_valid         (rx_valid),
    .addressed        (addressed)
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
`ifdef _IMEM_IP_
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
    //.clk_i         (clk),
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

  integer i;
  integer fd;

`ifndef _IMEM_IP_
  initial begin
    for (i = 0; i < 1024; i = i + 1)
      dut_imem.instructions_r[i] = 32'b0;
  end
`endif

`ifndef _DMEM_IP_
  initial begin
    for (i = 0; i < 256; i = i + 1) begin
      dut_dmem.dmem_uut0.mem[i] = 8'h00;
      dut_dmem.dmem_uut1.mem[i] = 8'h00;
      dut_dmem.dmem_uut2.mem[i] = 8'h00;
      dut_dmem.dmem_uut3.mem[i] = 8'h00;
    end
     $readmemh("data_0.mem", dut_dmem.dmem_uut0.mem);
     $readmemh("data_1.mem", dut_dmem.dmem_uut1.mem);
     $readmemh("data_2.mem", dut_dmem.dmem_uut2.mem);
     $readmemh("data_3.mem", dut_dmem.dmem_uut3.mem);
  end
`endif

  task dump_regfile;
    begin
      $fdisplay(fd, "==== Regfile dump @ time %0t ====", $time);
      for (i = 0; i < 32; i = i + 1) begin
          $fdisplay(fd, "x%0d = 0x%08h", i, dut_reg_file.registers[i]);
      end
      $fdisplay(fd, "");
    end
  endtask

  initial begin
    for (i = 0; i < 32; i = i + 1)
      dut_reg_file.registers[i] = 32'b0;
    // dump file
    fd = $fopen("regfile_dump.txt", "w");
  end

  always #5 clk = ~clk;

  initial begin
    $monitor("T=%0t | reg_write=%b | rd_addr=%0d | rd_data=0x%08h", $time, reg_write, rd_addr, rd_data);
  end

  initial begin
    clk = 0;
    rst = 1;
`ifndef _IMEM_IP_
    //_load_instruction
    $readmemh("instructions.mem", dut_imem.instructions_r);
`endif
    repeat (2) @(negedge clk);
    rst = 0;
    #50;
  //==================================================================
  //_calltest
  //==================================================================
    #5000;
`ifndef _IMEM_IP_
    $display("");
    $display("Instruction = %h ", dut_imem.instructions_r[0]);
    $display("Instruction = %h ", dut_imem.instructions_r[1]);
    $display("Instruction = %h ", dut_imem.instructions_r[2]);
`endif
    $display("");
    $display("REG[1] = %h", dut_reg_file.registers[1]);
    $display("REG[2] = %h", dut_reg_file.registers[2]);
    $display("REG[3] = %h", dut_reg_file.registers[3]);
    $display("");
    
    dump_regfile;
    $finish;
  end

endmodule
