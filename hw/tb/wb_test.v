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

  // === TEST TASKS ===
  /*__TEST_INCLUDE__*/

  //=============================
  // Set initial value 
  // ============================
  initial begin 
	  rst_i = 1;
    clk_i = 0;
    #50; rst_i = 0;
  end

  initial begin
	#300;
  /*__TEST_CALLS__*/
  $display("=======================");
	$display("=== Done run_test! ====");
  $display("=======================");
  $display("=======================");
  $display("No of test: %0d", test);
  $display("No of testpass: %0d", test_pass);
  if (test != 0) begin
    coverage = (test_pass * 100.0) / test;
    $display("Test coverage: %0d%%", coverage);
  end else
    $display("Test coverage: N/A");
  $display("=======================");
	#200;
	$finish;
  end

  // === TB TASKS (non-test) ===
  /*__TB_TASKS__*/
endmodule
