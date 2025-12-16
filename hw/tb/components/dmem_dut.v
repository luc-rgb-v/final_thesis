`ifdef _DMEM_DUT_
  // Signals
  reg        clka;
  reg        ena;
  reg        wea;
  reg  [7:0] addra;
  reg  [7:0] dina;
  wire [7:0] douta;

  // Instantiate the DUT
  dmem dmem_dut (
    .clka(clka),
    .ena(ena),
    .wea(wea),
    .addra(addra),
    .dina(dina),
    .douta(douta)
  );
`endif
