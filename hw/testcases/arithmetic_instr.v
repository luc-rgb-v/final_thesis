task run_test;
  begin
    $display("");
    $display("=================================================");
    $display("========== arithmetic instruction test ==========");
    $display("=================================================");

    $display("");
    $display(" This program verifies:");
    $display("  - U-type   : lui, auipc");
    $display("  - I-type   : addi, slti, sltiu, xori, ori, andi");
    $display("  - Shifts   : slli, srli, srai");
    $display("  - R-type   : add, sub, sll, slt, sltu, xor, srl, sra, or, and");

    $display("");
    $display("=================================================");

    #100000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
