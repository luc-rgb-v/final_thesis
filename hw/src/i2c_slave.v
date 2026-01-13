`timescale 1ns / 1ps
module i2c_slave #(
  parameter [6:0] SLAVE_ADDR = 7'h57
)(
  inout  wire       sda,
  input  wire       scl,
  input  wire       rst,               // async active-high reset
  input  wire [7:0] data_write_slave,
  output reg  [7:0] data_read_slave,
  output reg        rx_valid,
  output reg        addressed
);

  localparam [2:0]
    ST_IDLE     = 3'd0,
    ST_ADDR     = 3'd1,
    ST_ADDR_ACK = 3'd2,
    ST_RX       = 3'd3,
    ST_RX_ACK   = 3'd4,
    ST_TX       = 3'd5,
    ST_TX_ACK   = 3'd6;

  reg [2:0] state;

  reg       drive_low;   // open-drain: 1 -> pull low, 0 -> Z
  assign sda = drive_low ? 1'b0 : 1'bz;
  wire  sda_in = sda;

  reg [7:0] sh;
  reg [2:0] bit_cnt;     // counts 0..7
  reg       rw_latched;
  reg [7:0] next_sh;

  // START detection: SDA falling while SCL high
  always @(negedge sda or posedge rst) begin
    if (rst) begin
      state      <= ST_IDLE;
      addressed  <= 1'b0;
      drive_low  <= 1'b0;
      sh         <= 8'h00;
      bit_cnt    <= 3'd0;
      rw_latched <= 1'b0;
      rx_valid   <= 1'b0;
      data_read_slave <= 8'h00;
    end else if (scl == 1'b1) begin
      state      <= ST_ADDR;
      addressed  <= 1'b0;
      drive_low  <= 1'b0;
      sh         <= 8'h00;
      bit_cnt    <= 3'd0;
      rx_valid   <= 1'b0;
    end
  end

  // STOP detection: SDA rising while SCL high
  always @(posedge sda or posedge rst) begin
    if (rst) begin
      state     <= ST_IDLE;
      addressed <= 1'b0;
      drive_low <= 1'b0;
      rx_valid  <= 1'b0;
    end else if (scl == 1'b1) begin
      state     <= ST_IDLE;
      addressed <= 1'b0;
      drive_low <= 1'b0;
      rx_valid  <= 1'b0;
    end
  end

  // Sample on SCL rising edge
  always @(posedge scl or posedge rst) begin
    if (rst) begin
      state      <= ST_IDLE;
      addressed  <= 1'b0;
      sh         <= 8'h00;
      bit_cnt    <= 3'd0;
      rw_latched <= 1'b0;
      rx_valid   <= 1'b0;
      data_read_slave <= 8'h00;
    end else begin
      rx_valid <= 1'b0;

      case (state)
        ST_IDLE: begin
          // wait for START
        end

        ST_ADDR: begin
          // shift in bit (MSB first overall)
          // build "next" byte for comparison WITHOUT illegal concat indexing
          next_sh = {sh[6:0], sda_in};
          sh <= next_sh;

          if (bit_cnt == 3'd7) begin
            if (next_sh[7:1] == SLAVE_ADDR) begin
              addressed  <= 1'b1;
              rw_latched <= next_sh[0];
              state      <= ST_ADDR_ACK;
            end else begin
              addressed  <= 1'b0;
              state      <= ST_IDLE;
            end
            bit_cnt <= 3'd0;
            sh      <= 8'h00;
          end else begin
            bit_cnt <= bit_cnt + 1'b1;
          end
        end

        ST_ADDR_ACK: begin
          // After ACK phase, branch to RX or TX
          bit_cnt <= 3'd0;
          if (rw_latched == 1'b0) begin
            sh    <= 8'h00;
            state <= ST_RX;
          end else begin
            sh    <= data_write_slave;
            state <= ST_TX;
          end
        end

        ST_RX: begin
          next_sh = {sh[6:0], sda_in};
          sh <= next_sh;

          if (bit_cnt == 3'd7) begin
            data_read_slave <= next_sh;
            rx_valid        <= 1'b1;
            bit_cnt         <= 3'd0;
            sh              <= 8'h00;
            state           <= ST_RX_ACK;
          end else begin
            bit_cnt <= bit_cnt + 1'b1;
          end
        end

        ST_RX_ACK: begin
          // continue receiving more bytes
          bit_cnt <= 3'd0;
          sh      <= 8'h00;
          state   <= ST_RX;
        end

        ST_TX_ACK: begin
          // master drives ACK/NACK here
          if (sda_in == 1'b0) begin
            sh      <= data_write_slave;
            bit_cnt <= 3'd0;
            state   <= ST_TX;
          end else begin
            state     <= ST_IDLE;
            addressed <= 1'b0;
          end
        end

        default: begin
          // ST_TX: nothing on posedge (bits driven on negedge)
        end
      endcase
    end
  end

  // Drive on SCL falling edge
  always @(negedge scl or posedge rst) begin
    if (rst) begin
      drive_low <= 1'b0;
      bit_cnt   <= 3'd0;
      sh        <= 8'h00;
      state     <= ST_IDLE;
    end else begin
      case (state)
        ST_IDLE:     drive_low <= 1'b0;
        ST_ADDR:     drive_low <= 1'b0; // master drives address bits
        ST_ADDR_ACK: drive_low <= 1'b1; // ACK address
        ST_RX:       drive_low <= 1'b0; // master drives data
        ST_RX_ACK:   drive_low <= 1'b1; // ACK data

        ST_TX: begin
          // drive MSB (sh[7]) on this low phase
          drive_low <= (sh[7] == 1'b0);

          // shift for next bit
          sh <= {sh[6:0], 1'b0};

          if (bit_cnt == 3'd7) begin
            bit_cnt  <= 3'd0;
            state    <= ST_TX_ACK;
          end else begin
            bit_cnt <= bit_cnt + 1'b1;
          end
        end

        ST_TX_ACK: begin
          // release for master ACK/NACK
          drive_low <= 1'b0;
        end

        default: drive_low <= 1'b0;
      endcase
    end
  end

endmodule
