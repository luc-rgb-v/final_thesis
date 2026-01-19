task run_test;
  begin
    
    $display("");
    $display("=================================================");
    $display("============ uart communication test ============");
    $display("=================================================");
    $display("");
    $display("------- uart send hello and change baud rate ---");
    $display("");
    #1500000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask