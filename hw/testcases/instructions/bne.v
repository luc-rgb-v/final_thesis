task bne();
  begin
    $display("=======================");
    $display("Test BNE instruction");

    // Case 1: Branch taken (x1 != x2)
    // bne x1, x2, +8
    dut.registers[1] = 32'd5;
    dut.registers[2] = 32'd10;
    dut.pc_sub_r         = 32'd100;
    imem_instr_i     = 32'h00209663; // imm=8, rs1=x1, rs2=x2, BNE
    #50;
    compare(dut.if_pc_next_w, 32'd108);      // PC = PC + imm

    // Case 2: Branch NOT taken (x3 == x4)
    // bne x3, x4, +12
    dut.registers[3] = 32'd7;
    dut.registers[4] = 32'd7;
    dut.pc_sub_r         = 32'd200;
    imem_instr_i     = 32'h00421E63; // imm=12
    #50;
    compare(dut.if_pc_next_w, 32'd204);      // PC = PC + 4

    // Case 3: Branch taken with negative offset
    // bne x5, x6, -8
    dut.registers[5] = 32'd3;
    dut.registers[6] = 32'd8;
    dut.pc_sub_r         = 32'd300;
    imem_instr_i     = 32'hFE62D8E3; // imm=-8
    #50;
    compare(dut.if_pc_next_w, 32'd292);      // PC = PC + imm

    // Case 4: Branch NOT taken (both zero)
    // bne x7, x8, +16
    dut.registers[7] = 32'd0;
    dut.registers[8] = 32'd0;
    dut.pc_sub_r         = 32'd400;
    imem_instr_i     = 32'h0083DE63; // imm=16
    #50;
    compare(dut.if_pc_next_w, 32'd404);      // PC = PC + 4

    #20;
    $display("BNE tests completed");
    $display("=======================");
  end
endtask
