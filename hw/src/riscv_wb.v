`timescale 1ps / 1ps

module riscv_wb(
  input  wire        clk_i,
  input  wire        rst_i,

  // Processor (RISC-V core) side
  input  wire        dmem_we_i,
  input  wire        dmem_en_i,
  input  wire [31:0] dmem_addr_i,
  input  wire [31:0] dmem_data_i,
  output reg  [31:0] dmem_data_o,
  input  wire [2:0]  dmem_width_se_i,

  // Wishbone master side
  output reg         stb_o,
  output reg         cyc_o,
  output reg         we_o,
  output reg         en_o,
  output reg  [31:0] adr_o,
  output reg  [31:0] dat_o,
  output reg  [2:0]  width_se_o,
  input  wire [31:0] dat_i,
  input  wire        ack_i,
  input  wire        err_i
);

  // ------------------------------------------------------------
  // 3-state FSM
  // ------------------------------------------------------------
  localparam ST_IDLE = 2'b00;
  localparam ST_REQ  = 2'b01;  // issue request (first cycle)
  localparam ST_WAIT = 2'b10;  // wait for ACK/ERR

  reg [1:0] state;

  always @(posedge clk_i) begin
    if (rst_i) begin
      state        <= ST_IDLE;
      stb_o        <= 1'b0;
      cyc_o        <= 1'b0;
      we_o         <= 1'b0;
      en_o         <= 1'b0;
      adr_o        <= 32'b0;
      dat_o        <= 32'b0;
      width_se_o   <= 3'b0;
      dmem_data_o  <= 32'b0;

    end else begin
      case (state)

        // ======================================================
        // IDLE: waiting for CPU memory request
        // ======================================================
        ST_IDLE: begin
          stb_o <= 1'b0;
          cyc_o <= 1'b0;
          en_o  <= 1'b0;

          if (dmem_en_i) begin
            // Latch request from CPU
            we_o       <= dmem_we_i;
            en_o       <= 1'b1;            // local enable
            adr_o      <= dmem_addr_i;
            dat_o      <= dmem_data_i;
            width_se_o <= dmem_width_se_i;

            // Start bus cycle and request
            cyc_o      <= 1'b1;
            stb_o      <= 1'b1;

            state      <= ST_REQ;
          end
        end

        // ======================================================
        // REQ: address/data already on bus, first active cycle
        //      Move immediately to WAIT (classic single transfer)
        // ======================================================
        ST_REQ: begin
          // Keep CYC/STB asserted, signals stable
          cyc_o <= 1'b1;
          stb_o <= 1'b1;
          // Nothing else to change; go to WAIT for ACK/ERR
          state <= ST_WAIT;
        end

        // ======================================================
        // WAIT: wait for ACK or ERR from slave
        // ======================================================
        ST_WAIT: begin
          // Keep CYC/STB asserted while waiting
          cyc_o <= 1'b1;
          stb_o <= 1'b1;

          if (ack_i) begin
            // Successful completion
            cyc_o <= 1'b0;
            stb_o <= 1'b0;
            en_o  <= 1'b0;
            state <= ST_IDLE;

            // For read, capture returned data
            if (!we_o)
              dmem_data_o <= dat_i;

          end else if (err_i) begin
            // Error: abort cycle and return to IDLE
            cyc_o <= 1'b0;
            stb_o <= 1'b0;
            en_o  <= 1'b0;
            state <= ST_IDLE;
            // (optional: add error reporting to CPU here)
          end
        end

        default: begin
          state <= ST_IDLE;
          cyc_o <= 1'b0;
          stb_o <= 1'b0;
          en_o  <= 1'b0;
        end

      endcase
    end
  end

endmodule
