task run_test;
  begin
    $display("");
    $display("=================================================");
    $display("=========== RV32I divu32 corner tests ===========");
    $display("=================================================");
    $display("expected x31 (failmask) = 0x00000000");
    $display("expected tests:");
    $display("  T0: 0x00001234 / 0x00000000 => q=0xFFFFFFFF r=0x00001234");
    $display("  T1: 0xFFFFFFFF / 0xFFFFFFFF => q=0x00000001 r=0x00000000");
    $display("  T2: 0x80000000 / 0x00000002 => q=0x40000000 r=0x00000000");
    $display("  T3: 0x80000000 / 0x00000003 => q=0x2AAAAAAA r=0x00000002");
    $display("  T4: 0x80000001 / 0x80000000 => q=0x00000001 r=0x00000001");
    $display("expected final regs (after T4):");
    $display("  x10=0x80000001  x11=0x80000000  x12=0x00000001  x13=0x00000001");
    $display("note: if x31 != 0, bit i=1 => Ti failed");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
    $display("");
  end
endtask
