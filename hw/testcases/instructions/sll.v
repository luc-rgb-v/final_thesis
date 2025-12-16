task sll(); // logical shift left
  begin
    $display("=======================");
    $display("Test SLL instruction");

    // Case 1: Simple shift
    // 1 << 3 = 8
    // sll x5, x3, x4
    dut.registers[3] = 32'd1;
    dut.registers[4] = 32'd3;
    imem_instr_i     = 32'h004192B3;   // sll x5, x3, x4
    #50;
    compare(dut.registers[5], 32'd8);

    // Case 2: Shift by zero
    // 7 << 0 = 7
    // sll x6, x3, x0
    dut.registers[3] = 32'd7;
    dut.registers[0] = 32'd0;
    imem_instr_i     = 32'h00019333;   // sll x6, x3, x0
    #50;
    compare(dut.registers[6], 32'd7);

    // Case 3: Shift uses only lower 5 bits of rs2
    // 1 << 33 → 1 << 1 = 2
    // sll x7, x3, x4
    dut.registers[3] = 32'd1;
    dut.registers[4] = 32'd33;
    imem_instr_i     = 32'h004193B3;   // sll x7, x3, x4
    #50;
    compare(dut.registers[7], 32'd2);

    // Case 4: Shift causing overflow (bits discarded)
    // 0x40000000 << 1 = 0x80000000
    // sll x8, x9, x10
    dut.registers[9]  = 32'h40000000;
    dut.registers[10] = 32'd1;
    imem_instr_i      = 32'h00A49433;  // sll x8, x9, x10
    #50;
    compare(dut.registers[8], 32'h80000000);

    // Case 5: Shift all bits out
    // 1 << 31 = 0x80000000
    // sll x11, x12, x13
    dut.registers[12] = 32'd1;
    dut.registers[13] = 32'd31;
    imem_instr_i      = 32'h00D615B3;  // sll x11, x12, x13
    #50;
    compare(dut.registers[11], 32'h80000000);

    // Case 6: Write to x0 must be ignored
    // sll x0, x1, x2
    dut.registers[1] = 32'd2;
    dut.registers[2] = 32'd3;
    imem_instr_i     = 32'h00209033;   // sll x0, x1, x2
    #50;
    compare(dut.registers[0], 32'd0);

    #20;
    $display("=======================");
  end
endtask
