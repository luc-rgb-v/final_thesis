task run_test;
  begin

    $display("=================================================");
    $display("");
    $display(" ---     uart_s_sim     ---");
    $display("");
    $display("=================================================");

    #1000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask