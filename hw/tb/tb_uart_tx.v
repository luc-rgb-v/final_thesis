`timescale 1ns / 1ps

module uart_tx_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    //parameter PRESCALE = 9600;
    parameter PRESCALE = 1;

    // Inputs
    reg clk;
    reg rst;
    reg [DATA_WIDTH-1:0] s_axis_tdata;
    reg s_axis_tvalid;
    reg [15:0] prescale;

    // Outputs
    wire txd;
    wire s_axis_tready;
    wire busy;

    // Instantiate the UART TX module
    uart_tx #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .txd(txd),
        .busy(busy),
        .prescale(prescale)
    );

    // Clock generation
    always #5 clk = ~clk;  // 100 MHz clock (5 ns period)

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        s_axis_tvalid = 0;
        prescale = PRESCALE;
        
        // Reset the module
        rst = 1;
        #10 rst = 0;
        s_axis_tdata = 8'h69; // New test data (01101001 in binary)
        $display("Test Data = %b at %t:", s_axis_tdata, $time);
        $display("Cycle = always #5 clk = ~clk; so it is 10ns one cycle right!");
        $display("prescale = %d", prescale);
        s_axis_tvalid = 1;  // Valid data available
        #10 s_axis_tvalid = 0;
        
        @(posedge s_axis_tready) begin
            $display("Test Passed: UART is ready at %t:", $time);
        end
        #50;
        //$stop;
        $finish;
    end

endmodule
