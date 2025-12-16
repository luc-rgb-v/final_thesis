task csrrci();
  begin
    $display("=======================");
    $display("Test CSRRCI instruction");

    dut.csr_file[12'h300] = 32'h0000000F;

    // csrrci x5, mstatus, 3
    imem_instr_i = 32'h3002F2F3;
    #50;

    compare(dut.csr_file[12'h300], 32'h0000000C);

    #20;
    $display("=======================");
  end
endtask
