task run_test;
  begin

    $display("=================================================");
    $display("================= for loop test =================");
    $display("=================================================");
    $display("");
    $display("-------- Expected: x3 = 0'd55 0x37 ----------");
    $display("expected result:");
    $display("  sum(1..10) = 55 (0x00000037)");
    $display("expected final regs (at end_loop):");
    $display("  x1 = 11 (0x0000000B)   # i after last increment");
    $display("  x2 = 10 (0x0000000A)   # limit");
    $display("  x3 = 55 (0x00000037)   # sum");
    $display("=================================================");
    $display("");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask


