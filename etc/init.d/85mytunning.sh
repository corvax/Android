#!/system/bin/sh
#============================================================#
# MyTunning script                                           #
# created for Nik Project X                                  #
# v. 0.5                                                     #
# 20120806 Corvax                                            #
#============================================================#

LOG_FILE=/data/mytunning.log
if [ -e $LOG_FILE ]; then
  rm $LOG_FILE;
fi;

set_value () {
	# $1 - parameter (fille name)
	# $2 - value

	echo "$1" | tee -a $LOG_FILE;
	echo "old: " | tee -a $LOG_FILE;
	cat $1 | tee -a $LOG_FILE;
	# apply
	echo "$2" > $1;
	echo "new: " | tee -a $LOG_FILE;
	cat $1 | tee -a $LOG_FILE;

	echo "" | tee -a $LOG_FILE;
}

echo "MyTunning script started $( date +"%d/%m/%Y %H:%M:%S" )" | tee -a $LOG_FILE;

# Settings for the internal task killer
# set limits to 8, 12, 16, 32, 64, 96 MB; use pages in the minfree file
#echo "2048,3072,4096,8192,16384,24576" > /sys/module/lowmemorykiller/parameters/minfree;
#echo "Task killer settings applied" | tee -a $LOG_FILE;

# Kernel tweaks
# Credits to: hardcore, URL: http://forum.xda-developers.com/showthread.php?t=813309
# Tweak cfq io scheduler
#for i in $(ls -1 /sys/block/stl*) $(ls -1 /sys/block/mmc*) $(ls -1 /sys/block/bml*) $(ls -1 /sys/block/tfsr*)
#do echo "0" > $i/queue/rotational
#echo "1" > $i/queue/iosched/low_latency
#echo "1" > $i/queue/iosched/back_seek_penalty
#echo "1000000000" > $i/queue/iosched/back_seek_max
#echo "3" > $i/queue/iosched/slice_idle
#done

echo "" | tee -a $LOG_FILE;
echo "Storage cards tweaks..." | tee -a $LOG_FILE;

# for sd-cards, SS4N1, URL: http://forum.xda-developers.com/showpost.php?p=11496754
#MMC=`ls -d /sys/block/mmc*`;
#for i in $MMC;
#do
#	echo 1024 > $i/queue/optimal_io_size
#	echo 256 > $i/queue/read_ahead_kb;
#	echo 0 > $i/queue/rotational; 
#	if [ -e $i/queue/iosched/back_seek_penalty ];
#	then
#		echo 1 > $i/queue/iosched/back_seek_penalty;
#		echo 0 > $i/queue/iosched/slice_idle;
#	elif [ -e $i/queue/iosched/fifo_batch ];
#	then
#		echo 1 > $i/queue/iosched/fifo_batch;
#	fi;
#done;
#log -p i -t SS4N1 "*** STORAGE *** applied storage and I/O tweaks";

set_value "/sys/block/mmcblk0/queue/optimal_io_size" "4096"
set_value "/sys/block/mmcblk1/queue/optimal_io_size" "4096"

set_value "/sys/block/mmcblk0/queue/read_ahead_kb" "2048"
set_value "/sys/block/mmcblk1/queue/read_ahead_kb" "2048"

# Need to be checked
#	echo 0 > $i/queue/rotational; 
#	if [ -e $i/queue/iosched/back_seek_penalty ];
#	then
#		echo 1 > $i/queue/iosched/back_seek_penalty;
#		echo 0 > $i/queue/iosched/slice_idle;
#	elif [ -e $i/queue/iosched/fifo_batch ];
#	then
#		echo 1 > $i/queue/iosched/fifo_batch;
#	fi;

# Remount all partitions with noatime
#for k in $(busybox mount | grep relatime | cut -d " " -f3)
#do
#sync
#busybox mount -o remount,noatime $k
#done

#############################
# Tweak Storage card
#############################

#echo "" | tee -a $LOG_FILE;
#echo "SD Card tweaks..." | tee -a $LOG_FILE;

# Increase Read Cache for better SD Card access
# Credits to: brainmaster, http://forum.xda-developers.com/showthread.php?t=1010807
if [ -e /sys/devices/virtual/bdi/179:0/read_ahead_kb ]
then
  #echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;
  set_value "/sys/devices/virtual/bdi/179:0/read_ahead_kb" "2048"
fi;

echo "SD Card tweaks applied" | tee -a $LOG_FILE;


##############################
# Tweak kernel VM management
##############################

echo "" | tee -a $LOG_FILE;
echo "Kernel tweaks..." | tee -a $LOG_FILE;

# /proc/sys/vm/swappiness
#  The value in this file controls how aggressively the kernel will swap
#  memory pages.  Higher values increase aggressiveness, lower values
#  decrease aggressiveness.  
#  URL: http://www.kernel.org/doc/man-pages/online/pages/man5/proc.5.html
# Default: 60
#echo "0" > /proc/sys/vm/swappiness;
set_value "/proc/sys/vm/swappiness" "0"
# /proc/sys/vm/dirty_ratio
#  Maximum percentage of total memory that can be filled with dirty pages 
#  before processes are forced to write dirty buffers themselves during 
#  their time slice instead of being allowed to do more writes.
# Default: 0
#echo "10" > /proc/sys/vm/dirty_ratio;
set_value "/proc/sys/vm/dirty_ratio" "10"
#echo "4096" > /proc/sys/vm/min_free_kbytes

# Misc tweaks for battery life
#  In hundredths of a second, this is how often pdflush wakes up to write data to disk.
# Default: 500
#echo "3000" > /proc/sys/vm/dirty_writeback_centisecs;
set_value "/proc/sys/vm/dirty_writeback_centisecs" "3000"
#  In hundredths of a second, how long data can be in the page cache before
#  it's considered expired and must be written at the next opportunity.
# Default: 100
#echo "1000" > /proc/sys/vm/dirty_expire_centisecs;
set_value "/proc/sys/vm/dirty_expire_centisecs" "1000"

echo "Kernel tweaks applied" | tee -a $LOG_FILE;

# Tweak kernel scheduler, less aggressive settings
# NOT FOUND IN Android 4.0.3
#echo "18000000" > /proc/sys/kernel/sched_latency_ns
#echo "3000000" > /proc/sys/kernel/sched_wakeup_granularity_ns
#echo "1500000" > /proc/sys/kernel/sched_min_granularity_ns


##################
# Network tweaks
##################

echo "" | tee -a $LOG_FILE;
echo "Network tweaks..." | tee -a $LOG_FILE;

# Network tweaks, SS4N1, URL: http://forum.xda-developers.com/showpost.php?p=11496754
# default: 120
setprop wifi.supplicant_scan_interval 180;

# default: not specified
#setprop net.tcp.buffersize.default 4096,87380,174760,4096,16384,131072;
#setprop net.tcp.buffersize.wifi 4095,87380,174760,4096,16384,131072;
#setprop net.tcp.buffersize.umts 4094,87380,174760,4096,16384,131072;
setprop net.tcp.buffersize.default 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.wifi 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.umts 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.gprs 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.edge 4096,87380,256960,4096,16384,256960;

# This gives the maximum number of packets allowed to queue 
# when an interface receives packets faster than the kernel can process them.
# Change the following parameters when a high rate of incoming connection requests result in connection failures
# default: 1000
#echo 262144 > /proc/sys/net/core/netdev_max_backlog;
set_value "/proc/sys/net/core/netdev_max_backlog" "262144"

# default: 128
#echo 262144 > /proc/sys/net/core/somaxconn;
set_value "/proc/sys/net/core/somaxconn" "262144"

# setting the TCP Window to 256960, 
#echo 256960 > /proc/sys/net/core/rmem_default;
set_value "/proc/sys/net/core/rmem_default" "256960"
#echo 404480 > /proc/sys/net/core/rmem_max;
set_value "/proc/sys/net/core/rmem_max" "404480"
#echo 256960 > /proc/sys/net/core/wmem_default;
set_value "/proc/sys/net/core/wmem_default" "256960"
#echo 404480 > /proc/sys/net/core/wmem_max;
set_value "/proc/sys/net/core/wmem_max" "404480"

# disabling timestamps (to avoid 12 byte header overhead), 
# enabling tcp window scaling, and selective acknowledgements
#echo 0 > /proc/sys/net/ipv4/tcp_timestamps;
set_value "/proc/sys/net/ipv4/tcp_timestamps" "0"
#echo 1 > /proc/sys/net/ipv4/tcp_window_scaling;
set_value "/proc/sys/net/ipv4/tcp_window_scaling" "1"
#echo 1 > /proc/sys/net/ipv4/tcp_sack;
set_value "/proc/sys/net/ipv4/tcp_sack" "1"

# It enables fast recycling of TIME_WAIT sockets.
#echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle;
set_value "/proc/sys/net/ipv4/tcp_tw_recycle" "1"
#echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse;
set_value "/proc/sys/net/ipv4/tcp_tw_reuse" "1"

# Connection timeouts
#echo 5 > /proc/sys/net/ipv4/tcp_keepalive_probes;
set_value "/proc/sys/net/ipv4/tcp_keepalive_probes" "5"

#echo 30 > /proc/sys/net/ipv4/tcp_keepalive_intvl;
set_value "/proc/sys/net/ipv4/tcp_keepalive_intvl" "30"

#echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout;
set_value "/proc/sys/net/ipv4/tcp_fin_timeout" "30"

# memory reserved for TCP send buffers,
# the 3 numbers represent minimum, default and maximum memory values.
# default: 262144  524288  1048576
#echo 4096 16384 404480 > /proc/sys/net/ipv4/tcp_wmem;
set_value "/proc/sys/net/ipv4/tcp_wmem" "4096 16384 404480"

# memory reserved for TCP receive buffers
# default: 524288  1048576 2097152
#echo 4096 87380 404480 > /proc/sys/net/ipv4/tcp_rmem;
set_value "/proc/sys/net/ipv4/tcp_rmem" "4096 87380 404480"

# Need to be checked
#echo 1200 > /proc/sys/net/ipv4/tcp_keepalive_time;
#echo 360000 > /proc/sys/net/ipv4/tcp_max_tw_buckets;
#echo 5 > /proc/sys/net/ipv4/tcp_reordering;
#echo 0 > /proc/sys/net/ipv4/tcp_slow_start_after_idle;
#echo 3 > /proc/sys/net/ipv4/tcp_syn_retries;
#echo 2 > /proc/sys/net/ipv4/tcp_synack_retries;

#echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects;
#echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects;
#log -p i -t SS4N1 "*** NETWORK *** applied WIFI and TCP tweaks";
echo "Network tweaks applied" | tee -a $LOG_FILE;

################
# Other tweaks
################

# keep launcher in memory 
setprop ro.HOME_APP_ADJ 1

# increase system responsiveness
setprop debug.performance.tuning 1
setprop video.accelerate.hw 1

echo "Other tweaks applied" | tee -a $LOG_FILE;

echo "MyTunning script finished $( date +"%d/%m/%Y %H:%M:%S" )" | tee -a $LOG_FILE;
