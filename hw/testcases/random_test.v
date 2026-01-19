task run_test;
  begin
    
    $display("");
    $display("=================================================");
    $display("================== random test ==================");
    $display("=================================================");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
    $display("");

  end
endtask