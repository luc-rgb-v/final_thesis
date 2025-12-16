`ifdef _DMEM_WB_DUT_
  // Signals
  reg         clk_i;
  reg         rst_i;
  reg  [9:0]  addr_i;
  reg  [31:0] data_i;
  wire [31:0] data_o;
  reg  [2:0]  width_se_i;
  reg         we_i;
  reg         stb_i;
  wire        ack_o;
  wire        err_o;

  // Instantiate the DUT
  dmem_wb dmem_wb_dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .addr_i(addr_i),
    .data_i(data_i),
    .data_o(data_o),
    .width_se_i(width_se_i),
    .we_i(we_i),
    .stb_i(stb_i),
    .ack_o(ack_o),
    .err_o(err_o)
  );
`endif
