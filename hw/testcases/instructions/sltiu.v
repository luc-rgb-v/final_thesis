task sltiu();
  begin
    $display("=======================");
    $display("Test SLTIU instruction");

    // Case 1: rs1 < imm (unsigned)
    // 3 < 5 -> 1
    // sltiu x5, x3, 5
    dut.registers[3] = 32'd3;
    imem_instr_i     = 32'h0051B293;   // sltiu x5, x3, 5
    #50;
    compare(dut.registers[5], 32'd1);

    // Case 2: rs1 > imm (unsigned)
    // 7 < 2 -> 0
    // sltiu x6, x3, 2
    dut.registers[3] = 32'd7;
    imem_instr_i     = 32'h0021B313;   // sltiu x6, x3, 2
    #50;
    compare(dut.registers[6], 32'd0);

    // Case 3: rs1 == imm
    // 4 < 4 -> 0
    // sltiu x7, x3, 4
    dut.registers[3] = 32'd4;
    imem_instr_i     = 32'h0041B393;   // sltiu x7, x3, 4
    #50;
    compare(dut.registers[7], 32'd0);

    // Case 4: Unsigned comparison with negative value
    // 0xFFFFFFFF < 1 (unsigned) -> 0
    // sltiu x8, x9, 1
    dut.registers[9] = -32'sd1;        // 0xFFFFFFFF
    imem_instr_i     = 32'h0014B413;   // sltiu x8, x9, 1
    #50;
    compare(dut.registers[8], 32'd0);

    // Case 5: Zero < large unsigned imm
    // 0 < 4095 -> 1
    // sltiu x10, x11, 4095
    dut.registers[11] = 32'd0;
    imem_instr_i      = 32'hFFF5B513;  // sltiu x10, x11, 4095
    #50;
    compare(dut.registers[10], 32'd1);

    // Case 6: Write to x0 must be ignored
    // sltiu x0, x1, 10
    dut.registers[1] = 32'd3;
    imem_instr_i     = 32'h00A0B013;   // sltiu x0, x1, 10
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
