# extra comands/notes

This is just a convenient place to save notes and scripts to be used for the "extra" commands that MQTT_will supports.

For example, uptime as dsdd:yyt:mm

```text
hbarta@olive:~$ awk '{printf("%d:%02d:%02d\n",($1/60/60/24),($1/60/60%24),($1/60%60))}' /proc/uptime
3:06:03
hbarta@olive:~$
```

from the package `sysstat`, extract idle time

```text
hbarta@olive:~$ mpstat 1 1|tail -1 | awk '{print $12}'
94.47
hbarta@olive:~$ 
```

% memory used

'''text
hbarta@olive:~$ free -m|head -2 | tail -1|awk '{print int(100*$3/$2)}'
65
hbarta@olive:~$ 
```
