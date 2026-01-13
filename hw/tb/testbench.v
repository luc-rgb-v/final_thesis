`timescale 1ns / 1ps
//==================================================================
//_define
`define _DMEM_ACCESS
`define _REGISTER_FILE
//==================================================================
module testbench;
  reg clk = 0;
  reg rst = 0;
  reg if_flush = 0;
  reg stall = 0;

  wire imem_en;
  wire [31:0] imem_addr;
  wire [31:0] imem_instr;
  
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
  
  pullup(i2c_scl);
  pullup(i2c_sda);

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

  // Instantiation
  top_system u_top_dut (
    .clk_i              (clk),
    .rst_i              (rst),

    .imem_en_o          (imem_en),
    .imem_addr_o        (imem_addr),
    .imem_instr_i       (imem_instr),

    .dmem_en_o          (dmem_en),
    .dmem_we_o          (dmem_we),
    .dmem_addr_o        (dmem_addr),
    .dmem_w_data_o      (dmem_w_data),
    .dmem_r_data_i      (dmem_r_data),

    .rs1_addr           (rs1_addr),
    .rs2_addr           (rs2_addr),
    .rs1_data           (rs1_data),
    .rs2_data           (rs2_data),
    .reg_write          (reg_write),
    .rd_addr            (rd_addr),
    .rd_data            (rd_data),

    .i2c_sda_io         (i2c_sda),
    .i2c_scl_io         (i2c_scl),
    .i2c_ready_o        (i2c_ready),

    .txd_o              (txd),
    .uart_busy_o        (uart_tx_busy),
    .uart_data_ready_o  (uart_tx_data_ready),

    .if_flush_i         (if_flush),
    .stall_i            (stall),

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

  dmem_wrab dut_dmem (
    .clka   (clk),
    .ena    (dmem_en),
    .wea    (dmem_we),
    .addra  (dmem_addr[9:2]),
    .dina   (dmem_w_data),
    .douta  (dmem_r_data)
  );

  // Instruction Memory
  imem dut_imem (
    .clk_i         (clk),
    .en_i          (imem_en),
    .instr_addr_i  (imem_addr[11:2]),
    .instruction_o (imem_instr)
  );

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

`ifdef _DMEM_ACCESS
  // memmory block for compare
  reg [63:0] ref_mem [0:255];
  reg [63:0] dut_mem [0:255];

  integer dut_idx;
  wire store_valid = dmem_en && (dmem_we != 4'b0000);
  wire [31:0] store_addr = dmem_addr;

  reg [31:0] store_data;

  always @(*) begin
    case (dmem_we)
      4'b0000: store_data = 32'b0;
      // SB
      4'b0001: store_data = {24'b0, dmem_w_data[7:0]};
      4'b0010: store_data = {24'b0, dmem_w_data[15:8]};
      4'b0100: store_data = {24'b0, dmem_w_data[23:16]};
      4'b1000: store_data = {24'b0, dmem_w_data[31:24]};
      // SH
      4'b0011: store_data = {16'b0, dmem_w_data[15:0]};
      4'b1100: store_data = {16'b0, dmem_w_data[31:16]};
      // SW
      4'b1111: store_data = dmem_w_data;
      default: store_data = 32'b0;
    endcase
  end

  // Load Spike reference memory
  initial begin
    dut_idx = 0;
    $readmemh("data.mem", ref_mem);
  end
  // Capture DUT address + data on valid store
  always @(posedge clk) begin
    if (store_valid) begin
      dut_mem[dut_idx] <= {store_addr, store_data};
      dut_idx <= dut_idx + 1;
    end
  end
  // Compare task
  task compare_mem;
    begin
      for (i = 0; i < dut_idx; i = i + 1) begin
        if (dut_mem[i] !== ref_mem[i]) begin
          $display(
            "ERROR: idx=%0d | exp=0x%016h | got=0x%016h",
            i, ref_mem[i], dut_mem[i]
          );
        end else begin
          $display(
            "PASS : idx=%0d | data=0x%016h",
            i, dut_mem[i]
          );
        end
      end
    end
  endtask
`endif

`ifdef _REGISTER_FILE
  reg [31:0] ref_regs [0:31];
  initial begin
    $readmemh("registers.mem", ref_regs);
  end
  task compare_regs;
    begin
      for (i = 0; i < 32; i = i + 1) begin

        if (i == 0) begin
          if (dut_reg_file.registers[0] !== 32'h00000000) begin
            $display(
              "ERROR: x0 not zero | got=0x%08h",
              dut_reg_file.registers[0]
            );
          end
        end
        else begin
          if (dut_reg_file.registers[i] !== ref_regs[i]) begin
            $display(
              "ERROR: x%0d | exp=0x%08h | got=0x%08h",
              i,
              ref_regs[i],
              dut_reg_file.registers[i]
            );
          end
          else begin
            $display(
              "PASS : x%0d = 0x%08h",
              i,
              dut_reg_file.registers[i]
            );
          end
        end
      end
    end
  endtask
`endif

  initial begin
    for (i = 0; i < 1024; i = i + 1)
      dut_imem.instructions_r[i] = 32'b0;
  end

  initial begin
    for (i = 0; i < 256; i = i + 1) begin
      dut_dmem.dmem_uut0.mem[i] = 8'h00;
      dut_dmem.dmem_uut1.mem[i] = 8'h00;
      dut_dmem.dmem_uut2.mem[i] = 8'h00;
      dut_dmem.dmem_uut3.mem[i] = 8'h00;
    end
  end

  initial begin
    for (i = 0; i < 32; i = i + 1)
      dut_reg_file.registers[i] = 32'b0;
  end

  always #5 clk = ~clk;

  //==================================================================
  //_include
  `include "testcase.v"
  //==================================================================

  initial begin
    clk = 0;
    rst = 1;

    //_load_instruction
    $readmemh("instructions.mem", dut_imem.instructions_r);

    repeat (2) @(negedge clk);
    rst = 0;
    #50;
  //==================================================================
  //_calltest
    run_test();
  //==================================================================
    #50;
    $display("");
    $display("Instruction = %h ", dut_imem.instructions_r[0]);
    $display("Instruction = %h ", dut_imem.instructions_r[1]);
    $display("Instruction = %h ", dut_imem.instructions_r[2]);
    $display("");
    $display("REG[1] = %h", dut_reg_file.registers[1]);
    $display("REG[2] = %h", dut_reg_file.registers[2]);
    $display("REG[3] = %h", dut_reg_file.registers[3]);
    $display("");
    $finish;
  end

endmodule
