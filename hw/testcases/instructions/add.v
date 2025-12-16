task add();
  begin
    $display("=======================");
    $display("Test ADD instruction");

    // Case 1: Simple positive numbers (5 + 10 = 15)
    // add x4, x3, x2
    dut.registers[2] = 32'd5;
    dut.registers[3] = 32'd10;
    imem_instr_i     = 32'h00218233;
    #50;
    compare(dut.registers[4], 32'd15);
    // Case 2: Zero + number (0 + 7 = 7)
    // add x5, x0, x6
    dut.registers[0] = 32'd0;
    dut.registers[6] = 32'd7;
    imem_instr_i     = 32'h006002B3;
    #50;
    compare(dut.registers[5], 32'd7);
    // Case 3: Number + zero (9 + 0 = 9)
    // add x7, x6, x0
    dut.registers[6] = 32'd9;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h000303B3;
    #50;
    compare(dut.registers[7], 32'd9);
    // Case 4: Negative + positive (-5 + 8 = 3)
    // add x8, x9, x10
    dut.registers[9]  = -32'sd5;
    dut.registers[10] = 32'd8;
    imem_instr_i      = 32'h00A48433;
    #50;
    compare(dut.registers[8], 32'd3);
    // Case 5: Negative + negative (-4 + -6 = -10)
    // add x11, x12, x13
    dut.registers[12] = -32'sd4;
    dut.registers[13] = -32'sd6;
    imem_instr_i      = 32'h00D605B3;
    #50;
    compare(dut.registers[11], -32'sd10);
    // Case 6: Overflow behavior (wrap-around)
    // 0x7FFFFFFF + 1 = 0x80000000
    // add x14, x15, x16
    dut.registers[15] = 32'h7FFFFFFF;
    dut.registers[16] = 32'd1;
    imem_instr_i      = 32'h01078733;
    #50;
    compare(dut.registers[14], 32'h80000000);
    // Case 7: Write to x0 must be ignored
    // add x0, x1, x2
    dut.registers[1] = 32'd3;
    dut.registers[2] = 32'd4;
    imem_instr_i     = 32'h00208033;
    #50;
    compare(dut.registers[0], 32'd0);
    #20;

    $display("ADD tests completed");
    $display("=======================");
  end
endtask
