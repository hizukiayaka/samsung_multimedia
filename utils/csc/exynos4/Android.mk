LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_COPY_HEADERS_TO := libsecmm
LOCAL_COPY_HEADERS := \
	color_space_convertor.h \
	csc_fimc.h

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := \
	color_space_convertor.c \
	csc_linear_to_tiled_crop_neon.s \
	csc_linear_to_tiled_interleave_crop_neon.s \
	csc_tiled_to_linear_crop_neon.s \
	csc_tiled_to_linear_deinterleave_crop_neon.s \
	csc_interleave_memcpy_neon.s

ifeq ($(BOARD_USE_CSC_FIMC), true)
LOCAL_SRC_FILES += csc_fimc.cpp
endif

LOCAL_C_INCLUDES := \
	$(TOP)/device/friendly-arm/multimedia/openmax/include/khronos \
	$(TOP)/device/friendly-arm/multimedia/openmax/include/sec

ifeq ($(filter-out exynos4,$(TARGET_BOARD_PLATFORM)),)
LOCAL_C_INCLUDES += $(TOP)/device/friendly-arm/exynos4/include
endif

ifeq ($(filter-out exynos4412,$(TARGET_BOARD_PLATFORM)),)
LOCAL_C_INCLUDES += $(TOP)/device/friendly-arm/tiny4412/include
endif

ifeq ($(BOARD_USE_CSC_FIMC), true)
LOCAL_C_INCLUDES += $(TOP)/device/friendly-arm/exynos4/libhwconverter
endif

ifeq ($(BOARD_USE_SAMSUNG_COLORFORMAT), true)
LOCAL_CFLAGS += -DUSE_SAMSUNG_COLORFORMAT
endif

LOCAL_MODULE := libseccscapi

LOCAL_PRELINK_MODULE := false

LOCAL_CFLAGS :=

LOCAL_ARM_MODE := arm

LOCAL_STATIC_LIBRARIES :=
LOCAL_SHARED_LIBRARIES := liblog

ifeq ($(BOARD_USE_CSC_FIMC), true)
LOCAL_SHARED_LIBRARIES += libfimc libhwconverter
endif

include $(BUILD_STATIC_LIBRARY)
