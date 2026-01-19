task run_test;
  begin

    $display("=================================================");
    $display("============= test bj mul equation ==============");
    $display("=================================================");
    $display("");
    $display("------------------ Expected value ---------------");
    $display("");
    $display("");
    $display("=================================================");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
