# MQTT_will in C

## Motivation 

Bug in paho MQTT C++ library that truncates the will message to the first character.

## Status

Proof of concept - modifications to provoke the broker to publish will message.

* Connect with a will message
* ~abort to avoid clean shutdown~
* Loop with a status message, `<ctrl>C` now triggers will message from broker.
* Reconnect logic works with broker stopped and restarted.


## Starting point

Use the `MQTTClient_publish.c` that comes with the C library - the simplest one to start with.

## Building

```text
sudo dnf install paho-c-devel
```

```text
cc -o MQTTClient_publish  -Wall MQTTClient_publish.c -lpaho-mqtt3cs 
cc -o MQTT_will -Wall MQTT_will.c -lpaho-mqtt3cs 
```

## Errata

Code that builds the topic with the host name may fail for ridiculously long hostnames (>1024).
