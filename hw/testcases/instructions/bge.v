task bge();
  begin
    $display("=======================");
    $display("Test BGE instruction");

    // Case 1: Branch taken (x1 >= x2)
    // bge x1, x2, +8
    dut.registers[1] = 32'd10;
    dut.registers[2] = 32'd5;
    dut.pc_sub_r         = 32'd100;
    imem_instr_i     = 32'h0020C863; // imm=8, rs1=x1, rs2=x2, BGE
    #50;
    compare(dut.if_pc_next_w, 32'd108);      // PC should jump to PC + imm

    // Case 2: Branch not taken (x3 < x4)
    // bge x3, x4, +12
    dut.registers[3] = 32'd3;
    dut.registers[4] = 32'd6;
    dut.pc_sub_r         = 32'd200;
    imem_instr_i     = 32'h00420E63; // imm=12
    #50;
    compare(dut.if_pc_next_w, 32'd204);      // PC should go to next instruction (PC + 4)

    // Case 3: Branch taken with equal operands (x5 == x6)
    // bge x5, x6, -8
    dut.registers[5] = 32'd7;
    dut.registers[6] = 32'd7;
    dut.pc_sub_r         = 32'd300;
    imem_instr_i     = 32'hFE60CE63; // imm=-8
    #50;
    compare(dut.if_pc_next_w, 32'd292);      // PC = PC + imm

    #20;
    $display("BGE tests completed");
    $display("=======================");
  end
endtask
