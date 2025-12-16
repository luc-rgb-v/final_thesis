task sw();
  begin
    $display("=======================");
    $display("Test SW instruction");

    // Case 1: Store full word at base address
    // sw x5, 0(x3)
    dut.registers[3] = 32'd0;
    dut.registers[5] = 32'h12345678;
    imem_instr_i     = 32'h0051A023;   // sw x5, 0(x3)
    #50;
    compare(dmem_we_o, 1'b1);
    compare(dmem_data_o, 32'h12345678);

    // Case 2: Store negative value
    // sw x6, 4(x3)
    dut.registers[3] = 32'd0;
    dut.registers[6] = -32'sd1;        // 0xFFFFFFFF
    imem_instr_i     = 32'h0061A223;   // sw x6, 4(x3)
    #50;
    compare(dmem_data_o, 32'hFFFFFFFF);

    // Case 3: Store with non-zero base
    // sw x7, 8(x3)
    dut.registers[3] = 32'd100;
    dut.registers[7] = 32'hA5A5A5A5;
    imem_instr_i     = 32'h0071A423;   // sw x7, 8(x3)
    #50;
    compare(dmem_data_o, 32'hA5A5A5A5);

    // Case 4: Store zero
    // sw x8, 12(x3)
    dut.registers[3] = 32'd0;
    dut.registers[8] = 32'd0;
    imem_instr_i     = 32'h0081A623;   // sw x8, 12(x3)
    #50;
    compare(dmem_data_o, 32'h00000000);

    // Case 5: Store from x0
    // sw x0, 0(x3)
    dut.registers[3] = 32'd0;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h0001A023;   // sw x0, 0(x3)
    #50;
    compare(dmem_data_o, 32'h00000000);

    #20;
    $display("=======================");
  end
endtask
