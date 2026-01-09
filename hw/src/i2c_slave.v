`timescale 1ns / 1ps

/*
---------------------------- Description -----------------------------------------------------------------------
I2C Slave Module

I2C Protocol Overview

Read Operation
        __    ___ ___ ___ ___ ___ ___ ___ __      ___ ___ ___ ___ ___ ___ ___ ___       _____
sda     \__/_6_X_5_X_4_X_3_X_2_X_1_X_0_\ R  A_/_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_\_A____/
        ____   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _    _   _   _  
scl    ST \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \__/ \_/ \_/ SP

Write Operation
        __    ___ ___ ___ ___ ___ ___ ___            ___ ___ ___ ___ ___ ___ ___  __       ___ 
sda     \__/_6_X_5_X_4_X_3_X_2_X_1_X_0_/_ W__ \_A_/_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_\_A___/
        ____   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _    _    
scl    ST \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \__/ SP

- SLAVE Module Description:
  The MASTER module sends an address to the SLAVE module.
  When the SLAVE receives this address, it checks whether the address matches its own.
  If the address matches (ADDRESS_SLAVE == address sent by the MASTER),
  the SLAVE sends an ACK by pulling the SDA line low.
  Otherwise, the MASTER aborts the transmission.

  After the SLAVE sends the ACK, the MASTER begins data transmission.
  Once the MASTER finishes sending the data, the SLAVE must send another ACK
  to confirm successful data reception, and then the MASTER ends the transmission.

---------------------------- INPUT / OUTPUT --------------------------------------------------------------------
- sda              : SDA line
- scl              : SCL line
- data_write_slave : Data sent from the SLAVE to the MASTER
- data_read_slave  : Data received by the SLAVE from the MASTER
---------------------------------------------------------------------------------------------------------------
*/

module i2c_slave (
    inout  wire       sda,               // I2C data line
    input  wire       scl,               // I2C clock line
    input  wire [7:0] data_write_slave,  // Data to be transmitted to MASTER
    output wire  [7:0] data_read_slave    // Data received from MASTER
);

    // SLAVE address (7-bit)
    localparam ADDRESS_SLAVE = 7'b00000001; // 0x57 max30102 address

    // FSM states
    localparam STATE_READ_ADDR  = 0;  // Read slave address + R/W bit
    localparam STATE_SEND_ACK   = 1;  // Send ACK after address match
    localparam STATE_READ_DATA  = 2;  // Read data from MASTER
    localparam STATE_WRITE_DATA = 3;  // Write data to MASTER
    localparam STATE_SEND_ACK2  = 4;  // Send ACK after data reception

    reg [7:0] addr;          // Address register
    reg [7:0] counter;       // Bit counter
    reg [7:0] state = 0;     // FSM state
    reg       sda_out = 0;   // SDA output value
    reg       sda_in  = 0;   // SDA input (unused but kept for completeness)
    reg       start   = 0;   // Start condition detected
    reg       write_enable = 0; // SDA output enable
    reg  [7:0] data_read_slave_r = 0;
    assign data_read_slave = data_read_slave_r;
    // Tri-state control of SDA line
    assign sda = (write_enable == 1) ? sda_out : 1'bz;

    // Detect START condition (SDA falling while SCL is high)
    always @(negedge sda) begin
        if ((start == 0) && (scl == 1)) begin
            start   <= 1;
            counter <= 7;
        end
    end

    // Detect STOP condition (SDA rising while SCL is high)
    always @(posedge sda) begin
        if ((start == 1) && (scl == 1)) begin
            state        <= STATE_READ_ADDR;
            start        <= 0;
            write_enable <= 0;
        end
    end

    // FSM operation on rising edge of SCL
    always @(posedge scl) begin
        if (start == 1) begin
            case (state)

                // Read address and R/W bit from MASTER
                STATE_READ_ADDR: begin
                    addr[counter] <= sda;
                    if (counter == 0)
                        state <= STATE_SEND_ACK;
                    else
                        counter <= counter - 1;
                end

                // Check address and decide read or write operation
                STATE_SEND_ACK: begin
                    if (addr[7:1] == ADDRESS_SLAVE) begin
                        counter <= 7;
                        if (addr[0] == 0)
                            state <= STATE_READ_DATA;   // Write from MASTER
                        else
                            state <= STATE_WRITE_DATA;  // Read by MASTER
                    end
                end

                // Read data sent by MASTER
                STATE_READ_DATA: begin
                    data_read_slave_r[counter] <= sda;
                    if (counter == 0)
                        state <= STATE_SEND_ACK2;
                    else
                        counter <= counter - 1;
                end

                // Send ACK after receiving data
                STATE_SEND_ACK2: begin
                    state <= STATE_READ_ADDR;
                end

                // Write data to MASTER
                STATE_WRITE_DATA: begin
                    if (counter == 0)
                        state <= STATE_READ_ADDR;
                    else
                        counter <= counter - 1;
                end

            endcase
        end
    end

    // SDA control on falling edge of SCL
    always @(negedge scl) begin
        case (state)

            // Release SDA for address reception
            STATE_READ_ADDR: begin
                write_enable <= 0;
            end

            // Send ACK after address match
            STATE_SEND_ACK: begin
                sda_out      <= 0;
                write_enable <= 1;
            end

            // Release SDA for data reception
            STATE_READ_DATA: begin
                write_enable <= 0;
            end

            // Drive SDA with data to MASTER
            STATE_WRITE_DATA: begin
                sda_out      <= data_write_slave[counter];
                write_enable <= 1;
            end

            // Send ACK after data reception
            STATE_SEND_ACK2: begin
                sda_out      <= 0;
                write_enable <= 1;
            end

        endcase
    end

endmodule
