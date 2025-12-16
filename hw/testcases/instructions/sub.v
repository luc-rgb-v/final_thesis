task sub();
  begin
    $display("=======================");
    $display("Test SUB instruction");

    // Case 1: Positive - positive
    // 10 - 5 = 5
    // sub x5, x3, x4
    dut.registers[3] = 32'd10;
    dut.registers[4] = 32'd5;
    imem_instr_i     = 32'h4041C2B3;   // sub x5, x3, x4
    #50;
    compare(dut.registers[5], 32'd5);

    // Case 2: Positive - larger positive (negative result)
    // 5 - 10 = -5
    // sub x6, x3, x4
    dut.registers[3] = 32'd5;
    dut.registers[4] = 32'd10;
    imem_instr_i     = 32'h4041C333;   // sub x6, x3, x4
    #50;
    compare(dut.registers[6], -32'sd5);

    // Case 3: Number - zero
    // 7 - 0 = 7
    // sub x7, x3, x0
    dut.registers[3] = 32'd7;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h4001C3B3;   // sub x7, x3, x0
    #50;
    compare(dut.registers[7], 32'd7);

    // Case 4: Zero - number
    // 0 - 4 = -4
    // sub x8, x0, x3
    dut.registers[0] = 32'd0;
    dut.registers[3] = 32'd4;
    imem_instr_i     = 32'h40304433;   // sub x8, x0, x3
    #50;
    compare(dut.registers[8], -32'sd4);

    // Case 5: Overflow wrap-around
    // 0x80000000 - 1 = 0x7FFFFFFF
    // sub x9, x10, x11
    dut.registers[10] = 32'h80000000;
    dut.registers[11] = 32'd1;
    imem_instr_i      = 32'h40B54533;  // sub x9, x10, x11
    #50;
    compare(dut.registers[9], 32'h7FFFFFFF);

    // Case 6: Write to x0 must be ignored
    // sub x0, x1, x2
    dut.registers[1] = 32'd6;
    dut.registers[2] = 32'd2;
    imem_instr_i     = 32'h4020C033;   // sub x0, x1, x2
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
