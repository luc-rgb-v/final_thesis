task ecall();
  begin
    $display("=======================");
    $display("Test ECALL instruction");

    dut.pc = 32'h100;
    dut.csr_file[12'h305] = 32'h200; // mtvec

    // ecall
    imem_instr_i = 32'h00000073;
    #50;

    compare(dut.csr_file[12'h341], 32'h100); // mepc
    compare(dut.csr_file[12'h342], 32'd11);  // mcause
    compare(dut.pc, 32'h200);                 // jump to mtvec

    #20;
    $display("=======================");
  end
endtask
