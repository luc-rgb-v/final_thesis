task run_test;
  begin

    $display("=================================================");
    $display("=================== add C test ==================");
    $display("=================================================");

    #2000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
