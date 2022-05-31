# MQTT_will in C

## Motivation 

Bug in paho MQTT C++ library that truncates the will message to the first character. Not present in the C library.

## Direction

This is very much tailored/specific to my needs and wants. Is there benefit to making it more general in order to be more widely useful? IOW

* Provide command line (or other) options for the topic
* Provide command line (or other) options for the hello, status update and will messages?

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
cc -o MQTT_will -Wall MQTT_will.c MQTT_getopt.c MQTT_extra.c -lpaho-mqtt3cs 
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
```

Apparently didn't capture the rest. :(

## Usage / deploying via Ansdible

Work on the Ansibl;e playbooks is in progress.

Install on a target machine in some convenient location and add an `@reboot` cron job to start this off. It could also be run as a Systemd service but that is not provided at this time.

One way to use this is to combine it with other publishing requirements. For example this is intended to use on a Raspberry Pi that is collecting and publishing sensor information and the sensor information can be provided by a program provided using the `-extra` option option under development. The command provided wil be executed and its output captured and inserted into the JSON payload. Example output might look like

```text
"uptime": "232008", "temp": 68.3, "press": 991.6, "humid": 31.2
```

And would then be inserted into the LWT message

```text
{ "t": 1646841182, "status": "still" }
```

And result in

```text
{ "t": 1646841182, "status": "still",  "uptime": 232008, "temp": 68.3, "press": 991.6, "humid": 31.2 }
```

## Errata

Code that builds the topic with the host name may fail for ridiculously long hostnames (>1024).
