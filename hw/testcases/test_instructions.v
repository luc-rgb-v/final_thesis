task run_test;
  begin

    $display("");
    $display("=================================================");
    $display("======= specific instruction direct test ========");
    $display("=================================================");

    #70000;
    $display("");
    compare_regs();
    $display("");
    compare_mem();
    $display("REG[4] = %h", dut_reg_file.registers[4]);
    $display("REG[5] = %h", dut_reg_file.registers[5]);
    $display("REG[6] = %h", dut_reg_file.registers[6]);
    $display("REG[7] = %h", dut_reg_file.registers[7]);
    $display("REG[8] = %h", dut_reg_file.registers[8]);
    $display("REG[9] = %h", dut_reg_file.registers[9]);
  end
endtask
