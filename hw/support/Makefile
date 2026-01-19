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
TESTCASE   ?= dmem_access
C_TESTCASE ?= add

ASM_DIR := assembly
C_DIR   := c_program

# -------- sources --------
ASM_SRC := $(ASM_DIR)/$(TESTCASE).S
C_SRC   := $(C_DIR)/$(C_TESTCASE).c

# -------- outputs --------
ASM_ELF := $(TESTCASE).elf
C_ELF   := $(C_TESTCASE).elf

LOG := spike.log

REGMEM  := registers.mem
DATAMEM := data.mem

IMEM_BIN := instructions.bin
IMEM_HEX := instructions.hex
IMEM_COE := instructions.coe
IMEM_MEM := instructions.mem

# -------- linker --------
LINKER := linker.ld

# -------- flags --------
CFLAGS  := -march=rv32i -mabi=ilp32 -nostdlib
LDFLAGS := -Wl,-e,_start -T $(LINKER)

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
# Entry points
# ============================================================

all_asm: run_asm mem_asm instructions_asm
all_c:   run_c   mem_c   instructions_c

# ============================================================
# Build ELF
# ============================================================

$(ASM_ELF): $(ASM_SRC) $(LINKER)
	@echo "== Building ASM ELF: $@ =="
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

$(C_ELF): $(C_SRC) $(LINKER)
	@echo "== Building C ELF: $@ =="
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

# ============================================================
# Run Spike
# ============================================================

run_asm: $(ASM_ELF)
	@echo "== Running Spike (ASM) =="
	$(SPIKE) $(SPIKE_FLAGS) $(ASM_ELF) > $(LOG) 2>&1

run_c: $(C_ELF)
	@echo "== Running Spike (C) =="
	$(SPIKE) $(SPIKE_FLAGS) $(C_ELF) > $(LOG) 2>&1

# ============================================================
# Instruction memory generation
# ============================================================

instructions_asm: $(ASM_ELF)
	@echo "== Generating instructions (ASM) =="
	$(OBJCOPY) -O binary $(TEXT_SECTIONS) $< $(IMEM_BIN)
	$(HEXDUMP) -v -e '1/4 "%08X\n"' $(IMEM_BIN) > $(IMEM_HEX)
	cp $(IMEM_HEX) $(IMEM_MEM)
	@echo "memory_initialization_radix=16;" >  $(IMEM_COE)
	@printf "memory_initialization_vector=" >> $(IMEM_COE)
	@$(HEXDUMP) -v -e '1/4 "%08X "' $(IMEM_BIN) >> $(IMEM_COE)
	@echo ";" >> $(IMEM_COE)

instructions_c: $(C_ELF)
	@echo "== Generating instructions (C) =="
	$(OBJCOPY) -O binary $(TEXT_SECTIONS) $< $(IMEM_BIN)
	$(HEXDUMP) -v -e '1/4 "%08X\n"' $(IMEM_BIN) > $(IMEM_HEX)
	cp $(IMEM_HEX) $(IMEM_MEM)
	@echo "memory_initialization_radix=16;" >  $(IMEM_COE)
	@printf "memory_initialization_vector=" >> $(IMEM_COE)
	@$(HEXDUMP) -v -e '1/4 "%08X "' $(IMEM_BIN) >> $(IMEM_COE)
	@echo ";" >> $(IMEM_COE)

# ============================================================
# Register & data memory extraction
# ============================================================

mem_asm: run_asm
	@echo "== Extracting registers (ASM) =="
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
	@echo "== Extracting data memory (ASM) =="
	grep -E " mem 0x[0-9a-fA-F]+ 0x" $(LOG) | \
	awk '{ \
	  for(i=1;i<=NF;i++){ \
	    if($$i=="mem"){ \
	      printf "%08x%08x\n", strtonum($$(i+1)), strtonum($$(i+2)); \
	    } \
	  } \
	}' > $(DATAMEM)

mem_c: run_c
	@echo "== Extracting registers (C) =="
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
	@echo "== Extracting data memory (C) =="
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
	  $(ASM_ELF) $(C_ELF) $(LOG) \
	  $(REGMEM) $(DATAMEM) \
	  $(IMEM_BIN) $(IMEM_HEX) $(IMEM_COE) $(IMEM_MEM)

.PHONY: all_asm all_c run_asm run_c mem_asm mem_c instructions_asm instructions_c clean
