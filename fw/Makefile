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
RV_COE  := $(BUILD_DIR)/$(NAME).coe

CXXFLAGS_RV := \
	-march=rv32i -mabi=ilp32 \
	-ffreestanding -fno-builtin -nostdlib \
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
riscv: $(RV_ELF) $(RV_BIN) $(RV_DUMP) $(RV_TXT) $(RV_HEX) $(RV_COE)
	@echo "RISC-V build complete"
	@echo "Output in $(BUILD_DIR)"

# SPIKE build
spike: $(SPIKE_ELF)
	@echo "============================="
	@echo "(spike) until pc 0 0x80000000"
	@echo "(spike) pc 0"
	@echo "(spike) run 1"
	@echo "============================="
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

$(BUILD_DIR):
	@mkdir -p $@

$(BUILD_DIR)/%.o: %.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS_RV) -c $< -o $@

$(BUILD_DIR)/start.o: $(START) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS_RV) -c $< -o $@

$(RV_ELF): $(RV_OBJS) $(LINKER)
	$(CXX) $(CXXFLAGS_RV) -T $(LINKER) $(RV_OBJS) -lgcc -o $@

$(RV_BIN): $(RV_ELF)
	$(OBJCOPY) -O binary $< $@

$(RV_DUMP): $(RV_ELF)
	$(OBJDUMP) -d $< > $@

$(RV_TXT): $(RV_ELF)
	$(OBJDUMP) -s $< > $@

$(RV_HEX): $(RV_BIN)
	hexdump -v -e '1/4 "%08X\n"' $< > $@

$(RV_COE): $(RV_BIN)
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
