# ============================================================
# RISC-V RV32I Spike Flow
# ============================================================
SIM_DIR     := sim
SUPPORT_DIR := support
TB_DIR      := tb
VIVADO      := vivado
SCRIPTS_DIR := scripts
LIC_DIR		:= license
WIN_BAT     := D:\Github\final_thesis\hw\scripts\run_vivado.bat

# ============================================================
# Config variable build assembly
# ------------------------------------------------------------
#export TESTNAME ?= branch_jump
#export TESTNAME ?= arithmetic_instr
#export TESTNAME ?= dmem_access
#export TESTNAME ?= uart_s_sim
#export TESTNAME ?= i2c_assembly
#export TESTNAME ?= main_assembly
export TESTNAME ?= test_instructions
#export TESTNAME ?= sum_1_to_10
#export TESTNAME ?= fibonacci
#export TESTNAME ?= bubble_sort
#export TESTNAME ?= factorial

# ============================================================
# Config variable build c file
# ------------------------------------------------------------
#export C_TESTCASE ?= add
# ============================================================

export TESTCASE = $(TESTNAME)

TESTCASEVERILOG = $(TESTCASE).v
#TESTCASEVERILOG = $(C_TESTCASE).v

TESTCASE_DIR 	= testcases

FILES_SUPPORT 	:= instructions.mem data.mem registers.mem
FILES_TB 		:= testbench.v

# ------------------------------------------------------------
# 
# ------------------------------------------------------------
.PHONY: clean ca cv a b d e f g h vivado drc help license

a: build_run_console
b: build_run_cov_all_testcase
d: build_run_cov_all_testcase_gui
e: build_run_cov_all_testcase_html
f: build_run_gui_wave
g: fw_spike_build
h: gen_IP_cov_html_cov
# ------------------------------------------------------------
# Build instructions.mem data.mem registers.mem
# ------------------------------------------------------------
fw_spike_build:
	$(MAKE) -C $(SUPPORT_DIR) all_asm
#	$(MAKE) -C $(SUPPORT_DIR) all_c

fw_clean:
	$(MAKE) -C $(SUPPORT_DIR) clean

# ------------------------------------------------------------
# Simulation / Questa flow (sim)
# ------------------------------------------------------------
build_run_console: build_sim_copy
	$(MAKE) -C $(SIM_DIR) run

build_run_gui_wave: build_sim_copy
	$(MAKE) -C $(SIM_DIR) wave

build_run_cov_all_testcase: build_sim_copy
	$(MAKE) -C $(SIM_DIR) gen_cov

build_run_cov_all_testcase_gui: build_sim_copy
	$(MAKE) -C $(SIM_DIR) view_cov

build_run_cov_all_testcase_html: build_sim_copy
	$(MAKE) -C $(SIM_DIR) gen_html

gen_IP_cov_html_cov:
	$(MAKE) -C $(SIM_DIR) gen_ucdb_cov

sim_clean:
	$(MAKE) -C $(SIM_DIR) clean

sim_clean_all:
	$(MAKE) -C $(SIM_DIR) clean_all

group:
	make b TESTNAME:=branch_jump
	make b TESTNAME:=arithmetic_instr
	make b TESTNAME:=dmem_access
	make b TESTNAME:=i2c_assembly
	make b TESTNAME:=uart_s_sim
	make b TESTNAME:=i2c_assembly
	make b TESTNAME:=sum_1_to_10
	make b TESTNAME:=fibonacci
	make b TESTNAME:=bubble_sort
	make b TESTNAME:=factorial
	$(MAKE) -C $(SIM_DIR) gen_cov
	$(MAKE) -C $(SIM_DIR) view_cov

build_sim_copy: fw_spike_build
	@echo "Copying files to $(SIM_DIR)..."
	@mkdir -p $(SIM_DIR)

	@for f in $(FILES_SUPPORT); do \
		cp $(SUPPORT_DIR)/$$f $(SIM_DIR)/; \
	done

	@for f in $(FILES_TB); do \
		cp $(TB_DIR)/$$f $(SIM_DIR)/; \
	done

	@echo "Creating sim/testcase.v from testcases/$(TESTCASEVERILOG)"
	@cp $(TESTCASE_DIR)/$(TESTCASEVERILOG) $(SIM_DIR)/testcase.v

	@echo "Done."

drc:
	$(MAKE) -C $(SIM_DIR) drc

vivado:
	$(MAKE) -C $(SUPPORT_DIR) instructions
	cmd.exe /c "$(WIN_BAT)"

license:
	$(MAKE) -C $(LIC_DIR) all

help:
	@echo "=================================================================================="
	@echo "vivado  -vivado gui"
	@echo "drc     -design rule check"
	@echo "a       -build_run_console | build run"
	@echo "f       -build_run_gui_wave | build run wave"
	@echo "b       -build_run_cov_all_testcase | build_cov run_cov gen_cov"
	@echo "d       -build_run_cov_all_testcase_gui | build_cov run_cov gen_cov view_cov"
	@echo "e       -build_run_cov_all_testcase_html | build_cov run_cov gen_html"
	@echo "g       -fw_spike_build | instructions.mem data.mem registers.mem"
	@echo "h       -gen_IP_cov_html_cov | generate coverage report & html report from IP.ucdb"
	@echo "ca      -clean anything fw_clean | sim_clean_all"
	@echo "cv      -clean make vivado"
	@echo "clean   -clean anything accept '/sim/ucdb' fw_clean | sim_clean"
	@echo "=================================================================================="

# ---------------------------------------------------------
cv: fw_clean sim_clean
	@rm -rf .Xil
	@rm -rf top_sys_vivado \
			$(SCRIPTS_DIR)/*.log \
			$(SCRIPTS_DIR)/*.jou \
			$(SCRIPTS_DIR)/*.str
	@rm -rf ./*.log \
					./*.jou \
					./*.str

clean: fw_clean sim_clean
	@echo "Removing copied files from $(SIM_DIR)..."
	@rm -f $(SIM_DIR)/instructions.mem \
	       $(SIM_DIR)/data.mem \
	       $(SIM_DIR)/registers.mem \
	       $(SIM_DIR)/testbench.v \
	       $(SIM_DIR)/testcase.v
	@echo "Clean done."

ca: fw_clean sim_clean_all
	@echo "Removing copied files from $(SIM_DIR)..."
	@rm -rf .Xil
	@rm -f $(SUPPORT_DIR)/*.elf
	@rm -rf ./*.log \
					./*.jou \
					./*.str
	@rm -rf top_sys_vivado \
			$(SCRIPTS_DIR)/*.log \
			$(SCRIPTS_DIR)/*.jou \
			$(SCRIPTS_DIR)/*.str
	@rm -f $(SIM_DIR)/instructions.mem \
	       $(SIM_DIR)/data.mem \
	       $(SIM_DIR)/registers.mem \
	       $(SIM_DIR)/testbench.v \
	       $(SIM_DIR)/testcase.v
	@echo "Clean done."
