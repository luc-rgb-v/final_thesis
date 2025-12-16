# Compiler tool
CROSS = riscv32-unknown-elf
CC = $(CROSS)-gcc
OBJCOPY = $(CROSS)-objcopy
OBJDUMP = $(CROSS)-objdump

BUILD = build

# Input file
FILE ?= program.c
# Remove extension
NAME = $(basename $(notdir $(FILE)))
# Output
ELF = $(BUILD)/$(NAME).elf
BIN = $(BUILD)/$(NAME).bin
DUMP = $(BUILD)/$(NAME).S
TEXT = $(BUILD)/$(NAME).txt
HEX = $(BUILD)/$(NAME).hex
COE = $(BUILD)/$(NAME).coe

# Linker
LINKER = ./assembly/linker/link.ld

# No need start file
# START = ./assembly/start/start.S 

# Flag 
CFLAGS = -march=rv32i -mabi=ilp32 -nostartfiles
SRC = 
OBJ = $(BUILD)/

# -----------------------------------------------------
all:$(BUILD) $(ELF) $(BIN) $(DUMP) $(TEXT) $(HEX) $(COE)
	@echo "===================="
	@echo "All build completed!"
	@echo "Checkout ./build"
	@echo "===================="

$(BUILD):
	@echo "Buidding . . ."
	@mkdir -p $(BUILD) # No error if $(BUILD) exist
	@echo "All output at $(BUILD)"

$(ELF): $(LINKER) $(FILE)
	$(CC) $(CFLAGS) -T $(LINKER) $(FILE) -o $(ELF)
	@echo "Elf file: $(NAME).elf"

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $(ELF) $(BIN)
	@echo "Binary file: $(NAME).bin"

$(DUMP): $(ELF)
	$(OBJDUMP) -d $(ELF) > $(DUMP)
	@echo "Dump file: $(NAME).S"

$(TEXT): $(ELF)
	$(OBJDUMP) -s $(ELF) > $(TEXT)
	@echo "Text file: $(NAME).txt"

$(HEX): $(BIN)
	hexdump -v -e '1/4 "%08X\n"' $(BIN) > $(HEX)
	@echo "Hex file: $(NAME).hex"

$(COE): $(BIN)
	{\
		echo "memory_initialization_radix=16;"; \
		printf "memory_initialization_vector="; \
		xxd -p $(BIN) | tr -d '\n' | sed 's/../& /g'; \
		echo ";"; \
	} > $(COE)

GCC:

clean:
	@rm -rf $(BUILD)
	@echo "All clean!"

.PHONY: all clean

