# ==================================================
# Project paths
# ==================================================
ROOT_DIR      := ..
TESTCASE_DIR  := $(ROOT_DIR)/testcases/instructions
TB_DIR        := $(ROOT_DIR)/tb
TB_COMP_DIR   := $(TB_DIR)/components
LOG_DIR := log/$(TESTNAME)

# ==================================================
# Input file lists
# ==================================================
TEST_F        := $(TESTCASE_DIR)/tests.f
TB_F          := tb.f
INFO_V        := $(TB_COMP_DIR)/info

# ==================================================
# Generated outputs
# ==================================================
OUT_TEST      := test.v
OUT_TESTBENCH := testbench.v

# ==================================================
# Temporary files
# ==================================================
TMP_INFO       := .tb_info.tmp
TMP_COMPONENTS := .tb_components.tmp
TMP_TASKS      := .tb_tasks.tmp
TMP_TEST_CALLS := .test_calls.tmp
TMP_ALL        := $(TMP_INFO) $(TMP_COMPONENTS) $(TMP_TASKS) $(TMP_TEST_CALLS)

# ==================================================
# File lists (CRLF-safe)
# ==================================================
TEST_SRCS := $(shell sed 's/\r$$//' $(TEST_F) | sed '/^#/d;/^$$/d')
TB_SRCS   := $(shell sed 's/\r$$//' $(TB_F)   | sed '/^#/d;/^$$/d')

# ==================================================
# Simulation configuration
# ==================================================
TESTNAME ?= test
TB_NAME  ?= testbench
RADIX    ?= decimal

WORK_DIR := work
UCDB_DIR := ucdb

# ==================================================
# Coverage paths
# ==================================================
COV_DIR := coverage
COV_DB  := $(COV_DIR)/IP.ucdb

# ==================================================
# Helpers
# ==================================================
define STRIP_CRLF
sed 's/\r$$//' $(1)
endef

# ==================================================
# Phony targets
# ==================================================
.PHONY: \
  all all_wave all_cov \
  gen_test gen_tb \
  build build_cov \
  run run_cov \
  gen_cov gen_html view_cov \
  collect_logs \
  wave drc clean

# ==================================================
# Top-level flows
# ==================================================
all: gen_test gen_tb build run
all_wave: gen_test gen_tb build run wave
all_cov: gen_test gen_tb build_cov run_cov gen_cov

# ==================================================
# Generate test.v (from testcases/tests.f)
# ==================================================
gen_test: $(OUT_TEST)

$(OUT_TEST): $(TEST_F)
	@echo "== Generating $(OUT_TEST) =="
	@rm -f $@
	@for f in $(TEST_SRCS); do \
	  echo "// ===== $$f =====" >> $@; \
	  $(call STRIP_CRLF,$(TESTCASE_DIR)/$$f) >> $@; \
	  echo "" >> $@; \
	done

# ==================================================
# Generate testbench.v
# ==================================================
gen_tb: $(OUT_TESTBENCH)

$(OUT_TESTBENCH): $(OUT_TEST) $(TB_F)
	@echo "== Generating $(OUT_TESTBENCH) =="
	@rm -f $@ $(TMP_ALL)

	# 1) Copy testbench template
	@$(call STRIP_CRLF,$(TB_DIR)/test.v) > $@

	# 2) Insert info.v after `timescale
	@if [ -f $(INFO_V) ]; then \
	  $(call STRIP_CRLF,$(INFO_V)) > $(TMP_INFO); \
	  sed -i '/^`timescale[[:space:]]/r $(TMP_INFO)' $@; \
	fi

	# 3) Validate required markers
	@grep -q '__TB_COMPONENTS__' $@ || (echo "ERROR: __TB_COMPONENTS__ missing"; exit 1)
	@grep -q '__TB_TASKS__'      $@ || (echo "ERROR: __TB_TASKS__ missing"; exit 1)
	@grep -q '__TEST_INCLUDE__'  $@ || (echo "ERROR: __TEST_INCLUDE__ missing"; exit 1)
	@grep -q '__TEST_CALLS__'    $@ || (echo "ERROR: __TEST_CALLS__ missing"; exit 1)

	# 4) Collect TB components (components/* except info.v)
	@for f in $(TB_SRCS); do \
	  case "$$f" in \
	    components/info.v) ;; \
	    components/*) \
	      $(call STRIP_CRLF,$(TB_DIR)/$$f) >> $(TMP_COMPONENTS); \
	      echo "" >> $(TMP_COMPONENTS); \
	      ;; \
	  esac; \
	done

	# 5) Collect TB tasks (task/*)
	@for f in $(TB_SRCS); do \
	  case "$$f" in \
	    task/*) \
	      $(call STRIP_CRLF,$(TB_DIR)/$$f) >> $(TMP_TASKS); \
	      echo "" >> $(TMP_TASKS); \
	      ;; \
	  esac; \
	done

	# 6) Insert components and tasks
	@sed -i '/\/\*__TB_COMPONENTS__\*\//r $(TMP_COMPONENTS)' $@
	@sed -i '/\/\*__TB_TASKS__\*\//r $(TMP_TASKS)' $@

	# 7) Insert test include
	@sed -i '/\/\*__TEST_INCLUDE__\*\//a \`include "test.v"' $@

	# 8) Generate test calls from test.v
	@$(call STRIP_CRLF,$(OUT_TEST)) | \
	  grep -E '^[[:space:]]*task[[:space:]]+[a-zA-Z0-9_]+' | \
	  sed -E 's/.*task[[:space:]]+([a-zA-Z0-9_]+).*/    \1();/' \
	  > $(TMP_TEST_CALLS)

	@sed -i '/\/\*__TEST_CALLS__\*\//r $(TMP_TEST_CALLS)' $@

	# 9) Cleanup
	@rm -f $(TMP_ALL)

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
