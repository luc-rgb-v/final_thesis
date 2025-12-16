`timescale 1ps / 1ps
module riscv_core(
  input wire clk_i,
  input wire rst_i,

  output wire [31:0] imem_addr_o,
  output wire        imem_en_o,
  input  wire [31:0] imem_instr_i,

  output wire        dmem_we_o,
  output wire        dmem_en_o,
  output wire [31:0] dmem_addr_o,
  output wire [31:0] dmem_data_o,
  input wire [31:0]  dmem_data_i,
  output wire [2:0]  dmem_width_se_o
);

  // LOCAL_PARAM
  localparam RESET_PC  = 32'b00000000;
  localparam NOP_INSTR = 32'h00000013;
  // opcode RV32I
  localparam OPCODE_R       = 7'b0110011;
  localparam OPCODE_I_ARITH = 7'b0010011;
  localparam OPCODE_I_LOAD  = 7'b0000011;
  localparam OPCODE_I_JALR  = 7'b1100111;
  localparam OPCODE_SYSTEM  = 7'b1110011;
  localparam OPCODE_S       = 7'b0100011;
  localparam OPCODE_B       = 7'b1100011;
  localparam OPCODE_LUI     = 7'b0110111;
  localparam OPCODE_AUIPC   = 7'b0010111;
  localparam OPCODE_JAL     = 7'b1101111;
  localparam OPCODE_FENCE   = 7'b0001111;
  // ALU opcode
  localparam ALU_ADD  = 4'b0000;
  localparam ALU_SUB  = 4'b0001;
  localparam ALU_SLL  = 4'b0010;
  localparam ALU_SLT  = 4'b0011;
  localparam ALU_SLTU = 4'b0100;
  localparam ALU_XOR  = 4'b0101;
  localparam ALU_SRL  = 4'b0110;
  localparam ALU_SRA  = 4'b0111;
  localparam ALU_OR   = 4'b1000;
  localparam ALU_AND  = 4'b1001;
  // ALU branch
  localparam ALU_BEQ  = 4'b1010;
  localparam ALU_BNE  = 4'b1011;
  localparam ALU_BLT  = 4'b1100;
  localparam ALU_BGE  = 4'b1101;
  localparam ALU_BLTU = 4'b1110;
  localparam ALU_BGEU = 4'b1111;
  // Memory
  //localparam LB  = 3'b000;
  //localparam LH  = 3'b001;
  //localparam LW  = 3'b010;
  //localparam LBU = 3'b100;
  //localparam LHU = 3'b101;
  //localparam SB  = 3'b000;
  //localparam SH  = 3'b001;
  //localparam SW  = 3'b010;

  wire stall_cause_by_mem;
  // IF wires
  wire [31:0] if_pc_w;
  wire [31:0] if_pc_next_w;
  wire [31:0] if_pc_bj_w;
  wire        if_bj_taken_w;
  wire [31:0] pc_sub_w;

  // IF registers
  reg [31:0] pc_r;
  reg [31:0] ifid_pc_r;
  reg [31:0] ifid_instruction_r;
  reg [31:0] pc_sub_r;

  reg valid_pc;
  reg imem_en_r;

  assign pc_sub_w = pc_sub_r;
  assign if_pc_w = pc_r;
  assign imem_addr_o = if_pc_w;
  assign imem_en_o = imem_en_r;

  assign if_pc_next_w = if_bj_taken_w ? if_pc_bj_w : (if_pc_w + 32'h4);

  task reset_if_stage;
    begin
      ifid_pc_r <= RESET_PC;
      ifid_instruction_r <= NOP_INSTR;
    end
  endtask

  // PC register
  always @(posedge clk_i) begin
    if (rst_i)
      pc_r <= RESET_PC;
    else if (~stall_cause_by_mem)
      pc_r <= if_pc_next_w;
  end

  // imem enable
  always @(*) begin
    if (if_bj_taken_w || stall_cause_by_mem || rst_i)
      imem_en_r = 1'b0;
    else
      imem_en_r = 1'b1;
  end

  // valid_pc logic
  always @(posedge clk_i) begin
    if (rst_i || if_bj_taken_w)
      valid_pc <= 1'b0;
    else if (~stall_cause_by_mem)
      valid_pc <= 1'b1;
  end

  // pc_sub register
  always @(posedge clk_i) begin
    if (rst_i || if_bj_taken_w)
      pc_sub_r <= RESET_PC;
    else if (~stall_cause_by_mem)
      pc_sub_r <= if_pc_w;
  end

  // IF/ID register
  always @(posedge clk_i) begin
    if (rst_i || if_bj_taken_w) begin
      reset_if_stage();
    end else if (~stall_cause_by_mem) begin
      ifid_instruction_r <= valid_pc ? imem_instr_i : NOP_INSTR;
      ifid_pc_r          <= pc_sub_w;
    end
  end

  // ID wire
  wire [31:0] id_pc_w = ifid_pc_r;
  wire [31:0] id_instruction_w = ifid_instruction_r;
  wire [4:0] id_rs1_addr_w;
  wire [4:0] id_rs2_addr_w;
  wire id_jal_w;
  wire id_jalr_w;
  wire id_se_alu_src1_w;
  wire id_se_alu_src2_w;
  wire id_mem_en_w;
  wire id_mem_we_w;
  wire [2:0] id_width_se_w;
  wire [1:0] id_wb_se_w;
  wire id_regwrite_w;
  wire [4:0] id_rd_addr_w;
  wire [3:0] id_aluop_w;
  //
  wire [31:0] id_imm_w;
  wire [31:0] rf_rs1_data_w;
  wire [31:0] rf_rs2_data_w;

  wire [6:0] id_opcode_w = id_instruction_w[6:0];
  wire [4:0] id_src1_w   = id_instruction_w[19:15];
  wire [4:0] id_src2_w   = id_instruction_w[24:20];
  wire [4:0] id_rd_w     = id_instruction_w[11:7];
  wire [2:0] id_funct3_w = id_instruction_w[14:12];
  wire [6:0] id_funct7_w = id_instruction_w[31:25];

  wire [31:0] id_imm_i_w = {{20{id_instruction_w[31]}}, id_instruction_w[31:20]};
  wire [31:0] id_imm_s_w = {{20{id_instruction_w[31]}}, id_instruction_w[31:25], id_instruction_w[11:7]};
  wire [31:0] id_imm_b_w = {{19{id_instruction_w[31]}}, id_instruction_w[31], id_instruction_w[7], id_instruction_w[30:25], id_instruction_w[11:8], 1'b0};
  wire [31:0] id_imm_j_w = {{11{id_instruction_w[31]}}, id_instruction_w[31], id_instruction_w[19:12], id_instruction_w[20], id_instruction_w[30:21], 1'b0};
  wire [31:0] id_imm_u_w = {id_instruction_w[31:12], 12'b0};
  wire [31:0] id_shamt_imm_w = {27'b0, id_instruction_w[24:20]};

  // ID reg
  reg [31:0] registers [0:31];
  reg [31:0] idex_imm_r;
  reg [31:0] idex_rs1_data_r;
  reg [31:0] idex_rs2_data_r;
  reg [31:0] idex_pc_r;

  reg idex_jal_r, idex_jalr_r, idex_se_alu_src1_r, idex_se_alu_src2_r;
  reg [3:0] idex_aluop_r;
  reg [4:0] idex_rs1_addr_r, idex_rs2_addr_r;
  reg idex_mem_en_r, idex_mem_we_r;
  reg [2:0] idex_width_se_r;
  reg [1:0] idex_wb_se_r;
  reg idex_regwrite_r;
  reg [4:0] idex_rd_addr_r;

  // Blocking assignments ID
  assign rf_rs1_data_w = (id_rs1_addr_w == 5'b0) ? 32'b0 : registers[id_rs1_addr_w];
  assign rf_rs2_data_w = (id_rs2_addr_w == 5'b0) ? 32'b0 : registers[id_rs2_addr_w];

  assign id_jal_w = (id_opcode_w == OPCODE_JAL);
  assign id_jalr_w = (id_opcode_w == OPCODE_I_JALR);

  // IMM select
  assign id_imm_w = (id_opcode_w == OPCODE_LUI || id_opcode_w == OPCODE_AUIPC) ? id_imm_u_w :
                    (id_opcode_w == OPCODE_JAL)                                ? id_imm_j_w :
                    (id_opcode_w == OPCODE_I_JALR)                             ? id_imm_i_w :
                    (id_opcode_w == OPCODE_B)                                  ? id_imm_b_w :
                    (id_opcode_w == OPCODE_I_LOAD)                             ? id_imm_i_w :
                    (id_opcode_w == OPCODE_S)                                  ? id_imm_s_w :
                    (id_opcode_w == OPCODE_I_ARITH && (id_funct3_w == 3'b001 || id_funct3_w == 3'b101)) ? id_shamt_imm_w :
                    (id_opcode_w == OPCODE_I_ARITH)                            ? id_imm_i_w :
                    32'b0;

  // Register addresses
  assign id_rs1_addr_w = (id_opcode_w == OPCODE_LUI || id_opcode_w == OPCODE_AUIPC || id_opcode_w == OPCODE_JAL || id_opcode_w == OPCODE_FENCE || (id_opcode_w == OPCODE_SYSTEM && (id_funct3_w == 3'b001 || id_funct3_w == 3'b010 || id_funct3_w == 3'b011))) ? 5'b0 : id_src1_w;
  assign id_rs2_addr_w = (id_opcode_w == OPCODE_B || id_opcode_w == OPCODE_S || id_opcode_w == OPCODE_R) ? id_src2_w : 5'b0;
  assign id_se_alu_src1_w = (id_opcode_w == OPCODE_AUIPC);  // MUX = 0 : rs1 ; MUX = 1 : PC
  assign id_se_alu_src2_w = (id_opcode_w == OPCODE_R) || (id_opcode_w == OPCODE_B); // MUX = 0 : imm ; MUX = 1 : rs2
  // MEM control
  assign id_mem_we_w = (id_opcode_w == OPCODE_S) ? 1'b1 : 1'b0;
  assign id_mem_en_w = (id_opcode_w == OPCODE_I_LOAD) || (id_opcode_w == OPCODE_S);

  // Loads: 000=LB, 001=LH, 010=LW, 100=LBU, 101=LHU
  wire [2:0] id_load_se_w = (id_funct3_w == 3'b000) ? 3'b000 : (id_funct3_w == 3'b001) ? 3'b001 : (id_funct3_w == 3'b010) ? 3'b010 : (id_funct3_w == 3'b100) ? 3'b100 : (id_funct3_w == 3'b101) ? 3'b101 : 3'b010;
  // Stores: 000=SB, 001=SH, 010=SW (others unused)
  wire [2:0] id_store_se_w = (id_funct3_w == 3'b000) ? 3'b000 : (id_funct3_w == 3'b001) ? 3'b001 : 3'b010;
  // Load and store select
  assign id_width_se_w = (id_opcode_w == OPCODE_I_LOAD) ? id_load_se_w : (id_opcode_w == OPCODE_S) ? id_store_se_w : 3'b000;
  // wb_se = 01 memory; 10 PC + 4; 00 ALU
  assign id_wb_se_w = (id_opcode_w == OPCODE_I_LOAD) ? 2'b01 : ((id_opcode_w == OPCODE_JAL) || (id_opcode_w == OPCODE_I_JALR)) ? 2'b10 : 2'b00;

  // --- reg writeback enables
  assign id_regwrite_w = (id_opcode_w == OPCODE_R)       ||
                         (id_opcode_w == OPCODE_I_ARITH) ||
                         (id_opcode_w == OPCODE_I_LOAD)  ||
                         (id_opcode_w == OPCODE_JAL)     ||
                         (id_opcode_w == OPCODE_I_JALR)  ||
                         (id_opcode_w == OPCODE_LUI)     ||
                         (id_opcode_w == OPCODE_AUIPC)   ||
                         ((id_opcode_w == OPCODE_SYSTEM) && id_funct3_w != 3'b000);

  assign id_rd_addr_w = id_regwrite_w ? id_rd_w : 5'b0;

  // ALU control decode
  wire [3:0] id_alu_r_type_w = (id_funct3_w == 3'b000 && id_funct7_w == 7'b0100000) ? ALU_SUB :
                               (id_funct3_w == 3'b000)                              ? ALU_ADD :
                               (id_funct3_w == 3'b001)                              ? ALU_SLL :
                               (id_funct3_w == 3'b010)                              ? ALU_SLT :
                               (id_funct3_w == 3'b011)                              ? ALU_SLTU:
                               (id_funct3_w == 3'b100)                              ? ALU_XOR :
                               (id_funct3_w == 3'b101 && id_funct7_w == 7'b0100000) ? ALU_SRA :
                               (id_funct3_w == 3'b101)                              ? ALU_SRL :
                               (id_funct3_w == 3'b110)                              ? ALU_OR  :
                               (id_funct3_w == 3'b111)                              ? ALU_AND : ALU_ADD;

  wire [3:0] id_alu_i_type_w = (id_funct3_w == 3'b000)                              ? ALU_ADD :
                               (id_funct3_w == 3'b001)                              ? ALU_SLL :
                               (id_funct3_w == 3'b010)                              ? ALU_SLT :
                               (id_funct3_w == 3'b011)                              ? ALU_SLTU:
                               (id_funct3_w == 3'b100)                              ? ALU_XOR :
                               (id_funct3_w == 3'b101 && id_instruction_w[30])      ? ALU_SRA :
                               (id_funct3_w == 3'b101)                              ? ALU_SRL :
                               (id_funct3_w == 3'b110)                              ? ALU_OR  :
                               (id_funct3_w == 3'b111)                              ? ALU_AND : ALU_ADD;

  wire [3:0] id_alu_b_type_w = (id_funct3_w == 3'b000) ? ALU_BEQ  :
                               (id_funct3_w == 3'b001) ? ALU_BNE  :
                               (id_funct3_w == 3'b100) ? ALU_BLT  :
                               (id_funct3_w == 3'b101) ? ALU_BGE  :
                               (id_funct3_w == 3'b110) ? ALU_BLTU :
                               (id_funct3_w == 3'b111) ? ALU_BGEU : ALU_BEQ; // default safe

  assign id_aluop_w = (id_opcode_w == OPCODE_R)       ? id_alu_r_type_w :
                      (id_opcode_w == OPCODE_I_ARITH) ? id_alu_i_type_w :
                      (id_opcode_w == OPCODE_B)       ? id_alu_b_type_w :
                      (id_opcode_w == OPCODE_AUIPC)   ? ALU_ADD :          // typically PC + imm
                      (id_opcode_w == OPCODE_LUI)     ? ALU_ADD : ALU_ADD; // default

  // Non blocking assignments ID
  wire rf_reg_write_w;
  wire [4:0] rf_rd_addr_w;
  wire [31:0] rf_rd_data_w;

  always @ (posedge clk_i) begin
    if (rf_reg_write_w && rf_rd_addr_w != 5'b00000)
      registers[rf_rd_addr_w] <= rf_rd_data_w;
  end

  task reset_id_stage; 
    begin
      idex_jal_r <= 1'b0;
      idex_jalr_r <= 1'b0;
      idex_se_alu_src1_r <= 1'b0;
      idex_se_alu_src2_r <= 1'b0;
      idex_aluop_r <= 4'b0;
      idex_rs1_data_r <= 32'b0;
      idex_rs2_data_r <= 32'b0;
      idex_imm_r <= 32'b0;
      idex_rs1_addr_r <= 5'b0;
      idex_rs2_addr_r <= 5'b0;
      idex_mem_we_r <= 1'b0;
      idex_mem_en_r <= 1'b0;
      idex_width_se_r <= 3'b0;
      idex_wb_se_r <= 2'b0;
      idex_regwrite_r <= 1'b0;
      idex_rd_addr_r <= 5'b0;
      idex_pc_r <= RESET_PC;
    end
  endtask

  always @ (posedge clk_i) begin
    if (rst_i || if_bj_taken_w) begin
      reset_id_stage();
    end else if (~stall_cause_by_mem) begin
      idex_jal_r <= id_jal_w;
      idex_jalr_r <= id_jalr_w;
      idex_se_alu_src1_r <= id_se_alu_src1_w;
      idex_se_alu_src2_r <= id_se_alu_src2_w;
      idex_aluop_r <= id_aluop_w;
      idex_rs1_data_r <= rf_rs1_data_w;
      idex_rs2_data_r <= rf_rs2_data_w;
      idex_imm_r <= id_imm_w;
      idex_rs1_addr_r <= id_rs1_addr_w;
      idex_rs2_addr_r <= id_rs2_addr_w;
      idex_mem_we_r <= id_mem_we_w;
      idex_mem_en_r <= id_mem_en_w;
      idex_width_se_r <= id_width_se_w;
      idex_wb_se_r <= id_wb_se_w;
      idex_regwrite_r <= id_regwrite_w;
      idex_rd_addr_r <= id_rd_addr_w;
      idex_pc_r <= id_pc_w;
    end
  end

  // EX stage wires from ID/EX pipeline registers
  wire ex_jal_w = idex_jal_r;
  wire ex_jalr_w = idex_jalr_r;
  wire ex_alu_src1_w = idex_se_alu_src1_r;
  wire ex_alu_src2_w = idex_se_alu_src2_r;
  wire [3:0] ex_aluop_w = idex_aluop_r;
  wire [31:0] ex_rs1_data_w = idex_rs1_data_r;
  wire [31:0] ex_rs2_data_w = idex_rs2_data_r;
  wire [31:0] ex_imm_w = idex_imm_r;
  wire [4:0] ex_rs1_addr_w = idex_rs1_addr_r;
  wire [4:0] ex_rs2_addr_w = idex_rs2_addr_r;
  wire ex_mem_we_w = idex_mem_we_r;
  wire ex_mem_en_w = idex_mem_en_r;
  wire [2:0] ex_width_se_w = idex_width_se_r;
  wire [1:0] ex_wb_se_w = idex_wb_se_r;
  wire ex_regwrite_w = idex_regwrite_r;
  wire [4:0] ex_rd_addr_w = idex_rd_addr_r;
  wire [31:0] ex_pc_w = idex_pc_r;
  wire [31:0] ex_operand_a_w;
  wire [31:0] ex_operand_b_w;
  wire [31:0] ex_alu_result_w;
  wire [31:0] ex_pc_bj_w;
  wire ex_bj_taken_w;
  wire ex_alu_branch_taken_w;
  wire [3:0] forward_mux_1_w, forward_mux_2_w;
  wire [31:0] forward_src_1_w, forward_src_2_w;

  // EX/if registers
  reg [31:0] exif_pc_bj_r;
  reg exif_bj_taken_r;
  // EX/MEM registers
  reg exmem_mem_we_r;
  reg exmem_mem_en_r;
  reg [2:0] exmem_width_se_r;
  reg exmem_regwrite_r;
  reg [1:0] exmem_wb_se_r;
  reg [4:0] exmem_rd_addr_r;
  reg [31:0] exmem_alu_result_r;
  reg [31:0] exmem_rs2_data_r;
  reg [31:0] exmem_pc_plus_r;

  assign ex_operand_a_w = (ex_alu_src1_w == 1'b1) ? ex_pc_w : forward_src_1_w;
  assign ex_operand_b_w = (ex_alu_src2_w == 1'b1) ? forward_src_2_w : ex_imm_w;

  // ALU
  wire [31:0] ex_add_res_w = ex_operand_a_w + ex_operand_b_w;
  wire [31:0] ex_sub_res_w = ex_operand_a_w - ex_operand_b_w;
  wire [31:0] ex_sll_res_w = ex_operand_a_w << ex_operand_b_w[4:0];
  wire [31:0] ex_srl_res_w = ex_operand_a_w >> ex_operand_b_w[4:0];
  wire [31:0] ex_sra_res_w = ($signed(ex_operand_a_w)) >>> ex_operand_b_w[4:0];
  wire [31:0] ex_xor_res_w = ex_operand_a_w ^ ex_operand_b_w;
  wire [31:0] ex_or_res_w = ex_operand_a_w | ex_operand_b_w;
  wire [31:0] ex_and_res_w = ex_operand_a_w & ex_operand_b_w;
  wire [31:0] ex_slt_res_w = ($signed(ex_operand_a_w) < $signed(ex_operand_b_w)) ? 32'h1 : 32'b0;
  wire [31:0] ex_sltu_res_w = (ex_operand_a_w < ex_operand_b_w) ? 32'h1 : 32'b0;

  assign ex_alu_result_w = (ex_aluop_w == ALU_ADD) ? ex_add_res_w  :
                          (ex_aluop_w == ALU_SUB) ? ex_sub_res_w  :
                          (ex_aluop_w == ALU_SLL) ? ex_sll_res_w  :
                          (ex_aluop_w == ALU_SLT) ? ex_slt_res_w  :
                          (ex_aluop_w == ALU_SLTU) ? ex_sltu_res_w :
                          (ex_aluop_w == ALU_XOR) ? ex_xor_res_w  :
                          (ex_aluop_w == ALU_SRL) ? ex_srl_res_w  :
                          (ex_aluop_w == ALU_SRA) ? ex_sra_res_w  :
                          (ex_aluop_w == ALU_OR) ? ex_or_res_w   :
                          (ex_aluop_w == ALU_AND) ? ex_and_res_w  : 32'b0;

  assign ex_alu_branch_taken_w = (ex_aluop_w == ALU_BEQ) ? (ex_operand_a_w == ex_operand_b_w) :
                              (ex_aluop_w == ALU_BNE) ? (ex_operand_a_w != ex_operand_b_w) :
                              (ex_aluop_w == ALU_BLT) ? ($signed(ex_operand_a_w) <  $signed(ex_operand_b_w)) :
                              (ex_aluop_w == ALU_BGE) ? ($signed(ex_operand_a_w) >= $signed(ex_operand_b_w)) :
                              (ex_aluop_w == ALU_BLTU) ? (ex_operand_a_w < ex_operand_b_w) :
                              (ex_aluop_w == ALU_BGEU) ? (ex_operand_a_w >= ex_operand_b_w) : 1'b0;

  assign ex_pc_bj_w = ex_jalr_w ? ((ex_operand_a_w + ex_imm_w) & 32'hFFFFFFFE) : (ex_pc_w + ex_imm_w);
  assign ex_bj_taken_w = ex_alu_branch_taken_w || ex_jal_w || ex_jalr_w;

  // EX_STAGE
  task reset_ex_regs;
    begin
      exif_pc_bj_r <= 32'b0;
      exif_bj_taken_r <= 1'b0;
      exmem_alu_result_r <= 32'b0;
      exmem_rs2_data_r <= 32'b0;
      exmem_mem_we_r <= 1'b0;
      exmem_mem_en_r <= 1'b0;
      exmem_width_se_r <= 3'b0;
      exmem_wb_se_r <= 2'b0;
      exmem_regwrite_r <= 1'b0;
      exmem_rd_addr_r <= 5'b0;
      exmem_pc_plus_r <= NOP_INSTR;
    end
  endtask

  always @(posedge clk_i) begin
    if (rst_i) begin
      reset_ex_regs();
    end else if (~stall_cause_by_mem) begin
      exif_pc_bj_r <= ex_pc_bj_w;
      exif_bj_taken_r <= ex_bj_taken_w;
      exmem_alu_result_r <= ex_alu_result_w;
      exmem_rs2_data_r <= forward_src_2_w;
      exmem_mem_we_r <= ex_mem_we_w;
      exmem_mem_en_r <= ex_mem_en_w;
      exmem_width_se_r <= ex_width_se_w;
      exmem_wb_se_r <= ex_wb_se_w;
      exmem_regwrite_r <= ex_regwrite_w;
      exmem_rd_addr_r <= ex_rd_addr_w;
      exmem_pc_plus_r <= ex_pc_w + 32'h4;
    end
  end

  assign if_pc_bj_w = exif_pc_bj_r;
  assign if_bj_taken_w = exif_bj_taken_r;

  wire [31:0] mem_alu_result_w = exmem_alu_result_r;
  wire [31:0] mem_rs2_data_w = exmem_rs2_data_r;
  wire mem_mem_we_w = exmem_mem_we_r;
  wire mem_mem_en_w = exmem_mem_en_r;
  wire [2:0] mem_width_se_w = exmem_width_se_r;
  wire [1:0] mem_wb_se_w = exmem_wb_se_r;
  wire mem_regwrite_w = exmem_regwrite_r;
  wire [4:0] mem_rd_addr_w = exmem_rd_addr_r;
  wire [31:0] mem_pc_plus_w = exmem_pc_plus_r;

  wire [31:0] mem_data_w = dmem_data_i;
  assign stall_cause_by_mem = mem_mem_en_w ? ~mem_mem_we_w : 1'b0;

  assign dmem_we_o = mem_mem_we_w;
  assign dmem_en_o = mem_mem_en_w;
  assign dmem_addr_o = mem_alu_result_w;
  assign dmem_data_o = mem_rs2_data_w;
  assign dmem_width_se_o = mem_width_se_w;

    // MEM_STAGE registers
  reg        memwb_regwrite_r;
  reg [4:0]  memwb_rd_addr_r;
  reg [1:0]  memwb_wb_se_r;
  reg [31:0] memwb_pc_plus_r;
  reg [31:0] memwb_alu_result_r;
  reg [31:0] memwb_mem_data_r;

  task reset_MEM_to_WB_reg;
    begin
      memwb_regwrite_r   <= 0;
      memwb_rd_addr_r    <= 5'b0;
      memwb_wb_se_r      <= 2'b0;
      memwb_pc_plus_r    <= 32'b0;
      memwb_alu_result_r <= 32'b0;
      memwb_mem_data_r   <= 32'b0;
    end
  endtask

  always @(posedge clk_i) begin
    if (rst_i) begin
      reset_MEM_to_WB_reg();
    end else begin
      memwb_wb_se_r      <= mem_wb_se_w;
      memwb_alu_result_r <= mem_alu_result_w;
      memwb_mem_data_r   <= mem_data_w;
      memwb_pc_plus_r    <= mem_pc_plus_w;
      memwb_regwrite_r   <= mem_regwrite_w;
      memwb_rd_addr_r    <= mem_rd_addr_w;
    end
  end

  wire [1:0] wb_sel_w = memwb_wb_se_r;
  wire [31:0] wb_alu_result_w = memwb_alu_result_r;
  wire [31:0] wb_mem_data_w = memwb_mem_data_r;
  wire [31:0] wb_pc_plus_w = memwb_pc_plus_r;

  wire wb_regwrite_w = memwb_regwrite_r;
  wire [4:0] wb_rd_addr_w = memwb_rd_addr_r;
  wire [31:0] wb_data_w;

  assign wb_data_w = (wb_sel_w == 2'b00) ? wb_alu_result_w :
                     (wb_sel_w == 2'b01) ? wb_mem_data_w   :
                     (wb_sel_w == 2'b10) ? wb_pc_plus_w    : 32'b0;

  assign rf_reg_write_w = wb_regwrite_w;
  assign rf_rd_addr_w = wb_rd_addr_w;
  assign rf_rd_data_w = wb_data_w;

  wire exmem_match_1_w, exmem_match_2_w, memwb_match_1_w, memwb_match_2_w;

  assign exmem_match_1_w = exmem_regwrite_r && (ex_rs1_addr_w == exmem_rd_addr_r) && (ex_rs1_addr_w != 5'b00000);
  assign exmem_match_2_w = exmem_regwrite_r && (ex_rs2_addr_w == exmem_rd_addr_r) && (ex_rs2_addr_w != 5'b00000);
  assign memwb_match_1_w = memwb_regwrite_r && (ex_rs1_addr_w == memwb_rd_addr_r) && (ex_rs1_addr_w != 5'b00000);
  assign memwb_match_2_w = memwb_regwrite_r && (ex_rs2_addr_w == memwb_rd_addr_r) && (ex_rs2_addr_w != 5'b00000);

  // wb_se = 01 memory; 10 PC + 4; 00 ALU
  assign forward_mux_1_w = (exmem_match_1_w && (exmem_wb_se_r == 2'b00)) ? 4'b0001 :
                           (exmem_match_1_w && (exmem_wb_se_r == 2'b10)) ? 4'b0010 :
                           (memwb_match_1_w && (memwb_wb_se_r == 2'b00)) ? 4'b0110 :
                           (memwb_match_1_w && (memwb_wb_se_r == 2'b01)) ? 4'b0111 :
                           (memwb_match_1_w && (memwb_wb_se_r == 2'b10)) ? 4'b1000 : 4'b0000;

  assign forward_mux_2_w = (exmem_match_2_w && (exmem_wb_se_r == 2'b00)) ? 4'b0001 :
                           (exmem_match_2_w && (exmem_wb_se_r == 2'b10)) ? 4'b0010 :
                           (memwb_match_2_w && (memwb_wb_se_r == 2'b00)) ? 4'b0110 :
                           (memwb_match_2_w && (memwb_wb_se_r == 2'b01)) ? 4'b0111 :
                           (memwb_match_2_w && (memwb_wb_se_r == 2'b10)) ? 4'b1000 : 4'b0000;

  assign forward_src_1_w = (forward_mux_1_w == 4'b1000) ? memwb_pc_plus_r    :
                           (forward_mux_1_w == 4'b0111) ? memwb_mem_data_r   :
                           (forward_mux_1_w == 4'b0110) ? memwb_alu_result_r :
                           (forward_mux_1_w == 4'b0010) ? exmem_pc_plus_r    :
                           (forward_mux_1_w == 4'b0001) ? exmem_alu_result_r : ex_rs1_data_w;

  assign forward_src_2_w = (forward_mux_2_w == 4'b1000) ? memwb_pc_plus_r    :
                           (forward_mux_2_w == 4'b0111) ? memwb_mem_data_r   :
                           (forward_mux_2_w == 4'b0110) ? memwb_alu_result_r :
                           (forward_mux_2_w == 4'b0010) ? exmem_pc_plus_r    :
                           (forward_mux_2_w == 4'b0001) ? exmem_alu_result_r : ex_rs2_data_w;

endmodule
