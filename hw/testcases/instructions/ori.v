task ori();
  begin
    $display("=======================");
    $display("Test ORI instruction");

    // Case 1: Simple OR immediate
    // 5 | 3 = 7
    // ori x5, x3, 3
    dut.registers[3] = 32'd5;
    imem_instr_i     = 32'h0031E293;   // ori x5, x3, 3
    #50;
    compare(dut.registers[5], 32'd7);

    // Case 2: OR immediate with zero
    // 9 | 0 = 9
    // ori x6, x3, 0
    dut.registers[3] = 32'd9;
    imem_instr_i     = 32'h0001E313;   // ori x6, x3, 0
    #50;
    compare(dut.registers[6], 32'd9);

    // Case 3: OR with negative immediate (sign-extended)
    // 0x0000000F | 0xFFF = 0xFFFFFFFF
    // ori x7, x4, -1
    dut.registers[4] = 32'h0000000F;
    imem_instr_i     = 32'hFFF24393;   // ori x7, x4, -1
    #50;
    compare(dut.registers[7], 32'hFFFFFFFF);

    // Case 4: OR immediate sets upper bits
    // 0x12340000 | 0x100 = 0x12340100
    // ori x8, x9, 256
    dut.registers[9] = 32'h12340000;
    imem_instr_i     = 32'h1004E413;   // ori x8, x9, 256
    #50;
    compare(dut.registers[8], 32'h12340100);

    // Case 5: OR immediate with zero register
    // 0 | 0x7FF = 0x7FF
    // ori x10, x0, 2047
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h7FF04513;   // ori x10, x0, 2047
    #50;
    compare(dut.registers[10], 32'd2047);

    // Case 6: Write to x0 must be ignored
    // ori x0, x1, 5
    dut.registers[1] = 32'd3;
    imem_instr_i     = 32'h0050E013;   // ori x0, x1, 5
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
