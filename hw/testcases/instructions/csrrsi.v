task csrrsi();
  begin
    $display("=======================");
    $display("Test CSRRSI instruction");

    dut.csr_file[12'h300] = 32'h00000001;

    // csrrsi x5, mstatus, 2
    imem_instr_i = 32'h3002E2F3;
    #50;

    compare(dut.csr_file[12'h300], 32'h00000003);

    #20;
    $display("=======================");
  end
endtask
