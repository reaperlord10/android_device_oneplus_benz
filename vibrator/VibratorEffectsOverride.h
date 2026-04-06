/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once

#include <aidl/android/hardware/vibrator/Effect.h>

namespace aidl {
namespace android {
namespace hardware {
namespace vibrator {

static inline Effect overrideVibratorEffect(Effect effect) {
    switch (effect) {
        case Effect::CLICK:
        case Effect::TICK:
            return Effect::THUD;
        default:
            return effect;
    }
}

}  // namespace vibrator
}  // namespace hardware
}  // namespace android
}  // namespace aidl
