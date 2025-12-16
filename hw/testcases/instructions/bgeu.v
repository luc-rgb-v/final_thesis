task bgeu();
  begin
    $display("=======================");
    $display("Test BGEU instruction");

    // Case 1: Branch taken (x1 >= x2 unsigned)
    // bgeu x1, x2, +8
    dut.registers[1] = 32'd10;
    dut.registers[2] = 32'd5;
    dut.pc_i         = 32'd100;
    imem_instr_i     = 32'h0020F863; // imm=8, rs1=x1, rs2=x2, BGEU
    #50;
    compare(dut.pc_o, 32'd108);      // PC should jump to PC + imm

    // Case 2: Branch not taken (x3 < x4 unsigned)
    // bgeu x3, x4, +12
    dut.registers[3] = 32'd3;
    dut.registers[4] = 32'd6;
    dut.pc_i         = 32'd200;
    imem_instr_i     = 32'h00422E63; // imm=12
    #50;
    compare(dut.pc_o, 32'd204);      // PC should go to next instruction (PC + 4)

    // Case 3: Branch taken with equal operands (x5 == x6)
    // bgeu x5, x6, -8
    dut.registers[5] = 32'd7;
    dut.registers[6] = 32'd7;
    dut.pc_i         = 32'd300;
    imem_instr_i     = 32'hFE62CE63; // imm=-8
    #50;
    compare(dut.pc_o, 32'd292);      // PC = PC + imm

    // Case 4: Branch taken with large unsigned values
    // x7 = 0xFFFFFFFE, x8 = 0x7FFFFFFF
    dut.registers[7] = 32'hFFFFFFFE;
    dut.registers[8] = 32'h7FFFFFFF;
    dut.pc_i         = 32'd400;
    imem_instr_i     = 32'h00837E63; // imm=16
    #50;
    compare(dut.pc_o, 32'd416);

    #20;
    $display("BGEU tests completed");
    $display("=======================");
  end
endtask
