LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    gui.cpp \
    resources.cpp \
    pages.cpp \
    text.cpp \
    image.cpp \
    action.cpp \
    console.cpp \
    fill.cpp \
    button.cpp \
    checkbox.cpp \
    fileselector.cpp \
    progressbar.cpp \
    animation.cpp \
    conditional.cpp \
    slider.cpp \
    listbox.cpp

LOCAL_MODULE := libgui

# Use this flag to create a build that simulates threaded actions like installing zips, backups, restores, and wipes for theme testing
#TWRP_SIMULATE_ACTIONS := true
ifeq ($(TWRP_SIMULATE_ACTIONS), true)
LOCAL_CFLAGS += -D_SIMULATE_ACTIONS
endif

#TWRP_EVENT_LOGGING := true
ifeq ($(TWRP_EVENT_LOGGING), true)
LOCAL_CFLAGS += -D_EVENT_LOGGING
endif

ifneq ($(RECOVERY_SDCARD_ON_DATA),)
	LOCAL_CFLAGS += -DRECOVERY_SDCARD_ON_DATA
endif

LOCAL_C_INCLUDES += bionic external/stlport/stlport $(commands_recovery_local_path)/gui/devices/$(DEVICE_RESOLUTION)

include $(BUILD_STATIC_LIBRARY)

# Transfer in the resources for the device
include $(CLEAR_VARS)
LOCAL_MODULE := twrp
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res

TWRP_RES_LOC := $(commands_recovery_local_path)/gui/devices
TWRP_RES_GEN := $(intermediates)/twrp

$(TWRP_RES_GEN):
	mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/res/
	cp -fr $(TWRP_RES_LOC)/common/res/* $(TARGET_RECOVERY_ROOT_OUT)/res/
	cp -fr $(TWRP_RES_LOC)/$(DEVICE_RESOLUTION)/res/* $(TARGET_RECOVERY_ROOT_OUT)/res/
	mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/sbin/
	ln -sf /sbin/busybox $(TARGET_RECOVERY_ROOT_OUT)/sbin/sh

LOCAL_GENERATED_SOURCES := $(TWRP_RES_GEN)
LOCAL_SRC_FILES := twrp $(TWRP_RES_GEN)
include $(BUILD_PREBUILT)