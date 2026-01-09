task run_test;
  begin
    $display("");
    $display("=================================================");
    $display(" GOLDEN MODEL : RISC-V ASM EXPECTED BEHAVIOR");
    $display("=================================================");

    $display("");
    $display("[PROGRAM PURPOSE]");
    $display(" This program verifies:");
    $display("  - U-type   : lui, auipc");
    $display("  - I-type   : addi, slti, sltiu, xori, ori, andi");
    $display("  - Shifts   : slli, srli, srai");
    $display("  - R-type   : add, sub, sll, slt, sltu, xor, srl, sra, or, and");

    $display("");
    $display("[EXPECTED OPERATION FLOW]");
    $display("  - Immediate arithmetic and logic");
    $display("  - Shift operations (logical + arithmetic)");
    $display("  - Register-register ALU operations");
    $display("  - No branches, no jumps, straight-line execution");

    $display("");
    $display("[EXPECTED FINAL REGISTER VALUES]");
    $display(" ------------------------------------------------");
    $display("  x1  = 0x%08h", 32'h1234_5000);
    $display("  x2  = PC + 0x00001000   (AUIPC result)");
    $display("  x3  = %0d", 10);
    $display("  x4  = %0d", 40);
    $display("  x5  = %0d", 1);
    $display("  x6  = %0d", 1);
    $display("  x7  = %0d", 5);
    $display("  x8  = %0d", 20);
    $display("  x9  = %0d", 20);
    $display("  x10 = %0d", 42);
    $display("  x11 = %0d", 2);
    $display("  x12 = %0d", 50);
    $display("  x13 = %0d", 30);
    $display("  x14 = %0d", 20);
    $display("  x15 = %0d", 1);
    $display("  x16 = %0d", 1);
    $display("  x17 = %0d", 34);
    $display("  x18 = %0d", 20);
    $display("  x19 = %0d", 20);
    $display("  x20 = %0d", 42);
    $display("  x21 = %0d", 8);

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
