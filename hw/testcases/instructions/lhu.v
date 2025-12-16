task lhu();
  begin
    $display("=======================");
    $display("Test LHU instruction");

    // Case 1: Load positive halfword (0x1234 = 4660)
    // lhu x5, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00001234;   // halfword[0] = 0x1234
    imem_instr_i     = 32'h0001D283;   // lhu x5, 0(x3)
    #50;
    compare(dut.registers[5], 32'd4660);

    // Case 2: Load unsigned halfword (0x8000 = 32768)
    // lhu x6, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00008000;   // halfword[0] = 0x8000
    imem_instr_i     = 32'h0001D303;   // lhu x6, 0(x3)
    #50;
    compare(dut.registers[6], 32'd32768);

    // Case 3: Load halfword from offset 2
    // lhu x7, 2(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h12340000;   // halfword[1] = 0x1234
    imem_instr_i     = 32'h0021D383;   // lhu x7, 2(x3)
    #50;
    compare(dut.registers[7], 32'd4660);

    // Case 4: Load max unsigned halfword (0xFFFF = 65535)
    // lhu x8, 2(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'hFFFF0000;   // halfword[1] = 0xFFFF
    imem_instr_i     = 32'h0021D403;   // lhu x8, 2(x3)
    #50;
    compare(dut.registers[8], 32'd65535);

    // Case 5: Write to x0 must be ignored
    // lhu x0, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h0000FFFF;
    imem_instr_i     = 32'h0001D003;   // lhu x0, 0(x3)
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
