task run_test;
  begin

    $display("=================================================");
    $display("================ sum 1 to 100 test ==============");
    $display("=================================================");
    $display("");
    $display("------------------ Expected value ---------------");
    $display("");
    $display("  x1 = 10    (0x0000000a)");
    $display("  x2 = 55    (0x00000037)");
    $display("  x3 = 10    (0x0000000a)");
    $display("  x5 = 100   (0x00000064)");
    $display("  x11 = 200  (0x000000c8)");
    $display("");
    $display("=================================================");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
