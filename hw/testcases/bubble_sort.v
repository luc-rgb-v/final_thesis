task run_test;
  begin
    $display("=================================================");
    $display("============= Bubble Sort + Max Test ============");
    $display("=================================================");
    $display("");
    $display("------------------ Expected values --------------");
    $display("");

    $display("Registers:");
    $display("  x11 = 8        (0x00000008)   // N");
    $display("  x12 = 9        (0x00000009)   // max value");
    $display("");

    $display("Memory (sorted array):");
    $display("  mem[0] = 1  (0x00000001)");
    $display("  mem[1] = 2  (0x00000002)");
    $display("  mem[2] = 3  (0x00000003)");
    $display("  mem[3] = 4  (0x00000004)");
    $display("  mem[4] = 5  (0x00000005)");
    $display("  mem[5] = 7  (0x00000007)");
    $display("  mem[6] = 8  (0x00000008)");
    $display("  mem[7] = 9  (0x00000009)");
    $display("");

    $display("=================================================");

    #200000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
    $display("");

    $display("---- First 10 entries of data memory ----");
    for (i = 0; i < 10; i = i + 1) begin
      $display("addr[%0d] = 0x%08h", i, d_memory[i]);
    end
    $display("-------------------------------------");

  end
endtask
