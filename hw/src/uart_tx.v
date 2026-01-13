`timescale 1ns / 1ps
`include "defines.vh"

// UART TX (1 start, 8 data, 1 stop) with prescale input.
// Fixes Verilator WIDTHEXPAND by using sized math and explicit width extension.
module uart_tx(
    input  wire clk,
    input  wire rst,

    // Input handshake
    input  wire [`UART_DATA_WIDTH-1:0] data_8bit,
    input  wire                        data_valid,
    output wire                        data_ready,

    // UART interface
    output wire                        txd,

    // Status
    output wire                        busy,

    // Configuration: PRESCALE = CLK_FREQ / BAUD
    input  wire [15:0] prescale
);

  reg         tready_reg;
  reg         txd_reg;
  reg         busy_reg;

  // shift register contains: {stop_bit(1), data[7:0]} (LSB first is data[0])
  reg [`UART_DATA_WIDTH:0] shreg;

  // counts remaining bits in shreg to send (data + stop) after start bit
  reg [7:0]   bit_cnt;

  // prescaler counter (extended to avoid width warnings)
  reg [18:0]  prescale_reg;

  assign data_ready = tready_reg;
  assign txd        = txd_reg;
  assign busy       = busy_reg;

  // Extend prescale to match prescale_reg width and avoid WIDTHEXPAND
  wire [18:0] prescale_ext = (prescale == 16'd0) ? 19'd1 : {3'b000, prescale};

  always @(posedge clk) begin
    if (rst) begin
      tready_reg   <= 1'b1;
      txd_reg      <= 1'b1;      // idle high
      busy_reg     <= 1'b0;
      shreg        <= {(`UART_DATA_WIDTH+1){1'b0}};
      bit_cnt      <= 8'd0;
      prescale_reg <= 19'd0;
    end else begin
      if (!busy_reg) begin
        // IDLE
        tready_reg <= 1'b1;
        txd_reg    <= 1'b1;

        if (data_valid) begin
          // accept byte and start transmission
          tready_reg   <= 1'b0;
          busy_reg     <= 1'b1;

          // drive START bit immediately, then wait 1 baud before first data bit
          txd_reg      <= 1'b0;

          // payload = data bits + stop bit (stop is MSB)
          shreg        <= {1'b1, data_8bit};
          bit_cnt      <= (`UART_DATA_WIDTH + 1);   // 8 data + 1 stop (typically 9)

          // load prescaler for the start-bit duration
          prescale_reg <= prescale_ext - 19'd1;
        end
      end else begin
        // BUSY: hold current txd until prescale expires
        if (prescale_reg != 19'd0) begin
          prescale_reg <= prescale_reg - 19'd1;
        end else begin
          // baud tick: output next payload bit (LSB first), shift in '1' to keep line high after stop
          txd_reg      <= shreg[0];
          shreg        <= {1'b1, shreg[`UART_DATA_WIDTH:1]};
          prescale_reg <= prescale_ext - 19'd1;

          if (bit_cnt == 8'd1) begin
            // just sent last bit (stop bit)
            bit_cnt    <= 8'd0;
            busy_reg   <= 1'b0;
            tready_reg <= 1'b1;
            // txd_reg already set to stop bit (=1)
          end else begin
            bit_cnt <= bit_cnt - 8'd1;
          end
        end
      end
    end
  end

endmodule
