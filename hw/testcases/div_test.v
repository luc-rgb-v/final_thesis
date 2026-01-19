task run_test;
  begin
    $display("");
    $display("=================================================");
    $display("=============== RV32I divu32 tests ==============");
    $display("=================================================");
    $display("expected x31 (failmask) = 0x00000000");
    $display("expected final regs:");
    $display("  x31 = failmask (0=PASS)");
    $display("  x12 = last quotient  = 0xFFFFFFFF");
    $display("  x13 = last remainder = 0x00001234");
    $display("  x10 = last dividend  = 0x00001234");
    $display("  x11 = last divisor   = 0x00000000");
    $display("expected tests:");
    $display("  T0: 13 / 7        => q=1          r=6");
    $display("  T1: 0  / 7        => q=0          r=0");
    $display("  T2: 7  / 13       => q=0          r=7");
    $display("  T3: 255 / 2       => q=127        r=1");
    $display("  T4: 0xFFFFFFFF/16 => q=0x0FFFFFFF r=0x0000000F");
    $display("  T5: 0x1234 / 0    => q=0xFFFFFFFF r=0x00001234");
    $display("note: if x31 != 0, bit i=1 => test Ti failed");

    #1000000;
    $display("");

    compare_regs();
    compare_mem();
  end
endtask
