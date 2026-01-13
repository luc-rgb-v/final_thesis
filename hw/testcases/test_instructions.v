task run_test;
  begin

    $display("=================================================");
    $display("");
    $display(" ---     test_instructions     ---");
    $display("");
    $display("=================================================");

    #3000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask