task run_test;
  begin

    $dumpfile("test_wave_14_01_2026.vcd");
    $dumpvars(0,testbench);

    $display("");
    $display("=================================================");
    $display("======= specific instruction direct test ========");
    $display("=================================================");

    #1000000;
    $display("");
    compare_regs();
    $display("");
    $display("addr[0] = 0x%08h", d_memory[0]);
    $display("addr[4] = 0x%08h", d_memory[1]);
    $display("addr[8] = 0x%08h", d_memory[2]);
    $display("addr[c] = 0x%08h", d_memory[3]);
    $display("");
    compare_mem();
    $display("");
    $display("REG[4] = %h", dut_reg_file.registers[4]);
    $display("REG[5] = %h", dut_reg_file.registers[5]);
    $display("REG[6] = %h", dut_reg_file.registers[6]);
    $display("REG[7] = %h", dut_reg_file.registers[7]);
    $display("REG[8] = %h", dut_reg_file.registers[8]);
    $display("REG[9] = %h", dut_reg_file.registers[9]);
    $display("");
  end
endtask
