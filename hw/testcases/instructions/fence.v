task fence();
  begin
    $display("=======================");
    $display("Test FENCE instruction");

    dut.registers[5] = 32'h12345678;
    dut.pc           = 32'h500;

    // fence
    imem_instr_i = 32'h0000000F;
    #50;

    compare(dut.registers[5], 32'h12345678);
    compare(dut.pc, 32'h504);

    #20;
    $display("=======================");
  end
endtask
