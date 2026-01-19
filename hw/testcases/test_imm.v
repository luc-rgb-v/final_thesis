task run_test;
  begin
    
    $display("");
    $display("=================================================");
    $display("============== imm instruction test =============");
    $display("=================================================");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask