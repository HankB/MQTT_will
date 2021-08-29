# MQTT_will

Use MQTT last will and testament to monitor host up.

## Motivation

I have several Raspberry Pis monitoring stuff for Homeassistant as well as a server and test server. Sometimes it takes too long for me to notice if one goes down or otherwise becomes unavailable. The MQTT last will and testament facility can be used to identify hosts that have stopped communicating (as long as the MQTT broker is still up.

Some work to prove the capability was done in this project <https://github.com/HankB/Fun_with_MQTT>.

## Plans

* custom messages for startup, update and will.
* run using systemd
* options for repeat interval and host for MQTT broker.

## Testing

Using  `shellcheck` as a `bash` linter. Unit tests using `shunit12`. To run all unit tests


```text
./MQTT_will.sh -t
```

Seems not possible at present to run selected tests with this structure (tests in same file as the code under test.)

## TODO

* split out testing into a separate file(s)
* Decide what to do about topic. Function like broker, connect_msg etc?
* implement some processing tests.
