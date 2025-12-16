task andi();
  begin
    $display("=======================");
    $display("Test ANDI instruction");

    // Case 1: Basic AND (0xF & 0xA = 0xA)
    // andi x5, x3, 0xA
    dut.registers[3] = 32'h0000000F;
    imem_instr_i     = 32'h00A1F293; // imm=0x00A, rs1=x3, rd=x5
    #50;
    compare(dut.registers[5], 32'h0000000A);

    // Case 2: AND with zero immediate (anything & 0 = 0)
    // andi x6, x3, 0
    dut.registers[3] = 32'hFFFFFFFF;
    imem_instr_i     = 32'h0001F313;
    #50;
    compare(dut.registers[6], 32'd0);

    // Case 3: AND with all-ones immediate (mask lower 12 bits)
    // andi x7, x3, -1  (imm = 0xFFF)
    dut.registers[3] = 32'h12345678;
    imem_instr_i     = 32'hFFF1F393;
    #50;
    compare(dut.registers[7], 32'h12345678);

    // Case 4: AND clears upper bits
    // 0xABCD1234 & 0x00F = 0x004
    // andi x8, x3, 0xF
    dut.registers[3] = 32'hABCD1234;
    imem_instr_i     = 32'h00F1F413;
    #50;
    compare(dut.registers[8], 32'h00000004);

    // Case 5: rd == rs1
    // andi x9, x9, 0xFF
    dut.registers[9] = 32'h1234ABCD;
    imem_instr_i     = 32'h0FF4F493;
    #50;
    compare(dut.registers[9], 32'h000000CD);

    // Case 6: AND with zero register
    // andi x10, x0, 0xFF
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h0FF05513;
    #50;
    compare(dut.registers[10], 32'd0);

    // Case 7: Write to x0 must be ignored
    // andi x0, x1, 0xFF
    dut.registers[1] = 32'hFFFFFFFF;
    imem_instr_i     = 32'h0FF0F013;
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("ANDI tests completed");
    $display("=======================");
  end
endtask
