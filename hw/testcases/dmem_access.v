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
    $display("=================================================");
    $display(" These values are the GOLDEN reference.");
    $display("=================================================");
    #100000;
    $display("");
    $display("addr[0] = 0x%08h", d_memory[0]);
    $display("addr[4] = 0x%08h", d_memory[1]);
    $display("addr[8] = 0x%08h", d_memory[2]);
    $display("addr[c] = 0x%08h", d_memory[3]);
    $display("addr[10] = 0x%08h", d_memory[4]);
    $display("addr[14] = 0x%08h", d_memory[5]);
    $display("addr[18] = 0x%08h", d_memory[6]);
    $display("addr[1c] = 0x%08h", d_memory[7]);
    $display("addr[20] = 0x%08h", d_memory[8]);
    $display("addr[24] = 0x%08h", d_memory[9]);
    $display("addr[28] = 0x%08h", d_memory[10]);
    $display("addr[2c] = 0x%08h", d_memory[11]);
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
