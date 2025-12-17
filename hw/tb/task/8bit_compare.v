`ifdef _COMPARE_
  task compare(input [7:0] act_val, input [7:0] exp_val);
    begin
      test = test + 1;
      if (act_val == exp_val) begin
        $display("time %0t: Matched value = '%h'", $time, act_val);
        test_pass = test_pass + 1;
      end else begin
        $display("time %0t: Mismatched value - actual = '%h' - expected = '%h'", $time, act_val, exp_val);
      end
    end
  endtask
`endif
