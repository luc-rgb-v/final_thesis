`ifdef _DMEM_WRAB_DUT_
 // Signals
  reg         clka;
  reg         ena;
  reg  [3:0]  wea;
  reg  [7:0]  addra;
  reg  [31:0] dina;
  wire [31:0] douta;

  // Instantiate DUT
  dmem_wrab dmem_wrab_dut (
    .clka(clka),
    .ena(ena),
    .wea(wea),
    .addra(addra),
    .dina(dina),
    .douta(douta)
  );
`endif