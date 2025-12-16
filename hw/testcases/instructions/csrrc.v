task csrrc();
  begin
    $display("=======================");
    $display("Test CSRRC instruction");

    dut.csr_file[12'h300] = 32'h000000FF;
    dut.registers[3]      = 32'h0000000F;

    // csrrc x5, mstatus, x3
    imem_instr_i = 32'h3001B2F3;
    #50;

    compare(dut.registers[5], 32'h000000FF);
    compare(dut.csr_file[12'h300], 32'h000000F0);

    #20;
    $display("=======================");
  end
endtask
