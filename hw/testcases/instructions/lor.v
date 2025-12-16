task lor(); // logical OR
  begin
    $display("=======================");
    $display("Test OR instruction");

    // Case 1: Simple OR
    // 0b0101 | 0b0011 = 0b0111 (5 | 3 = 7)
    // or x5, x3, x4
    dut.registers[3] = 32'd5;
    dut.registers[4] = 32'd3;
    imem_instr_i     = 32'h0041E2B3;   // or x5, x3, x4
    #50;
    compare(dut.registers[5], 32'd7);

    // Case 2: OR with zero
    // 9 | 0 = 9
    // or x6, x3, x0
    dut.registers[3] = 32'd9;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h0001E333;   // or x6, x3, x0
    #50;
    compare(dut.registers[6], 32'd9);

    // Case 3: Zero OR number
    // 0 | 12 = 12
    // or x7, x0, x4
    dut.registers[4] = 32'd12;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h004063B3;   // or x7, x0, x4
    #50;
    compare(dut.registers[7], 32'd12);

    // Case 4: OR with all bits set
    // 0xF0F0 | 0x0F0F = 0xFFFF
    // or x8, x9, x10
    dut.registers[9]  = 32'h0000F0F0;
    dut.registers[10] = 32'h00000F0F;
    imem_instr_i      = 32'h00A4E433;  // or x8, x9, x10
    #50;
    compare(dut.registers[8], 32'h0000FFFF);

    // Case 5: OR with negative number
    // (-1) | 0x1234 = 0xFFFFFFFF
    // or x11, x12, x13
    dut.registers[12] = -32'sd1;
    dut.registers[13] = 32'h00001234;
    imem_instr_i      = 32'h00D665B3;  // or x11, x12, x13
    #50;
    compare(dut.registers[11], 32'hFFFFFFFF);

    // Case 6: Write to x0 must be ignored
    // or x0, x1, x2
    dut.registers[1] = 32'd6;
    dut.registers[2] = 32'd3;
    imem_instr_i     = 32'h0020E033;   // or x0, x1, x2
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
