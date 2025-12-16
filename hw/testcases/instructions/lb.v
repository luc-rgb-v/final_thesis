task lb();
  begin
    $display("=======================");
    $display("Test LB instruction");

    // Case 1: Load positive byte (0x7F = 127)
    // lb x5, 0(x3)
    dut.registers[3] = 32'd0;          // base address
    dmem_data_i      = 32'h0000007F;   // byte[0] = 0x7F
    imem_instr_i     = 32'h00018283;   // lb x5, 0(x3)
    #50;
    compare(dut.registers[5], 32'd127);

    // Case 2: Load negative byte (0x80 = -128)
    // lb x6, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00000080;   // byte[0] = 0x80
    imem_instr_i     = 32'h00018303;   // lb x6, 0(x3)
    #50;
    compare(dut.registers[6], -32'sd128);

    // Case 3: Load from byte offset 1
    // lb x7, 1(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00001234;   // byte[1] = 0x12
    imem_instr_i     = 32'h00118383;   // lb x7, 1(x3)
    #50;
    compare(dut.registers[7], 32'd18);

    // Case 4: Load from byte offset 2 (negative)
    // lb x8, 2(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00FF0000;   // byte[2] = 0xFF
    imem_instr_i     = 32'h00218403;   // lb x8, 2(x3)
    #50;
    compare(dut.registers[8], -32'sd1);

    // Case 5: Load from byte offset 3
    // lb x9, 3(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h80000000;   // byte[3] = 0x80
    imem_instr_i     = 32'h00318483;   // lb x9, 3(x3)
    #50;
    compare(dut.registers[9], -32'sd128);

    // Case 6: Write to x0 must be ignored
    // lb x0, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h0000007F;
    imem_instr_i     = 32'h00018003;   // lb x0, 0(x3)
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
