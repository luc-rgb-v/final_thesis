task run_test;
  begin
    $display("");
    $display("=================================================");
    $display("======= memory access instruction test ==========");
    $display("=================================================");

    $display("");
    $display(" This program verifies:");
    $display("  - U-type   : lui");
    $display("  - I-type   : addi");
    $display("  - Stores   : sw, sh, sb");
    $display("  - Loads    : lw, lh, lhu, lb, lbu");
    $display("  - Sign/Zero extension behavior");
    $display("  - x0 immutability");

    $display("");
    $display("[EXPECTED MEMORY BEHAVIOR]");
    $display("  mem[0x80000000] = 0x11223344  (sw)");
    $display("  mem[0x80000004] = 0x3344      (sh)");
    $display("  mem[0x80000006] = 0x44        (sb)");
    $display("  mem[0x80000008] = 0xFF        (sb -1)");
    $display("  mem[0x8000000A] = 0xFFFF      (sh -1)");

    $display("");
    $display("[EXPECTED FINAL REGISTER VALUES]");
    $display(" ------------------------------------------------");
    $display("  x1  = 0x%08h", 32'h8000_0000);
    $display("  x2  = 0x%08h", 32'h1122_3344);
    $display("  x3  = 0x%08h", 32'hFFFF_FFFF);
    $display("  x4  = 0x%08h", 32'h1122_3344);
    $display("  x5  = 0x%08h", 32'h0000_3344);
    $display("  x6  = 0x%08h", 32'h0000_3344);
    $display("  x7  = 0x%08h", 32'h0000_0044);
    $display("  x8  = 0x%08h", 32'h0000_0044);
    $display("  x9  = 0x%08h", 32'hFFFF_FFFF);
    $display("  x10 = 0x%08h", 32'h0000_00FF);
    $display("  x11 = 0x%08h", 32'hFFFF_FFFF);
    $display("  x12 = 0x%08h", 32'h0000_FFFF);
    $display("  x0  = 0x%08h (always zero)", 32'h0000_0000);

    $display("");
    $display("=================================================");
    $display(" These values are the GOLDEN reference.");
    $display(" Next step: compare DUT vs Spike.");
    $display("=================================================");

    #1000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
