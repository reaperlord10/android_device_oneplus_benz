#
# Copyright (C) 2021-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from benz device
$(call inherit-product, device/oneplus/benz/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_benz
PRODUCT_DEVICE := benz
PRODUCT_MANUFACTURER := OnePlus
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := CPH2613

PRODUCT_GMS_CLIENTID_BASE := android-oneplus

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="qssi-user 15 AP3A.240617.008 1760366015175 release-keys" \
    BuildFingerprint=OnePlus/CPH2613IN/OP5D3FL1:15/TP1A.220905.001/U.R4T2.205883a-1-10c029:user/release-keys \
    DeviceName=OP5D3FL1 \
    DeviceProduct=CPH2613 \
    SystemDevice=OP5D3FL1 \
    SystemName=CPH2613

# Lunaris
WITH_GMS := true
WITH_BCR := true
BYPASS_CHARGE_SUPPORTED := true
LUNARIS_BUILD_TYPE := OFFICIAL
TARGET_CUSTOM_UDFPS := true
TARGET_INCLUDE_LIVE_WALLPAPERS := true
TARGET_BOOT_ANIMATION_RES := 1080