#!/system/bin/sh
#============================================================#
# MyTunning script                                           #
# created for Nik Project X                                  #
# v. 0.2                                                     #
# by Corvax, 20120713                                        #
#============================================================#

# Settings for the internal task killer
# set limits to 8, 12, 16, 32, 64, 96 MB; use pages in the minfree file
echo "2048,3072,4096,8192,16384,24576" > /sys/module/lowmemorykiller/parameters/minfree

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

# Remount all partitions with noatime
#for k in $(busybox mount | grep relatime | cut -d " " -f3)
#do
#sync
#busybox mount -o remount,noatime $k
#done

##############################
# Tweak Storeage card
##############################

# Increase Read Cache for better SD Card access
# Credits to: brainmaster, http://forum.xda-developers.com/showthread.php?t=1010807
if [ -e /sys/devices/virtual/bdi/179:0/read_ahead_kb ]
then
echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
fi

##############################
# Tweak kernel VM management
##############################

# /proc/sys/vm/swappiness
#  The value in this file controls how aggressively the kernel will swap
#  memory pages.  Higher values increase aggressiveness, lower values
#  decrease aggressiveness.  
#  URL: http://www.kernel.org/doc/man-pages/online/pages/man5/proc.5.html
# Default: 60
echo "0" > /proc/sys/vm/swappiness
# /proc/sys/vm/dirty_ratio
#  Maximum percentage of total memory that can be filled with dirty pages 
#  before processes are forced to write dirty buffers themselves during 
#  their time slice instead of being allowed to do more writes.
# Default: 0
echo "10" > /proc/sys/vm/dirty_ratio
#echo "4096" > /proc/sys/vm/min_free_kbytes

# Misc tweaks for battery life
#  In hundredths of a second, this is how often pdflush wakes up to write data to disk.
# Default: 500
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
#  In hundredths of a second, how long data can be in the page cache before
#  it's considered expired and must be written at the next opportunity.
# Default: 100
echo "1000" > /proc/sys/vm/dirty_expire_centisecs

# Tweak kernel scheduler, less aggressive settings
# NOT FOUND IN Android 4.0.3
#echo "18000000" > /proc/sys/kernel/sched_latency_ns
#echo "3000000" > /proc/sys/kernel/sched_wakeup_granularity_ns
#echo "1500000" > /proc/sys/kernel/sched_min_granularity_ns

# Network tweaks, SS4N1, URL: http://forum.xda-developers.com/showpost.php?p=11496754
#setprop wifi.supplicant_scan_interval 180;
#setprop net.tcp.buffersize.default 4096,87380,174760,4096,16384,131072;
#setprop net.tcp.buffersize.wifi 4095,87380,174760,4096,16384,131072;
#setprop net.tcp.buffersize.umts 4094,87380,174760,4096,16384,131072;
#echo 262144 > /proc/sys/net/core/netdev_max_backlog;
#echo 262144 > /proc/sys/net/core/somaxconn;
#echo 65535 > /proc/sys/net/core/rmem_default;
#echo 131071 > /proc/sys/net/core/rmem_max;
#echo 65535 > /proc/sys/net/core/wmem_default;
#echo 131071 > /proc/sys/net/core/wmem_max;
#echo 4096 16384 131072 > /proc/sys/net/ipv4/tcp_wmem;
#echo 4096 87380 174760 > /proc/sys/net/ipv4/tcp_rmem;
#echo 15 > /proc/sys/net/ipv4/tcp_fin_timeout;
#echo 1200 > /proc/sys/net/ipv4/tcp_keepalive_time;
#echo 360000 > /proc/sys/net/ipv4/tcp_max_tw_buckets;
#echo 5 > /proc/sys/net/ipv4/tcp_reordering;
#echo 0 > /proc/sys/net/ipv4/tcp_slow_start_after_idle;
#echo 3 > /proc/sys/net/ipv4/tcp_syn_retries;
#echo 2 > /proc/sys/net/ipv4/tcp_synack_retries;
#echo 0 > /proc/sys/net/ipv4/tcp_timestamps;
#echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle;
#echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse;
#echo 0 > /proc/sys/net/ipv4/tcp_window_scaling;
#echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects;
#echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects;
#log -p i -t SS4N1 "*** NETWORK *** applied WIFI and TCP tweaks";
