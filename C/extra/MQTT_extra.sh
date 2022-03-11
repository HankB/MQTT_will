#!/bin/sh
#
# script to capture some system statistics to include in the MQTT_will hello and update messages.

CPU_pct=$(mpstat 1 1|tail -1 | awk '{print 100-$12}')
uptime=$(awk '{printf("%d:%02d:%02d\n",($1/60/60/24),($1/60/60%24),($1/60%60))}' /proc/uptime)
mem_pct=$(free -m|head -2 | tail -1|awk '{print int(100*$3/$2)}')
CPU_temp=$(</sys/class/thermal/thermal_zone0/temp awk '{print $1/1000}')
FS_pct=$(df --output=pcent /|tail -1|tr -d "[ %]")
echo " \"uptime\":\"$uptime\", \"CPU_pct\":$CPU_pct, \"mem_pct\":$mem_pct, \"CPU_temp\":$CPU_temp, \"FS_pct\":$FS_pct"