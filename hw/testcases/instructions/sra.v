task sra();
  begin
    $display("=======================");
    $display("Test SRA instruction");

    // Case 1: Positive number shift
    // 0x20 >> 2 = 0x08
    // sra x5, x3, x4
    dut.registers[3] = 32'h00000020;
    dut.registers[4] = 32'd2;
    imem_instr_i     = 32'h4041D2B3;   // sra x5, x3, x4
    #50;
    compare(dut.registers[5], 32'h00000008);

    // Case 2: Negative number sign extension
    // 0xFFFFFFF0 >> 4 = 0xFFFFFFFF
    // sra x6, x3, x4
    dut.registers[3] = 32'hFFFFFFF0;
    dut.registers[4] = 32'd4;
    imem_instr_i     = 32'h4041D333;   // sra x6, x3, x4
    #50;
    compare(dut.registers[6], 32'hFFFFFFFF);

    // Case 3: Shift by zero
    // sra x7, x3, x0
    dut.registers[3] = 32'h80000000;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h4001D3B3;   // sra x7, x3, x0
    #50;
    compare(dut.registers[7], 32'h80000000);

    // Case 4: Large shift amount (masked to 5 bits)
    // shift = 33 -> 1
    // sra x8, x9, x10
    dut.registers[9]  = 32'h80000000;
    dut.registers[10] = 32'd33;
    imem_instr_i      = 32'h40A4D433;  // sra x8, x9, x10
    #50;
    compare(dut.registers[8], 32'hC0000000);

    // Case 5: All ones stays all ones
    // sra x11, x12, x13
    dut.registers[12] = -32'sd1;
    dut.registers[13] = 32'd5;
    imem_instr_i      = 32'h40D655B3;  // sra x11, x12, x13
    #50;
    compare(dut.registers[11], 32'hFFFFFFFF);

    // Case 6: Write to x0 must be ignored
    // sra x0, x1, x2
    dut.registers[1] = 32'h80000000;
    dut.registers[2] = 32'd1;
    imem_instr_i     = 32'h4020D033;   // sra x0, x1, x2
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
