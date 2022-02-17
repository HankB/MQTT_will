# MQTT_will

Use MQTT last will and testament to monitor host up. What it does:

* Connect to an MQTT broker, specifying a will message and topic.
* Send a "connect" message.
* Optionally send periodic updates.
* If the host goes away, the broker will publish the will message.

By default it uses a topic `CM/<hostname>/NA/state` to match the format in use for home automation. The 'NA' would be location and is unused for this particular topic.

## Motivation

I have several Raspberry Pis monitoring stuff for Homeassistant as well as a server and test server. Sometimes it takes too long for me to notice if one goes down or otherwise becomes unavailable. The MQTT last will and testament facility can be used to identify hosts that have stopped communicating (as long as the MQTT broker is still up.

Some work to prove the capability was done in this project <https://github.com/HankB/Fun_with_MQTT>.

## Plans

* custom messages for startup, update and will.
* run using systemd or crontab `@reboot` schedule
* options for repeat interval and hostname for MQTT broker.

## Programming Language

`bash` and `mosquitto_sub` resulted in unsatisfactory performance which did not appear to be entirely fixable. To provide better control over the initial connection and reconnecting, a monolothic program using an MQTT library seems like it will provide the capability to better manage the MQTT broker connection. Choices could be (in ortder of programming ease for me) C/C++, Python, Perl, Go and Rust. This seems like not a particularly demanding application so effeciency in terms of CPU load and RAM footprint are not a big consideration. Perhaps in the interest of expediency, C/C++ should be the first choice. When the broker logic is worked out, other langiuages can be explored. A brief search seems to indicate that the Paho MQTT library is popular and probably provides the same functionality for all.
