task xori();
  begin
    $display("=======================");
    $display("Test XORI instruction");

    // Case 1: Basic XOR
    // 0x0F ^ 0xF0 = 0xFF
    // xori x5, x3, 0xF0
    dut.registers[3] = 32'h0000000F;
    imem_instr_i     = 32'h0F01C293;   // xori x5, x3, 0xF0
    #50;
    compare(dut.registers[5], 32'h000000FF);

    // Case 2: XOR with zero immediate
    // 0x12345678 ^ 0 = 0x12345678
    // xori x6, x3, 0
    dut.registers[3] = 32'h12345678;
    imem_instr_i     = 32'h0001C313;   // xori x6, x3, 0
    #50;
    compare(dut.registers[6], 32'h12345678);

    // Case 3: XOR with all ones (sign-extended imm = -1)
    // 0x00000000 ^ 0xFFFFFFFF = 0xFFFFFFFF
    // xori x7, x3, -1
    dut.registers[3] = 32'h00000000;
    imem_instr_i     = 32'hFFF1C393;   // xori x7, x3, -1
    #50;
    compare(dut.registers[7], 32'hFFFFFFFF);

    // Case 4: XOR toggling MSB
    // 0x80000000 ^ 0x800 = 0x80000800
    // xori x8, x9, 0x800
    dut.registers[9] = 32'h80000000;
    imem_instr_i     = 32'h8004C413;   // xori x8, x9, 0x800
    #50;
    compare(dut.registers[8], 32'h80000800);

    // Case 5: Negative rs1 value
    // 0xFFFFFF00 ^ 0x0F = 0xFFFFFF0F
    // xori x10, x11, 0x0F
    dut.registers[11] = 32'hFFFFFF00;
    imem_instr_i      = 32'h00F5C513;  // xori x10, x11, 0x0F
    #50;
    compare(dut.registers[10], 32'hFFFFFF0F);

    // Case 6: Write to x0 must be ignored
    // xori x0, x1, 0xFF
    dut.registers[1] = 32'h12345678;
    imem_instr_i     = 32'h0FF0C013;   // xori x0, x1, 0xFF
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
