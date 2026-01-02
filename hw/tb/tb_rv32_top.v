`timescale 1ns / 1ps
`define _DMEM_IP_
//`define _DEBUG_WIRE_
module tb_rv32_top;
  reg clk;
  reg rst;
`ifdef _DEBUG_WIRE_
  wire [31:0] pc_r = dut.u_if_stage.pc_r;
`endif
  wire imem_en;
  wire [31:0] imem_addr;
  wire [31:0] imem_instr;
`ifdef _DEBUG_WIRE_
  wire [31:0] ifid_pc_o = dut.u_if_stage.ifid_pc_o;
  wire [31:0] ifid_instruction_o = dut.u_if_stage.ifid_instruction_o;
`endif
  wire rf_reg_write = dut.rf_reg_write_w;
  wire [4:0] rf_rd_addr = dut.rf_rd_addr_w;
  wire [31:0] rf_rd_data = dut.rf_rd_data_w;
  wire dmem_en;
  wire [3:0] dmem_we;
  wire [31:0] dmem_addr;
  wire [31:0] dmem_w_data;
  wire [31:0] dmem_r_data;

  wire [1:0] mem_err_o;
  reg if_flush = 0;
  wire if_stall = 0;
  wire id_stall = 0;
  wire ex_stall = 0;
  // Register file interface
  wire [4:0] rs1_addr;
  wire [4:0] rs2_addr;
  wire [31:0] rs1_data;
  wire [31:0] rs2_data;
  wire reg_write;
  wire [4:0] rd_addr;
  wire [31:0] rd_data;

  // ============================================================
  // DUT Instantiation
  // ============================================================
  top_rv32 dut (
    .clk_i(clk),
    .rst_i(rst),

    // IMEM
    .imem_en_o(imem_en),
    .imem_addr_o(imem_addr),
    .imem_instr_i(imem_instr),

    // DMEM
    .dmem_en_o(dmem_en),
    .dmem_we_o(dmem_we),
    .dmem_addr_o(dmem_addr),
    .dmem_w_data_o(dmem_w_data),
    .dmem_r_data_i(dmem_r_data),
      // Register file interface
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .reg_write(reg_write),
    .rd_addr(rd_addr),
    .rd_data(rd_data)


  `ifdef _NOT_USE_YET_
    ,.if_flush(if_flush)
    ,.if_stall(if_stall)
    ,.id_stall(id_stall)
    ,.ex_stall(ex_stall)
    ,.mem_err_o(mem_err_o)
  `endif
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
