task csrrwi();
  begin
    $display("=======================");
    $display("Test CSRRWI instruction");

    dut.csr_file[12'h305] = 32'h00000000;

    // csrrwi x5, mtvec, 5
    imem_instr_i = 32'h3052D2F3;
    #50;

    compare(dut.registers[5], 32'h00000000);
    compare(dut.csr_file[12'h305], 32'd5);

    #20;
    $display("=======================");
  end
endtask
