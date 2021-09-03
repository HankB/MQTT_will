#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

# shellcheck disable=SC1091 # this file isn't part of the project
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

test_will_msg() {
    date() { # mock shell date command
        echo "1629312459"
    }
    HOSTNAME="foo"
    assertEquals "will_msg" "$(will_msg )" '{"t":1629312459, "host":"foo", "status": "connection dropped" }'
}

test_custom_settings() {
    test_dir=test$$
    mkdir $test_dir
    cd $test_dir
cat <<EOF >./custom_settings
#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

broker() {
    echo "mqttbroker"|tr -d "\\\\n"    # use mqttbroker
}

connect_msg() {
    echo "$(date +%s), foo, connected"|tr -d "\\\\n"
}

update_msg() {
    echo "$(date +%s), foo, still connected"|tr -d "\\\\n"
}

will_msg() {
    echo "$(date +%s), foo, gone"|tr -d "\\\\n"
}

EOF

    read_custom_settings
    assertEquals "broker" "$(broker )" "mqttbroker"
    assertEquals "connect_msg" "$(connect_msg )" '1629312459, foo, connected'
    assertEquals "update_msg" "$(update_msg )" '1629312459, foo, still connected'
    assertEquals "will_msg" "$(will_msg )" '1629312459, foo, gone'

    # cleanup
    cd ..
    rm -rf $test_dir

}

# test argument passing
test_process_args() {
    # mock mosquitto_pub and sleep for test purposes
    mosquitto_pub() {
        cat >/dev/null          # discard STDIN
        echo "$*" >/dev/null    # discard args
    }
    sleep() {
        echo sleeping "$@"      # report args
        exit
    }
    process
    # test default interval (0 = wait forever)
    assertEquals "check update interval" "sleeping 86400" "$(sleep 86400)"
    #assertEquals "check update interval" "sleeping 86400" "$(process)"
}

test_parse_args() {
    # first default values
    # shellcheck disable=SC2154 # assigned in the source file
    assertEquals "broker" "$broker" "localhost"
    # shellcheck disable=SC2154 # assigned in the source file
    assertEquals "interval" "$interval" 0
    parse_args "-b" "mqtt1"
    assertEquals "broker" "$broker" "mqtt1"
    parse_args "--broker" "mqtt2"
    assertEquals "broker" "$broker" "mqtt2"
    parse_args "-i" 3
    assertEquals "interval" "$interval" 3
    parse_args "--interval" 5
    assertEquals "interval" "$interval" 5
}


# shellcheck disable=SC1091 # this file isn't part of the project
source shunit2
