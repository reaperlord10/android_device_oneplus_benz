#=============================================================================
# Copyright (c) 2023 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

enable_sched_events()
{
    local instance=/sys/kernel/tracing

    echo > $instance/trace
    echo > $instance/set_event

    # timer
    echo 1 > $instance/events/timer/timer_expire_entry/enable
    echo 1 > $instance/events/timer/timer_expire_exit/enable
    echo 1 > $instance/events/timer/hrtimer_cancel/enable
    echo 1 > $instance/events/timer/hrtimer_expire_entry/enable
    echo 1 > $instance/events/timer/hrtimer_expire_exit/enable
    echo 1 > $instance/events/timer/hrtimer_init/enable
    echo 1 > $instance/events/timer/hrtimer_start/enable
    #enble FTRACE for softirq events
    echo 1 > $instance/events/irq/enable
    #enble FTRACE for Workqueue events
    echo 1 > $instance/events/workqueue/enable
    # sched
    echo 1 > $instance/events/sched/sched_cpu_hotplug/enable
    echo 1 > $instance/events/sched/sched_migrate_task/enable
    echo 1 > $instance/events/sched/sched_pi_setprio/enable
    echo 1 > $instance/events/sched/sched_switch/enable
    echo 1 > $instance/events/sched/sched_wakeup/enable
    echo 1 > $instance/events/sched/sched_wakeup_new/enable
    echo 1 > $instance/events/schedwalt/halt_cpus/enable
    echo 1 > $instance/events/schedwalt/halt_cpus_start/enable
    # hot-plug
    echo 1 > $instance/events/cpuhp/enable

    echo 1 > $instance/events/power/cpu_frequency/enable

    echo 1 > $instance/tracing_on
}

enable_tracing_events()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ] ; then
        return
    fi

    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/tracing/events ] ; then
        return
    fi

    enable_sched_events
}

enable_tracing_events