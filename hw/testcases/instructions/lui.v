task lui();
  begin
    $display("=======================");
    $display("Test LUI instruction");

    // Case 1: Load simple upper immediate
    // lui x5, 0x00012  -> x5 = 0x00012000
    imem_instr_i = 32'h000122B7;   // imm=0x00012, rd=x5
    #50;
    compare(dut.registers[5], 32'h00012000);

    // Case 2: Non-zero upper immediate
    // lui x6, 0xABCDE -> x6 = 0xABCDE000
    imem_instr_i = 32'hABCDE337;   // imm=0xABCDE, rd=x6
    #50;
    compare(dut.registers[6], 32'hABCDE000);

    // Case 3: Sign bit set in upper immediate
    // lui x7, 0x80000 -> x7 = 0x80000000
    imem_instr_i = 32'h800003B7;   // imm=0x80000, rd=x7
    #50;
    compare(dut.registers[7], 32'h80000000);

    // Case 4: All ones immediate
    // lui x8, 0xFFFFF -> x8 = 0xFFFFF000
    imem_instr_i = 32'hFFFFF437;   // imm=0xFFFFF, rd=x8
    #50;
    compare(dut.registers[8], 32'hFFFFF000);

    // Case 5: Write to x0 must be ignored
    // lui x0, 0x12345
    imem_instr_i = 32'h12345037;   // rd=x0
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
