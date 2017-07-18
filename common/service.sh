#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread
#!/system/bin/sh
#Original author: Alcolawl
#Settings By: RogerF81
#Device: HTC 10 (perfume)
#Codename: Soilworker_UNI
#SoC: Snapdragon 820
#Build Status: stable
#Version: 6.0
#Last Updated: 07/17/2017
#Credits: @Alcolawl @soniCron @Asiier @Freak07 @Mostafa Wael @Senthil360 @TotallyAnxious @Eliminater74 @RenderBroken @ZeroInfinity @Kyuubi10 @ivicask
sleep 30
echo ----------------------------------------------------
echo Applying Soilwork Kernel Tweaks
echo ----------------------------------------------------
echo "\m/"
echo "Let's go"

#Disable BCL
if [ -e "/sys/devices/soc/soc:qcom,bcl/mode" ]; then
echo Disabling BCL and Removing Perfd
	chmod 644 /sys/devices/soc/soc:qcom,bcl/mode
	echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
fi
if [ -e "/data/system/perfd" ]; then
	stop perfd
fi
if [ -e "/data/system/perfd/default_values" ]; then
	rm /data/system/perfd/default_values
fi
#turn on all cores
chmod 644 /sys/devices/system/cpu/online
echo 0-3 > /sys/devices/system/cpu/online
echo 1 > /sys/devices/system/cpu/cpu0/online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1593600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 307200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo 2150400 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo 307200 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
#Apply settings to LITTLE cluster
echo Changing governor at LITTLE cluster
if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
if [ -e /sys/devices/system/cpu/cpu0/cpufreq ]; then
    GOV_PATH=/sys/devices/system/cpu/cpu0/cpufreq
fi
string1=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors;
string1_1=/system/etc/;
#zzmove_available=false;
interactive_available=false;
schedutil_available=false;
pnp_available=false;
if [ -e /system/etc/pnp.xml ]; then
	pnp_available=true;
fi
if grep 'interactive' $string1; then
    interactive_available=true;
fi
#if grep 'zzmove' $string1; then
#	zzmove_available=true;
#fi
if grep 'pwrutilx' $string1; then
	prwutilx_available=true;
fi
if grep 'schedutil' $string1; then
	schedutil_available=true;
fi
if [ "$pwrutilx_available" == "true" ]; then
	if [ -e $string1 ]; then
		echo setting pwrutilx
		echo pwrutilx > $GOV_PATH/scaling_governor
		chmod 664 /dev/stune/top-app/schedtune.boost
		echo 72 > /proc/sys/kernel/sched_nr_migrate
		echo 1 > /dev/stune/foreground/schedtune.prefer_idle
		echo 1 > /dev/stune/top-app/schedtune.prefer_idle
		if [ -e "/proc/sys/kernel/sched_autogroup_enabled" ]; then
			echo 0 > /proc/sys/kernel/sched_autogroup_enabled
		fi
		echo 0 > /proc/sys/kernel/sched_child_runs_first
		echo 1 > /proc/sys/kernel/sched_cstate_aware
		if [ -e "/proc/sys/kernel/sched_is_big_little" ]; then
			echo 1 > /proc/sys/kernel/sched_is_big_little
		fi
		echo 10 > /proc/sys/kernel/sched_initial_task_util
		if [ -e "/proc/sys/kernel/sched_boost" ]; then
			echo 0 > /proc/sys/kernel/sched_boost
		fi
		if [ -e "/proc/sys/kernel/sched_use_walt_task_util" ]; then
			echo 0 > /proc/sys/kernel/sched_use_walt_task_util
			echo 0 > /proc/sys/kernel/sched_use_walt_cpu_util
		fi
	fi
elif [ "$pwrutilx_available" == "false" ] && [ "$schedutil_available" == "true" ]; then
	if [ -e $string1 ]; then
		echo setting schedutil
		echo schedutil > $GOV_PATH/scaling_governor
		chmod 664 /dev/stune/top-app/schedtune.boost
		echo 5 > /dev/stune/top-app/schedtune.boost
		echo 72 > /proc/sys/kernel/sched_nr_migrate
		echo 1 > /dev/stune/foreground/schedtune.prefer_idle
		echo 1 > /dev/stune/top-app/schedtune.prefer_idle
		if [ -e "/proc/sys/kernel/sched_autogroup_enabled" ]; then
			echo 0 > /proc/sys/kernel/sched_autogroup_enabled
		fi
		echo 0 > /proc/sys/kernel/sched_child_runs_first
		echo 1 > /proc/sys/kernel/sched_cstate_aware
		if [ -e "/proc/sys/kernel/sched_is_big_little" ]; then
			echo 1 > /proc/sys/kernel/sched_is_big_little
		fi
		echo 10 > /proc/sys/kernel/sched_initial_task_util
		if [ -e "/proc/sys/kernel/sched_boost" ]; then
			echo 0 > /proc/sys/kernel/sched_boost
		fi
		if [ -e "/proc/sys/kernel/sched_use_walt_task_util" ]; then
			echo 0 > /proc/sys/kernel/sched_use_walt_task_util
			echo 0 > /proc/sys/kernel/sched_use_walt_cpu_util
		fi
	fi
else
    if [ -e $string1 ]; then
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction
		echo Tweaking HMP Scheduler
		chmod 644 /sys/module/workqueue/parameters/power_efficient
		echo Y > /sys/module/workqueue/parameters/power_efficient 
		echo 60 > /proc/sys/kernel/sched_upmigrate
		echo 25 > /proc/sys/kernel/sched_downmigrate
		echo 15 > /proc/sys/kernel/sched_small_wakee_task_load
		echo 0 > /proc/sys/kernel/sched_init_task_load
		if [ -e "/proc/sys/kernel/sched_heavy_task" ]; then
			echo 65 > /proc/sys/kernel/sched_heavy_task
		fi
		if [ -e "/proc/sys/kernel/sched_enable_power_aware" ]; then
			echo 1 > /proc/sys/kernel/sched_enable_power_aware
		fi
		echo 1 > /proc/sys/kernel/sched_enable_thread_grouping
		echo 35 > /proc/sys/kernel/sched_big_waker_task_load
		if [ -e "/proc/sys/kernel/sched_small_task" ]; then
			echo 10 > /proc/sys/kernel/sched_small_task
		fi
		echo 3 > /proc/sys/kernel/sched_window_stats_policy
		echo 4 > /proc/sys/kernel/sched_ravg_hist_size
		echo 0 > /proc/sys/kernel/sched_upmigrate_min_nice
		echo 3 > /proc/sys/kernel/sched_spill_nr_run
		echo 70 > /proc/sys/kernel/sched_spill_load
		echo 1 > /proc/sys/kernel/sched_enable_thread_grouping
		echo 1 > /proc/sys/kernel/sched_restrict_cluster_spill
		echo 110 > /proc/sys/kernel/sched_wakeup_load_threshold
		echo 10 > /proc/sys/kernel/sched_rr_timeslice_ms
		echo 950000 > /proc/sys/kernel/sched_rt_runtime_us
		echo 1000000 > /proc/sys/kernel/sched_rt_period_us
		if [ -e "/proc/sys/kernel/sched_migration_fixup" ]; then
			echo 1 > /proc/sys/kernel/sched_migration_fixup
		fi
		if [ -e "/proc/sys/kernel/sched_freq_dec_notify" ]; then
			echo 410000 > /proc/sys/kernel/sched_freq_dec_notify
		fi
		if [ -e "/proc/sys/kernel/sched_freq_inc_notify" ]; then
			echo 610000 > /proc/sys/kernel/sched_freq_inc_notify
		fi
		if [ -e "/proc/sys/kernel/sched_boost" ]; then
			echo 0 > /proc/sys/kernel/sched_boost
		fi
		if [ "pnp_available" == "false" ]; then
			echo interactive will be set on LITTLE cluster
			echo 70 422400:50 480000:57 556800:69 652800:78 729600:83 844800:86 960000:91 1036800:89 1111300:86 1190400:7 1228800:88 1324800:94 1478400:99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
			echo 384050 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
			chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
			echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
			echo 422400 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
			echo 0 422400:120000 844800:150000 1111300:175000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
			echo 400 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		else
			echo PnP detected! Tweaks will be set accordingly
			echo 80 1324800:94 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		fi
	fi
fi
#if [ "$schedutil_available" == "false" ] && [ "$zzmove_available" == "true" ]; then
#	if [ -e $string1 ]; then
#		echo zzmove will be set on LITTLE cluster
#		if [ -e /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/profile_number ]; then
#			echo 2 > /sys/devices/system/cpu/cpu0/cpufreq/zzmoove/profile_number
#		fi
#	fi
#fi
fi
#Apply settings to Big cluster
echo Changing governor at big cluster

if [ -d /sys/devices/system/cpu/cpu2/cpufreq ]; then
if [ -e /sys/devices/system/cpu/cpu2/cpufreq ]; then
    GOV_big_PATH=/sys/devices/system/cpu/cpu2/cpufreq
fi
string2=/sys/devices/system/cpu/cpu2/cpufreq/scaling_available_governors;
interactive_available_big=false;
pwrutilx_available_big=false;
schedutil_available_big=false;
if grep 'interactive' $string2; then
     interactive_available_big=true;
fi
if grep 'pwrutilx' $string2; then
	pwrutilx_available_big=true;
fi
if grep 'schedutil' $string2; then
	schedutil_available_big=true;
fi
if [ "$pwrutilx_available_big" == "true" ]; then
	if [ -e $string2 ]; then
		echo setting pwrutilx
		echo pwrutilx > $GOV_big_PATH/scaling_governor
	fi
elif [ "$pwrutilx_available_big" == "false" ] && [ "$schedutil_available_big" == "true" ]; then
	if [ -e $string2 ]; then
		echo setting schedutil
		echo schedutil > $GOV_big_PATH/scaling_governor
	fi
else
    if [ -e $string2 ]; then
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/max_freq_hysteresis
		echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/ignore_hispeed_on_notif
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/boost
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/fast_ramp_down
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/align_windows
		echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/use_migration_notif
		echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/boostpulse_duration
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/io_is_busy
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/enable_prediction
		if [ "pnp_available" == "false" ]; then
			echo interactive will be set on big cluster
			echo interactive > $GOV_big_PATH/scaling_governor
			echo 76 556800:59 652800:74 729600:76 806400:80 883200:74 940800:78 1036800:82 1113600:81 1190400:83 1248000:84 1324800:86 1785600:91 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/target_loads
			echo 192025 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_slack
			echo 556800 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/hispeed_freq
			echo 40000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_rate
			echo 0 556800:100000 1248000:180000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/above_hispeed_delay
			echo 79 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/go_hispeed_load
			echo 25000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time
		else
			echo PnP detected! Tweaks will be set accordingly
			echo 76 1324800:86 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		fi
    fi
fi
fi
#Disable input boost
if [ -e "/sys/kernel/cpu_input_boost" ]; then
	chmod 644 /sys/kernel/cpu_input_boost/enable
	echo 0 > /sys/kernel/cpu_input_boost/enable
	chmod 644 /sys/kernel/cpu_input_boost/ib_duration_ms
	echo 0 > /sys/kernel/cpu_input_boost/ib_duration_ms
	chmod 644 /sys/kernel/cpu_input_boost/ib_freqs
	echo "0 0" > /sys/kernel/cpu_input_boost/ib_freqs
fi
if [ -e "/sys/module/cpu_boost" ]; then
	chmod 644 /sys/module/cpu_boost/parameters/input_boost_enabled
	echo 0 > /sys/module/cpu_boost/parameters/input_boost_enabled
	chmod 644 /sys/module/cpu_boost/parameters/input_boost_freq
	echo 0:0 1:0 2:0 3:0 > /sys/module/cpu_boost/parameters/input_boost_freq
	chmod 644 /sys/module/cpu_boost/parameters/boost_ms
	echo 0 > /sys/module/cpu_boost/parameters/boost_ms
	chmod 644 /sys/module/cpu_boost/parameters/input_boost_ms
	echo 0 > /sys/module/cpu_boost/parameters/input_boost_ms
fi
#Disable TouchBoost
echo Disabling TouchBoost
if [ -e "/sys/module/msm_performance/parameters/touchboost" ]; then
	chmod 644 /sys/module/msm_performance/parameters/touchboost
	echo 0 > /sys/module/msm_performance/parameters/touchboost
fi
if [ -e "/sys/power/pnpmgr/touch_boost" ]; then
	chmod 644 /sys/power/pnpmgr/touch_boost
	echo 0 > /sys/power/pnpmgr/touch_boost
fi
#I/0 Tweaks
echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
echo "maple" > /sys/block/mmcblk0/queue/scheduler
echo 16 > /sys/block/mmcblk0/queue/iosched/fifo_batch
echo 4 > /sys/block/mmcblk0/queue/iosched/writes_starved
echo 10 > /sys/block/mmcblk0/queue/iosched/sleep_latency_multiple
echo 0 > /sys/block/mmcblk0/queue/add_random
echo 0 > /sys/block/mmcblk0/queue/iostats
echo 1 > /sys/block/mmcblk0/queue/nomerges
echo 128 > /sys/block/mmcblk0/queue/nr_requests
echo 0 > /sys/block/mmcblk0/queue/rotational
echo 1 > /sys/block/mmcblk0/queue/rq_affinity
echo 1024 > /sys/block/mmcblk1/bdi/read_ahead_kb
echo "maple" > /sys/block/mmcblk1/queue/scheduler
echo 16 > /sys/block/mmcblk1/queue/iosched/fifo_batch
echo 4 > /sys/block/mmcblk1/queue/iosched/writes_starved
echo 10 > /sys/block/mmcblk1/queue/iosched/sleep_latency_multiple
echo 0 > /sys/block/mmcblk1/queue/add_random
echo 0 > /sys/block/mmcblk1/queue/iostats
echo 1 > /sys/block/mmcblk1/queue/nomerges
echo 0 > /sys/block/mmcblk1/queue/rotational
echo 1 > /sys/block/mmcblk1/queue/rq_affinity
#TCP tweaks
echo westwood > /proc/sys/net/ipv4/tcp_congestion_control
echo 2 > /proc/sys/net/ipv4/tcp_ecn
echo 1 > /proc/sys/net/ipv4/tcp_dsack
echo 0 > /proc/sys/net/ipv4/tcp_low_latency
echo 1 > /proc/sys/net/ipv4/tcp_timestamps
echo 1 > /proc/sys/net/ipv4/tcp_sack
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling
## Wakelocks
if [ -e "/sys/module/bcmdhd/parameters/wlrx_divide" ]; then
	echo 10 > /sys/module/bcmdhd/parameters/wlrx_divide
fi
if [ -e "/sys/module/bcmdhd/parameters/wlctrl_divide" ]; then
	echo 10 > /sys/module/bcmdhd/parameters/wlctrl_divide
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_rx_wake_ws" ]; then
	echo N > /sys/module/wakeup/parameters/enable_wlan_rx_wake_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_ctrl_wake_ws" ]; then
	echo N > /sys/module/wakeup/parameters/enable_wlan_ctrl_wake_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_wake_ws" ]; then
	echo N > /sys/module/wakeup/parameters/enable_wlan_wake_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_bluedroid_timer_ws" ]; then
	echo N > /sys/module/wakeup/parameters/enable_bluedroid_timer_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_ipa_ws" ]; then
	echo N > /sys/module/wakeup/parameters/enable_ipa_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_wlan_extscan_wl_ws" ]; then
	echo N > /sys/module/wakeup/parameters/enable_wlan_extscan_wl_ws
fi
if [ -e "/sys/module/wakeup/parameters/enable_qcom_rx_wakelock_ws" ]; then
	echo N > /sys/module/wakeup/parameters/enable_qcom_rx_wakelock_ws
fi
## Thermal
if [ -e "/sys/module/msm_thermal" ]; then
	chmod 644 /sys/module/msm_thermal/parameters/temp_threshold
	echo 36 > /sys/module/msm_thermal/parameters/temp_threshold
	echo 1 > /sys/module/msm_thermal/core_control/enabled
	chmod 644 /sys/module/msm_thermal/parameters/enabled
	echo N > /sys/module/msm_thermal/parameters/enabled
fi
## zRam
if [ -e "/sys/block/zram0" ]; then
	swapoff /dev/block/zram0 > /dev/null 2>&1
	echo 1 > /sys/block/zram0/reset
	echo lz4 > /sys/block/zram0/comp_algorithm
	echo 0 > /sys/block/zram0/disksize
	echo 0 > /sys/block/zram0/queue/add_random 
	echo 0 > /sys/block/zram0/queue/iostats 
	echo 2 > /sys/block/zram0/queue/nomerges 
	echo 0 > /sys/block/zram0/queue/rotational 
	echo 1 > /sys/block/zram0/queue/rq_affinity
	echo 4 > /sys/block/zram0/max_comp_streams
	chmod 644 /sys/block/zram0/disksize
	echo 1073741824 > /sys/block/zram0/disksize
	mkswap /dev/block/zram0 > /dev/null 2>&1
	swapon /dev/block/zram0 > /dev/null 2>&1
fi
## GPU
echo "msm-adreno-tz" > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/governor

if [ -d /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/gpu_available_frequencies ]; then
if [ -e /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/gpu_available_frequencies ]; then
    GPU_FREQ=/sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/gpu_available_frequencies
fi
GPU_OC=false;
if grep '652800000' $GPU_FREQ; then
     GPU_OC=true;
fi
if [ "$GPU_OC" == "true" ]; then
    if [ -e $GPU_FREQ ]; then
		chmod 644 /sys/class/kgsl/kgsl-3d0/max_gpuclk
		echo 652800000 > /sys/class/kgsl/kgsl-3d0/max_gpuclk
		echo 652800000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/max_freq
		chmod 644 /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/target_freq
		echo 214000000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/target_freq
		echo 133000000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/min_freq
		chmod 644 /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/adrenoboost
		echo 1 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/adrenoboost
    fi
fi
if [ "$GPU_OC" == "false" ]; then
	if [ -e $GPU_FREQ ]; then
		chmod 644 /sys/class/kgsl/kgsl-3d0/max_gpuclk
		echo 624000000 > /sys/class/kgsl/kgsl-3d0/max_gpuclk
		echo 624000000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/max_freq
		chmod 644 /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/target_freq
		echo 133000000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/target_freq
		echo 133000000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/min_freq
		chmod 644 /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/adrenoboost
		echo 2 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/adrenoboost
	fi
fi
fi
## Buttons
chmod 644 /sys/class/leds/button-backlight/bln
echo 0 > /sys/class/leds/button-backlight/bln
chmod 644 /sys/fpf/vib_strength
echo 0 > /sys/fpf/vib_strength
chmod 644 /sys/fpf/fpf_dt_wait_period
echo 5 > /sys/fpf/fpf_dt_wait_period
if [ -e "/sys/sweep2sleep/sweep2sleep" ]; then
	chmod 664 /sys/sweep2sleep/sweep2sleep
	echo 0 > /sys/sweep2sleep/sweep2sleep
fi
## Vibration
chmod 644 /sys/class/timed_output/vibrator/voltage_level
echo 710 > /sys/class/timed_output/vibrator/voltage_level
## FS
echo 10 > /proc/sys/fs/lease-break-time
echo 32768 > /proc/sys/fs/inotify/max_queued_events
echo 256 > /proc/sys/fs/inotify/max_user_instances
echo 16384 > /proc/sys/fs/inotify/max_user_watches
## VM
echo 500 > /proc/sys/vm/dirty_expire_centisecs
echo 3000 > /proc/sys/vm/dirty_writeback_centisecs
echo 0 > /proc/sys/vm/oom_kill_allocating_task
echo 0 > /proc/sys/vm/page-cluster
echo 60 > /proc/sys/vm/swappiness
echo 100 > /proc/sys/vm/vfs_cache_pressure
echo 15 > /proc/sys/vm/dirty_ratio
echo 3 > /proc/sys/vm/dirty_background_ratio
echo 50 > /proc/sys/vm/overcommit_ratio
echo 4096 > /proc/sys/vm/min_free_kbytes
echo 8 > /proc/sys/kernel/random/read_wakeup_threshold
echo 16 > /proc/sys/kernel/random/write_wakeup_threshold
## Block rpmb
echo "maple" > /sys/block/mmcblk0rpmb/queue/scheduler
echo 16 > /sys/block/mmcblk0rpmb/queue/iosched/fifo_batch
echo 4 > /sys/block/mmcblk0rpmb/queue/iosched/writes_starved
echo 10 > /sys/block/mmcblk0rpmb/queue/iosched/sleep_latency_multiple
echo 0 > /sys/block/mmcblk0rpmb/queue/add_random
echo 0 > /sys/block/mmcblk0rpmb/queue/iostats
echo 1 > /sys/block/mmcblk0rpmb/queue/nomerges
echo 0 > /sys/block/mmcblk0rpmb/queue/rotational
echo 1 > /sys/block/mmcblk0rpmb/queue/rq_affinity
## Block loop
for i in /sys/block/loop*; do
   echo 0 > $i/queue/add_random
   echo 0 > $i/queue/iostats
   echo 1 > $i/queue/nomerges
   echo 0 > $i/queue/rotational
   echo 1 > $i/queue/rq_affinity
done
## Block ram
for j in /sys/block/ram*; do
   echo 0 > $j/queue/add_random
   echo 0 > $j/queue/iostats
   echo 1 > $j/queue/nomerges
   echo 0 > $j/queue/rotational
   echo 1 > $j/queue/rq_affinity
done
## Charging 
echo "0" > /sys/kernel/fast_charge/force_fast_charge
## Filesystem
#busybox mount -o remount,noatime,barrier=0,nodiratime /sys
#busybox mount -o remount,noatime,noauto_da_alloc,nodiratime,barrier=0,nobh /system
#busybox mount -o remount,noatime,noauto_da_alloc,nosuid,nodev,nodiratime,barrier=0,nobh /data
#busybox mount -o remount,noatime,noauto_da_alloc,nosuid,nodev,nodiratime,barrier=0,nobh /cache
## Fstrim
fstrim -v /data
fstrim -v /cache
fstrim -v /system
fstrim -v /preload
echo ----------------------------------------------------
echo "Settings successfully applied, have fun! \m/"
echo ----------------------------------------------------
