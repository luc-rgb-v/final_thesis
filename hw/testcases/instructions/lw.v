task lw();
  begin
    $display("=======================");
    $display("Test LW instruction");

    // Case 1: Load simple word
    // lw x5, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h12345678;
    imem_instr_i     = 32'h0001A283;   // lw x5, 0(x3)
    #50;
    compare(dut.registers[5], 32'h12345678);

    // Case 2: Load negative word
    // lw x6, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h80000000;
    imem_instr_i     = 32'h0001A303;   // lw x6, 0(x3)
    #50;
    compare(dut.registers[6], 32'h80000000);

    // Case 3: Load from non-zero offset
    // lw x7, 4(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'hDEADBEEF;
    imem_instr_i     = 32'h0041A383;   // lw x7, 4(x3)
    #50;
    compare(dut.registers[7], 32'hDEADBEEF);

    // Case 4: Load all ones
    // lw x8, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'hFFFFFFFF;
    imem_instr_i     = 32'h0001A403;   // lw x8, 0(x3)
    #50;
    compare(dut.registers[8], 32'hFFFFFFFF);

    // Case 5: Write to x0 must be ignored
    // lw x0, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'hCAFEBABE;
    imem_instr_i     = 32'h0001A003;   // lw x0, 0(x3)
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
