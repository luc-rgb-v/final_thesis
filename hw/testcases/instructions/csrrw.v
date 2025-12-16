task csrrw();
  begin
    $display("=======================");
    $display("Test CSRRW instruction");

    // csr[0x300] = 0x1234
    dut.csr_file[12'h300] = 32'h00001234;
    dut.registers[3]      = 32'hDEADBEEF;

    // csrrw x5, 0x300, x3
    imem_instr_i = 32'h300192F3;
    #50;

    // rd gets old CSR
    compare(dut.registers[5], 32'h00001234);
    // CSR gets rs1
    compare(dut.csr_file[12'h300], 32'hDEADBEEF);

    #20;
    $display("=======================");
  end
endtask
