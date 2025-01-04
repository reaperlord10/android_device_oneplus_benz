#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from ossi device
$(call inherit-product, device/oneplus/benz/device.mk)

PRODUCT_DEVICE := benz
PRODUCT_NAME := lineage_benz
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := CPH2613
PRODUCT_MANUFACTURER := OnePlus

PRODUCT_GMS_CLIENTID_BASE := android-oneplus

PRODUCT_SYSTEM_NAME := $(PRODUCT_MODEL)
PRODUCT_SYSTEM_DEVICE := OP5D3FL1

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="qssi-user 15 AP3A.240617.008 1732008019222 release-keys"

BUILD_FINGERPRINT := oplus/ossi/ossi:15/AP3A.240617.008/1732008019222:user/release-keys
