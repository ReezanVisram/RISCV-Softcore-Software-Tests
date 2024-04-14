# Directories
SRC_DIR := asm
BUILD_DIR := build
ASM_BUILD_DIR := $(BUILD_DIR)/$(SRC_DIR)

# Files
ASM_FILES := $(wildcard $(SRC_DIR)/*_test.s)
ELF_FILES := $(patsubst $(SRC_DIR)/%.s,$(ASM_BUILD_DIR)/%.elf,$(ASM_FILES))
HEX_FILES := $(patsubst $(ASM_BUILD_DIR)/%.elf,$(ASM_BUILD_DIR)/%.hex,$(ELF_FILES))
MODIFIED_HEX_FILES := $(patsubst $(ASM_BUILD_DIR)/%.hex,$(ASM_BUILD_DIR)/%-modified.hex,$(HEX_FILES))

# Compiler and flags
CC := riscv64-unknown-elf-as
ASM_FLAGS := -march=rv32i -o

# Targets
.PHONY: all clean

all: $(MODIFIED_HEX_FILES)

$(ASM_BUILD_DIR)/%.elf: $(SRC_DIR)/%.s | $(ASM_BUILD_DIR)
	$(CC) $(ASM_FLAGS) $@ $<

$(ASM_BUILD_DIR)/%.hex: $(ASM_BUILD_DIR)/%.elf
	riscv64-unknown-elf-objcopy -O verilog $< $@

# Tell Make not to delete these files
.SECONDARY: $(ELF_FILES) $(HEX_FILES)

$(ASM_BUILD_DIR)/%-modified.hex: $(ASM_BUILD_DIR)/%.hex
	python prepare_hex_files.py $<

$(ASM_BUILD_DIR):
	mkdir -p $(ASM_BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)