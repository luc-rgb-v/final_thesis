task run_test;
  begin
    $display("");
    $display("=================================================");
    $display("========= branch jump instruction test ==========");
    $display("=================================================");

    $display("");
    $display(" This program verifies:");
    $display("  - ALU ops   : add, sub, xor, or, and, sll, srl");
    $display("  - Branches  : beq, bne, blt, bge, bltu, bgeu");
    $display("  - Jumps     : jal, jalr");
    $display("  - Loop + flow control");
    $display("  - Status in x5 (0=PASS, non-zero=FAIL)");

    $display("");
    $display("[EXPECTED CONTROL FLOW]");
    $display("  beq  x2,x3   -> TAKEN");
    $display("  bne  x2,x3   -> NOT taken");
    $display("  blt  x2,x4   -> TAKEN");
    $display("  bge  x4,x2   -> TAKEN");
    $display("  bltu x10,x9  -> TAKEN");
    $display("  bgeu x9,x10  -> TAKEN");
    $display("  jal/jalr     -> return OK");
    $display("  loop         -> exits when x13 == 0");

    $display("");
    $display("[EXPECTED FINAL REGISTER VALUES]");
    $display(" ------------------------------------------------");
    $display("  x1  = 0x%08h", 32'h0000_0001);
    $display("  x5  = %0d   (STATUS: PASS)", 0);
    $display("  x6  = %0d", 19);
    $display("  x7  = %0d", 19);
    $display("  x8  = %0d", 8);
    $display("  x9  = -1");
    $display("  x10 = 1");
    $display("  x11 = 0");
    $display("  x13 = 0");

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
