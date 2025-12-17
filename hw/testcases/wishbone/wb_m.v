`ifdef _WISHBONE_MASTER_
task wb_transaction; begin
    // Drive inputs
    dmem_we_i      = write;
    dmem_en_i      = 1'b1;
    dmem_addr_i    = addr;
    dmem_data_i    = data_in;
    dmem_width_se_i = width_se;

    // Wait one clock edge for outputs to propagate
    @(posedge clk_i);

    // Optionally check outputs to wishbone signals
    $display("CYC_O=%b STB_O=%b WE_O=%b ADR_O=%h DAT_O=%h WIDTH=%b", 
              riscv_wb_dut.cyc_o, riscv_wb_dut.stb_o, riscv_wb_dut.we_o, riscv_wb_dut.adr_o, riscv_wb_dut.dat_o, riscv_wb_dut.width_se_o);

    // Wait until ack or err from Wishbone
    wait (riscv_wb_dut.ack_i || riscv_wb_dut.err_i);

    // Capture read data if read
    if (!write)
        data_out = riscv_wb_dut.dmem_data_o;

    // Deassert enable after transaction
    riscv_wb_dut.dmem_en_i = 0;
    riscv_wb_dut.dmem_we_i = 0;

    @(posedge clk_i); // optional: wait 1 cycle for clean reset
  end
endtask
`endif
