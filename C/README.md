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
* Loop with a status message, `<ctrl>C` now triggers will message from broker.
* Reconnect logic works with broker stopped and restarted and network interruptions.
* Some command line options provided, `extra` implemented and working as tested.
* Ansible playbook provided for easier deployment.

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

### Ansible
An Ansible playbook has seen light testing. (It worked at least once!) The command for a single host (e.g. `dorman`) would be

```text
ansible-playbook deploy-MQTT_will.yml -K -i dorman,
```

If the `overlayfs` finesystem has been deployed on the Raspberry Pi Target, the following command should work.

```text
ansible-playbook deploy-MQTT_will-overlayfs.yml -K -i dorman,
```

This has been developed primarily for use with my small herd of Raspberry Pis, some of which use the R-Ri OS readonly filesystem (`overlayfs`) so it provides support for installing on a Raspberry Pi that is so configured. There are three playbooks.

`deploy-MQTT_will-tasks.yml` which performs the desired installation steps.  
`deploy-MQTT_will.yml` invokes `deploy-MQTT_will-tasks.yml` to perform the tasks on a host which is not configured for `overlayfs`.  
`deploy-MQTT_will-overlayfs.yml` invokes `deploy-MQTT_will-tasks.yml` to perform the tasks on a host which *is* configured for `overlayfs`.  This requires another project that has the playbooks that enable and disable the `overlayfs` as needed. The directory structure is

```text
.../somedir/MQTT_will/
.../somedir/Ansible/
```

(`Ansible` should probably be a submodule of `MQTT_will` and will probably be there some day.) The `Ansible` project can be found at <https://github.com/HankB/Ansible>

### *Caution* which binary gets installed?

The Ansible playbook will install the binary found (and typically) built on the host architecture. If the architecture does not match the target host, it will not work. There is no checking for this.

### Manual installation

Install on a target machine in some convenient location and add an `@reboot` cron job to start this off. It could also be run as a Systemd service but that is not provided at this time.

One way to use this is to combine it with other publishing requirements. For example this is intended to use on a Raspberry Pi that is collecting and publishing sensor information and the sensor information can be provided by a program provided using the `-extra` option. The command provided will be executed and its output captured and inserted into the JSON payload. Example output from the "extra" program might look like

```text
"uptime": "232008", "temp": 68.3, "press": 991.6, "humid": 31.2
```

And would then be inserted into the LWT update message

```text
{ "t": 1646841182, "status": "still" }
```

And result in

```text
{ "t": 1646841182, "status": "still",  "uptime": 232008, "temp": 68.3, "press": 991.6, "humid": 31.2 }
```

## Errata

Code that builds the topic with the host name may fail for ridiculously long hostnames (>1024).
