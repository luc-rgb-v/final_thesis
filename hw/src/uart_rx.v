`timescale 1ns / 1ps
`include "defines.vh"

module uart_rx(
    input  wire clk,
    input  wire rst,

    // UART interface
    input  wire rxd,

    // Output
    output reg  [`UART_DATA_WIDTH-1:0] data_8bit,
    output reg  data_valid,

    // Status
    output wire busy,

    // Configuration
    input  wire [15:0] prescale // PRESCALE = CLK_FREQ / BAUD
);

    // FSM states
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0]  state = IDLE;
    reg [15:0] prescale_reg = 0;
    reg [3:0]  bit_cnt = 0;
    reg        busy_reg = 0;
    reg [`UART_DATA_WIDTH-1:0] data_reg = 0;

    assign busy = busy_reg;

    always @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            prescale_reg <= 0;
            bit_cnt      <= 0;
            data_reg     <= 0;
            data_8bit    <= 0;
            data_valid   <= 0;
            busy_reg     <= 0;
        end else begin
            data_valid <= 0; // default

            case (state)

                // -------------------------------------------------
                // IDLE: wait for start bit (RXD goes low)
                // -------------------------------------------------
                IDLE: begin
                    busy_reg <= 0;
                    if (rxd == 0) begin
                        state        <= START;
                        prescale_reg <= prescale >> 1; // sample mid start-bit
                        busy_reg     <= 1;
                    end
                end

                // -------------------------------------------------
                // START: validate start bit
                // -------------------------------------------------
                START: begin
                    if (prescale_reg > 0) begin
                        prescale_reg <= prescale_reg - 1;
                    end else begin
                        if (rxd == 0) begin
                            state        <= DATA;
                            prescale_reg <= prescale - 1;
                            bit_cnt      <= 0;
                        end else begin
                            state <= IDLE; // false start
                        end
                    end
                end

                // -------------------------------------------------
                // DATA: receive 8 bits (LSB first)
                // -------------------------------------------------
                DATA: begin
                    if (prescale_reg > 0) begin
                        prescale_reg <= prescale_reg - 1;
                    end else begin
                        data_reg[bit_cnt] <= rxd;
                        prescale_reg <= prescale - 1;

                        if (bit_cnt == `UART_DATA_WIDTH-1) begin
                            state <= STOP;
                        end else begin
                            bit_cnt <= bit_cnt + 1;
                        end
                    end
                end

                // -------------------------------------------------
                // STOP: expect stop bit (high)
                // -------------------------------------------------
                STOP: begin
                    if (prescale_reg > 0) begin
                        prescale_reg <= prescale_reg - 1;
                    end else begin
                        if (rxd == 1) begin
                            data_8bit  <= data_reg;
                            data_valid <= 1;
                        end
                        state    <= IDLE;
                        busy_reg <= 0;
                    end
                end

            endcase
        end
    end

endmodule
