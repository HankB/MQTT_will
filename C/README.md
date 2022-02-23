# MQTT_will in C

## Motivation 

Bug in paho MQTT C++ library that truncates the will message to the first character.

## Starting point

Use the `QTTClient_publish.c` that comes with the C library - the simplest one to start with.

## Building

```text
cc -o MQTTClient_publish MQTTClient_publish.c -lpaho-mqtt3cs 
```

