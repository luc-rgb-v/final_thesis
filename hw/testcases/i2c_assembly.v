task run_test;
  begin

    $display("=================================================");
    $display("================ i2c assemply test ==============");
    $display("=================================================");

    #10000000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
