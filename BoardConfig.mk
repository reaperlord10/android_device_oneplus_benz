#
# Copyright (C) 2021-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

BUILD_BROKEN_DUP_RULES := true

# Include the common OEM chipset BoardConfig.
include device/oneplus/sm7550-common/BoardConfigCommon.mk

DEVICE_PATH := device/oneplus/benz

# Assert
TARGET_OTA_ASSERT_DEVICE := OP5D3FL1

# Display
TARGET_SCREEN_DENSITY := 420

# Kernel
TARGET_KERNEL_CONFIG += vendor/oplus/benz.config

# Partitions
BOARD_ONEPLUS_DYNAMIC_PARTITIONS_SIZE := 15028191232
BOARD_SUPER_PARTITION_SIZE := 15032385536

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 103

# Include the proprietary files BoardConfig.
include vendor/oneplus/benz/BoardConfigVendor.mk
