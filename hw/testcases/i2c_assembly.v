task run_test;
  begin

    $display("=================================================");
    $display("");
    $display(" ---     i2c_assemply     ---");
    $display("");
    $display("=================================================");

    #1000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
  end
endtask
