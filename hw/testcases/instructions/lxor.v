task lxor(); // logical XOR
  begin
    $display("=======================");
    $display("Test XOR instruction");

    // Case 1: Simple XOR
    // 5 ^ 3 = 6
    // xor x5, x3, x4
    dut.registers[3] = 32'd5;
    dut.registers[4] = 32'd3;
    imem_instr_i     = 32'h0041C2B3;   // xor x5, x3, x4
    #50;
    compare(dut.registers[5], 32'd6);

    // Case 2: XOR with zero
    // 9 ^ 0 = 9
    // xor x6, x3, x0
    dut.registers[3] = 32'd9;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h0001C333;   // xor x6, x3, x0
    #50;
    compare(dut.registers[6], 32'd9);

    // Case 3: Zero XOR number
    // 0 ^ 12 = 12
    // xor x7, x0, x4
    dut.registers[4] = 32'd12;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h004043B3;   // xor x7, x0, x4
    #50;
    compare(dut.registers[7], 32'd12);

    // Case 4: XOR identical values → 0
    // 0xAAAA ^ 0xAAAA = 0
    // xor x8, x9, x10
    dut.registers[9]  = 32'h0000AAAA;
    dut.registers[10] = 32'h0000AAAA;
    imem_instr_i      = 32'h00A4C433;  // xor x8, x9, x10
    #50;
    compare(dut.registers[8], 32'd0);

    // Case 5: XOR with all ones
    // 0x0F0F ^ 0xFFFF = 0xF0F0
    // xor x11, x12, x13
    dut.registers[12] = 32'h00000F0F;
    dut.registers[13] = 32'h0000FFFF;
    imem_instr_i      = 32'h00D665B3;  // xor x11, x12, x13
    #50;
    compare(dut.registers[11], 32'h0000F0F0);

    // Case 6: Write to x0 must be ignored
    // xor x0, x1, x2
    dut.registers[1] = 32'd6;
    dut.registers[2] = 32'd3;
    imem_instr_i     = 32'h0020C033;   // xor x0, x1, x2
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
