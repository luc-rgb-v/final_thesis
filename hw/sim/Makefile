# ============================================================
# Questa / ModelSim Verification Flow
# ============================================================

# -------- user-configurable variables --------
TESTNAME  ?= test_inigow
TB_NAME   ?= testbench
RADIX     ?= decimal

# -------- directories --------
LOG_DIR   := log
UCDB_DIR  := ucdb
COV_DIR   := coverage
WORK_DIR  := work

# -------- files --------
RTL_FILE  := rtl.f
TB_FILE   := testbench.v

UCDB_MERGED := IP.ucdb

# -------- tools --------
VLIB   := vlib
VMAP   := vmap
VLOG   := vlog
VSIM   := vsim
VCOVER := vcover
VERILATOR := verilator

# -------- vlog flags --------
VLOG_COV_FLAGS := +cover=bcesft
VSIM_COV_FLAGS := -coverage -voptargs="+cover=bcesft"

# ============================================================
# Lint / DRC
# ============================================================
drc: $(RTL_FILE)
	@echo "== Running Verilator lint =="
	$(VERILATOR) --lint-only -Wall -I../src -f $(RTL_FILE)

# ============================================================
# Build
# ============================================================
build:
	@echo "== Build (no coverage) =="
	$(VLIB) $(WORK_DIR)
	$(VMAP) $(WORK_DIR) $(WORK_DIR)
	$(VLOG) -f $(RTL_FILE) $(TB_FILE)

build_cov:
	@echo "== Build (with coverage) =="
	$(VLIB) $(WORK_DIR)
	$(VMAP) $(WORK_DIR) $(WORK_DIR)
	$(VLOG) $(VLOG_COV_FLAGS) -f $(RTL_FILE) $(TB_FILE)

# ============================================================
# Run simulation
# ============================================================
run: build
	@echo "== Running simulation =="
	mkdir -p $(LOG_DIR)
	$(VSIM) -debugDB -assertdebug -c \
	  -l $(TESTNAME).log \
	  -voptargs=+acc \
	  $(TB_NAME) \
	  -do "log -r /*; run -all; quit"
	cp -f $(TESTNAME).log sim.log
	mv $(TESTNAME).log $(LOG_DIR)/

run_cov: build_cov
	@echo "== Running simulation (coverage) =="
	mkdir -p $(LOG_DIR) $(UCDB_DIR)
	$(VSIM) $(VSIM_COV_FLAGS) -assertdebug -c \
	  -l $(TESTNAME).log \
	  $(TB_NAME) \
	  -do "coverage save -onexit $(TESTNAME).ucdb; log -r /*; run -all; quit"
	cp -f $(TESTNAME).log sim.log
	mv $(TESTNAME).log $(LOG_DIR)/
	mv $(TESTNAME).ucdb $(UCDB_DIR)/

# ============================================================
# Coverage processing
# ============================================================
gen_cov: run_cov
	@echo "== Generating coverage reports (text) =="
	mkdir -p $(COV_DIR)
	$(VCOVER) merge $(UCDB_MERGED) $(UCDB_DIR)/*.ucdb
	$(VCOVER) report $(UCDB_MERGED) \
	  -output $(COV_DIR)/summary_report.txt
	$(VCOVER) report -zeros -detail -code bcesft \
	  -annotate -codeAll $(UCDB_MERGED) \
	  -output $(COV_DIR)/detail_report.txt

gen_ucdb_cov: $(UCDB_DIR)
	@echo "== Generating coverage reports (text) =="
	mkdir -p $(COV_DIR)
	$(VCOVER) merge $(UCDB_MERGED) $(UCDB_DIR)/*.ucdb
	$(VCOVER) report $(UCDB_MERGED) \
	  -output $(COV_DIR)/summary_report.txt
	$(VCOVER) report -zeros -detail -code bcesft \
	  -annotate -codeAll $(UCDB_MERGED) \
	  -output $(COV_DIR)/detail_report.txt
	$(VCOVER) report -zeros -details \
	  -code bcesft \
	  -annotate -testhitdataAll \
	  -html $(UCDB_MERGED)

gen_html: run_cov
	@echo "== Generating coverage HTML report =="
	mkdir -p $(COV_DIR)
	$(VCOVER) merge $(UCDB_MERGED) $(UCDB_DIR)/*.ucdb
	$(VCOVER) report -zeros -details \
	  -code bcesft \
	  -annotate -testhitdataAll \
	  -html $(UCDB_MERGED)

view_cov: gen_cov
	@echo "== Viewing merged coverage =="
	$(VSIM) -gui -viewcov $(UCDB_MERGED) &

# ============================================================
# Waveform viewing
# ============================================================
wave: run
	@echo "== Opening waveform viewer =="
	$(VSIM) -i -view vsim.wlf \
	  -do "add wave vsim:/$(TB_NAME)/*; radix -$(RADIX)" &

# ============================================================
# Clean
# ============================================================
clean:
	@echo "== Cleaning project =="
	rm -rf \
	  $(WORK_DIR) \
	  $(LOG_DIR) \
	  $(COV_DIR) \
	  *.ucdb *.log *.wlf \
	  vsim.dbg transcript \
	  modelsim.ini *.ini \
	  covhtmlreport

clean_all:
	@echo "== Cleaning project =="
	rm -rf \
	  $(WORK_DIR) \
	  $(LOG_DIR) \
	  $(UCDB_DIR) \
	  $(COV_DIR) \
	  *.ucdb *.log *.wlf \
	  vsim.dbg transcript \
	  modelsim.ini *.ini \
	  covhtmlreport

.PHONY: \
	drc build build_cov \
	run run_cov \
	gen_cov gen_html view_cov gen_ucdb_cov\
	wave clean
