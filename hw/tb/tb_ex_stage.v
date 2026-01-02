`timescale 1ns/1ps
//`define _TASK_COMPARE_
module tb_ex_stage;

  // ------------------------------------------------------------
  // Clock / reset
  // ------------------------------------------------------------
  reg clk;
  reg rst;
  reg stall;

  always #5 clk = ~clk;

  // ------------------------------------------------------------
  // DUT inputs
  // ------------------------------------------------------------
  reg [31:0] ex_pc;
  reg [31:0] ex_imm;
  reg [31:0] ex_rs1_data;
  reg [31:0] ex_rs2_data;

  reg        ex_jal;
  reg        ex_jalr;
  reg        ex_alu_src1;
  reg        ex_alu_src2;
  reg [3:0]  ex_aluop;
  reg        ex_mem_we;
  reg        ex_mem_en;
  reg [2:0]  ex_width_se;
  reg [1:0]  ex_wb_se;
  reg        ex_regwrite;
  reg [4:0]  ex_rd_addr;

  // ------------------------------------------------------------
  // DUT outputs
  // ------------------------------------------------------------
  wire [31:0] exif_pc_bj;
  wire        exif_bj_taken;

  wire        exmem_mem_we;
  wire        exmem_mem_en;
  wire [2:0]  exmem_width_se;
  wire [1:0]  exmem_wb_se;
  wire        exmem_regwrite;
  wire [4:0]  exmem_rd_addr;
  wire [31:0] exmem_alu_result;
  wire [31:0] exmem_rs2_data;
  wire [31:0] exmem_pc_plus;

  // ------------------------------------------------------------
  // DUT
  // ------------------------------------------------------------
  ex_stage dut (
    .clk_i(clk),
    .rst_i(rst),
    .stall_i(stall),

    .ex_pc_i(ex_pc),
    .ex_imm_i(ex_imm),
    .ex_rs1_data_i(ex_rs1_data),
    .ex_rs2_data_i(ex_rs2_data),

    .ex_jal_i(ex_jal),
    .ex_jalr_i(ex_jalr),
    .ex_alu_src1_i(ex_alu_src1),
    .ex_alu_src2_i(ex_alu_src2),
    .ex_aluop_i(ex_aluop),
    .ex_mem_we_i(ex_mem_we),
    .ex_mem_en_i(ex_mem_en),
    .ex_width_se_i(ex_width_se),
    .ex_wb_se_i(ex_wb_se),
    .ex_regwrite_i(ex_regwrite),
    .ex_rd_addr_i(ex_rd_addr),

    .exif_pc_bj_o(exif_pc_bj),
    .exif_bj_taken_o(exif_bj_taken),

    .exmem_mem_we_o(exmem_mem_we),
    .exmem_mem_en_o(exmem_mem_en),
    .exmem_width_se_o(exmem_width_se),
    .exmem_wb_se_o(exmem_wb_se),
    .exmem_regwrite_o(exmem_regwrite),
    .exmem_rd_addr_o(exmem_rd_addr),
    .exmem_alu_result_o(exmem_alu_result),
    .exmem_rs2_data_o(exmem_rs2_data),
    .exmem_pc_plus_o(exmem_pc_plus)
  );

  // ------------------------------------------------------------
  // Dump
  // ------------------------------------------------------------
  initial begin
    $dumpfile("EX_stage_dump.vcd");
    $dumpvars(0, tb_ex_stage);
  end

  // ------------------------------------------------------------
  // Test sequence
  // ------------------------------------------------------------
  initial begin
    clk = 0;
    rst = 1;
    stall = 0;

    drive_ex_inputs(
      32'b0, 
      32'b0, 
      32'b0, 
      32'b0,
      0, 
      0, 
      0, 
      0, 
      0,
      0, 
      0, 
      0, 
      0, 
      0,
      5'd0
    );

    repeat (2) @(posedge clk);
    rst = 0;

`ifdef _TASK_COMPARE_
    @(posedge clk);
    compare_ex_outputs(
      32'd30,         // alu_result
      1'b0,           // bj_taken
      32'h00000104,   // pc_plus
      1'b1,           // regwrite
      5'd3            // rd
    );
`endif


`ifdef _TASK_COMPARE_
    @(posedge clk);
    compare1(exif_bj_taken, 1'b1);
    compare32(exif_pc_bj, 32'h210);
`endif

    @(posedge clk);
    @(posedge clk);

    // 1. ALU_ADD
    // Operation: rs1 + rs2
    // Expected result: 10 + 20 = 30 (0x1E)
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'd10, 32'd20, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_ADD, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 2. ALU_SUB
    // Operation: rs1 - rs2
    // Expected result: 10 - 20 = -10 (0xFFFFFFF6, two's complement)
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'd10, 32'd20, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_SUB, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 3. ALU_SLL (shift left logical)
    // Operation: rs1 << (rs2[4:0])
    // Expected result: 10 << 2 = 40 (0x28)
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'd10, 32'd2, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_SLL, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 4. ALU_SLT (signed less than)
    // Operation: rs1 < rs2 (signed) ? 1 : 0
    // Expected result: 10 < 20 → 1
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'd10, 32'd20, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_SLT, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 5. ALU_SLTU (unsigned less than)
    // Operation: rs1 < rs2 (unsigned) ? 1 : 0
    // Expected result: 10 < 20 → 1
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'd10, 32'd20, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_SLTU, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 6. ALU_XOR
    // Operation: rs1 ^ rs2
    // Expected result: 0xAAAA ^ 0x5555 = 0xFFFF
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'hAAAA, 32'h5555, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_XOR, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 7. ALU_SRL (shift right logical)
    // Operation: rs1 >> (rs2[4:0]) (zero-extend)
    // Expected result: 0x80000000 >> 1 = 0x40000000
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'h80000000, 32'd1, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_SRL, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 8. ALU_SRA (shift right arithmetic)
    // Operation: rs1 >> (rs2[4:0]) (sign-extend)
    // Expected result: 0x80000000 >> 1 = 0xC0000000
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'h80000000, 32'd1, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_SRA, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 9. ALU_OR
    // Operation: rs1 | rs2
    // Expected result: 0xAA00 | 0x0055 = 0xAA55
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'hAA00, 32'h0055, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_OR, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 10. ALU_AND
    // Operation: rs1 & rs2
    // Expected result: 0xFF00 & 0x00FF = 0x0000
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'hFF00, 32'h00FF, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_AND, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 11. ALU_BEQ (branch if equal)
    // Operation: rs1 == rs2 ? 1 : 0
    // Expected result: 10 == 10 → 1 (taken)
    // pc, imm, rs1, rs2, jal, jalr, src1, src2, aluop, mem_we, mem_en, width, wb, regwrite, rd
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'd16, 32'd10, 32'd10, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_BEQ, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 12. ALU_BNE (branch if not equal)
    // Operation: rs1 != rs2 ? 1 : 0
    // Expected result: 10 != 20 → 1 (taken)
    @(posedge clk);
    drive_ex_inputs(32'h200, 32'd8, 32'd10, 32'd20, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_BNE, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 13. ALU_BLT (signed less than)
    // Operation: rs1 < rs2 (signed) ? 1 : 0
    // Expected result: -5 < 10 → 1 (taken)
    @(posedge clk);
    drive_ex_inputs(32'h300, 32'd4, 32'hFFFFFFFB, 32'd10, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_BLT, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 14. ALU_BGE (signed greater or equal)
    // Operation: rs1 >= rs2 (signed) ? 1 : 0
    // Expected result: 20 >= 10 → 1 (taken)
    @(posedge clk);
    drive_ex_inputs(32'h500, 32'd8, 32'd20, 32'd10, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_BGE, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 15. ALU_BLTU (unsigned less than)
    // Operation: rs1 < rs2 (unsigned) ? 1 : 0
    // Expected result: 10 < 20 → 1 (taken)
    @(posedge clk);
    drive_ex_inputs(32'h600, 32'd8, 32'd10, 32'd20, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_BLTU, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 16. ALU_BGEU (unsigned greater or equal)
    // Operation: rs1 >= rs2 (unsigned) ? 1 : 0
    // Expected result: 20 >= 10 → 1 (taken)
    @(posedge clk);
    drive_ex_inputs(32'h700, 32'd8, 32'd20, 32'd10, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_BGEU, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // Bonus: False cases for branches (to test zero output)
    // ALU_BNE false: 10 != 10 → 0 (not taken)
    @(posedge clk);
    drive_ex_inputs(32'h800, 32'd8, 32'd10, 32'd10, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_BNE, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // ALU_BLT false: 20 < 10 → 0 (not taken)
    @(posedge clk);
    drive_ex_inputs(32'h900, 32'd8, 32'd20, 32'd10, 1'b0, 1'b0, 1'b0, 1'b1, `ALU_BLT, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 17. JAL (positive offset)
    // Operation: Target = PC + imm
    // imm = 0x100 (256 bytes forward, even)
    // Expected ALU result (target): 0x100 + 0x100 = 0x200
    // pc, imm, rs1, rs2, jal, jalr, src1, src2, aluop, mem_we, mem_en, width, wb, regwrite, rd
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'h100, 32'd0, 32'd0, 1'b1, 1'b0, 1'b0, 1'b0, `ALU_ADD, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1); // jal rd, offset (uses ALU_ADD internally)

    // 18. JAL (negative offset)
    // Operation: Target = PC + imm
    // imm = -0x80 (signed -128, forward 0x100 - 0x80 = 0x80)
    // Expected ALU result (target): 0x100 - 0x80 = 0x80
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'hFFFFF800, 32'd0, 32'd0, 1'b1, 1'b0, 1'b0, 1'b0, `ALU_ADD, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1); // jal rd, -128 (imm sign-extended)

    // 19. JALR (rs1 + imm = 0)
    // Operation: Target = (rs1 + 0) & ~1
    // rs1 = 0x200 (even), imm = 0
    // Expected ALU result (target): 0x200 & ~1 = 0x200
    @(posedge clk);
    drive_ex_inputs(32'h100, 32'b0, 32'h200, 32'd0, 1'b0, 1'b1, 1'b0, 1'b1, `ALU_ADD, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1); // jalr rd, rs1, 0 (uses ALU_ADD)

    // 20. JALR (rs1 + imm, odd rs1)
    // Operation: Target = (rs1 + imm) & ~1
    // rs1 = 0x201 (odd), imm = 0xF (15)
    // Expected ALU result (target): (0x201 + 0xF) & ~1 = 0x210 & ~1 = 0x210
    @(posedge clk);
    drive_ex_inputs(32'h200, 32'hF, 32'h201, 32'd0, 1'b0, 1'b1, 1'b0, 1'b1, `ALU_ADD, 1'b0, 1'b0, 3'b000, 2'b00, 1'b1, 5'd1);

    // 21. JALR (return idiom: jalr x0, x1, 0)
    // Operation: Target = x1 & ~1 (discard rd since x0)
    // Expected ALU result (target): x1 value masked
    // Link: discarded
    @(posedge clk);
    drive_ex_inputs(32'h300, 32'b0, 32'h300, 32'd0, 1'b0, 1'b1, 1'b0, 1'b1, `ALU_ADD, 1'b0, 1'b0, 3'b000, 2'b00, 1'b0, 5'd0); // jalr x0, x1, 0 (no reg write)

    // End of test
    @(posedge clk);
    $display("ALU opcode test sequence complete. Verify results against comments.");

    #20;
    $finish;
  end

  // ------------------------------------------------------------
  // Tasks
  // ------------------------------------------------------------
  task drive_ex_inputs(
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] rs1,
    input [31:0] rs2,
    input        jal,
    input        jalr,
    input        src1,
    input        src2,
    input [3:0]  aluop,
    input        mem_we,
    input        mem_en,
    input [2:0]  width,
    input [1:0]  wb,
    input        regwrite,
    input [4:0]  rd
  );
    begin
      ex_pc        = pc;
      ex_imm       = imm;
      ex_rs1_data  = rs1;
      ex_rs2_data  = rs2;
      ex_jal       = jal;
      ex_jalr      = jalr;
      ex_alu_src1  = src1;
      ex_alu_src2  = src2;
      ex_aluop     = aluop;
      ex_mem_we    = mem_we;
      ex_mem_en    = mem_en;
      ex_width_se  = width;
      ex_wb_se     = wb;
      ex_regwrite  = regwrite;
      ex_rd_addr   = rd;
    end
  endtask

`ifdef _TASK_COMPARE_
  task compare_ex_outputs(
    input [31:0] exp_alu,
    input        exp_bj,
    input [31:0] exp_pc_plus,
    input        exp_regwrite,
    input [4:0]  exp_rd
  );
    begin
      compare32(exmem_alu_result, exp_alu);
      compare1 (exif_bj_taken,    exp_bj);
      compare32(exmem_pc_plus,    exp_pc_plus);
      compare1 (exmem_regwrite,   exp_regwrite);
      compare5 (exmem_rd_addr,    exp_rd);
    end
  endtask

  task compare32(input [31:0] act, input [31:0] exp);
    begin
      if (act === exp)
        $display("time %0t: PASS %h", $time, act);
      else
        $display("time %0t: FAIL act=%h exp=%h", $time, act, exp);
    end
  endtask

  task compare5(input [4:0] act, input [4:0] exp);
    begin
      if (act === exp)
        $display("time %0t: PASS %h", $time, act);
      else
        $display("time %0t: FAIL act=%h exp=%h", $time, act, exp);
    end
  endtask

  task compare1(input act, input exp);
    begin
      if (act === exp)
        $display("time %0t: PASS %b", $time, act);
      else
        $display("time %0t: FAIL act=%b exp=%b", $time, act, exp);
    end
  endtask
`endif

endmodule
