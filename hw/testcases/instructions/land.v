task land(); // logical AND (avoid Verilog keyword "and")
  begin
    $display("=======================");
    $display("Test AND instruction");

    // Case 1: Simple AND (656 & 656 = 656)
    // and x5, x3, x4
    dut.registers[3] = 32'd656;
    dut.registers[4] = 32'd656;
    imem_instr_i     = 32'h0041F2B3;
    #50;
    compare(dut.registers[5], 32'd656);

    // Case 2: AND with zero (123 & 0 = 0)
    // and x6, x3, x0
    dut.registers[3] = 32'd123;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h0001F333;
    #50;
    compare(dut.registers[6], 32'd0);

    // Case 3: Zero AND number (0 & 77 = 0)
    // and x7, x0, x4
    dut.registers[0] = 32'd0;
    dut.registers[4] = 32'd77;
    imem_instr_i     = 32'h004033B3;
    #50;
    compare(dut.registers[7], 32'd0);

    // Case 4: Bit masking
    // 0xFF00FF00 & 0x0F0F0F0F = 0x0F000F00
    // and x8, x9, x10
    dut.registers[9]  = 32'hFF00FF00;
    dut.registers[10] = 32'h0F0F0F0F;
    imem_instr_i      = 32'h00A4F433;
    #50;
    compare(dut.registers[8], 32'h0F000F00);

    // Case 5: rd == rs1
    // and x11, x11, x12
    dut.registers[11] = 32'hFFFF0000;
    dut.registers[12] = 32'h0F0F0F0F;
    imem_instr_i      = 32'h00C5F5B3;
    #50;
    compare(dut.registers[11], 32'h0F0F0000);

    // Case 6: Negative numbers
    // -1 & 0x12345678 = 0x12345678
    // and x13, x14, x15
    dut.registers[14] = -32'sd1;
    dut.registers[15] = 32'h12345678;
    imem_instr_i      = 32'h00F776B3;
    #50;
    compare(dut.registers[13], 32'h12345678);

    // Case 7: Write to x0 must be ignored
    // and x0, x1, x2
    dut.registers[1] = 32'hFFFFFFFF;
    dut.registers[2] = 32'h00000000;
    imem_instr_i     = 32'h0020F033;
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("AND tests completed");
    $display("=======================");
  end
endtask
