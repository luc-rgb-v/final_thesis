task lh();
  begin
    $display("=======================");
    $display("Test LH instruction");

    // Case 1: Load positive halfword (0x1234 = 4660)
    // lh x5, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00001234;   // halfword[0] = 0x1234
    imem_instr_i     = 32'h00019283;   // lh x5, 0(x3)
    #50;
    compare(dut.registers[5], 32'd4660);

    // Case 2: Load negative halfword (0x8000 = -32768)
    // lh x6, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00008000;   // sign bit set
    imem_instr_i     = 32'h00019303;   // lh x6, 0(x3)
    #50;
    compare(dut.registers[6], -32'sd32768);

    // Case 3: Load halfword from offset 2
    // lh x7, 2(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h12340000;   // halfword[1] = 0x1234
    imem_instr_i     = 32'h00219383;   // lh x7, 2(x3)
    #50;
    compare(dut.registers[7], 32'd4660);

    // Case 4: Negative halfword from offset 2
    // lh x8, 2(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h80000000;   // halfword[1] = 0x8000
    imem_instr_i     = 32'h00219403;   // lh x8, 2(x3)
    #50;
    compare(dut.registers[8], -32'sd32768);

    // Case 5: Write to x0 must be ignored
    // lh x0, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h0000FFFF;
    imem_instr_i     = 32'h00019003;   // lh x0, 0(x3)
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
