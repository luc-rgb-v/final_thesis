`timescale 1ns / 1ps
`include "defines.vh"
//UART_DATA_WIDTH = 8
module uart_tx(
    input  wire clk,
    input  wire rst,

    // Input
    input  wire [`UART_DATA_WIDTH-1:0] data_8bit,
    input  wire data_valid,
    output wire data_ready,

    // UART interface
    output wire txd,

    // Status
    output wire busy,

    // Configuration
    input  wire [15:0] prescale //PRESCALE = CLK_FREQ / BAUD;
);

reg tready_reg = 0;
reg txd_reg = 1; // Start state for UART (idle is high)
reg busy_reg = 0;
reg [`UART_DATA_WIDTH:0] data_reg = 0;
reg [18:0] prescale_reg = 0;
reg [3:0] bit_cnt = 0;
//reg sub_ready;

assign data_ready = tready_reg;
assign txd = txd_reg;
assign busy = busy_reg;

//always @(posedge clk) begin
//    if (rst) sub_ready <= 0;
//    else sub_ready <= tready_reg;
//end

always @(posedge clk) begin
    if (rst) begin
        tready_reg <= 0;
        txd_reg <= 1;  // UART idle state
        prescale_reg <= 0;
        bit_cnt <= 0;
        busy_reg <= 0;
    end else begin
        if (prescale_reg > 0) begin
            // Decrement prescaler if not done yet
            prescale_reg <= prescale_reg - 1;
        end else begin
            if (bit_cnt == 0) begin
                // When no transmission is in progress, ready to accept new data
                tready_reg <= 1;
                busy_reg <= 0;

                if (data_valid) begin
                    // If valid data is present, start transmission
                    tready_reg <= 0;  // No longer ready for new data
                    prescale_reg <= prescale - 1;  // Set prescaler based on the input
                    bit_cnt <= `UART_DATA_WIDTH + 1;  // Start transmitting data + stop bit
                    data_reg <= {1'b1, data_8bit};  // Add stop bit (1) to data
                    txd_reg <= 0;  // Start bit (low)
                    busy_reg <= 1;  // UART is busy
                end
            end else begin
                // Shift out the bits from the data register
                if (bit_cnt > 1) begin
                    bit_cnt <= bit_cnt - 1;
                    prescale_reg <= prescale - 1;  // Reset prescaler for each bit
                    {data_reg, txd_reg} <= {1'b0, data_reg};  // Shift out the next bit (LSB first)
                end else if (bit_cnt == 1) begin
                    // After the last data bit, send the stop bit (1)
                    bit_cnt <= bit_cnt - 1;
                    prescale_reg <= prescale - 1;
                    txd_reg <= 1;  // Stop bit (high)
                end
            end
        end
    end
end

endmodule
