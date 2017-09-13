#!/system/bin/sh
#Original author: Alcolawl
#Settings By: RogerF81
#Device: HTC 10 (perfume)
#Codename: Soilworker_UNI
#SoC: Snapdragon 820
#Build Status: stable
#Version: 7.1
#Last Updated: 09/13/2017
#Credits: @Alcolawl @soniCron @Asiier @Freak07 @Mostafa Wael @Senthil360 @TotallyAnxious @Eliminater74 @RenderBroken @ZeroInfinity @Kyuubi10 @ivicask
sleep 30
echo "----------------------------------------------------"
echo "Applying Soilwork Kernel Tweaks"
echo "----------------------------------------------------"
echo "\m/"
echo "Let's go"

#Disable BCL
if [ -e /sys/devices/soc/soc:qcom,bcl/mode ]; then
	echo "Disabling BCL and Removing Perfd"
	chmod 644 /sys/devices/soc/soc:qcom,bcl/mode
	echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
fi
if [ -e /data/system/perfd ]; then
	stop perfd
fi
if [ -e /data/system/perfd/default_values ]; then
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
echo "Changing governor at LITTLE cluster"
if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
	if [ -e /sys/devices/system/cpu/cpu0/cpufreq ]; then
   		GOV_PATH=/sys/devices/system/cpu/cpu0/cpufreq
	fi
	string1=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors;
	string1_1=/system/etc/;
	interactive_available=false;
	pwrutilx_available=false;
	schedutil_available=false;
	pnp_available=false;
	if grep 'pwrutilx' $string1; then
		pwrutilx_available=true;
	fi
	if grep 'schedutil' $string1; then
		schedutil_available=true;
	fi
	if [ -e /system/etc/pnp.xml ]; then
		pnp_available=true;
	fi
	if grep 'interactive' $string1; then
  		interactive_available=true;
	fi
	if [ "$pwrutilx_available" == "true" ]; then
		if [ -e $string1 ]; then
			echo "setting pwrutilx"
			echo pwrutilx > $GOV_PATH/scaling_governor
			echo 96 > /proc/sys/kernel/sched_nr_migrate
			echo 0 > /dev/stune/schedtune.prefer_idle
			echo 0 > /dev/stune/background/schedtune.prefer_idle
			echo 1 > /dev/stune/foreground/schedtune.prefer_idle
			echo 1 > /dev/stune/top-app/schedtune.prefer_idle
			echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/pwrutilx/iowait_boost_enable
			echo 800 > /sys/devices/system/cpu/cpu0/cpufreq/pwrutilx/up_rate_limit_us
			echo 4000 > /sys/devices/system/cpu/cpu0/cpufreq/pwrutilx/down_rate_limit_us
			if [ -e /proc/sys/kernel/sched_autogroup_enabled ]; then
				echo 0 > /proc/sys/kernel/sched_autogroup_enabled
			fi
			echo 0 > /proc/sys/kernel/sched_child_runs_first
			echo 1 > /proc/sys/kernel/sched_cstate_aware
			if [ -e /proc/sys/kernel/sched_is_big_little ]; then
				echo 1 > /proc/sys/kernel/sched_is_big_little
			fi
			echo 0 > /proc/sys/kernel/sched_initial_task_util
			if [ -e "proc/sys/kernel/sched_boost ]; then
				echo 0 > /proc/sys/kernel/sched_boost
			fi
			if [ -e /proc/sys/kernel/sched_use_walt_task_util ]; then
				echo 0 > /proc/sys/kernel/sched_use_walt_task_util
				echo 0 > /proc/sys/kernel/sched_use_walt_cpu_util
				echo 0 > /proc/sys/kernel/sched_walt_init_task_load_pct
			fi
		fi
	elif [ "$pwrutilx_available" == "false" ] && [ "$schedutil_available" == "true" ]; then
		if [ -e $string1 ]; then
			echo "setting schedutil"
			echo schedutil > $GOV_PATH/scaling_governor
			chmod 664 /dev/stune/top-app/schedtune.boost
			echo 10 > /dev/stune/top-app/schedtune.boost
			echo 96 > /proc/sys/kernel/sched_nr_migrate
			echo 0 > /dev/stune/background/schedtune.prefer_idle
			echo 1 > /dev/stune/foreground/schedtune.prefer_idle
			echo 1 > /dev/stune/top-app/schedtune.prefer_idle
			if [ -e /proc/sys/kernel/sched_autogroup_enabled ]; then
				echo 0 > /proc/sys/kernel/sched_autogroup_enabled
			fi
			echo 0 > /proc/sys/kernel/sched_child_runs_first
			echo 1 > /proc/sys/kernel/sched_cstate_aware
			if [ -e /proc/sys/kernel/sched_is_big_little ]; then
				echo 1 > /proc/sys/kernel/sched_is_big_little
			fi
			echo 0 > /proc/sys/kernel/sched_initial_task_util
			if [ -e /proc/sys/kernel/sched_boost ]; then
				echo 0 > /proc/sys/kernel/sched_boost
			fi
			if [ -e /proc/sys/kernel/sched_use_walt_task_util ]; then
				echo 0 > /proc/sys/kernel/sched_use_walt_task_util
				echo 0 > /proc/sys/kernel/sched_use_walt_cpu_util
				echo 0 > /proc/sys/kernel/sched_walt_init_task_load_pct
			fi
		fi
	else
   		if [ -e $string1 ]; then
			echo "Tweaking HMP Scheduler"
			echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
			echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
			echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif
			echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
			echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down
			echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
			echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
			echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
			echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
			echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
			echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction
			echo 50 > /proc/sys/kernel/sched_upmigrate
			echo 15 > /proc/sys/kernel/sched_downmigrate
			echo 15 > /proc/sys/kernel/sched_small_wakee_task_load
			echo 20 > /proc/sys/kernel/sched_init_task_load
			if [ -e /proc/sys/kernel/sched_heavy_task ]; then
				echo 45 > /proc/sys/kernel/sched_heavy_task
			fi
			if [ -e /proc/sys/kernel/sched_enable_power_aware ]; then
				echo 1 > /proc/sys/kernel/sched_enable_power_aware
			fi
			echo 1 > /proc/sys/kernel/sched_enable_thread_grouping
			echo 5 > /proc/sys/kernel/sched_big_waker_task_load
			if [ -e /proc/sys/kernel/sched_small_task ]; then
				echo 1 > /proc/sys/kernel/sched_small_task
			fi
			echo 2 > /proc/sys/kernel/sched_window_stats_policy
			echo 4 > /proc/sys/kernel/sched_ravg_hist_size
			echo 9 > /proc/sys/kernel/sched_upmigrate_min_nice
			echo 3 > /proc/sys/kernel/sched_spill_nr_run
			echo 55 > /proc/sys/kernel/sched_spill_load
			echo 1 > /proc/sys/kernel/sched_enable_thread_grouping
			echo 0 > /proc/sys/kernel/sched_restrict_cluster_spill
			echo 110 > /proc/sys/kernel/sched_wakeup_load_threshold
			echo 30 > /proc/sys/kernel/sched_rr_timeslice_ms
			echo 950000 > /proc/sys/kernel/sched_rt_runtime_us
			echo 1000000 > /proc/sys/kernel/sched_rt_period_us
			if [ -e /proc/sys/kernel/sched_migration_fixup ]; then
				echo 1 > /proc/sys/kernel/sched_migration_fixup
			fi
			if [ -e /proc/sys/kernel/sched_freq_dec_notify ]; then
				echo 410000 > /proc/sys/kernel/sched_freq_dec_notify
			fi
			if [ -e /proc/sys/kernel/sched_freq_inc_notify ]; then
				echo 610000 > /proc/sys/kernel/sched_freq_inc_notify
			fi
			if [ -e /proc/sys/kernel/sched_boost ]; then
				echo 0 > /proc/sys/kernel/sched_boost
			fi
			if [ "pnp_available" == "false" ]; then
				echo "interactive will be set on LITTLE cluster"
				echo 67 422400:49 480000:56 556800:68 652800:76 729600:81 844800:84 960000:89 1036800:87 1111300:84 1190400:7 1228800:86 1324800:92 1478400:99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
				echo 356940 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
				chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
				echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
				echo 652800 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
				echo 0 652800:40000 1111300:120000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
				echo 400 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
			else
				echo "PnP detected! Tweaks will be set accordingly"
				echo 67 1228800:86 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
			fi
		fi
	fi
fi
#Apply settings to Big cluster
echo "Changing governor at big cluster"
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
			echo "setting pwrutilx"
			echo pwrutilx > $GOV_big_PATH/scaling_governor
			echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/pwrutilx/iowait_boost_enable
			echo 800 > /sys/devices/system/cpu/cpu2/cpufreq/pwrutilx/up_rate_limit_us
			echo 3000 > /sys/devices/system/cpu/cpu2/cpufreq/pwrutilx/down_rate_limit_us		
		fi
	elif [ "$pwrutilx_available_big" == "false" ] && [ "$schedutil_available_big" == "true" ]; then
		if [ -e $string2 ]; then
			echo "setting schedutil"
			echo schedutil > $GOV_big_PATH/scaling_governor
		fi
	else
   		if [ -e $string2 ]; then
			echo 40000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time
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
				echo "interactive will be set on big cluster"
				echo interactive > $GOV_big_PATH/scaling_governor
				echo 58 556800:58 652800:78 729600:80 806400:84 883200:77 940800:82 1036800:86 1113600:84 1190400:87 1248000:88 1324800:90 1785600:96 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/target_loads
				echo 178470 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_slack
				echo 1248000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/hispeed_freq
				echo 20000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_rate
				echo 0 652800:80000 1248000:120000> /sys/devices/system/cpu/cpu2/cpufreq/interactive/above_hispeed_delay
				echo 81 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/go_hispeed_load
			else
				echo "PnP detected! Tweaks will be set accordingly"
				echo 58 1248000:88 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
			fi
		fi
	fi
fi
#Disable input boost
if [ -e /sys/kernel/cpu_input_boost ]; then
	chmod 644 /sys/kernel/cpu_input_boost/enable
	echo 0 > /sys/kernel/cpu_input_boost/enable
	chmod 644 /sys/kernel/cpu_input_boost/ib_duration_ms
	echo 0 > /sys/kernel/cpu_input_boost/ib_duration_ms
	chmod 644 /sys/kernel/cpu_input_boost/ib_freqs
	echo "0 0" > /sys/kernel/cpu_input_boost/ib_freqs
fi
if [ -e /sys/module/cpu_boost ]; then
	chmod 644 /sys/module/cpu_boost/parameters/sched_boost_on_input
	echo N > /sys/module/cpu_boost/parameters/sched_boost_on_input
	chmod 644 /sys/module/cpu_boost/parameters/input_boost_freq
	echo 0:0 1:0 2:0 3:0 > /sys/module/cpu_boost/parameters/input_boost_freq
	chmod 644 /sys/module/cpu_boost/parameters/boost_ms
	echo 0 > /sys/module/cpu_boost/parameters/boost_ms
fi
#Disable TouchBoost
echo "Disabling TouchBoost"
if [ -e /sys/module/msm_performance/parameters/touchboost ]; then
	chmod 644 /sys/module/msm_performance/parameters/touchboost
	echo 0 > /sys/module/msm_performance/parameters/touchboost
fi
if [ -e /sys/power/pnpmgr/touch_boost ]; then
	chmod 644 /sys/power/pnpmgr/touch_boost
	echo 0 > /sys/power/pnpmgr/touch_boost
fi
#I/0 & block tweaks
string3=/sys/block/mmcblk0/queue/scheduler;
deadline=false;
bfq=false;
if grep 'deadline' $string3; then
	deadline=true;
fi
if grep 'bfq' $string3; then
	bfq=true;
fi
if [ "$deadline" == "true" ]; then
	if [ -e $string3 ]; then
		echo "setting deadline"
		echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
		echo "deadline" > /sys/block/mmcblk0/queue/scheduler
		echo 16 > /sys/block/mmcblk0/queue/iosched/fifo_batch
		echo 1 > /sys/block/mmcblk0/queue/iosched/front_merges
		echo 250 > /sys/block/mmcblk0/queue/iosched/read_expire
		echo 2500 > /sys/block/mmcblk0/queue/iosched/write_expire
		echo 1 > /sys/block/mmcblk0/queue/iosched/writes_starved
		echo 0 > /sys/block/mmcblk0/queue/add_random
		echo 0 > /sys/block/mmcblk0/queue/iostats
		echo 1 > /sys/block/mmcblk0/queue/nomerges
		echo 0 > /sys/block/mmcblk0/queue/rotational
		echo 1 > /sys/block/mmcblk0/queue/rq_affinity
		echo 1024 > /sys/block/mmcblk1/bdi/read_ahead_kb
		echo "deadline" > /sys/block/mmcblk1/queue/scheduler
		echo 16 > /sys/block/mmcblk1/queue/iosched/fifo_batch
		echo 1 > /sys/block/mmcblk1/queue/iosched/front_merges
		echo 250 > /sys/block/mmcblk1/queue/iosched/read_expire
		echo 2500 > /sys/block/mmcblk1/queue/iosched/write_expire
		echo 1 > /sys/block/mmcblk1/queue/iosched/writes_starved
		echo 0 > /sys/block/mmcblk1/queue/add_random
		echo 0 > /sys/block/mmcblk1/queue/iostats
		echo 1 > /sys/block/mmcblk1/queue/nomerges
		echo 0 > /sys/block/mmcblk1/queue/rotational
		echo 1 > /sys/block/mmcblk1/queue/rq_affinity
		echo "deadline" > /sys/block/mmcblk0rpmb/queue/scheduler
		echo 16 > /sys/block/mmcblk0rpmb/queue/iosched/fifo_batch
		echo 1 > /sys/block/mmcblk0rpmb/queue/iosched/front_merges
		echo 250 > /sys/block/mmcblk0rpmb/queue/iosched/read_expire
		echo 2500 > /sys/block/mmcblk0rpmb/queue/iosched/write_expire
		echo 1 > /sys/block/mmcblk0rpmb/queue/iosched/writes_starved
		echo 0 > /sys/block/mmcblk0rpmb/queue/add_random
		echo 0 > /sys/block/mmcblk0rpmb/queue/iostats
		echo 1 > /sys/block/mmcblk0rpmb/queue/nomerges
		echo 0 > /sys/block/mmcblk0rpmb/queue/rotational
		echo 1 > /sys/block/mmcblk0rpmb/queue/rq_affinity
	fi
elif [ "$deadline" == "false" ] && [ "bfq" == "true" ]; then
	if [ -e $string3 ]; then
		echo "setting bfq"
		echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
		echo "bfq" > /sys/block/mmcblk0/queue/scheduler
		echo 16384 > /sys/block/mmcblk0/queue/iosched/back_seek_max
		echo 1 > /sys/block/mmcblk0/queue/iosched/back_seek_penalty
		echo 250 > /sys/block/mmcblk0/queue/iosched/fifo_expire_async
		echo 120 > /sys/block/mmcblk0/queue/iosched/fifo_expire_sync
		echo 1 > /sys/block/mmcblk0/queue/iosched/low_latency
		echo 0 > /sys/block/mmcblk0/queue/iosched/max_budget
		echo 4 > /sys/block/mmcblk0/queue/iosched/max_budget_async_rq
		echo 0 > /sys/block/mmcblk0/queue/iosched/slice_idle
		echo 40 > /sys/block/mmcblk0/queue/iosched/timeout_async
		echo 120 > /sys/block/mmcblk0/queue/iosched/timeout_sync
		echo 20 > /sys/block/mmcblk0/queue/iosched/wr_coeff
		echo 7000 > /sys/block/mmcblk0/queue/iosched/wr_max_softrt_rate
		echo 2250 > /sys/block/mmcblk0/queue/iosched/wr_max_time
		echo 2000 > /sys/block/mmcblk0/queue/iosched/wr_min_idle_time
		echo 500 > /sys/block/mmcblk0/queue/iosched/wr_min_inter_arr_async
		echo 300 > /sys/block/mmcblk0/queue/iosched/wr_rt_max_time
		echo 0 > /sys/block/mmcblk0/queue/add_random
		echo 0 > /sys/block/mmcblk0/queue/iostats
		echo 1 > /sys/block/mmcblk0/queue/nomerges
		echo 0 > /sys/block/mmcblk0/queue/rotational
		echo 1 > /sys/block/mmcblk1/queue/rq_affinity
		echo 1024 > /sys/block/mmcblk1/bdi/read_ahead_kb
		echo "bfq" > /sys/block/mmcblk1/queue/scheduler
		echo 16384 > /sys/block/mmcblk1/queue/iosched/back_seek_max
		echo 1 > /sys/block/mmcblk1/queue/iosched/back_seek_penalty
		echo 250 > /sys/block/mmcblk1/queue/iosched/fifo_expire_async
		echo 120 > /sys/block/mmcblk1/queue/iosched/fifo_expire_sync
		echo 1 > /sys/block/mmcblk1/queue/iosched/low_latency
		echo 0 > /sys/block/mmcblk1/queue/iosched/max_budget
		echo 4 > /sys/block/mmcblk1/queue/iosched/max_budget_async_rq
		echo 0 > /sys/block/mmcblk1/queue/iosched/slice_idle
		echo 40 > /sys/block/mmcblk1/queue/iosched/timeout_async
		echo 120 > /sys/block/mmcblk1/queue/iosched/timeout_sync
		echo 20 > /sys/block/mmcblk1/queue/iosched/wr_coeff
		echo 7000 > /sys/block/mmcblk1/queue/iosched/wr_max_softrt_rate
		echo 2250 > /sys/block/mmcblk1/queue/iosched/wr_max_time
		echo 2000 > /sys/block/mmcblk1/queue/iosched/wr_min_idle_time
		echo 500 > /sys/block/mmcblk1/queue/iosched/wr_min_inter_arr_async
		echo 300 > /sys/block/mmcblk1/queue/iosched/wr_rt_max_time
		echo 0 > /sys/block/mmcblk1/queue/add_random
		echo 0 > /sys/block/mmcblk1/queue/iostats
		echo 1 > /sys/block/mmcblk1/queue/nomerges
		echo 0 > /sys/block/mmcblk1/queue/rotational
		echo 1 > /sys/block/mmcblk1/queue/rq_affinity
		echo "bfq" > /sys/block/mmcblk0rpmb/queue/scheduler
		echo 16384 > /sys/block/mmcblk0rpmb/queue/iosched/back_seek_max
		echo 1 > /sys/block/mmcblk0rpmb/queue/iosched/back_seek_penalty
		echo 250 > /sys/block/mmcblk0rpmb/queue/iosched/fifo_expire_async
		echo 120 > /sys/block/mmcblk0rpmb/queue/iosched/fifo_expire_sync
		echo 1 > /sys/block/mmcblk0rpmb/queue/iosched/low_latency
		echo 0 > /sys/block/mmcblk0rpmb/queue/iosched/max_budget
		echo 4 > /sys/block/mmcblk0rpmb/queue/iosched/max_budget_async_rq
		echo 0 > /sys/block/mmcblk0rpmb/queue/iosched/slice_idle
		echo 40 > /sys/block/mmcblk0rpmb/queue/iosched/timeout_async
		echo 120 > /sys/block/mmcblk0rpmb/queue/iosched/timeout_sync
		echo 20 > /sys/block/mmcblk0rpmb/queue/iosched/wr_coeff
		echo 7000 > /sys/block/mmcblk0rpmb/queue/iosched/wr_max_softrt_rate
		echo 2250 > /sys/block/mmcblk0rpmb/queue/iosched/wr_max_time
		echo 2000 > /sys/block/mmcblk0rpmb/queue/iosched/wr_min_idle_time
		echo 500 > /sys/block/mmcblk0rpmb/queue/iosched/wr_min_inter_arr_async
		echo 300 > /sys/block/mmcblk0rpmb/queue/iosched/wr_rt_max_time
		echo 0 > /sys/block/mmcblk0rpmb/queue/add_random
		echo 0 > /sys/block/mmcblk0rpmb/queue/iostats
		echo 1 > /sys/block/mmcblk0rpmb/queue/nomerges
		echo 0 > /sys/block/mmcblk0rpmb/queue/rotational
		echo 1 > /sys/block/mmcblk0rpmb/queue/rq_affinity
	fi
else
	if [ -e $string3 ]; then
		echo "I/0 governor won't be changed"
    	fi
fi
#TCP tweaks
string4=/proc/sys/net/ipv4/tcp_available_congestion_control;
westwood=false;
if grep 'westwood' $string4; then
	westwood=true;
fi
if [ "$westwood" == "true" ]; then
	if [ -e $string4 ]; then
		echo "westwood will be set"
		echo westwood > /proc/sys/net/ipv4/tcp_congestion_control
		echo 2 > /proc/sys/net/ipv4/tcp_ecn
		echo 1 > /proc/sys/net/ipv4/tcp_dsack
		echo 1 > /proc/sys/net/ipv4/tcp_low_latency
		echo 1 > /proc/sys/net/ipv4/tcp_timestamps
		echo 1 > /proc/sys/net/ipv4/tcp_sack
		echo 1 > /proc/sys/net/ipv4/tcp_window_scaling
	fi
else
	if [ -e $string4 ]; then
		echo "cubic will be set"
		echo cubic > /proc/sys/net/ipv4/tcp_congestion_control
		echo 2 > /proc/sys/net/ipv4/tcp_ecn
		echo 1 > /proc/sys/net/ipv4/tcp_dsack
		echo 1 > /proc/sys/net/ipv4/tcp_low_latency
		echo 1 > /proc/sys/net/ipv4/tcp_timestamps
		echo 1 > /proc/sys/net/ipv4/tcp_sack
		echo 1 > /proc/sys/net/ipv4/tcp_window_scaling
	fi
fi
## Wakelocks
if [ -e /sys/module/bcmdhd/parameters/wlrx_divide ]; then
	echo 10 > /sys/module/bcmdhd/parameters/wlrx_divide
fi
if [ -e /sys/module/bcmdhd/parameters/wlctrl_divide ]; then
	echo 10 > /sys/module/bcmdhd/parameters/wlctrl_divide
fi
if [ -e /sys/module/wakeup/parameters/enable_wlan_rx_wake_ws ]; then
	echo N > /sys/module/wakeup/parameters/enable_wlan_rx_wake_ws
fi
if [ -e /sys/module/wakeup/parameters/enable_wlan_ctrl_wake_ws ]; then
	echo N > /sys/module/wakeup/parameters/enable_wlan_ctrl_wake_ws
fi
if [ -e /sys/module/wakeup/parameters/enable_wlan_wake_ws ]; then
	echo N > /sys/module/wakeup/parameters/enable_wlan_wake_ws
fi
if [ -e /sys/module/wakeup/parameters/enable_bluedroid_timer_ws ]; then
	echo N > /sys/module/wakeup/parameters/enable_bluedroid_timer_ws
fi
if [ -e /sys/module/wakeup/parameters/enable_ipa_ws ]; then
	echo N > /sys/module/wakeup/parameters/enable_ipa_ws
fi
if [ -e /sys/module/wakeup/parameters/enable_wlan_extscan_wl_ws ]; then
	echo N > /sys/module/wakeup/parameters/enable_wlan_extscan_wl_ws
fi
if [ -e /sys/module/wakeup/parameters/enable_qcom_rx_wakelock_ws ]; then
	echo N > /sys/module/wakeup/parameters/enable_qcom_rx_wakelock_ws
fi
## Thermal
if [ -e /sys/module/msm_thermal ]; then
	echo 1 > /sys/module/msm_thermal/core_control/enabled
	echo 0 > /sys/module/msm_thermal/vdd_restriction/enabled
fi
## zRam
if [ -e /sys/block/zram0 ]; then
	swapoff /dev/block/zram0 > /dev/null 2>&1
	echo 1 > /sys/block/zram0/reset
	echo lz4 > /sys/block/zram0/comp_algorithm
	echo 0 > /sys/block/zram0/disksize
	echo 0 > /sys/block/zram0/queue/add_random 
	echo 0 > /sys/block/zram0/queue/iostats 
	echo 2 > /sys/block/zram0/queue/nomerges 
	echo 0 > /sys/block/zram0/queue/rotational 
	echo 1 > /sys/block/zram0/queue/rq_affinity
	echo 64 > /sys/block/zram0/queue/nr_requests
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
	if [ "$GPU_FREQ" -gt 624000000 ]; then
    		GPU_OC=true;
	fi
	if [ "$GPU_OC" == "true" ]; then
		if [ -e $GPU_FREQ ]; then
			echo "GPU is overclocked"
			chmod 644 /sys/class/kgsl/kgsl-3d0/max_gpuclk
			echo 652800000 > /sys/class/kgsl/kgsl-3d0/max_gpuclk
			echo 652800000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/max_freq
			chmod 644 /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/target_freq
			echo 214000000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/target_freq
			echo 133000000 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/min_freq
			chmod 644 /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/adrenoboost
			echo 2 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/adrenoboost
   		fi
	else
		if [ -e $GPU_FREQ ]; then
			echo "GPU is on stock max freq"
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
##Pnp, if available
if [ -e /sys/power/pnpmgr ]; then
	echo 0 > /sys/power/pnpmgr/touch_boost
	echo 844800 > /sys/power/pnpmgr/cluster/little/cpu0/thermal_freq
	echo 307200 > /sys/power/pnpmgr/cluster/little/cpu0/scaling_min_freq
	echo 1248000 > /sys/power/pnpmgr/cluster/big/cpu0/thermal_freq
	echo 307200 > /sys/power/pnpmgr/cluster/big/cpu0/scaling_min_freq
fi	
## Vibration
chmod 644 /sys/class/timed_output/vibrator/voltage_level
echo 710 > /sys/class/timed_output/vibrator/voltage_level
## FS
echo 10 > /proc/sys/fs/lease-break-time
echo 32768 > /proc/sys/fs/inotify/max_queued_events
echo 256 > /proc/sys/fs/inotify/max_user_instances
echo 16384 > /proc/sys/fs/inotify/max_user_watches
## WQ
chmod 644 /sys/module/workqueue/parameters/power_efficient
echo Y > /sys/module/workqueue/parameters/power_efficient 
## VM
echo 500 > /proc/sys/vm/dirty_expire_centisecs
echo 3000 > /proc/sys/vm/dirty_writeback_centisecs
echo 0 > /proc/sys/vm/oom_kill_allocating_task
echo 0 > /proc/sys/vm/page-cluster
echo 60 > /proc/sys/vm/swappiness
echo 100 > /proc/sys/vm/vfs_cache_pressure
echo 20 > /proc/sys/vm/dirty_ratio
echo 5 > /proc/sys/vm/dirty_background_ratio
echo 50 > /proc/sys/vm/overcommit_ratio
echo 1 > /proc/sys/vm/laptop_mode
echo 4096 > /proc/sys/vm/min_free_kbytes
echo 64 > /proc/sys/kernel/random/read_wakeup_threshold
echo 896 > /proc/sys/kernel/random/write_wakeup_threshold
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
if [ -e /sys/module/snd_soc_wcd9330/parameters/high_perf_mode ]; then
	chmod 664 /sys/module/snd_soc_wcd9330/parameters/high_perf_mode
	echo 1 > /sys/module/snd_soc_wcd9330/parameters/high_perf_mode
fi
sleep 1
start perfd
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
