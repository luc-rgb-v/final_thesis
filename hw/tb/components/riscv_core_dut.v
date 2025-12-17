`ifdef _RISCV_CORE_DUT_
  reg clk_i;
  reg rst_i;
  reg [31:0] imem_instr_i;
  reg [31:0] dmem_data_i;
  
  wire [31:0] imem_addr_o;
  wire imem_en_o;
  wire dmem_we_o;
  wire dmem_en_o;
  wire [31:0] dmem_addr_o;
  wire [31:0] dmem_data_o;
  wire [2:0] dmem_width_se_o;
  
  riscv_core dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .imem_addr_o(imem_addr_o),
    .imem_en_o(imem_en_o),
    .imem_instr_i(imem_instr_i),
    .dmem_we_o(dmem_we_o),
    .dmem_en_o(dmem_en_o),
    .dmem_addr_o(dmem_addr_o),
    .dmem_data_o(dmem_data_o),
    .dmem_data_i(dmem_data_i),
    .dmem_width_se_o(dmem_width_se_o));
`endif
  