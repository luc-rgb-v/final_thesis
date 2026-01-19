task run_test;
  begin

    $display("=================================================");
    $display("================= if else test =================");
    $display("=================================================");
    $display("");
    $display("-------- Expected:  ----------");
    $display("");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
