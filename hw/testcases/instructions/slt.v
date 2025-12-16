task slt();
  begin
    $display("=======================");
    $display("Test SLT instruction");

    // Case 1: rs1 < rs2 (positive numbers)
    // 3 < 5 -> 1
    // slt x5, x3, x4
    dut.registers[3] = 32'd3;
    dut.registers[4] = 32'd5;
    imem_instr_i     = 32'h0041A2B3;   // slt x5, x3, x4
    #50;
    compare(dut.registers[5], 32'd1);

    // Case 2: rs1 > rs2
    // 7 < 2 -> 0
    // slt x6, x3, x4
    dut.registers[3] = 32'd7;
    dut.registers[4] = 32'd2;
    imem_instr_i     = 32'h0041A333;   // slt x6, x3, x4
    #50;
    compare(dut.registers[6], 32'd0);

    // Case 3: Equal values
    // 4 < 4 -> 0
    // slt x7, x3, x4
    dut.registers[3] = 32'd4;
    dut.registers[4] = 32'd4;
    imem_instr_i     = 32'h0041A3B3;   // slt x7, x3, x4
    #50;
    compare(dut.registers[7], 32'd0);

    // Case 4: Negative < positive
    // -1 < 1 -> 1
    // slt x8, x9, x10
    dut.registers[9]  = -32'sd1;
    dut.registers[10] = 32'd1;
    imem_instr_i      = 32'h00A4A433;  // slt x8, x9, x10
    #50;
    compare(dut.registers[8], 32'd1);

    // Case 5: Negative > negative
    // -3 < -7 -> 0
    // slt x11, x12, x13
    dut.registers[12] = -32'sd3;
    dut.registers[13] = -32'sd7;
    imem_instr_i      = 32'h00D625B3;  // slt x11, x12, x13
    #50;
    compare(dut.registers[11], 32'd0);

    // Case 6: Write to x0 must be ignored
    // slt x0, x1, x2
    dut.registers[1] = 32'd1;
    dut.registers[2] = 32'd2;
    imem_instr_i     = 32'h0020A033;   // slt x0, x1, x2
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
