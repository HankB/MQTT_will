# MQTT_will in bash/mosquitto_pub

## Status

Usable, Unsatisfactory. ABANDONED.

At present out of 10 hosts running this, only one shows the correct status on HomeAssistant. Most show "unknown" while 2 display the will message (even though they are still up.) The one that has the correct information was rebooted a little earlier. One booted a few minutes ago still displays the will message.

Clearly this is not working as desired. With the decoupling of functionality between shell commands and the connection to the broker there may not be a way to address the issue. While the concept seems good, this implementation is going to be abandoned.

* Limited unit tests do not succeed at present. Update to wait for successful ping of MQTT broker breaks this test.
* Runs from command line (Ship it!)
* requires that broker accept anonymous connections. (Not default for Mosquiqitto 2.0)
* Restart on boot (via Systemd) not tested with latest update.
* Starts from user crontab entry

```text
@reboot /home/pi/bin/MQTT_will.sh -b mqtt -i 300 >/tmp/MQTT_will 2>&1
```

## TODO

* <s>implement some processing tests.
* Provide a working Systemd unit file.
* Support non-anomyous connection
* add cleanup to `test_MQTT_will.sh` to delete test directory.</s>

## Testing

Using  `shellcheck` as a `bash` linter. Unit tests using `shunit2`. To lint and run all unit tests

```text
shellcheck -x  MQTT_will.sh
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

`mosquitto_pub` and `mosquitto_sub` use `-h` to specify broker name. This script uses `-b` and uses `-h` for a Usage message"
