task srai();
  begin
    $display("=======================");
    $display("Test SRAI instruction");

    // Case 1: Positive number shift
    // 0x20 >> 2 = 0x08
    // srai x5, x3, 2
    dut.registers[3] = 32'h00000020;
    imem_instr_i     = 32'h4021D293;   // srai x5, x3, 2
    #50;
    compare(dut.registers[5], 32'h00000008);

    // Case 2: Negative number sign extension
    // 0xFFFFFFF0 >> 4 = 0xFFFFFFFF
    // srai x6, x3, 4
    dut.registers[3] = 32'hFFFFFFF0;
    imem_instr_i     = 32'h4041D313;   // srai x6, x3, 4
    #50;
    compare(dut.registers[6], 32'hFFFFFFFF);

    // Case 3: Shift by zero
    // srai x7, x3, 0
    dut.registers[3] = 32'h80000000;
    imem_instr_i     = 32'h4001D393;   // srai x7, x3, 0
    #50;
    compare(dut.registers[7], 32'h80000000);

    // Case 4: Max shift amount (31)
    // srai x8, x9, 31
    dut.registers[9] = 32'h80000000;
    imem_instr_i     = 32'h41F4D413;   // srai x8, x9, 31
    #50;
    compare(dut.registers[8], 32'hFFFFFFFF);

    // Case 5: All ones stays all ones
    // srai x10, x11, 5
    dut.registers[11] = -32'sd1;
    imem_instr_i      = 32'h4055D513;  // srai x10, x11, 5
    #50;
    compare(dut.registers[10], 32'hFFFFFFFF);

    // Case 6: Write to x0 must be ignored
    // srai x0, x1, 3
    dut.registers[1] = 32'h80000000;
    imem_instr_i     = 32'h4030D013;   // srai x0, x1, 3
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
