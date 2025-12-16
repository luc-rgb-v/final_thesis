task srl();
  begin
    $display("=======================");
    $display("Test SRL instruction");

    // Case 1: Positive number shift
    // 0x20 >> 2 = 0x08
    // srl x5, x3, x4
    dut.registers[3] = 32'h00000020;
    dut.registers[4] = 32'd2;
    imem_instr_i     = 32'h0041D2B3;   // srl x5, x3, x4
    #50;
    compare(dut.registers[5], 32'h00000008);

    // Case 2: Negative number zero-fill
    // 0x80000000 >> 4 = 0x08000000
    // srl x6, x3, x4
    dut.registers[3] = 32'h80000000;
    dut.registers[4] = 32'd4;
    imem_instr_i     = 32'h0041D333;   // srl x6, x3, x4
    #50;
    compare(dut.registers[6], 32'h08000000);

    // Case 3: Shift by zero
    // srl x7, x3, x0
    dut.registers[3] = 32'h12345678;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h0001D3B3;   // srl x7, x3, x0
    #50;
    compare(dut.registers[7], 32'h12345678);

    // Case 4: Large shift amount (masked to 5 bits)
    // shift = 33 -> 1
    // srl x8, x9, x10
    dut.registers[9]  = 32'h80000000;
    dut.registers[10] = 32'd33;
    imem_instr_i      = 32'h00A4D433;  // srl x8, x9, x10
    #50;
    compare(dut.registers[8], 32'h40000000);

    // Case 5: All ones becomes zero-filled
    // srl x11, x12, x13
    dut.registers[12] = -32'sd1;       // 0xFFFFFFFF
    dut.registers[13] = 32'd8;
    imem_instr_i      = 32'h00D655B3;  // srl x11, x12, x13
    #50;
    compare(dut.registers[11], 32'h00FFFFFF);

    // Case 6: Write to x0 must be ignored
    // srl x0, x1, x2
    dut.registers[1] = 32'h80000000;
    dut.registers[2] = 32'd1;
    imem_instr_i     = 32'h0020D033;   // srl x0, x1, x2
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
