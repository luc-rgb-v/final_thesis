`timescale 1ns/1ps

module tb_forwarding;

    // DUT inputs
    reg [4:0]  ex_rs1_addr, ex_rs2_addr;
    reg [31:0] ex_rs1_data, ex_rs2_data;

    reg        exmem_regwrite;
    reg [4:0]  exmem_rd_addr;
    reg [1:0]  exmem_wb_se;
    reg [31:0] exmem_alu_result;
    reg [31:0] exmem_pc_plus;

    reg        memwb_regwrite;
    reg [4:0]  memwb_rd_addr;
    reg [1:0]  memwb_wb_se;
    reg [31:0] memwb_alu_result;
    reg [31:0] memwb_mem_data;
    reg [31:0] memwb_pc_plus;

    // DUT outputs
    wire [31:0] forward_src_1;
    wire [31:0] forward_src_2;

    // Instantiate DUT
    forwarding dut(
        .ex_rs1_addr(ex_rs1_addr),
        .ex_rs2_addr(ex_rs2_addr),
        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),

        .exmem_regwrite(exmem_regwrite),
        .exmem_rd_addr(exmem_rd_addr),
        .exmem_wb_se(exmem_wb_se),
        .exmem_alu_result(exmem_alu_result),
        .exmem_pc_plus(exmem_pc_plus),

        .memwb_regwrite(memwb_regwrite),
        .memwb_rd_addr(memwb_rd_addr),
        .memwb_wb_se(memwb_wb_se),
        .memwb_alu_result(memwb_alu_result),
        .memwb_mem_data(memwb_mem_data),
        .memwb_pc_plus(memwb_pc_plus),

        .forward_src_1(forward_src_1),
        .forward_src_2(forward_src_2)
    );

    task print_state;
    begin
        #1;
        $display("rs1=%0d  rs2=%0d  -> fwd1=%h  fwd2=%h",
            ex_rs1_addr, ex_rs2_addr,
            forward_src_1, forward_src_2);
    end
    endtask

    initial begin
        $display("=== Forwarding TB Start ===");

        // baseline
        ex_rs1_addr = 5'd1;
        ex_rs2_addr = 5'd2;
        ex_rs1_data = 32'hAAAA_AAAA; // original operand 1
        ex_rs2_data = 32'hBBBB_BBBB; // original operand 2

        // Default pipeline (no forwarding active)
        exmem_regwrite = 0;
        exmem_rd_addr  = 5'd0;
        exmem_wb_se    = 2'b00;
        exmem_alu_result = 32'h1111_1111;
        exmem_pc_plus    = 32'h2222_2222;

        memwb_regwrite = 0;
        memwb_rd_addr  = 5'd0;
        memwb_wb_se    = 2'b00;
        memwb_alu_result = 32'h3333_3333;
        memwb_mem_data   = 32'h4444_4444;
        memwb_pc_plus    = 32'h5555_5555;

        // =====================================================
        $display("\n-- 1. No forwarding --");
        print_state();

        // =====================================================
        $display("\n-- 2. EX/MEM forwarding ALU Result to rs1 --");
        exmem_regwrite = 1;
        exmem_rd_addr  = 5'd1;
        exmem_wb_se    = 2'b00; // select alu
        print_state();

        // =====================================================
        $display("\n-- 3. EX/MEM forwarding PC+4 to rs2 --");
        exmem_rd_addr  = 5'd2;
        exmem_wb_se    = 2'b10; // PC+4
        print_state();

        // =====================================================
        $display("\n-- 4. MEM/WB forwarding ALU result to rs1 --");
        exmem_regwrite = 0;
        memwb_regwrite = 1;
        memwb_rd_addr  = 5'd1;
        memwb_wb_se    = 2'b00; // alu
        print_state();

        // =====================================================
        $display("\n-- 5. MEM/WB forwarding MEM data to rs2 --");
        memwb_rd_addr  = 5'd2;
        memwb_wb_se    = 2'b01; // mem
        print_state();

        // =====================================================
        $display("\n-- 6. MEM/WB forwarding PC+4 to rs1 --");
        ex_rs1_addr = 5'd3;
        memwb_rd_addr = 5'd3;
        memwb_wb_se = 2'b10;
        print_state();

        $display("\n=== Forwarding TB Done ===");
        $finish;
    end

endmodule
