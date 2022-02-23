# MQTT_will in C++

## License

This portion of the code is derived from an example kindly provided by the Eclipse Foundation and therefore follows `Eclipse Public License - v 1.0` as described at http://www.eclipse.org/legal/epl-v10.html. The Eclipse foundation is not, of course, responsible for the changes I have made to the code.

## Status

Example code added that includes MQTT publishing that works. However only the first character of the will message is published. Reported at https://github.com/eclipse/paho.mqtt.cpp/issues/378. Setting this aside until this can be addressed as the will message is critical for this project.

## Plan

Implement using C++. Add unit tests as appropriate. Start with a simple `g++` build command and expand to `Makefile` or `cmake` if appropriate.

## Build

### Linux (Debian)

```text
sudo apt install libpaho-mqtt-dev
```

See [instructions for building the C++ library](Paho-C++-lib.md).

```text
g++ -Wall -o MQTT_will MQTT_will.cpp -lpaho-mqttpp3 -lpaho-mqtt3as -lpthread
```

## Test

Subscribe to local server

```text
mosquitto_sub  -v -t \# -h olive
```

Execute the produced binary.

```text
./MQTT_will olive
```
