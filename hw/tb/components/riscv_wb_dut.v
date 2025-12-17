`ifdef _RISCV_WB_DUT_
 // Processor signals
  reg         clk_i;
  reg         rst_i;
  reg         dmem_we_i;
  reg         dmem_en_i;
  reg  [31:0] dmem_addr_i;
  reg  [31:0] dmem_data_i;
  wire [31:0] dmem_data_o;
  reg  [2:0]  dmem_width_se_i;

  // Wishbone signals
  wire        stb_o;
  wire        cyc_o;
  wire        we_o;
  wire        en_o;
  wire [31:0] adr_o;
  wire [31:0] dat_o;
  wire [2:0]  width_se_o;
  reg  [31:0] dat_i;
  reg         ack_i;
  reg         err_i;

  // Instantiate the DUT
  riscv_wb riscv_wb_dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .dmem_we_i(dmem_we_i),
    .dmem_en_i(dmem_en_i),
    .dmem_addr_i(dmem_addr_i),
    .dmem_data_i(dmem_data_i),
    .dmem_data_o(dmem_data_o),
    .dmem_width_se_i(dmem_width_se_i),
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
`endif
