`timescale 1ps / 1ps
module testbench;
  // === DUT & COMPONENTS ===
  /*__TB_COMPONENTS__*/
  // === TEST PARA ===
  parameter CLK_PERIOD = 10;
  integer test = 0;
  integer test_pass = 0;
  real coverage = 0;
  always #(CLK_PERIOD/2) clk_i = ~clk_i;

  `ifdef _INSPECT_
    integer if_log, id_log, ex_log, mem_log, wb_log, branch_jump, forwarding_unit, flush_stall;
  `endif
  // === TEST TASKS ===
  /*__TEST_INCLUDE__*/

  //=============================
  // Set initial value 
  // ============================
  initial begin 
	  rst_i = 0;
    clk_i = 0;
    `ifdef _RISCV_CORE_DUT_
      imem_instr_i = 32'b0;
      dmem_data_i = 32'b0;
    `endif
  end

  //=============================
  // Set initial value 
  // ============================
  initial begin
    #50; rst_i = 1;
    #100; rst_i = 0;
  end

  initial begin
	#300;
  /*__TEST_CALLS__*/
  $display("=======================");
	$display("=== Done run_test! ====");
  $display("=======================");
  $display("=======================");
  $display("No of test: %0d",test);
  $display("No of testpass: %0d",test_pass);
  if (test != 0) begin
  coverage = (test_pass * 100.0) / test;
  $display("Test coverage: %0d%%", coverage);
  end else
  $display("Test coverage: N/A");
  $display("===============================");
	#200;
	$finish;
  end

  // === TB TASKS (non-test) ===
  /*__TB_TASKS__*/
endmodule
