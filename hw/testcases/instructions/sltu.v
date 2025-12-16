task sltu();
  begin
    $display("=======================");
    $display("Test SLTU instruction");

    // Case 1: rs1 < rs2 (unsigned)
    // 3 < 7 -> 1
    // sltu x5, x3, x4
    dut.registers[3] = 32'd3;
    dut.registers[4] = 32'd7;
    imem_instr_i     = 32'h0041B2B3;   // sltu x5, x3, x4
    #50;
    compare(dut.registers[5], 32'd1);

    // Case 2: rs1 > rs2 (unsigned)
    // 9 < 4 -> 0
    // sltu x6, x3, x4
    dut.registers[3] = 32'd9;
    dut.registers[4] = 32'd4;
    imem_instr_i     = 32'h0041B333;   // sltu x6, x3, x4
    #50;
    compare(dut.registers[6], 32'd0);

    // Case 3: rs1 == rs2
    // 5 < 5 -> 0
    // sltu x7, x3, x4
    dut.registers[3] = 32'd5;
    dut.registers[4] = 32'd5;
    imem_instr_i     = 32'h0041B3B3;   // sltu x7, x3, x4
    #50;
    compare(dut.registers[7], 32'd0);

    // Case 4: Unsigned comparison with negative value
    // 0xFFFFFFFF < 1 (unsigned) -> 0
    // sltu x8, x9, x10
    dut.registers[9]  = -32'sd1;       // 0xFFFFFFFF
    dut.registers[10] = 32'd1;
    imem_instr_i      = 32'h00A4B433;  // sltu x8, x9, x10
    #50;
    compare(dut.registers[8], 32'd0);

    // Case 5: Small unsigned < large unsigned
    // 1 < 0xFFFFFFFF -> 1
    // sltu x11, x12, x13
    dut.registers[12] = 32'd1;
    dut.registers[13] = -32'sd1;       // 0xFFFFFFFF
    imem_instr_i      = 32'h00D635B3;  // sltu x11, x12, x13
    #50;
    compare(dut.registers[11], 32'd1);

    // Case 6: Write to x0 must be ignored
    // sltu x0, x1, x2
    dut.registers[1] = 32'd2;
    dut.registers[2] = 32'd3;
    imem_instr_i     = 32'h0020B033;   // sltu x0, x1, x2
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
