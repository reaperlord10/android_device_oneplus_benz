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

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="CPH2613IN-user 15 TP1A.220905.001 U.R4T2.1c822c2_1_3 release-keys" \
    BuildFingerprint=OnePlus/CPH2613IN/OP5D3FL1:15/TP1A.220905.001/U.R4T2.1c822c2_1_3:user/release-keys \
    DeviceName=OP5D3FL1 \
    DeviceProduct=CPH2613 \
    SystemDevice=OP5D3FL1 \
    SystemName=CPH2613
