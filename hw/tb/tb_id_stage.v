`timescale 1ns/1ps

module tb_id_stage;

  // ------------------------------------------------------------
  // Clock / reset
  // ------------------------------------------------------------
  reg clk;
  reg rst;

  always #5 clk = ~clk;  // 100 MHz

  // ------------------------------------------------------------
  // DUT inputs
  // ------------------------------------------------------------
  reg  [31:0] ifid_pc;
  reg  [31:0] ifid_instruction;
  reg         flush;
  reg         stall;

  reg         rf_reg_write;
  reg  [4:0]  rf_rd_addr;
  reg  [31:0] rf_rd_data;

  // ------------------------------------------------------------
  // DUT outputs
  // ------------------------------------------------------------
  wire        idex_jal;
  wire        idex_jalr;
  wire        idex_se_alu_src1;
  wire        idex_se_alu_src2;
  wire [3:0]  idex_aluop;
  wire [31:0] idex_rs1_data;
  wire [31:0] idex_rs2_data;
  wire [31:0] idex_imm;
  wire [4:0]  idex_rs1_addr;
  wire [4:0]  idex_rs2_addr;
  wire        idex_mem_we;
  wire        idex_mem_en;
  wire [2:0]  idex_width_se;
  wire [1:0]  idex_wb_se;
  wire        idex_regwrite;
  wire [4:0]  idex_rd_addr;
  wire [31:0] idex_pc;

  // ------------------------------------------------------------
  // DUT
  // ------------------------------------------------------------
  id_stage dut (
    .clk_i(clk),
    .rst_i(rst),

    .ifid_pc_i(ifid_pc),
    .ifid_instruction_i(ifid_instruction),

    .flush_i(flush),
    .stall_i(stall),

    .rf_reg_write_i(rf_reg_write),
    .rf_rd_addr_i(rf_rd_addr),
    .rf_rd_data_i(rf_rd_data),

    .idex_jal_o(idex_jal),
    .idex_jalr_o(idex_jalr),
    .idex_se_alu_src1_o(idex_se_alu_src1),
    .idex_se_alu_src2_o(idex_se_alu_src2),
    .idex_aluop_o(idex_aluop),
    .idex_rs1_data_o(idex_rs1_data),
    .idex_rs2_data_o(idex_rs2_data),
    .idex_imm_o(idex_imm),
    .idex_rs1_addr_o(idex_rs1_addr),
    .idex_rs2_addr_o(idex_rs2_addr),
    .idex_mem_we_o(idex_mem_we),
    .idex_mem_en_o(idex_mem_en),
    .idex_width_se_o(idex_width_se),
    .idex_wb_se_o(idex_wb_se),
    .idex_regwrite_o(idex_regwrite),
    .idex_rd_addr_o(idex_rd_addr),
    .idex_pc_o(idex_pc)
  );

  integer i;
  initial begin
    $dumpfile("ID_stage_dump.vcd");
    $dumpvars(0,tb_id_stage);
    for(i = 0; i < 32 ; i=i+1)
    dut.registers[i] =32'b0;
    $readmemh("regfile_initial.mem", dut.registers);
    #1;
    $display("Index 0: %h", dut.registers[0]);
    $display("Index 1: %h", dut.registers[1]);
    $display("Index 2: %h", dut.registers[2]);
    $display("Index 3: %h", dut.registers[3]);
  end
  // ------------------------------------------------------------
  // Test sequence
  // ------------------------------------------------------------
  initial begin
    clk = 0;
    rst = 1;

    ifid_pc = 0;
    ifid_instruction = 0;
    flush = 0;
    stall = 0;

    rf_reg_write = 0;
    rf_rd_addr = 0;
    rf_rd_data = 0;

    // Reset
    repeat (2) @(posedge clk);
    rst = 0;

    @(posedge clk);
    drive_ifid_inputs(
      32'h00000000,   // ifid_pc
      32'h00008067,   // ifid_instruction jalr x1, x1, 0
      1'b0,           // flush
      1'b0            // stall
    );

    drive_rf_inputs(
      1'b1,       // rf_reg_write
      5'd3,       // rf_rd_addr
      32'h1234    // rf_rd_data
    );

  `ifdef _TASK_COPARE_
    @(posedge clk);
    compare_idex_outputs(
      1'b1,      // idex_jal
      1'b0,      // idex_jalr
      1'b0,      // idex_se_alu_src1
      1'b1,      // idex_se_alu_src2
      4'h2,      // idex_aluop
      32'h10,    // idex_rs1_data
      32'h20,    // idex_rs2_data
      32'h100,   // idex_imm
      5'd1,      // idex_rs1_addr
      5'd2,      // idex_rs2_addr
      1'b0,      // idex_mem_we
      1'b1,      // idex_mem_en
      3'b010,    // idex_width_se
      2'b01,     // idex_wb_se
      1'b1,      // idex_regwrite
      5'd3,      // idex_rd_addr
      32'h8000   // idex_pc
    );
  `endif

    #20;
    $writememh("regfile_dump.txt", dut.registers);
    // LOAD Instructions (I-type)
    @(posedge clk); ifid_instruction = 32'h00052283; // pc 0x00000000  lw   x5, 0(x10)
    @(posedge clk); ifid_instruction = 32'h00451303; // pc 0x00000004  lh   x6, 4(x10)
    @(posedge clk); ifid_instruction = 32'h00655383; // pc 0x00000008  lhu  x7, 6(x10)
    @(posedge clk); ifid_instruction = 32'h00150403; // pc 0x0000000C  lb   x8, 1(x10)
    @(posedge clk); ifid_instruction = 32'h00254483; // pc 0x00000010  lbu  x9, 2(x10)
    
    // STORE Instructions (S-type)
    @(posedge clk); ifid_instruction = 32'h00352623; // pc 0x00000014  sw   x3, 12(x10)
    @(posedge clk); ifid_instruction = 32'hfe451e23; // pc 0x00000018  sh   x4, -4(x10)
    @(posedge clk); ifid_instruction = 32'h005503a3; // pc 0x0000001C  sb   x5, 7(x10)
    
    // ADD/SUB/Logic/Shift (R-type)
    @(posedge clk); ifid_instruction = 32'h00208333; // pc 0x00000020  add  x6, x1, x2
    @(posedge clk); ifid_instruction = 32'h404183b3; // pc 0x00000024  sub  x7, x3, x4
    @(posedge clk); ifid_instruction = 32'h00629433; // pc 0x00000028  sll  x8, x5, x6
    @(posedge clk); ifid_instruction = 32'h0062d4b3; // pc 0x0000002C  srl  x9, x5, x6
    @(posedge clk); ifid_instruction = 32'h4062d533; // pc 0x00000030  sra  x10, x5, x6
    
    @(posedge clk); ifid_instruction = 32'h0062a5b3; // pc 0x00000034  slt  x11, x5, x6
    @(posedge clk); ifid_instruction = 32'h0062b633; // pc 0x00000038  sltu x12, x5, x6
    @(posedge clk); ifid_instruction = 32'h0062c6b3; // pc 0x0000003C  xor  x13, x5, x6
    @(posedge clk); ifid_instruction = 32'h0062e733; // pc 0x00000040  or   x14, x5, x6
    @(posedge clk); ifid_instruction = 32'h0062f7b3; // pc 0x00000044  and  x15, x5, x6
    
    // Immediate Arithmetic (I-type)
    @(posedge clk); ifid_instruction = 32'h00a30293; // pc 0x00000048  addi x5, x6, 10
    @(posedge clk); ifid_instruction = 32'h0ff3f313; // pc 0x0000004C  andi x6, x7, 0xFF
    @(posedge clk); ifid_instruction = 32'h30046393; // pc 0x00000050  ori  x7, x8, 0x300
    @(posedge clk); ifid_instruction = 32'h0554c413; // pc 0x00000054  xori x8, x9, 0x55
    
    @(posedge clk); ifid_instruction = 32'hff852493; // pc 0x00000058  slti x9, x10, -8
    @(posedge clk); ifid_instruction = 32'h0ff5b513; // pc 0x0000005C  sltiu x10, x11, 255
    @(posedge clk); ifid_instruction = 32'h00361593; // pc 0x00000060  slli x11, x12, 3
    
    @(posedge clk); ifid_instruction = 32'h0016d613; // pc 0x00000064  srli x12, x13, 1
    @(posedge clk); ifid_instruction = 32'h40275693; // pc 0x00000068  srai x13, x14, 2
    
    // LUI + AUIPC (U-type)
    @(posedge clk); ifid_instruction = 32'h12345a37; // pc 0x0000006C  lui   x20, 0x12345
    @(posedge clk); ifid_instruction = 32'h00004a97; // pc 0x00000070  auipc x21, 0x4
    
    // Branch Instructions (B-type)
    @(posedge clk); ifid_instruction = 32'hf82086e3; // pc 0x00000074  beq  x1, x2, lable1
    @(posedge clk); ifid_instruction = 32'hf8419ee3; // pc 0x00000078  bne  x3, x4, lable2
    @(posedge clk); ifid_instruction = 32'hfc62c6e3; // pc 0x0000007C  blt  x5, x6, lable3
    @(posedge clk); ifid_instruction = 32'hfe83d6e3; // pc 0x00000080  bge  x7, x8, lable4
    @(posedge clk); ifid_instruction = 32'hfca4eae3; // pc 0x00000084  bltu x9, x10, lable5
    @(posedge clk); ifid_instruction = 32'hfac5f6e3; // pc 0x00000088  bgeu x11, x12, lable6
    
    // Jumps (J-type & I-type)
    @(posedge clk); ifid_instruction = 32'hfd9ff0ef; // pc 0x0000008C  jal  x1, lable7
    @(posedge clk); ifid_instruction = 32'h00028067; // pc 0x00000090  jalr x0, 0(x5)
    
    // System ecal ebreak
    @(posedge clk); ifid_instruction = 32'h00000073; // ecall
    @(posedge clk); ifid_instruction = 32'h00100073; // ebreak
    // fence instruction
    @(posedge clk); ifid_instruction = 32'h0000000f; // fence
    @(posedge clk); ifid_instruction = 32'h0000100f; // fence.i
    // csr instruction
    @(posedge clk); ifid_instruction = 32'h34111073; // csrrw x0, mscratch, x2
    @(posedge clk); ifid_instruction = 32'h30212073; // csrrs x0, medeleg, x2
    @(posedge clk); ifid_instruction = 32'h30313073; // csrrc x0, mideleg, x2
    @(posedge clk); ifid_instruction = 32'h34115073; // csrrwi x0, mscratch, 2
    @(posedge clk); ifid_instruction = 32'h3021e073; // csrrsi x0, medeleg, 3
    @(posedge clk); ifid_instruction = 32'h3031f073; // csrrci x0, mideleg, 3
    @(posedge clk);
    $finish;
  end

  task drive_ifid_inputs;
      input [31:0] pc;
      input [31:0] instruction;
      input        flush_i;
      input        stall_i;
    begin
      ifid_pc             = pc;
      ifid_instruction    = instruction;
      flush               = flush_i;
      stall               = stall_i;
    end
  endtask

  task drive_rf_inputs;
      input        reg_write;
      input [4:0]  rd_addr;
      input [31:0] rd_data;
    begin
      rf_reg_write = reg_write;
      rf_rd_addr   = rd_addr;
      rf_rd_data   = rd_data;
    end
  endtask

`ifdef _TASK_COPARE_
  task compare_idex_outputs;
      input exp_idex_jal;
      input exp_idex_jalr;
      input exp_idex_se_alu_src1;
      input exp_idex_se_alu_src2;
      input [3:0]  exp_idex_aluop;
      input [31:0] exp_idex_rs1_data;
      input [31:0] exp_idex_rs2_data;
      input [31:0] exp_idex_imm;
      input [4:0]  exp_idex_rs1_addr;
      input [4:0]  exp_idex_rs2_addr;
      input exp_idex_mem_we;
      input exp_idex_mem_en;
      input [2:0]  exp_idex_width_se;
      input [1:0]  exp_idex_wb_se;
      input exp_idex_regwrite;
      input [4:0]  exp_idex_rd_addr;
      input [31:0] exp_idex_pc;
    begin
      compare1 (idex_jal,         exp_idex_jal);
      compare1 (idex_jalr,        exp_idex_jalr);
      compare1 (idex_se_alu_src1, exp_idex_se_alu_src1);
      compare1 (idex_se_alu_src2, exp_idex_se_alu_src2);

      compare32({28'b0,idex_aluop}, {28'b0,exp_idex_aluop});

      compare32(idex_rs1_data,    exp_idex_rs1_data);
      compare32(idex_rs2_data,    exp_idex_rs2_data);
      compare32(idex_imm,         exp_idex_imm);

      compare5 (idex_rs1_addr,    exp_idex_rs1_addr);
      compare5 (idex_rs2_addr,    exp_idex_rs2_addr);

      compare1 (idex_mem_we,      exp_idex_mem_we);
      compare1 (idex_mem_en,      exp_idex_mem_en);

      compare32({29'b0,idex_width_se}, {29'b0,exp_idex_width_se});
      compare32({30'b0,idex_wb_se},    {30'b0,exp_idex_wb_se});

      compare1 (idex_regwrite,    exp_idex_regwrite);
      compare5 (idex_rd_addr,     exp_idex_rd_addr);
      compare32(idex_pc,          exp_idex_pc);
    end
  endtask

  task compare32(input [31:0] act, input [31:0] exp);
    begin
      if (act === exp) begin
        $display("time %0t: PASS value = %h", $time, act);
      end else begin
        $display("time %0t: FAIL act=%h exp=%h", $time, act, exp);
      end
    end
  endtask

  task compare5(input [4:0] act, input [4:0] exp);
    begin
      if (act === exp) begin
        $display("time %0t: PASS value = %h", $time, act);
      end else begin
        $display("time %0t: FAIL act=%h exp=%h", $time, act, exp);
      end
    end
  endtask

  task compare1(input act, input exp);
    begin
      if (act === exp) begin
        $display("time %0t: PASS value = %b", $time, act);
      end else begin
        $display("time %0t: FAIL act=%b exp=%b", $time, act, exp);
      end
    end
  endtask
`endif

endmodule
