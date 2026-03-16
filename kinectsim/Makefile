DEBUG   = -g
CC      = qcc
LD      = qcc

TARGET  = -Vgcc_ntoaarch64le
#TARGET = -Vgcc_ntox86_64
#TARGET = -Vgcc_ntox86
#TARGET = -Vgcc_ntoarmv7le

CFLAGS  += $(DEBUG) $(TARGET) -Wall
LDFLAGS += $(DEBUG) $(TARGET)

SRC_DIR   := src
BUILD_DIR := build

SRCS := $(wildcard $(SRC_DIR)/*.c)
BINS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%,$(SRCS))

.PHONY: all clean print-bin

all: $(BUILD_DIR) $(BINS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

print-bin:
	@basename $(BINS)

clean:
	rm -rf $(BUILD_DIR)
