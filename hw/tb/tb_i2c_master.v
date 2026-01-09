`timescale 1ns / 1ps

module tb_i2c_pure_verilog;

    // =====================================================
    // Clock / Reset
    // =====================================================
    reg clk;
    reg rst;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // =====================================================
    // I2C open-drain bus (with pull-ups)
    // =====================================================
    tri1 i2c_sda;
    tri1 i2c_scl;

    // =====================================================
    // Master interface
    // =====================================================
    reg  [6:0] addr;
    reg  [7:0] data_write_master;
    wire [7:0] data_read_master;
    reg        enable;
    reg        rw;
    wire       ready;

    // =====================================================
    // Slave interface
    // =====================================================
    reg  [7:0] data_write_slave;
    wire [7:0] data_read_slave;

    // =====================================================
    // DUT instantiation
    // =====================================================
    i2c_master u_master (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .data_write_master(data_write_master),
        .enable(enable),
        .rw(rw),
        .data_read_master(data_read_master),
        .ready(ready),
        .i2c_sda(i2c_sda),
        .i2c_scl(i2c_scl)
    );

    i2c_slave u_slave (
        .sda(i2c_sda),
        .scl(i2c_scl),
        .data_write_slave(data_write_slave),
        .data_read_slave(data_read_slave)
    );

    // =====================================================
    // Helpers (pure Verilog tasks)
    // =====================================================
    task wait_ready;
        begin
            @(posedge ready);
            @(negedge clk);
        end
    endtask

    task do_write;
        input [7:0] data;
        begin
            data_write_master = data;
            rw     = 1'b0;
            enable = 1'b1;
            wait_ready;
            enable = 1'b0;

            if (data_read_slave !== data)
                $fatal;
        end
    endtask

    task do_read;
        input [7:0] data;
        begin
            data_write_slave = data;
            rw     = 1'b1;
            enable = 1'b1;
            wait_ready;
            enable = 1'b0;

            if (data_read_master !== data)
                $fatal;
        end
    endtask

    // =====================================================
    // Test sequence
    // =====================================================
    initial begin
        // Defaults
        rst = 1'b1;
        enable = 1'b0;
        rw = 1'b0;
        addr = 7'b00000001;
        data_write_master = 8'h00;
        data_write_slave  = 8'h00;

        // -------------------------
        // Reset test
        // -------------------------
        #50;
        rst = 1'b0;
        #50;
        
        do_write(8'h1);
        //do_write(8'hA5);
        #100;

        do_read(8'h5A);

        // -------------------------
        // End
        // -------------------------
        #100;
        $finish;
    end

endmodule
