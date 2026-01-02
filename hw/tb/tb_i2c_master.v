`timescale 1ns / 1ps

module tb_i2c_master;

// Signals
reg clk;
reg rst;
reg [6:0] s_axis_cmd_address;
reg s_axis_cmd_start;
reg s_axis_cmd_write;
reg s_axis_cmd_read;
reg s_axis_cmd_stop;
reg s_axis_cmd_valid;
wire s_axis_cmd_ready;

reg [7:0] s_axis_data_tdata;
reg s_axis_data_tvalid;
wire s_axis_data_tready;
reg s_axis_data_tlast;

wire [7:0] m_axis_data_tdata;
wire m_axis_data_tvalid;
reg m_axis_data_tready = 1;
wire m_axis_data_tlast;

reg scl_i = 1;
wire scl_o;
wire scl_t;
reg sda_i = 1;
wire sda_o;
wire sda_t;

wire busy;
wire bus_control;
wire bus_active;
wire missed_ack;

// Instantiate I2C Master
i2c_master uut (
    .clk(clk),
    .rst(rst),
    .s_axis_cmd_address(s_axis_cmd_address),
    .s_axis_cmd_start(s_axis_cmd_start),
    .s_axis_cmd_read(s_axis_cmd_read),
    .s_axis_cmd_write(s_axis_cmd_write),
    .s_axis_cmd_stop(s_axis_cmd_stop),
    .s_axis_cmd_valid(s_axis_cmd_valid),
    .s_axis_cmd_ready(s_axis_cmd_ready),
    .s_axis_data_tdata(s_axis_data_tdata),
    .s_axis_data_tvalid(s_axis_data_tvalid),
    .s_axis_data_tready(s_axis_data_tready),
    .s_axis_data_tlast(s_axis_data_tlast),
    .m_axis_data_tdata(m_axis_data_tdata),
    .m_axis_data_tvalid(m_axis_data_tvalid),
    .m_axis_data_tready(m_axis_data_tready),
    .m_axis_data_tlast(m_axis_data_tlast),
    .scl_i(scl_i),
    .scl_o(scl_o),
    .scl_t(scl_t),
    .sda_i(sda_i),
    .sda_o(sda_o),
    .sda_t(sda_t),
    .busy(busy),
    .bus_control(bus_control),
    .bus_active(bus_active),
    .missed_ack(missed_ack)
);

// Clock Generation
always begin
    clk = 0;
    #5 clk = 1;
    #5;
end

// Stimulus Process
initial begin
    // Reset and initial conditions
    rst = 1;
    s_axis_cmd_valid = 0;
    s_axis_data_tvalid = 0;
    s_axis_data_tlast = 0;
    s_axis_cmd_start = 0;
    s_axis_cmd_write = 0;
    s_axis_cmd_stop = 0;
    s_axis_cmd_address = 7'b0000111;  // Slave address (example)
    s_axis_data_tdata = 8'b00110010;   // Data to send
    s_axis_cmd_read = 0;

    // Apply reset
    #20;
    rst = 0;

    // Test Write Operation to Slave (Address 0x42)
    s_axis_cmd_start = 1;
    s_axis_cmd_write = 1;
    s_axis_cmd_valid = 1;
    s_axis_data_tvalid = 1;
    s_axis_data_tlast = 1;
    #100; // Wait for transmission

    // Check for ACK
    if (m_axis_data_tvalid && m_axis_data_tdata == 8'hA5) begin
        $display("Write Test Passed");
    end else begin
        $display("Write Test Failed");
    end

    // Test Read Operation from Slave (Address 0x42)
    s_axis_cmd_read = 1;
    s_axis_cmd_start = 1;
    s_axis_cmd_valid = 1;
    #100; // Wait for transmission

    // Check for received data
    if (m_axis_data_tvalid) begin
        $display("Read Test Passed: Received Data = %h", m_axis_data_tdata);
    end else begin
        $display("Read Test Failed");
    end
    #1000;
    $stop; // End simulation
end

endmodule
