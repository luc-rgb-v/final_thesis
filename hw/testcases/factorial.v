task run_test;
  begin
    $display("=================================================");
    $display("================= Factorial Test ================");
    $display("=================================================");
    $display("");
    $display("------------------ Expected values --------------");
    $display("");

    $display("Registers:");
    $display("  x1  = 6        (0x00000006)   // N");
    $display("  x2  = 7        (0x00000007)   // i (stopped at N+1)");
    $display("  x3  = 720      (0x000002d0)   // final factorial");
    $display("  ");
    $display("  ");

    $display("Memory (sorted array):");
    $display("  mem[0] = 1  (0x00000001)");
    $display("  mem[1] = 2  (0x00000002)");
    $display("  mem[2] = 3  (0x00000006)");
    $display("  mem[3] = 4  (0x00000018)");
    $display("  mem[4] = 5  (0x00000078)");
    $display("  mem[5] = 7  (0x000002d0)");
    $display("");

    $display("=================================================");

    #4000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
