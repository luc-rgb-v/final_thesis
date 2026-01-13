# ============================================================
# RISC-V RV32I Spike Flow
# ============================================================

# -------- tools --------
CC      := riscv32-unknown-elf-gcc
OBJDUMP := riscv32-unknown-elf-objdump
OBJCOPY := riscv32-unknown-elf-objcopy
SPIKE   := spike
HEXDUMP := hexdump

# -------- testcase --------
TESTCASE ?= dmem_access
ASM_DIR  := assembly

# -------- files --------
SRC      := $(ASM_DIR)/$(TESTCASE).S
ELF      ?= $(TESTCASE).elf
LOG      := spike.log

REGMEM   := registers.mem
DATAMEM  := data.mem

IMEM_BIN := instructions.bin
IMEM_HEX := instructions.hex
IMEM_COE := instructions.coe
IMEM_MEM := instructions.mem

# -------- linker --------
LINKER   := linker.ld

# -------- flags --------
CFLAGS   := -march=rv32i -mabi=ilp32 -nostdlib
LDFLAGS  := -Wl,-e,_start -T $(LINKER)

# -------- Spike options --------
SPIKE_ISA   := rv32i
SPIKE_PC    := 0x80000000
SPIKE_INST  := 2000
SPIKE_FLAGS := --isa=$(SPIKE_ISA) \
               --log-commits \
               --pc=$(SPIKE_PC) \
               --instructions=$(SPIKE_INST)

# -------- objcopy --------
TEXT_SECTIONS := --only-section=.text --only-section=.rodata

# ============================================================
# Default target
# ============================================================
all: run mem instructions

# ============================================================
# Build ELF
# ============================================================
$(ELF): $(SRC) $(LINKER)
	@echo "== Building ELF: $@ =="
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

# ============================================================
# Run Spike (batch mode)
# ============================================================
run: $(ELF)
	@echo "== Running Spike =="
	$(SPIKE) $(SPIKE_FLAGS) $(ELF) > $(LOG) 2>&1

# ============================================================
# Instruction memory generation
# ============================================================
instructions: $(IMEM_BIN) $(IMEM_HEX) $(IMEM_COE)
	@echo "== Instruction memory generated =="

$(IMEM_BIN): $(ELF)
	@echo "  -> $@"
	$(OBJCOPY) -O binary $(TEXT_SECTIONS) $< $@

$(IMEM_HEX): $(IMEM_BIN)
	@echo "  -> $@"
	$(HEXDUMP) -v -e '1/4 "%08X\n"' $< > $@
	cp $@ $(IMEM_MEM)

$(IMEM_COE): $(IMEM_BIN)
	@echo "  -> $@"
	@echo "memory_initialization_radix=16;" >  $@
	@printf "memory_initialization_vector=" >> $@
	@$(HEXDUMP) -v -e '1/4 "%08X "' $< >> $@
	@echo ";" >> $@

# ============================================================
# Register & data memory extraction
# ============================================================
mem: run
	@echo "== Extracting registers =="
	grep -E " x[0-9]+ " $(LOG) | \
	awk '{ \
	  for(i=1;i<=NF;i++){ \
	    if($$i ~ /^x[0-9]+$$/){ \
	      r[$$i] = $$(i+1); \
	    } \
	  } \
	} \
	END{ \
	  for(i=0;i<32;i++){ \
	    k="x"i; \
	    if(k in r) printf "%08x\n", strtonum(r[k]); \
	    else       printf "00000000\n"; \
	  } \
	}' > $(REGMEM)

	@echo "== Extracting data memory =="
	grep -E " mem 0x[0-9a-fA-F]+ 0x" $(LOG) | \
	awk '{ \
	  for(i=1;i<=NF;i++){ \
	    if($$i=="mem"){ \
	      printf "%08x%08x\n", strtonum($$(i+1)), strtonum($$(i+2)); \
	    } \
	  } \
	}' > $(DATAMEM)

# ============================================================
# Clean
# ============================================================
clean:
	@echo "== Cleaning generated files =="
	rm -f \
	  $(ELF) $(LOG) \
	  $(REGMEM) $(DATAMEM) \
	  $(IMEM_BIN) $(IMEM_HEX) $(IMEM_COE) $(IMEM_MEM)

.PHONY: all run mem instructions clean
