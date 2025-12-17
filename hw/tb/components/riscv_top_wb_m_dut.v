`ifdef _RISCV_TOP_WB_M_DUT_
  // Clock and reset
  reg clk_i;
  reg rst_i;

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

  // Instantiate DUT
  riscv_top_wb_m riscv_top_wb_m_dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
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
