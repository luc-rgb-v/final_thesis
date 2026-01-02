# ==================================================
# Project paths
# ==================================================
ROOT_DIR      := ..
TESTCASE_DIR  := $(ROOT_DIR)/testcases/instructions

TB_DIR        := $(ROOT_DIR)/tb
TB_COMP_DIR   := $(TB_DIR)/components
LOG_DIR 	  	:= log/$(TESTNAME)

# ==================================================
# Input file lists
# ==================================================
TEST_F        := $(TESTCASE_DIR)/tests.f
TB_F          := tb.f
INFO_V        := $(TB_COMP_DIR)/info

# ==================================================
# Build & Run
# ==================================================
build:
	@echo "== BUILD =="
	@mkdir -p $(WORK_DIR)
	vlib $(WORK_DIR)
	vmap work $(WORK_DIR)
	vlog -f compile.f

run:
	@echo "== RUN =="
	vsim -debugDB \
	  -voptargs=+acc \
	  -assertdebug \
	  -c $(TB_NAME) \
	  -l $(TESTNAME).log \
	  -do "log -r /*; run -all; quit -f"
	@$(MAKE) collect_logs


# ==================================================
# Coverage
# ==================================================
build_cov:
	@echo "== BUILD (COVERAGE) =="
	@mkdir -p $(WORK_DIR)
	vlib $(WORK_DIR)
	vmap work $(WORK_DIR)
	vlog +cover=bcesft -f compile.f

run_cov:
	@echo "== RUN (COVERAGE) =="
	@mkdir -p $(LOG_DIR) $(UCDB_DIR)
	vsim -coverage \
	  -voptargs="+cover=bcesft" \
	  -assertdebug \
	  -c $(TB_NAME) \
	  -l $(TESTNAME).log \
	  -do "coverage save -onexit $(UCDB_DIR)/$(TESTNAME).ucdb; log -r /*; run -all; quit -f"
	@$(MAKE) collect_logs

gen_cov: run_cov
	@echo "== GENERATING COVERAGE REPORTS =="
	@mkdir -p $(COV_DIR)
	vcover merge $(COV_DB) $(UCDB_DIR)/*.ucdb
	vcover report $(COV_DB) \
	  -output $(COV_DIR)/summary_report.txt
	vcover report -zeros -detail -code bcesft \
	  -annotate -All -codeAll $(COV_DB) \
	  -output $(COV_DIR)/detail_report.txt

gen_html: run_cov
	@echo "== GENERATING HTML COVERAGE =="
	@mkdir -p $(COV_DIR)
	vcover merge $(COV_DB) $(UCDB_DIR)/*.ucdb
	vcover report -zeros -details -code bcesft \
	  -annotate -testhitdataAll \
	  -html $(COV_DB)

view_cov: run_cov
	@echo "== VIEW COVERAGE =="
	vsim -gui -viewcov $(UCDB_DIR)/$(TESTNAME).ucdb &

# ==================================================
# Utilities
# ==================================================
wave:
	@echo "== OPENING WAVEFORM =="
	vsim -i -view vsim.wlf \
	  -do "add wave vsim:/$(TB_NAME)/*; radix -$(RADIX)" &

drc:
	verilator --lint-only -Wall -f rtl.f

collect_logs:
	@echo "== COLLECT LOGS =="
	@mkdir -p $(LOG_DIR)
	@find . -maxdepth 1 -type f \( \
	    -name "*.log" -o \
	    -name "report.txt" -o \
	    -name "transcript" -o \
	    -name "vsim.dbg" \
	  \) -exec sh -c ' \
	    for f do \
	      echo "  moving $$f -> $(LOG_DIR)"; \
	      mv -f "$$f" "$(LOG_DIR)"; \
	    done \
	  ' sh {} +

# ==================================================
# Clean
# ==================================================
clean:
	@rm -rf $(WORK_DIR) $(LOG_DIR) $(UCDB_DIR)
	@rm -rf vsim.dbg transcript *.ini *.wlf *.log *.ucdb
	@rm -rf $(COV_DIR) covhtmlreport
	@rm -f $(OUT_TEST) $(OUT_TESTBENCH)
	@rm -f $(TMP_ALL)
	@echo "Cleaned!"
