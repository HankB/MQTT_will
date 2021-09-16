# MQTT_will

Use MQTT last will and testament to monitor host up.

## Status

Half Baked.

* Limited unit tests succeed.
* Runs from command line (Ship it!)
* requires that broker accept anonymous connections. (Not default for Mosquiqitto 2.0)

## TODO

* Decide what to do about topic. 
    * Config function like broker?
    * host name in topic? Or add to status messages.
* implement some processing tests.
* Provide a Systemd unit file.
* Support non-anomyous connection
* add cleanup to `test_MQTT_will.sh` to delete test directory.

## Motivation

I have several Raspberry Pis monitoring stuff for Homeassistant as well as a server and test server. Sometimes it takes too long for me to notice if one goes down or otherwise becomes unavailable. The MQTT last will and testament facility can be used to identify hosts that have stopped communicating (as long as the MQTT broker is still up.

Some work to prove the capability was done in this project <https://github.com/HankB/Fun_with_MQTT>.

## Plans

* custom messages for startup, update and will.
* run using systemd
* options for repeat interval and host for MQTT broker.

## Testing

Using  `shellcheck` as a `bash` linter. Unit tests using `shunit2`. To lint and run all unit tests

```text
shellcheck -P ./ test_MQTT_will.sh
./test_MQTT_will.sh
```

Seems not possible at present to run selected tests with this structure.

## requirements

### For Testing

* `shunit2`
* `mosquitto` and `mosquitto-clients` are be used test complete functionality. 

### To deploy

* `mosquitto-clients`

```text
apt install shunit2 shellcheck mosquitto
apt install mosquitto-clients
```

## Errata

This script does not provide user/password authentication. For MQTT 2.0 it may be necessary to add the following to `/etc/mosquitto/mosquitto.conf`

```text
listener 1883
allow_anonymous true
```
