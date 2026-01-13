`timescale 1ns/1ps

module tb_mem_stage;

  // ------------------------------------------------------------------
  // Clock & Reset
  // ------------------------------------------------------------------
  reg clk_i;
  reg rst_i;

  // ------------------------------------------------------------------
  // Inputs to DUT
  // ------------------------------------------------------------------
  reg        mem_we_i;
  reg        mem_en_i;
  reg [2:0]  mem_width_se_i;

  reg [31:0] mem_alu_result_i;
  reg [31:0] mem_data_i;

  reg        mem_regwrite_i;
  reg [4:0]  mem_rd_addr_i;
  reg [1:0]  mem_wb_se_i;
  reg [31:0] mem_pc_plus_i;

  // Memory interface
  wire       dmem_en;
  wire [3:0] dmem_we;
  wire [31:0] dmem_addr;
  wire [31:0] dmem_w_data;
  wire  [31:0] dmem_r_data;

  // Outputs to WB stage
  wire stall_by_mem;
  wire        memwb_regwrite_o;
  wire [4:0]  memwb_rd_addr_o;
  wire [1:0]  memwb_wb_se_o;
  wire [31:0] memwb_pc_plus_o;
  wire [31:0] memwb_alu_result_o;
  wire [31:0] memwb_mem_data_o;

  wire [1:0]  mem_stage_err;

  // ------------------------------------------------------------------
  // DUT
  // ------------------------------------------------------------------
  mem_stage dut (
    .clk_i(clk_i),
    .rst_i(rst_i),

    .mem_we_i(mem_we_i),
    .mem_en_i(mem_en_i),
    .mem_width_se_i(mem_width_se_i),

    .mem_alu_result_i(mem_alu_result_i),
    .mem_data_i(mem_data_i),

    .mem_regwrite_i(mem_regwrite_i),
    .mem_rd_addr_i(mem_rd_addr_i),
    .mem_wb_se_i(mem_wb_se_i),
    .mem_pc_plus_i(mem_pc_plus_i),

    .dmem_en_o(dmem_en),
    .dmem_we_o(dmem_we),
    .dmem_addr_o(dmem_addr),
    .dmem_din_o(dmem_w_data),
    .dmem_dout_i(dmem_r_data),

    .memwb_regwrite_o(memwb_regwrite_o),
    .memwb_rd_addr_o(memwb_rd_addr_o),
    .memwb_wb_se_o(memwb_wb_se_o),
    .memwb_pc_plus_o(memwb_pc_plus_o),
    .memwb_alu_result_o(memwb_alu_result_o),
    .memwb_mem_data_o(memwb_mem_data_o),

    .mem_stage_err_r(mem_stage_err),
    .stall_by_mem (stall_by_mem)
  );

`ifdef _DMEM_IP_
  dmem_ip dut_dmem (
    .clka   (clk_i),
    .ena    (dmem_en),
    .wea    (dmem_we),
    .addra  (dmem_addr[9:2]),
    .dina   (dmem_w_data),
    .douta  (dmem_r_data)
  );
`else
  dmem_wrab dut_dmem (
    .clka   (clk_i),
    .ena    (dmem_en),
    .wea    (dmem_we),
    .addra  (dmem_addr[9:2]),
    .dina   (dmem_w_data),
    .douta  (dmem_r_data)
  );
`endif

  // ------------------------------------------------------------------
  // Clock generation
  // ------------------------------------------------------------------
  initial begin
    clk_i = 1;
    forever #5 clk_i = ~clk_i;   // 100 MHz
  end

  // ------------------------------------------------------------------
  // Test sequence
  // ------------------------------------------------------------------
  initial begin
    // ---------------- Reset ----------------
    rst_i = 1;

    mem_we_i          = 0;
    mem_en_i          = 0;
    mem_width_se_i    = 3'b000;

    mem_alu_result_i  = 32'h0;
    mem_data_i        = 32'h0;

    mem_regwrite_i    = 0;
    mem_rd_addr_i     = 5'd0;
    mem_wb_se_i       = 2'b0;
    mem_pc_plus_i     = 32'h80000004;

    #20;
    rst_i = 0;
    mem_en_i         <= 1;
    mem_we_i         <= 1;
    mem_width_se_i   <= 3'b010;
    mem_alu_result_i <= 32'h80000010;
    mem_data_i       <= 32'hAABBCCDD;

    mem_regwrite_i   <= 0;
    mem_rd_addr_i    <= 5'd0;
    mem_wb_se_i      <= 2'b0;
    mem_pc_plus_i    <= 32'h8000000C;

    #10;
    rst_i = 0;
    mem_en_i         <= 1;
    mem_we_i         <= 1;
    mem_width_se_i   <= 3'b010;
    mem_alu_result_i <= 32'h8000002c;
    mem_data_i       <= 32'h0;

    mem_regwrite_i   <= 0;
    mem_rd_addr_i    <= 5'd0;
    mem_wb_se_i      <= 2'b0;
    mem_pc_plus_i    <= 32'h80000c00;
    
    #10;
    mem_we_i          = 0;
    mem_en_i          = 0;
    mem_width_se_i    = 3'b000;

    mem_alu_result_i  = 32'h0;
    mem_data_i        = 32'h0;

    mem_regwrite_i    = 0;
    mem_rd_addr_i     = 5'd0;
    mem_wb_se_i       = 2'b0;
    mem_pc_plus_i     = 32'h80000004;
    
    #10;
    rst_i = 0;
    mem_en_i         <= 1;
    mem_we_i         <= 0;
    mem_width_se_i   <= 3'b010;
    mem_alu_result_i <= 32'h80000010;
    mem_data_i       <= 32'h0c;

    mem_regwrite_i   <= 1;
    mem_rd_addr_i    <= 5'd4;
    mem_wb_se_i      <= 2'b01;
    mem_pc_plus_i    <= 32'h8000001c;
    
    #40;
    mem_we_i          = 0;
    mem_en_i          = 0;
    mem_width_se_i    = 3'b000;

    mem_alu_result_i  = 32'h0;
    mem_data_i        = 32'h0;

    mem_regwrite_i    = 0;
    mem_rd_addr_i     = 5'd0;
    mem_wb_se_i       = 2'b0;
    mem_pc_plus_i     = 32'h80000004;

    #200;
    $finish;
  end

endmodule
