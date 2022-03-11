# extra comands/notes

This is just a convenient place to save notes and scripts to be used for the "extra" commands that MQTT_will supports.

For example, uptime as ddd:yy:mm

```text
hbarta@olive:~$ awk '{printf("%d:%02d:%02d\n",($1/60/60/24),($1/60/60%24),($1/60%60))}' /proc/uptime
3:06:03
hbarta@olive:~$
```

from the package `sysstat` package, extract idle time, calculate CPU usage

```text
hbarta@olive:~$ mpstat 1 1|tail -1 | awk '{print 100-$12}'
0.5
hbarta@olive:~$ 
```

% memory used

'''text
hbarta@olive:~$ free -m|head -2 | tail -1|awk '{print int(100*$3/$2)}'
65
hbarta@olive:~$ 
```

From https://shallowsky.com/blog/linux/kernel/sysfs-thermal-zone.html CPU temperature

```text
[hbarta@kapok C]$ cat /sys/class/thermal/thermal_zone0/temp
49000
[hbarta@kapok C]$ </sys/class/thermal/thermal_zone0/temp awk '{print $1/1000}'
51
[hbarta@kapok C]$ 
```

Root FS usage

```text
[hbarta@kapok C]$ df --output=pcent /|tail -1
  3%
[hbarta@kapok C]$ 
```
