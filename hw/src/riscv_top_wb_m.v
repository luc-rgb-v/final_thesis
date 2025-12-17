`timescale  1ns / 1ps
module riscv_top_wb_m (
  input wire clk_i,
  input wire rst_i,
  // Wishbone master side
  output wire        stb_o,
  output wire        cyc_o,
  output wire        we_o,
  output wire        en_o,
  output wire [31:0] adr_o,
  output wire [31:0] dat_o,
  output wire [2:0]  width_se_o,
  input  wire [31:0] dat_i,
  input  wire        ack_i,
  input  wire        err_i,
  output wire [21:0] dontuse
);

  wire [31:0] instr_addr;
  assign dontuse = {instr_addr[31:12],instr_addr[1:0]};
  wire [31:0] instruction;
  wire en;

  wire dmem_we;
  wire dmem_en;
  wire [31:0] dmem_addr;
  wire [31:0] data_in;
  wire [31:0] data_out;
  wire [2:0] dmem_width_se;

  imem imem_uut(
    .clk_i(clk_i),
    .en_i(en),
    .instr_addr_i(instr_addr[11:2]),
    .instruction_o(instruction)
  );

  riscv_core riscv_uut(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .imem_addr_o(instr_addr),
    .imem_en_o(en),
    .imem_instr_i(instruction),

    .dmem_we_o(dmem_we),
    .dmem_en_o(dmem_en),
    .dmem_addr_o(dmem_addr),
    .dmem_data_o(data_out),
    .dmem_data_i(data_in),
    .dmem_width_se_o(dmem_width_se)
  );

  riscv_wb riscv_wb_uut(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .dmem_we_i(dmem_we),
    .dmem_en_i(dmem_en),
    .dmem_addr_i(dmem_addr),
    .dmem_data_i(data_out),
    .dmem_data_o(data_in),
    .dmem_width_se_i(dmem_width_se),

    .stb_o(stb_o),
    .cyc_o(cyc_o),
    .we_o(we_o),
    .en_o(en_o),
    .adr_o(adr_o),
    .dat_o(dat_o),
    .width_se_o(width_se_o),
    .dat_i(dat_i),
    .ack_i(ack_i),
    .err_i(err_i)
);


endmodule
