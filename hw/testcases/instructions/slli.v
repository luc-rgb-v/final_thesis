task slli();
  begin
    $display("=======================");
    $display("Test SLLI instruction");

    // Case 1: Simple shift immediate
    // 1 << 3 = 8
    // slli x5, x3, 3
    dut.registers[3] = 32'd1;
    imem_instr_i     = 32'h00319293;   // slli x5, x3, 3
    #50;
    compare(dut.registers[5], 32'd8);

    // Case 2: Shift by zero
    // 7 << 0 = 7
    // slli x6, x3, 0
    dut.registers[3] = 32'd7;
    imem_instr_i     = 32'h00019313;   // slli x6, x3, 0
    #50;
    compare(dut.registers[6], 32'd7);

    // Case 3: Shift by max amount (31)
    // 1 << 31 = 0x80000000
    // slli x7, x3, 31
    dut.registers[3] = 32'd1;
    imem_instr_i     = 32'h01F19393;   // slli x7, x3, 31
    #50;
    compare(dut.registers[7], 32'h80000000);

    // Case 4: Shift causing overflow (bits discarded)
    // 0x40000000 << 1 = 0x80000000
    // slli x8, x9, 1
    dut.registers[9] = 32'h40000000;
    imem_instr_i     = 32'h00149413;   // slli x8, x9, 1
    #50;
    compare(dut.registers[8], 32'h80000000);

    // Case 5: Shift all bits out
    // 0x80000000 << 1 = 0x00000000
    // slli x10, x11, 1
    dut.registers[11] = 32'h80000000;
    imem_instr_i      = 32'h0015D513;  // slli x10, x11, 1
    #50;
    compare(dut.registers[10], 32'd0);

    // Case 6: Write to x0 must be ignored
    // slli x0, x1, 4
    dut.registers[1] = 32'd2;
    imem_instr_i     = 32'h00409013;   // slli x0, x1, 4
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
