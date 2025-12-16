task sh();
  begin
    $display("=======================");
    $display("Test SH instruction");

    // Case 1: Store low halfword
    // sh x5, 0(x3)
    dut.registers[3] = 32'd0;
    dut.registers[5] = 32'h00001234;
    imem_instr_i     = 32'h00519023;   // sh x5, 0(x3)
    #50;
    compare(dmem_we_o, 1'b1);
    compare(dmem_data_o[15:0], 16'h1234);

    // Case 2: Upper bits ignored
    // sh x6, 0(x3)
    dut.registers[3] = 32'd0;
    dut.registers[6] = 32'hABCD5678;
    imem_instr_i     = 32'h00619023;   // sh x6, 0(x3)
    #50;
    compare(dmem_data_o[15:0], 16'h5678);

    // Case 3: Store negative halfword
    // sh x7, 2(x3)
    dut.registers[3] = 32'd0;
    dut.registers[7] = 32'hFFFF8000;
    imem_instr_i     = 32'h00719123;   // sh x7, 2(x3)
    #50;
    compare(dmem_data_o[15:0], 16'h8000);

    // Case 4: Store max halfword
    // sh x8, 2(x3)
    dut.registers[3] = 32'd0;
    dut.registers[8] = 32'h0000FFFF;
    imem_instr_i     = 32'h00819123;   // sh x8, 2(x3)
    #50;
    compare(dmem_data_o[15:0], 16'hFFFF);

    // Case 5: Store from x0
    // sh x0, 0(x3)
    dut.registers[3] = 32'd0;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h00019023;   // sh x0, 0(x3)
    #50;
    compare(dmem_data_o[15:0], 16'h0000);

    #20;
    $display("=======================");
  end
endtask
