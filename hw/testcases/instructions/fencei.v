task fencei();
  begin
    $display("=======================");
    $display("Test FENCE.I instruction");

    dut.pc           = 32'h100;
    dut.registers[5] = 32'hCAFEBABE;

    // fence.i
    imem_instr_i = 32'h0000100F;
    #50;

    // No register changes
    compare(dut.registers[5], 32'hCAFEBABE);

    // PC must advance normally
    compare(dut.pc, 32'h104);

    #20;
    $display("=======================");
  end
endtask
