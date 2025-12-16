task csrrs();
  begin
    $display("=======================");
    $display("Test CSRRS instruction");

    dut.csr_file[12'h300] = 32'h0000000F;
    dut.registers[3]      = 32'h000000F0;

    // csrrs x5, mstatus, x3
    imem_instr_i = 32'h3001A2F3;
    #50;

    compare(dut.registers[5], 32'h0000000F);
    compare(dut.csr_file[12'h300], 32'h000000FF);

    #20;
    $display("=======================");
  end
endtask
