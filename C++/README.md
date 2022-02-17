# MQTT_will in C++

## License

This portion of the code is derived from an example kindly provided by the Eclipse Foundation and therefore follows `Eclipse Public License - v 1.0` as described at http://www.eclipse.org/legal/epl-v10.html. The Eclipse foundation is not, of course, responsible for the changes I have made to the code.

## Status

None

## Plan

Implement using C++. Add unit tests as appropriate. Start with a simple `g++` build command and expand to `Makefile` or `cmake` if appropriate.

## Build

### Linux (Debian)

```text
sudo apt install libpaho-mqtt-dev
```

See [instructions for building the C++ library](Paho-C++-lib.md).

```text
g++ -o MQTT_will MQTT_will.cpp -lpaho-mqttpp3 -lpaho-mqtt3as -lpthread
```

## Test

Subscribe to local server

```text
mosquitto_sub  -v -t \#
```
Execute the produced binaryu

```text
./MQTT_will olive
```
