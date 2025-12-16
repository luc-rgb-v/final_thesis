task jalr();
  begin
    $display("=======================");
    $display("Test JALR instruction");
    $display("=======================");

    // Case 1: Simple JALR
    // jalr x1, x2, 8
    dut.pc_i         = 32'd100;
    dut.registers[2] = 32'd200;
    imem_instr_i     = 32'h008100E7; // imm=8, rs1=x2, rd=x1, JALR
    #50;
    compare(dut.registers[1], 32'd104); // rd = PC + 4
    compare(dut.pc_o,       32'd208);  // PC = (x2 + imm) & ~1

    // Case 2: rd = x0 (link ignored)
    // jalr x0, x3, 4
    dut.pc_i         = 32'd300;
    dut.registers[3] = 32'd400;
    imem_instr_i     = 32'h00418067; // rd=x0
    #50;
    compare(dut.registers[0], 32'd0);
    compare(dut.pc_o,       32'd404);

    // Case 3: Alignment masking (LSB cleared)
    // jalr x4, x5, 3  -> target = (x5 + 3) & ~1
    dut.pc_i         = 32'd500;
    dut.registers[5] = 32'd101;      // 101 + 3 = 104 -> already aligned
    imem_instr_i     = 32'h00328267; // imm=3
    #50;
    compare(dut.registers[4], 32'd504);
    compare(dut.pc_o,       32'd104);

    // Case 4: Backward jump with negative immediate
    // jalr x6, x7, -8
    dut.pc_i         = 32'd600;
    dut.registers[7] = 32'd200;
    imem_instr_i     = 32'hFF87C367; // imm=-8
    #50;
    compare(dut.registers[6], 32'd604);
    compare(dut.pc_o,       32'd192);

    #20;
    $display("JALR tests completed");
    $display("=======================");
  end
endtask
