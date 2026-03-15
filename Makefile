PLATFORM ?= x86_64
BUILD_PROFILE ?= debug

CONFIG_NAME ?= $(PLATFORM)-$(BUILD_PROFILE)
OUTPUT_DIR := build/$(CONFIG_NAME)

CC := qcc -Vgcc_nto$(PLATFORM)
CXX := q++ -Vgcc_nto$(PLATFORM)_cxx
LD := $(CC)

CCFLAGS_release += -O2
CCFLAGS_debug += -g -O0 -fno-builtin
CCFLAGS_coverage += -g -O0 -ftest-coverage -fprofile-arcs
LDFLAGS_coverage += -ftest-coverage -fprofile-arcs
CCFLAGS_profile += -g -O0 -finstrument-functions
LIBS_profile += -lprofilingS

CCFLAGS_all += -Wall -Wextra -fmessage-length=0 -fPIC
CCFLAGS_all += $(CCFLAGS_$(BUILD_PROFILE))

LDFLAGS_all += $(LDFLAGS_$(BUILD_PROFILE))
LIBS_all += $(LIBS_$(BUILD_PROFILE))

DEPS = -Wp,-MMD,$(@:%.o=%.d),-MT,$@

MAIN_NAME := QNXKinect
SIM_NAME := KinectSim

COMMON_C_SRCS :=
COMMON_CPP_SRCS :=

MAIN_C_SRCS := src/main/main.c $(COMMON_C_SRCS)
MAIN_CPP_SRCS := $(COMMON_CPP_SRCS)

SIM_C_SRCS := src/kinectsim/main.c $(COMMON_C_SRCS)
SIM_CPP_SRCS := $(COMMON_CPP_SRCS)

MAIN_SRCS := $(MAIN_C_SRCS) $(MAIN_CPP_SRCS)
SIM_SRCS := $(SIM_C_SRCS) $(SIM_CPP_SRCS)

MAIN_OBJS := $(addprefix $(OUTPUT_DIR)/,$(addsuffix .o,$(basename $(MAIN_SRCS))))
SIM_OBJS := $(addprefix $(OUTPUT_DIR)/,$(addsuffix .o,$(basename $(SIM_SRCS))))
ALL_OBJS := $(sort $(MAIN_OBJS) $(SIM_OBJS))

MAIN_TARGET := $(OUTPUT_DIR)/$(MAIN_NAME)
SIM_TARGET := $(OUTPUT_DIR)/$(SIM_NAME)

.PHONY: all clean rebuild

all: $(MAIN_TARGET) $(SIM_TARGET)

$(OUTPUT_DIR)/%.o: %.c
	-@mkdir -p $(dir $@)
	$(CC) -c $(DEPS) -o $@ $(CCFLAGS_all) $(CCFLAGS) $<

$(OUTPUT_DIR)/%.o: %.cpp
	-@mkdir -p $(dir $@)
	$(CXX) -c $(DEPS) -o $@ $(CCFLAGS_all) $(CCFLAGS) $<

$(MAIN_TARGET): $(MAIN_OBJS)
	-@mkdir -p $(dir $@)
	$(LD) -o $@ $(LDFLAGS_all) $(LDFLAGS) $(MAIN_OBJS) $(LIBS_all) $(LIBS)

$(SIM_TARGET): $(SIM_OBJS)
	-@mkdir -p $(dir $@)
	$(LD) -o $@ $(LDFLAGS_all) $(LDFLAGS) $(SIM_OBJS) $(LIBS_all) $(LIBS)

clean:
	rm -rf build

rebuild: clean all

-include $(ALL_OBJS:%.o=%.d)
