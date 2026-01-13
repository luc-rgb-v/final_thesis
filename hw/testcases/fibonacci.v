task run_test;
  begin
    $display("=================================================");
    $display("============ Fibonacci + Sum Test ===============");
    $display("=================================================");
    $display("");
    $display("------------------ Expected values --------------");
    $display("");

    $display("Registers:");
    $display("  x4  = 10     (0x0000000A)   // N");
    $display("  x12 = 88     (0x00000058)   // sum of fib[0..9]");
    $display("");

    $display("Memory (fib_array):");
    $display("  mem[0]  = 0   (0x00000000)");
    $display("  mem[1]  = 1   (0x00000001)");
    $display("  mem[2]  = 1   (0x00000001)");
    $display("  mem[3]  = 2   (0x00000002)");
    $display("  mem[4]  = 3   (0x00000003)");
    $display("  mem[5]  = 5   (0x00000005)");
    $display("  mem[6]  = 8   (0x00000008)");
    $display("  mem[7]  = 13  (0x0000000D)");
    $display("  mem[8]  = 21  (0x00000015)");
    $display("  mem[9]  = 34  (0x00000022)");
    $display("");

    $display("=================================================");

    #2000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
