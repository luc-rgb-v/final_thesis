task sb();
  begin
    $display("=======================");
    $display("Test SB instruction");

    // Case 1: Store low byte
    // sb x5, 0(x3)
    dut.registers[3] = 32'd0;          // base address
    dut.registers[5] = 32'h000000AA;   // data
    imem_instr_i     = 32'h00518023;   // sb x5, 0(x3)
    #50;
    compare(dmem_we_o, 1'b1);
    compare(dmem_data_o[7:0], 8'hAA);

    // Case 2: Store byte with upper bits ignored
    // sb x6, 1(x3)
    dut.registers[3] = 32'd0;
    dut.registers[6] = 32'h123456FF;
    imem_instr_i     = 32'h006180A3;   // sb x6, 1(x3)
    #50;
    compare(dmem_data_o[7:0], 8'hFF);

    // Case 3: Store negative byte
    // sb x7, 2(x3)
    dut.registers[3] = 32'd0;
    dut.registers[7] = 32'hFFFFFF80;  // -128
    imem_instr_i     = 32'h00718123;   // sb x7, 2(x3)
    #50;
    compare(dmem_data_o[7:0], 8'h80);

    // Case 4: Store byte at offset 3
    // sb x8, 3(x3)
    dut.registers[3] = 32'd0;
    dut.registers[8] = 32'h00000011;
    imem_instr_i     = 32'h008181A3;   // sb x8, 3(x3)
    #50;
    compare(dmem_data_o[7:0], 8'h11);

    // Case 5: Store from x0 (always zero)
    // sb x0, 0(x3)
    dut.registers[3] = 32'd0;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h00018023;   // sb x0, 0(x3)
    #50;
    compare(dmem_data_o[7:0], 8'h00);

    #20;
    $display("=======================");
  end
endtask
