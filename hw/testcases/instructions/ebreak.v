task ebreak();
  begin
    $display("=======================");
    $display("Test EBREAK instruction");

    dut.pc = 32'h300;
    dut.csr_file[12'h305] = 32'h400; // mtvec

    // ebreak
    imem_instr_i = 32'h00100073;
    #50;

    compare(dut.csr_file[12'h341], 32'h300); // mepc
    compare(dut.csr_file[12'h342], 32'd3);   // mcause
    compare(dut.pc, 32'h400);

    #20;
    $display("=======================");
  end
endtask
