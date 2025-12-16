task auipc();
  begin
    $display("=======================");
    $display("Test AUIPC instruction");
    $display("imm[31:12] rd 0010111");
    $display("=======================");

    // Case 1: Simple AUIPC: x5 = PC + 0x1_000
    // auipc x5, 0x1
    dut.pc_i          = 32'd100;       // current PC = 100
    imem_instr_i      = 32'h00001117;   // imm=0x0, rd=x5, opcode=AUIPC (0010111)
    #50;
    compare(dut.registers[5], 32'd100); // imm=0, so x5 = PC + 0 = 100

    // Case 2: AUIPC with non-zero immediate: x6 = PC + 0x12345000
    dut.pc_i          = 32'd200;
    imem_instr_i      = 32'h12345617;   // imm=0x12345, rd=x6, AUIPC
    #50;
    compare(dut.registers[6], 32'd200 + (32'h12345 << 12));

    // Case 3: rd == x0, result ignored
    dut.pc_i          = 32'd300;
    imem_instr_i      = 32'h00000017;   // rd = x0
    #50;
    compare(dut.registers[0], 32'd0);

    // Case 4: AUIPC negative offset (signed 20-bit imm)
    dut.pc_i          = 32'd400;
    imem_instr_i      = 32'hFFF7F817;   // imm = -0x00081
    #50;
    compare(dut.registers[7], 32'd400 + (32'hFFFFF << 12)); // 2's complement

    #20;
    $display("AUIPC tests completed");
    $display("=======================");
  end
endtask
