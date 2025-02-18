#=============================================================================
# Copyright (c) 2023 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

#Please ensure that the tunables are set as per the product variant

rev=`cat /sys/devices/soc0/revision`
ddr_type=`od -An -tx /proc/device-tree/memory/ddr_device_type`
ddr_type4="07"
ddr_type5="08"

# Disable Core control on silver
echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable

# Disable Core control on gold
echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/enable

# Disable Core control on gold+
echo 0 > /sys/devices/system/cpu/cpu6/core_ctl/enable

# Setting b.L scheduler parameters
echo 65 85 > /proc/sys/walt/sched_downmigrate
echo 71 95 > /proc/sys/walt/sched_upmigrate
echo 85 > /proc/sys/walt/sched_group_downmigrate
echo 100 > /proc/sys/walt/sched_group_upmigrate
echo 1 > /proc/sys/walt/sched_walt_rotate_big_tasks
echo 0 > /proc/sys/walt/sched_coloc_busy_hysteresis_enable_cpus
echo 255 > /proc/sys/walt/sched_util_busy_hysteresis_enable_cpus
echo 8500000 8500000 8500000 8500000 5000000 5000000 2000000 > /proc/sys/walt/sched_util_busy_hyst_cpu_ns
echo 1 1 1 1 15 15 15 > /proc/sys/walt/sched_util_busy_hyst_cpu_util

# cpuset parameters
echo 0-3 > /dev/cpuset/background/cpus
echo 0-3 > /dev/cpuset/system-background/cpus

# Turn off scheduler boost at the end
echo 0 > /proc/sys/walt/sched_boost

# Reset the RT boost, which is 1024 (max) by default.
echo 0 > /proc/sys/kernel/sched_util_clamp_min_rt_default

# configure governor settings for silver cluster
echo "walt" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/walt/down_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/walt/up_rate_limit_us
echo 1075200 > /sys/devices/system/cpu/cpufreq/policy0/walt/hispeed_freq
echo 614400 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/walt/pl

# configure input boost settings
echo 1075200 0 0 0 0 0 0 > /proc/sys/walt/input_boost/input_boost_freq
echo 120 > /proc/sys/walt/input_boost/input_boost_ms

# configure governor settings for gold cluster
echo "walt" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo 0 > /sys/devices/system/cpu/cpufreq/policy4/walt/down_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpufreq/policy4/walt/up_rate_limit_us
echo 1113600 > /sys/devices/system/cpu/cpufreq/policy4/walt/hispeed_freq
echo 652800 > /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq
echo 85 > /sys/devices/system/cpu/cpufreq/policy4/walt/hispeed_load
echo -6 > /sys/devices/system/cpu/cpufreq/policy4/walt/boost
echo 0 > /sys/devices/system/cpu/cpufreq/policy4/walt/rtg_boost_freq
echo 0 > /sys/devices/system/cpu/cpufreq/policy4/walt/pl

# configure governor settings for gold+ cluster
echo "walt" > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
echo 0 > /sys/devices/system/cpu/cpufreq/policy6/walt/down_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpufreq/policy6/walt/up_rate_limit_us
echo 1401600 > /sys/devices/system/cpu/cpufreq/policy6/walt/hispeed_freq
echo 652800 > /sys/devices/system/cpu/cpufreq/policy6/scaling_min_freq
echo 85 > /sys/devices/system/cpu/cpufreq/policy6/walt/hispeed_load
echo -6 > /sys/devices/system/cpu/cpufreq/policy6/walt/boost
echo 0 > /sys/devices/system/cpu/cpufreq/policy6/walt/rtg_boost_freq
echo 0 > /sys/devices/system/cpu/cpufreq/policy6/walt/pl

# colocation V3 settings
echo 614400 > /sys/devices/system/cpu/cpufreq/policy0/walt/rtg_boost_freq
echo 51 > /proc/sys/walt/sched_min_task_util_for_boost
echo 35 > /proc/sys/walt/sched_min_task_util_for_colocation
echo 20000000 > /proc/sys/walt/sched_task_unfilter_period

# Enable conservative pl
echo 1 > /proc/sys/walt/sched_conservative_pl

# Limit kswapd in cpu0-6
echo `ps -elf | grep -v grep | grep kswapd0 | awk '{print $2}'` > /dev/cpuset/kswapd-like/tasks

# configure bus-dcvs
bus_dcvs="/sys/devices/system/cpu/bus_dcvs"

for device in $bus_dcvs/*
do
	cat $device/hw_min_freq > $device/boost_freq
done

for llccbw in $bus_dcvs/LLCC/*bwmon-llcc
do
	echo "4577 7110 9155 12298 14236 15258" > $llccbw/mbps_zones
	echo 4 > $llccbw/sample_ms
	echo 68 > $llccbw/io_percent
	echo 20 > $llccbw/hist_memory
	echo 80 > $llccbw/down_thres
	echo 0 > $llccbw/guard_band_mbps
	echo 250 > $llccbw/up_scale
	echo 1600 > $llccbw/idle_mbps
	echo 40 > $llccbw/window_ms
done

for ddrbw in $bus_dcvs/DDR/*bwmon-ddr
do
	if [ ${ddr_type:4:2} == $ddr_type4 ]; then
		echo "1144 1720 2086 2929 3879 5931 6515 8136" > $ddrbw/mbps_zones
	elif [ ${ddr_type:4:2} == $ddr_type5 ]; then
		echo "1720 2086 2929 3879 5931 6515 7980 12191" > $ddrbw/mbps_zones
	fi
	echo 4 > $ddrbw/sample_ms
	echo 68 > $ddrbw/io_percent
	echo 20 > $ddrbw/hist_memory
	echo 80 > $ddrbw/down_thres
	echo 0 > $ddrbw/guard_band_mbps
	echo 250 > $ddrbw/up_scale
	echo 1600 > $ddrbw/idle_mbps
	echo 48 > $ddrbw/window_ms
done

for latfloor in $bus_dcvs/*/*latfloor
do
	echo 25000 > $latfloor/ipm_ceil
done

for l3gold in $bus_dcvs/L3/*gold
do
	echo 4000 > $l3gold/ipm_ceil
	echo 60 > $l3gold/wb_pct_thres
done

for l3prime in $bus_dcvs/L3/*prime
do
	echo 20000 > $l3prime/ipm_ceil
	echo 60 > $l3prime/wb_pct_thres
done

for ddrprime in $bus_dcvs/DDR/*prime
do
	echo 25 > $ddrprime/freq_scale_pct
	echo 1881 > $ddrprime/freq_scale_limit_mhz
	echo 3196800 > $ddrprime/spm_max_vote
done

for ddrgold in $bus_dcvs/DDR/*gold
do
	echo 3196800 > $ddrgold/spm_max_vote
done

for qosgold in $bus_dcvs/DDRQOS/*gold
do
	echo 50 > $qosgold/ipm_ceil
done

for qosprime in $bus_dcvs/DDRQOS/*prime
do
	echo 100 > $qosprime/ipm_ceil
done

# set s2idle as default suspend mode
echo s2idle > /sys/power/mem_sleep

# Enable LPM
echo N > /sys/devices/system/cpu/qcom_lpm/parameters/sleep_disabled

#=============================================

# Let kernel know our image version/variant/crm_version
if [ -f /sys/devices/soc0/select_image ]; then
	image_version="10:"
	image_version+=`getprop ro.build.id`
	image_version+=":"
	image_version+=`getprop ro.build.version.incremental`
	image_variant=`getprop ro.product.name`
	image_variant+="-"
	image_variant+=`getprop ro.build.type`
	oem_version=`getprop ro.build.version.codename`
	echo 10 > /sys/devices/soc0/select_image
	echo $image_version > /sys/devices/soc0/image_version
	echo $image_variant > /sys/devices/soc0/image_variant
	echo $oem_version > /sys/devices/soc0/image_crm_version
fi

# Change console log level as per console config property
console_config=`getprop persist.vendor.console.silent.config`
case "$console_config" in
	"1")
		echo "Enable console config to $console_config"
		echo 0 > /proc/sys/kernel/printk
	;;
	*)
		echo "Enable console config to $console_config"
	;;
esac





setprop vendor.post_boot.parsed 1
