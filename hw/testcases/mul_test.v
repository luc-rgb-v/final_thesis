task run_test;
  begin

    $display("=================================================");
    $display("================= mul test =================");
    $display("=================================================");
    $display("");
    $display("-------- Expected: x3 = 0'd55 0x37 ----------");
    $display("");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
