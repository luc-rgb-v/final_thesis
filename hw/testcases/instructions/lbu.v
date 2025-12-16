task lbu();
  begin
    $display("=======================");
    $display("Test LBU instruction");

    // Case 1: Load positive byte (0x7F = 127)
    // lbu x5, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h0000007F;   // byte[0] = 0x7F
    imem_instr_i     = 32'h0001C283;
    #50;
    compare(dut.registers[5], 32'd127);

    // Case 2: Load unsigned byte (0x80 = 128)
    // lbu x6, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00000080;   // byte[0] = 0x80
    imem_instr_i     = 32'h0001C303;
    #50;
    compare(dut.registers[6], 32'd128);

    // Case 3: Load from byte offset 1
    // lbu x7, 1(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00001234;   // byte[1] = 0x12
    imem_instr_i     = 32'h0011C383;
    #50;
    compare(dut.registers[7], 32'd18);

    // Case 4: Load from byte offset 2
    // lbu x8, 2(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h00FF0000;   // byte[2] = 0xFF
    imem_instr_i     = 32'h0021C403;
    #50;
    compare(dut.registers[8], 32'd255);

    // Case 5: Load from byte offset 3
    // lbu x9, 3(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h80000000;   // byte[3] = 0x80
    imem_instr_i     = 32'h0031C483;
    #50;
    compare(dut.registers[9], 32'd128);

    // Case 6: Write to x0 must be ignored
    // lbu x0, 0(x3)
    dut.registers[3] = 32'd0;
    dmem_data_i      = 32'h000000FF;
    imem_instr_i     = 32'h0001C003;
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
