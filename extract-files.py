#!/usr/bin/env -S PYTHONPATH=../../../tools python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import os
from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

# Get device and vendor from environment or default to benz/oneplus
DEVICE = os.getenv("DEVICE", "benz")
VENDOR = os.getenv("VENDOR", "oneplus")

# Namespaces for extracting files
namespace_imports = [
    f'device/{VENDOR}/{DEVICE}',
    f'vendor/{VENDOR}/sm7550-common',
    'hardware/oplus',
    'hardware/qcom-caf/sm8550',
    'vendor/qcom/opensource/display',
    'vendor/qcom/opensource/commonsys-intf/display',
]

# Suffix-based library fixups

def lib_fixup_odm_suffix(lib: str, partition: str, *args, **kwargs) -> str | None:
    return f'{lib}_{partition}' if partition == 'odm' else None

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs) -> str | None:
    return f'{lib}_{partition}' if partition == 'vendor' else None

# Update default lib fixups with partition suffix rules
lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'libhwconfigurationutil',
        'vendor.oplus.hardware.cammidasservice-V1-ndk',
        'vendor.oplus.hardware.sendextcamcmd-V1-ndk',
    ): lib_fixup_vendor_suffix,
    (
        'vendor.oplus.hardware.touch-V2-ndk',
    ): lib_fixup_odm_suffix,
}

# Helper for logging blob fixups
def fixup_log(path: str, fix: blob_fixup) -> blob_fixup:
    print(f"Applying fixup for {path}")
    return fix

# Blob fixups based on real-world proprietary issues
blob_fixups: blob_fixups_user_type = {
    'odm/bin/hw/vendor.oplus.hardware.biometrics.fingerprint@2.1-service_uff': fixup_log(
        'fingerprint@2.1-service_uff',
        blob_fixup().add_needed("libshims_aidl_fingerprint_v2.benz.so")
    ),
    'odm/lib64/libAlgoProcess.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V3-ndk.so', 'android.hardware.graphics.common-V6-ndk.so'),

    # libstdc++ replacement group
    ('odm/lib64/libCOppLceTonemapAPI.so', 'odm/lib64/libCS.so', 'odm/lib64/libSuperRaw.so',
     'odm/lib64/libYTCommon.so', 'odm/lib64/libyuv2.so', 'odm/lib64/libaps_frame_registration.so'):
        blob_fixup().replace_needed('libstdc++.so', 'libstdc++_vendor.so'),

    # AHardwareBuffer symbols
    ('odm/lib64/libHIS.so', 'odm/lib64/libOGLManager.so'):
        blob_fixup()
        .clear_symbol_version('AHardwareBuffer_allocate')
        .clear_symbol_version('AHardwareBuffer_describe')
        .clear_symbol_version('AHardwareBuffer_lock')
        .clear_symbol_version('AHardwareBuffer_release')
        .clear_symbol_version('AHardwareBuffer_unlock'),

    # Remote handle symbols
    'odm/lib64/libarcsoft_high_dynamic_range_v4.so': blob_fixup()
        .clear_symbol_version('remote_handle_close')
        .clear_symbol_version('remote_handle_invoke')
        .clear_symbol_version('remote_handle_open')
        .clear_symbol_version('remote_register_buf_attr')
        .clear_symbol_version('remote_register_buf'),

    # libziparchive replacement
    'odm/lib64/libextensionlayer.so': blob_fixup()
        .replace_needed('libziparchive.so', 'libziparchive_odm.so'),

    # Config tweaks
    'odm/etc/camera/CameraHWConfiguration.config': blob_fixup()
        .regex_replace('SystemCamera =  0;  0;  1;  1;', 'SystemCamera =  0;  0;  0;  0;'),
}

# Define module with fixups
module = ExtractUtilsModule(
    device=DEVICE,
    vendor=VENDOR,
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(
        module, 'sm7550-common', module.vendor
    )
    utils.run()