task addi();
  begin
    $display("=======================");
    $display("Test ADDI instruction");

    // Case 1: Simple positive immediate (4 + 5 = 9)
    // addi x5, x3, 5
    dut.registers[3] = 32'd4;
    imem_instr_i     = 32'h00518293;
    #50;
    compare(dut.registers[5], 32'd9);

    // Case 2: Zero + immediate (0 + 7 = 7)
    // addi x6, x0, 7
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h00700313;
    #50;
    compare(dut.registers[6], 32'd7);

    // Case 3: Immediate = 0 (9 + 0 = 9)
    // addi x7, x6, 0
    dut.registers[6] = 32'd9;
    imem_instr_i     = 32'h00030393;
    #50;
    compare(dut.registers[7], 32'd9);

    // Case 4: Negative immediate (10 + -3 = 7)
    // addi x8, x3, -3
    dut.registers[3] = 32'd10;
    imem_instr_i     = 32'hFFD18413; // imm = 0xFFD = -3
    #50;
    compare(dut.registers[8], 32'd7);

    // Case 5: rd == rs1 (self add)
    // addi x9, x9, 1
    dut.registers[9] = 32'd99;
    imem_instr_i     = 32'h00148493;
    #50;
    compare(dut.registers[9], 32'd100);

    // Case 6: Overflow behavior (wrap-around)
    // 0x7FFFFFFF + 1 = 0x80000000
    // addi x10, x10, 1
    dut.registers[10] = 32'h7FFFFFFF;
    imem_instr_i      = 32'h00150513;
    #50;
    compare(dut.registers[10], 32'h80000000);

    // Case 7: Write to x0 must be ignored
    // addi x0, x1, 5
    dut.registers[1] = 32'd3;
    imem_instr_i     = 32'h00508013;
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("ADDI tests completed");
    $display("=======================");
  end
endtask
