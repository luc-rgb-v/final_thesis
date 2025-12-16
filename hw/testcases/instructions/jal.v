task jal();
  begin
    $display("=======================");
    $display("Test JAL instruction");
    $display("=======================");

    // Case 1: Simple forward jump
    // jal x1, +16
    dut.pc_i     = 32'd100;
    imem_instr_i = 32'h010000EF; // imm=16, rd=x1, JAL
    #50;
    compare(dut.registers[1], 32'd104); // rd = PC + 4
    compare(dut.pc_o,       32'd116);  // PC = PC + imm

    // Case 2: Jump with rd = x0 (link discarded)
    // jal x0, +8
    dut.pc_i     = 32'd200;
    imem_instr_i = 32'h0080006F; // rd=x0
    #50;
    compare(dut.registers[0], 32'd0);   // x0 unchanged
    compare(dut.pc_o,       32'd208);

    // Case 3: Backward jump (negative offset)
    // jal x2, -12
    dut.pc_i     = 32'd300;
    imem_instr_i = 32'hFF5FF16F; // imm=-12, rd=x2
    #50;
    compare(dut.registers[2], 32'd304); // PC + 4
    compare(dut.pc_o,       32'd288);   // PC - 12

    // Case 4: Large jump offset
    // jal x3, +2048
    dut.pc_i     = 32'd400;
    imem_instr_i = 32'h001000EF; // imm=2048
    #50;
    compare(dut.registers[3], 32'd404);
    compare(dut.pc_o,       32'd2448);

    #20;
    $display("JAL tests completed");
    $display("=======================");
  end
endtask
