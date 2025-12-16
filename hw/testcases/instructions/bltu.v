task bltu();
  begin
    $display("=======================");
    $display("Test BLTU instruction");
    $display("=======================");

    // Case 1: Branch taken (unsigned x1 < x2)
    // bltu x1, x2, +8
    dut.registers[1] = 32'd5;
    dut.registers[2] = 32'd10;
    dut.pc_i         = 32'd100;
    imem_instr_i     = 32'h0020E063; // imm=8, rs1=x1, rs2=x2, BLTU
    #50;
    compare(dut.pc_o, 32'd108);      // PC = PC + imm

    // Case 2: Branch NOT taken (unsigned x3 >= x4)
    // bltu x3, x4, +12
    dut.registers[3] = 32'd20;
    dut.registers[4] = 32'd10;
    dut.pc_i         = 32'd200;
    imem_instr_i     = 32'h00426E63; // imm=12
    #50;
    compare(dut.pc_o, 32'd204);      // PC = PC + 4

    // Case 3: Unsigned corner case
    // 0xFFFFFFFF < 1  (unsigned: false)
    dut.registers[5] = 32'hFFFFFFFF;
    dut.registers[6] = 32'd1;
    dut.pc_i         = 32'd300;
    imem_instr_i     = 32'h0062EE63; // imm=16
    #50;
    compare(dut.pc_o, 32'd304);      // NOT taken

    // Case 4: Unsigned corner case
    // 0 < 0xFFFFFFFF (unsigned: true)
    dut.registers[7] = 32'd0;
    dut.registers[8] = 32'hFFFFFFFF;
    dut.pc_i         = 32'd400;
    imem_instr_i     = 32'h0083E863; // imm=16
    #50;
    compare(dut.pc_o, 32'd416);      // taken

    #20;
    $display("BLTU tests completed");
    $display("=======================");
  end
endtask
