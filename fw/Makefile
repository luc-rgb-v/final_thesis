# =====================================================
# Project settings
# =====================================================
NAME        := main
BUILD_DIR   := build

SRCS        := main.cpp
SPIKE_ELF = build/main.elf

# =====================================================
# Native (Ubuntu / WSL)
# =====================================================
CXX_NATIVE      := g++
CXXFLAGS_NATIVE := -std=c++17 -O2 -Wall -Wextra
NATIVE_OBJS := $(SRCS:%.cpp=%)

# =====================================================
# RISC-V (RV32I bare metal)
# =====================================================
CROSS   := riscv32-unknown-elf
CXX     := $(CROSS)-g++
OBJCOPY := $(CROSS)-objcopy
OBJDUMP := $(CROSS)-objdump

LINKER := linker.ld
START  := start.S

RV_OBJS := $(SRCS:%.cpp=$(BUILD_DIR)/%.o) \
           $(BUILD_DIR)/start.o

RV_ELF  := $(BUILD_DIR)/$(NAME).elf
RV_BIN  := $(BUILD_DIR)/$(NAME).bin
RV_DUMP := $(BUILD_DIR)/$(NAME).S
RV_TXT  := $(BUILD_DIR)/$(NAME).txt
RV_HEX  := $(BUILD_DIR)/$(NAME).hex

RV_ASM  :=$(BUILD_DIR)/$(NAME)_assembly.S

IMEM_BIN := $(BUILD_DIR)/imem.bin
DMEM_BIN := $(BUILD_DIR)/dmem.bin

IMEM_HEX := $(BUILD_DIR)/imem.hex
DMEM_HEX := $(BUILD_DIR)/dmem.hex

IMEM_COE := $(BUILD_DIR)/imem.coe
DMEM_COE := $(BUILD_DIR)/dmem.coe

CXXFLAGS_RV := \
	-march=rv32i -mabi=ilp32 \
	-ffreestanding -fno-builtin -nostdlib \
	-fno-exceptions \
	-fno-unwind-tables \
	-fno-asynchronous-unwind-tables \
	-std=c++11 -O2 -Wall -Wextra

# =====================================================
# Default target
# =====================================================
all: native

native:
	$(CXX_NATIVE) $(CXXFLAGS_NATIVE) $(SRCS) -o $(NATIVE_OBJS)
run:
	./$(NATIVE_OBJS)
# =====================================================
# RISC-V build
# =====================================================

riscv: $(RV_ELF) $(RV_DUMP) $(RV_ASM) $(RV_TXT) $(RV_HEX) $(RV_COE) $(IMEM_BIN) $(DMEM_BIN) $(IMEM_HEX) $(DMEM_HEX) $(IMEM_COE) $(DMEM_COE)
	@echo "===== Build complete ======"

# SPIKE build
spike: $(SPIKE_ELF)
	@echo "============================="
	@echo "(spike) until pc 0 0x80000000       - <_start>: auipc sp,0x10"
	@echo "(spike) pc 0                        - program counter at core 0"
	@echo "(spike) run 1                       - run 1 instruction"
	@echo "(spike) reg 0                       - check register file"
	@echo "(spike) until insn 0 0x00ac2023     - or until pc 0 800004a8 : sw a0,0(s8)"
	@echo "(spike) mem 0 0x80010730            - heartrate data address"
	@echo "(spike) until pc 0 0x800007d0       - or until insn 0 0x00eda023 : sw a4,0(s11)"
	@echo "(spike) mem 0 0x800107e8            - SpO2 data address"
	@echo "============================="
	riscv32-unknown-elf-nm $(SPIKE_ELF) | grep main
	spike --isa=rv32i -d --pc=0x80000000 $(SPIKE_ELF)

# =====================================================
# Help
# =====================================================
help:
	@echo "make all                         - build for wsl"
	@echo "make riscv                       - build for rv32i"
	@echo "./main > log.csv                 - gen log file"
	@echo "python3 -m venv venv             - create Python virtual environment"
	@echo "source venv/bin/activate         - activare virtual environment"
	@echo "pip install -r requirements.txt  - venv requirement"
	@echo "deactivate                       - exit virtual environment"

$(RV_ASM): $(SRCS) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS_RV) -S $< -o $@

$(BUILD_DIR):
	@mkdir -p $@

$(BUILD_DIR)/%.o: %.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS_RV) -c $< -o $@

$(BUILD_DIR)/start.o: $(START) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS_RV) -c $< -o $@

$(RV_ELF): $(RV_OBJS) $(LINKER)
	$(CXX) $(CXXFLAGS_RV) -T $(LINKER) $(RV_OBJS) -lgcc \
	-Wl,-Map=$(BUILD_DIR)/$(NAME).map \
	-o $@

$(RV_BIN): $(RV_ELF)
	$(OBJCOPY) -O binary $< $@

$(RV_DUMP): $(RV_ELF)
	$(OBJDUMP) -d $< > $@

$(RV_TXT): $(RV_ELF)
	$(OBJDUMP) -s $< > $@

$(RV_HEX): $(RV_BIN) 
	hexdump -v -e '1/4 "%08X\n"' $< > $@

$(IMEM_BIN): $(RV_ELF)
	$(OBJCOPY) \
	  -O binary \
	  --only-section=.text \
	  --only-section=.rodata \
	  $< $@

$(IMEM_HEX): $(IMEM_BIN)
	hexdump -v -e '1/4 "%08X\n"' $< > $@

$(IMEM_COE): $(IMEM_BIN)
	@echo "memory_initialization_radix=16;" >  $@
	@printf "memory_initialization_vector=" >> $@
	@hexdump -v -e '1/4 "%08X "' $< >> $@
	@echo ";" >> $@

$(DMEM_BIN): $(RV_ELF)
	$(OBJCOPY) \
	  -O binary \
	  --only-section=.data \
	  --only-section=.sdata \
	  --only-section=.bss \
	  --only-section=.sbss \
	  $< $@

$(DMEM_HEX): $(DMEM_BIN)
	hexdump -v -e '1/4 "%08X\n"' $< > $@

$(DMEM_COE): $(DMEM_BIN)
	@echo "memory_initialization_radix=16;" >  $@
	@printf "memory_initialization_vector=" >> $@
	@hexdump -v -e '1/4 "%08X "' $< >> $@
	@echo ";" >> $@

# =====================================================
# Clean
# =====================================================
clean:
	rm -f $(NATIVE_OBJS) $(NATIVE_TARGET)
	rm -rf $(BUILD_DIR)
	rm -f *.csv
	@echo "build/ removed"

.PHONY: all riscv run clean help
