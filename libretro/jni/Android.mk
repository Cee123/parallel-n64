LOCAL_PATH := $(call my-dir)
PERFTEST = 0
HAVE_PARALLEL :=1
HAVE_RDP_DUMP=0
HAVE_RSP_DUMP=0
USE_CXD4_NEW=1

include $(CLEAR_VARS)

GIT_VERSION ?= " $(shell git rev-parse --short HEAD || echo unknown)"
ifneq ($(GIT_VERSION)," unknown")
	LOCAL_CFLAGS += -DGIT_VERSION=\"$(GIT_VERSION)\"
endif

LOCAL_MODULE := retro

ROOT_DIR := ../..
LIBRETRO_DIR = ../libretro

ifeq ($(TARGET_ARCH),arm)
LOCAL_ARM_MODE := arm
LOCAL_CFLAGS := -marm
WITH_DYNAREC := arm

COMMON_FLAGS := -DANDROID_ARM -DDYNAREC -DNEW_DYNAREC=3 -DNO_ASM
WITH_DYNAREC := arm

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
LOCAL_ARM_NEON := true
HAVE_NEON := 1
endif

endif

ifeq ($(TARGET_ARCH),x86)
COMMON_FLAGS := -DANDROID_X86 -DDYNAREC -D__SSE2__ -D__SSE__ -D__SOFTFP__
WITH_DYNAREC := x86
endif

ifeq ($(TARGET_ARCH),mips)
COMMON_FLAGS := -DANDROID_MIPS
endif

ifeq ($(NDK_TOOLCHAIN_VERSION), 4.6)
COMMON_FLAGS += -DANDROID_OLD_GCC
endif

SOURCES_C   :=
SOURCES_CXX :=
SOURCES_ASM :=
INCFLAGS    :=

include $(ROOT_DIR)/Makefile.common

LOCAL_SRC_FILES := $(SOURCES_CXX) $(SOURCES_C) $(SOURCES_ASM)

# Video Plugins

PLATFORM_EXT := unix

COMMON_FLAGS += -DM64P_CORE_PROTOTYPES -D_ENDUSER_RELEASE -DM64P_PLUGIN_API -D__LIBRETRO__ -DINLINE="inline" -DANDROID -DSINC_LOWER_QUALITY -DHAVE_LOGGER -fexceptions $(GLFLAGS) 
COMMON_OPTFLAGS = -O3 -ffast-math

LOCAL_CFLAGS += $(COMMON_OPTFLAGS) $(COMMON_FLAGS) $(INCFLAGS)
LOCAL_CXXFLAGS += $(COMMON_OPTFLAGS) $(COMMON_FLAGS) $(INCFLAGS)

LOCAL_CXXFLAGS += -std=c++11
LOCAL_CXXFLAGS += -DHAVE_PARALLEL
LOCAL_CFLAGS += -DHAVE_PARALLEL

LOCAL_C_INCLUDES = $(CORE_DIR)/src $(CORE_DIR)/src/api $(LIBRETRO_DIR)/libco $(LIBRETRO_DIR)

ifeq ($(PERFTEST), 1)
LOCAL_CFLAGS += -DPERF_TEST
LOCAL_CXXFLAGS += -DPERF_TEST
endif

include $(BUILD_SHARED_LIBRARY)

