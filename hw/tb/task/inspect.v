`ifdef _INSPECT_

  task initial_log; begin
      if_log = $fopen("if_stage.log", "w");
      $fdisplay(if_log, "======== IF stage inspect ========");
      id_log = $fopen("id_stage.log", "w");
      $fdisplay(id_log, "======== ID stage inspect ========");
      ex_log = $fopen("ex_stage.log", "w");
      $fdisplay(ex_log, "======== EX stage inspect ========");
      mem_log = $fopen("mem_stage.log", "w");
      $fdisplay(mem_log, "======== MEM stage inspect ========");
      wb_log = $fopen("write_back.log", "w");
      $fdisplay(wb_log, "======== WB stage inspect ========");
    end
  endtask

  task inspect_all_reg; begin
      log_if();
      log_id();
      log_ex();
      log_mem();
      log_wb();
    end
  endtask

  task log_if; begin
    $fdisplay(if_log,
        "[%0t][IF] pc_r=%h | ifid_pc_r=%h | ifid_instruction_r=%h | pc_sub_r=%h | imem_en_r=%b",
        $time,
        dut.pc_r,
        dut.ifid_pc_r,
        dut.ifid_instruction_r,
        dut.pc_sub_r,
        dut.imem_en_r
      );
    end
  endtask

  task log_id; begin
    $fdisplay(id_log,
        "[%0t][ID] idex_imm_r=%h | idex_rs1_data_r=%h | idex_rs2_data_r=%h | idex_pc_r=%h | idex_jal_r=%b | idex_jalr_r=%b | idex_se_alu_src1_r=%h | idex_se_alu_src2_r=%h | idex_aluop_r=%b | idex_rs1_addr_r=%b | idex_rs2_addr_r=%b | idex_mem_en_r=%b | idex_mem_we_r=%b | idex_width_se_r=%b | idex_wb_se_r=%b | idex_regwrite_r=%b | idex_rd_addr_r=%b",
        $time,
        dut.idex_imm_r,
        dut.idex_rs1_data_r,
        dut.idex_rs2_data_r,
        dut.idex_pc_r,
        dut.idex_jal_r,
        dut.idex_jalr_r,
        dut.idex_se_alu_src1_r,
        dut.idex_se_alu_src2_r,
        dut.idex_aluop_r,
        dut.idex_rs1_addr_r,
        dut.idex_rs2_addr_r,
        dut.idex_mem_en_r,
        dut.idex_mem_we_r,
        dut.idex_width_se_r,
        dut.idex_wb_se_r,
        dut.idex_regwrite_r,
        dut.idex_rd_addr_r
      );
    end
  endtask

  task log_ex; begin
    $fdisplay(ex_log,
        "[%0t][EX] exif_pc_bj_r=%h | exif_bj_taken_r=%b | exmem_mem_we_r=%b | exmem_mem_en_r=%b | exmem_width_se_r=%b | exmem_regwrite_r=%b | exmem_wb_se_r=%b | exmem_rd_addr_r=%b | exmem_alu_result_r=%h | exmem_rs2_data_r=%h | exmem_pc_plus_r=%h",
        $time,
        dut.exif_pc_bj_r,
        dut.exif_bj_taken_r,
        dut.exmem_mem_we_r,
        dut.exmem_mem_en_r,
        dut.exmem_width_se_r,
        dut.exmem_regwrite_r,
        dut.exmem_wb_se_r,
        dut.exmem_rd_addr_r,
        dut.exmem_alu_result_r,
        dut.exmem_rs2_data_r,
        dut.exmem_pc_plus_r
      );
    end
  endtask

  task log_mem; begin
    $fdisplay(mem_log,
        "[%0t][MEM] memwb_regwrite_r=%b | memwb_rd_addr_r=%b | memwb_wb_se_r=%h | memwb_pc_plus_r=%h | memwb_alu_result_r=%h | memwb_mem_data_r=%h",
        $time,
        dut.memwb_regwrite_r,
        dut.memwb_rd_addr_r,
        dut.memwb_wb_se_r,
        dut.memwb_pc_plus_r,
        dut.memwb_alu_result_r,
        dut.memwb_mem_data_r
      );
    end
  endtask

  task log_wb; begin
      $fdisplay(wb_log,
        "[%0t][WB] rf_reg_write_w=%b | rf_rd_addr_w=%h | rf_rd_data_w=%h",
        $time,
        dut.rf_reg_write_w,
        dut.rf_rd_addr_w,
        dut.rf_rd_data_w,
      );
    end
  endtask

`endif
