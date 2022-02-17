#  Paho C++ library

Seems not available as a Debian package so must be built from source. Instructions at <https://github.com/eclipse/paho.mqtt.cpp#building-the-paho-c-library-1>

```text
git clone https://github.com/eclipse/paho.mqtt.cpp
cd paho.mqtt.cpp
cmake -Bbuild -H. -DPAHO_BUILD_STATIC=ON \
    -DPAHO_BUILD_DOCUMENTATION=TRUE -DPAHO_BUILD_SAMPLES=TRUE

cmake -Bbuild -H. -DPAHO_WITH_SSL=ON -DPAHO_ENABLE_TESTING=OFF -DPAHO_BUILD_DEB_PACKAGE=ON
cmake --build build
(cd build && cpack)
sudo apt install  ./build/libpaho-mqtt.cpp-1.2.0-Linux.deb
```

```text
hbarta@olive:~/Downloads/paho-mqtt-C++/paho.mqtt.cpp$ ls -l build/libpaho-mqtt.cpp-1.2.0-Linux.deb
-rw-r--r-- 1 hbarta hbarta 2199044 Feb 17 11:45 build/libpaho-mqtt.cpp-1.2.0-Linux.deb
hbarta@olive:~/Downloads/paho-mqtt-C++/paho.mqtt.cpp$ sudo apt install  ./build/libpaho-mqtt.cpp-1.2.0-Linux.deb
[sudo] password for hbarta: 
Sorry, try again.
[sudo] password for hbarta: 
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Note, selecting 'libpaho-mqtt.cpp' instead of './build/libpaho-mqtt.cpp-1.2.0-Linux.deb'
The following NEW packages will be installed:
  libpaho-mqtt.cpp
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 0 B/2,199 kB of archives.
After this operation, 16.0 MB of additional disk space will be used.
Get:1 /home/hbarta/Downloads/paho-mqtt-C++/paho.mqtt.cpp/build/libpaho-mqtt.cpp-1.2.0-Linux.deb libpaho-mqtt.cpp amd64 1.2.0 [2,199 kB]
Selecting previously unselected package libpaho-mqtt.cpp.
(Reading database ... 352892 files and directories currently installed.)
Preparing to unpack .../libpaho-mqtt.cpp-1.2.0-Linux.deb ...
Unpacking libpaho-mqtt.cpp (1.2.0) ...
Setting up libpaho-mqtt.cpp (1.2.0) ...
hbarta@olive:~/Downloads/paho-mqtt-C++/paho.mqtt.cpp$ 
```
