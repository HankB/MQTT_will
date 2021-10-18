# MQTT_will

Use MQTT last will and testament to monitor host up. What it does:

* Connect to an MQTT broker, specifying a will message and topic.
* Send a "connect" message.
* Optionally send periodic updates.
* If the host goes away, the broker will publish the will message.

By default it uses a topic `CM/<hostname>/NA/state` to match the format in use for home automation. The 'NA' would be location and is unused for this particular topic.

## Status

Usable.

* Limited unit tests succeed.
* Runs from command line (Ship it!)
* requires that broker accept anonymous connections. (Not default for Mosquiqitto 2.0)
* Restart on boot (via Systemd) not presently working.

At present, starts from `/etc/rc.local` using

```text
runuser -u hbarta $(sleep 10; cd /home/hbarta/MQTT_will; /home/hbarta/bin/MQTT_will.sh) 2>&1 > /tmp/rc.local.err &
```

## TODO

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

## Systemd unit

```text
sudo loginctl enable-linger $USER
mkdir -p ~/.config/systemd/user/
mkdir ~/MQTT_will
mkdir -p ~/bin
cp MQTT_will.sh ~/bin/
# cp custom_settings ~/bin/ # if used, not currently working
cp MQTT_will.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user status MQTT_will
systemctl --user enable MQTT_will
systemctl --user start MQTT_will
systemctl --user status MQTT_will
```

## Errata

This script does not provide user/password authentication. For MQTT 2.0 it may be necessary to add the following to `/etc/mosquitto/mosquitto.conf`

```text
listener 1883
allow_anonymous true
```
`mosquitto_pub` and `mosquitto_pub` use `-h` to specify broker name. This script uses `-b` and uses `-h` for a Usage message"
