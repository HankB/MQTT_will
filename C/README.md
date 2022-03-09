# MQTT_will in C

## Motivation 

Bug in paho MQTT C++ library that truncates the will message to the first character.

## Status

Proof of concept - modifications to provoke the broker to publish will message.

* Connect with a will message
* ~abort to avoid clean shutdown~
* Loop with a status message, `<ctrl>C` now triggers will message from broker.
* Reconnect logic works with broker stopped and restarted.
* Some command line options provided, `extra` not fully implemented.

## Starting point

Use the `MQTTClient_publish.c` that comes with the C library - the simplest one to start with.

## Building

```text
sudo dnf install paho-c-devel
sudo apt install libpaho-mqtt-dev
```

```text
cc -o MQTT_will -Wall MQTT_will.c MQTT_getopt.c -lpaho-mqtt3cs 
```

### R-Pi OS 10

Need to build the paho library <https://github.com/eclipse/paho.mqtt.c> Most of the requirements listed below are for Debian packages.

```text
apt install libssl-dev
apt-get install build-essential gcc make cmake cmake-gui cmake-curses-gui
apt-get install fakeroot fakeroot devscripts dh-make lsb-release
apt-get install libssl-dev
apt-get install doxygen graphviz
sudo apt install ninja-build

git clone https://github.com/eclipse/paho.mqtt.c.git
cd paho.mqtt.c


## Errata

Code that builds the topic with the host name may fail for ridiculously long hostnames (>1024).
