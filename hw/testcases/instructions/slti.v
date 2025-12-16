task slti();
  begin
    $display("=======================");
    $display("Test SLTI instruction");

    // Case 1: rs1 < imm (positive numbers)
    // 3 < 5 -> 1
    // slti x5, x3, 5
    dut.registers[3] = 32'd3;
    imem_instr_i     = 32'h0051A293;   // slti x5, x3, 5
    #50;
    compare(dut.registers[5], 32'd1);

    // Case 2: rs1 > imm
    // 7 < 2 -> 0
    // slti x6, x3, 2
    dut.registers[3] = 32'd7;
    imem_instr_i     = 32'h0021A313;   // slti x6, x3, 2
    #50;
    compare(dut.registers[6], 32'd0);

    // Case 3: rs1 == imm
    // 4 < 4 -> 0
    // slti x7, x3, 4
    dut.registers[3] = 32'd4;
    imem_instr_i     = 32'h0041A393;   // slti x7, x3, 4
    #50;
    compare(dut.registers[7], 32'd0);

    // Case 4: Negative rs1 < positive imm
    // -1 < 1 -> 1
    // slti x8, x9, 1
    dut.registers[9] = -32'sd1;
    imem_instr_i     = 32'h0014A413;   // slti x8, x9, 1
    #50;
    compare(dut.registers[8], 32'd1);

    // Case 5: Positive rs1 < negative imm
    // 1 < -1 -> 0
    // slti x10, x11, -1
    dut.registers[11] = 32'd1;
    imem_instr_i      = 32'hFFF5A513;  // slti x10, x11, -1
    #50;
    compare(dut.registers[10], 32'd0);

    // Case 6: Write to x0 must be ignored
    // slti x0, x1, 10
    dut.registers[1] = 32'd3;
    imem_instr_i     = 32'h00A0A013;   // slti x0, x1, 10
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask

