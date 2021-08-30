#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

. ./MQTT_will.sh -t 

test_connect_msg() {
    date() { # mock shell date command
        echo "1629312459"
    }
    HOSTNAME="foo"
    assertEquals "connect_msg" "$(connect_msg )" '{"t":1629312459, "host":"foo", "status": "connected" }'
}

test_update_msg() {
    date() { # mock shell date command
        echo "1629312459"
    }
    HOSTNAME="foo"
    assertEquals "update_msg" "$(update_msg )" '{"t":1629312459, "host":"foo", "status": "still connected" }'
}


# shellcheck disable=SC1091 # this file isn't part of the project
source shunit2
