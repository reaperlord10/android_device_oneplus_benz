#
# Copyright (C) 2021-2024 The LineageOS Project
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

PRODUCT_SYSTEM_NAME := $(PRODUCT_MODEL)
PRODUCT_SYSTEM_DEVICE := OP5D3FL1

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="CPH2585IN-user 15 TP1A.220905.001 U.R4T3.1bbd5ce_6e35-2367f release-keys" \
    BuildFingerprint=OnePlus/CPH2585IN/OP5D35L1:15/TP1A.220905.001/U.R4T3.1bbd5ce_6e35-2367f:user/release-keys \
    DeviceName=OP5D35L1 \
    DeviceProduct=CPH2585 \
    SystemDevice=OP5D35L1 \
    SystemName=CPH2585
