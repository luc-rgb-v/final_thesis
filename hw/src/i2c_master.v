`timescale 1ns / 1ps
// ------------------------------------------------------------
// I2C single-byte master (7-bit addr) : write 1 byte or read 1 byte
// - Open-drain SDA (drive low or Z), SCL generated internally
// - Data changes while SCL low (low_pulse), sampling while SCL high (high_pulse)
// ------------------------------------------------------------
module i2c_master #(
  parameter integer CLK_DIV = 4  // must be even for MID = CLK_DIV/2 default is 4 for simulation and 500 if want 100khz at #5 clk = ~clk
)(
  input  wire       clk,
  input  wire       rst,       // active-high synchronous reset
  input  wire [6:0] addr,
  input  wire [7:0] data_write_master,
  input  wire       start,     // can be pulse or level; must drop low to arm next transaction
  input  wire       rw,        // 1 = read, 0 = write

  output reg  [7:0] data_read_master,
  output wire       ready,

  inout  wire       i2c_sda,
  output wire       i2c_scl,
  output wire [3:0] state_o,
  output wire ack_ok
);

  // ----------------------------
  // Clock divider / SCL generator
  // ----------------------------
  localparam CNT_W = (CLK_DIV <= 1) ? 1 : $clog2(CLK_DIV);
  localparam integer MID = (CLK_DIV/2);

  reg [CNT_W-1:0] cnt;
  reg             scl_r;
  reg             scl_gen_en;

  // Force SCL high when generator disabled
  assign i2c_scl = scl_gen_en ? scl_r : 1'b1;

  // Generate mid-low / mid-high pulses ONLY when scl_gen_en=1
  wire scl_low   = (scl_r == 1'b0);
  wire low_pulse = scl_gen_en && scl_low        && (cnt == MID[CNT_W-1:0]);
  wire high_pulse= scl_gen_en && (!scl_low)     && (cnt == MID[CNT_W-1:0]);

  reg prev_low_pulse, prev_high_pulse;
  wire low_tick  = low_pulse  && !prev_low_pulse;
  wire high_tick = high_pulse && !prev_high_pulse;

  always @(posedge clk) begin
    if (rst) begin
      cnt   <= {CNT_W{1'b0}};
      scl_r <= 1'b1;
    end else if (!scl_gen_en) begin
      cnt   <= {CNT_W{1'b0}};
      scl_r <= 1'b1;
    end else begin
      if (cnt == (CLK_DIV-1)) begin
        cnt   <= {CNT_W{1'b0}};
        scl_r <= ~scl_r;
      end else begin
        cnt <= cnt + 1'b1;
      end
    end
  end

  // ----------------------------
  // SDA open-drain
  // ----------------------------
  reg sda_drive_low;
  assign i2c_sda = sda_drive_low ? 1'b0 : 1'bz;
  wire  sda_in   = i2c_sda;

  // ----------------------------
  // FSM
  // ----------------------------
  localparam [3:0]
    ST_IDLE           = 4'd0,
    ST_START          = 4'd1,

    ST_SEND_ADDR      = 4'd2,
    ST_ADDR_ACK_PREP  = 4'd3,
    ST_ADDR_ACK_SAMP  = 4'd4,

    ST_SEND_DATA      = 4'd5,
    ST_DATA_ACK_PREP  = 4'd6,
    ST_DATA_ACK_SAMP  = 4'd7,

    ST_RECV_DATA      = 4'd8,
    ST_MASTER_NACK_PREP = 4'd9,
    ST_MASTER_NACK_SAMP = 4'd10,

    ST_STOP_PREP      = 4'd11,
    ST_STOP_RELEASE   = 4'd12,
    ST_DONE           = 4'd13;

  reg [3:0] state;
  assign state_o = state;

  reg [7:0] tx_shift;
  reg [7:0] rx_shift;
  reg [2:0] bit_pos;        // 7..0
  reg       ack_ok_r;
  assign ack_ok = ack_ok_r;

  // Start arming: accept start once, require start to return 0 to arm again
  reg start_armed;

  assign ready = (!rst) && (state == ST_IDLE);

  always @(posedge clk) begin
    if (rst) begin
      state          <= ST_IDLE;
      scl_gen_en     <= 1'b0;
      sda_drive_low  <= 1'b0;
      tx_shift       <= 8'h00;
      rx_shift       <= 8'h00;
      data_read_master <= 8'h00;
      bit_pos        <= 3'd7;
      ack_ok_r         <= 1'b0;
      prev_low_pulse <= 1'b0;
      prev_high_pulse<= 1'b0;
      start_armed    <= 1'b1;
    end else begin
      // pulse edge history
      prev_low_pulse  <= low_pulse;
      prev_high_pulse <= high_pulse;

      // arm logic
      if (!start) start_armed <= 1'b1;

      // defaults in states (safe)
      case (state)
        ST_IDLE: begin
          scl_gen_en    <= 1'b0;   // hold SCL high
          sda_drive_low <= 1'b0;   // release SDA
          rx_shift      <= rx_shift;
          tx_shift      <= tx_shift;

          if (start_armed && start) begin
            start_armed   <= 1'b0;

            // START: SDA low while SCL high (SCL is forced high here)
            sda_drive_low <= 1'b1;

            // prepare address+rw
            tx_shift   <= {addr, rw};
            bit_pos    <= 3'd7;

            // start clocking
            scl_gen_en <= 1'b1;
            state      <= ST_START;
          end
        end

        // Wait for first low_tick so we can put bit[7] while SCL low
        ST_START: begin
          if (low_tick) begin
            // drive first bit (bit7)
            sda_drive_low <= (tx_shift[7] == 1'b0);
            state         <= ST_SEND_ADDR;
          end
        end

        // Send address bits 7..0 (bit_pos updated on high_tick)
        ST_SEND_ADDR: begin
          // on low phase center: drive current bit_pos
          if (low_tick) begin
            sda_drive_low <= (tx_shift[bit_pos] == 1'b0);
          end

          // on high phase center: one bit has been clocked -> update bit_pos / move to ACK
          if (high_tick) begin
            if (bit_pos == 3'd0) begin
              state <= ST_ADDR_ACK_PREP;
            end else begin
              bit_pos <= bit_pos - 1'b1;
            end
          end
        end

        // Release SDA during ACK bit low phase (9th clock)
        ST_ADDR_ACK_PREP: begin
          if (low_tick) begin
            sda_drive_low <= 1'b0; // release so slave can ACK
            state         <= ST_ADDR_ACK_SAMP;
          end
        end

        // Sample ACK on ACK bit high phase
        ST_ADDR_ACK_SAMP: begin
          if (high_tick) begin
            ack_ok_r <= (sda_in == 1'b0);

            if (sda_in == 1'b0) begin
              if (rw == 1'b0) begin
                // write: send data byte
                tx_shift <= data_write_master;
                bit_pos  <= 3'd7;
                state    <= ST_SEND_DATA;
              end else begin
                // read: receive data byte
                rx_shift <= 8'h00;
                bit_pos  <= 3'd7;
                sda_drive_low <= 1'b0; // release SDA for slave driving
                state    <= ST_RECV_DATA;
              end
            end else begin
              // NACK -> STOP
              state <= ST_STOP_PREP;
            end
          end
        end

        // Send data bits 7..0 (FIXED: includes bit[7])
        ST_SEND_DATA: begin
          if (low_tick) begin
            sda_drive_low <= (tx_shift[bit_pos] == 1'b0);
          end
          if (high_tick) begin
            if (bit_pos == 3'd0) begin
              state <= ST_DATA_ACK_PREP;
            end else begin
              bit_pos <= bit_pos - 1'b1;
            end
          end
        end

        // Release SDA during data ACK bit low phase
        ST_DATA_ACK_PREP: begin
          if (low_tick) begin
            sda_drive_low <= 1'b0; // release for ACK
            state         <= ST_DATA_ACK_SAMP;
          end
        end

        // Sample data ACK on high phase, then STOP regardless
        ST_DATA_ACK_SAMP: begin
          if (high_tick) begin
            ack_ok_r <= (sda_in == 1'b0);
            state  <= ST_STOP_PREP;
          end
        end

        // Receive data bits 7..0 from slave, sample on high_tick
        ST_RECV_DATA: begin
          // always release SDA so slave can drive
          sda_drive_low <= 1'b0;

          if (high_tick) begin
            rx_shift[bit_pos] <= sda_in;
            if (bit_pos == 3'd0) begin
              data_read_master <= {rx_shift[7:1], sda_in};
              state    <= ST_MASTER_NACK_PREP;
            end else begin
              bit_pos <= bit_pos - 1'b1;
            end
          end
        end

        // 9th clock for read: master NACK = SDA released (high). Prep during low phase.
        ST_MASTER_NACK_PREP: begin
          if (low_tick) begin
            sda_drive_low <= 1'b0; // release = NACK
            state         <= ST_MASTER_NACK_SAMP;
          end
        end

        // Consume the 9th clock high phase then go STOP
        ST_MASTER_NACK_SAMP: begin
          if (high_tick) begin
            state <= ST_STOP_PREP;
          end
        end

        // STOP prep: while SCL low, pull SDA low so we can create a rising edge later
        ST_STOP_PREP: begin
          if (low_tick) begin
            sda_drive_low <= 1'b1; // SDA low while SCL low
            state         <= ST_STOP_RELEASE;
          end
        end

        // STOP: while SCL high, release SDA (rising edge SDA while SCL high)
        ST_STOP_RELEASE: begin
          if (high_tick) begin
            sda_drive_low <= 1'b0; // release -> STOP condition
            scl_gen_en    <= 1'b0; // force SCL high immediately after
            state         <= ST_DONE;
          end
        end

        ST_DONE: begin
          // one clean cycle done, then idle
          sda_drive_low <= 1'b0;
          scl_gen_en    <= 1'b0;
          state         <= ST_IDLE;
        end

        default: begin
          state <= ST_IDLE;
        end
      endcase
    end
  end

endmodule
