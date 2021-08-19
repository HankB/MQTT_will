#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

# usage ...
usage() {
    echo "$0 [-h|-?|-t"
}

# function to return broker hostname
broker() {
    echo "localhost"|tr -d '\n'    # default to localhost
}

test_broker() {
    assertEquals "broker" "$(broker )" "localhost"
}


# function to return connect message, seconds since epoch, hostname and status
# JSON format
# e.g. {"t":1629312351, "host":"olive", "status": "connected" }
connect_msg() {
    echo "{\"t\":$(date +%s), \"host\":\"$HOSTNAME\", \"status\": \"connected\" }"|tr -d '\n'
}

test_connect_msg() {
    date() { # mock shell date command
        echo "1629312459"
    }
    HOSTNAME="foo"
    assertEquals "connect_msg" "$(connect_msg )" '{"t":1629312459, "host":"foo", "status": "connected" }'
}

# function to return periodic status update message, seconds since epoch, hostname and status
# JSON format
# e.g. {"t":1629312351, "host":"olive", "status": "connected" }
update_msg() {
    echo "{\"t\":$(date +%s), \"host\":\"$HOSTNAME\", \"status\": \"still connected\" }"|tr -d '\n'
}

test_update_msg() {
    date() { # mock shell date command
        echo "1629312459"
    }
    HOSTNAME="foo"
    assertEquals "update_msg" "$(update_msg )" '{"t":1629312459, "host":"foo", "status": "still connected" }'
}

# function to return lass will message, seconds since epoch, hostname and status
# JSON format
# Note: the "t" value will be the time the connection was established, now when it
# has been detected that it has dropped.
# e.g. {"t":1629312351, "host":"olive", "status": "connection dropped" }
will_msg() {
    echo "{\"t\":$(date +%s), \"host\":\"$HOSTNAME\", \"status\": \"connection dropped\" }"|tr -d '\n'
}

test_will_msg() {
    date() { # mock shell date command
        echo "1629312459"
    }
    HOSTNAME="foo"
    assertEquals "will_msg" "$(will_msg )" '{"t":1629312459, "host":"foo", "status": "connection dropped" }'
}

# pull custom settings if provided
read_custom_settings() {
    if [ -e ./custom_settings ]
    then
    . ./custom_settings 
    fi
}

test_custom_settings() {
    test_dir=test$$
    mkdir $test_dir
    cd $test_dir
cat <<EOF >./custom_settings
broker() {
    echo "mqttbroker"|tr -d '\n'    # use mqttbroker
}

connect_msg() {
    echo "$(date +%s), foo, connected"|tr -d '\n'
}

update_msg() {
    echo "$(date +%s), foo, still connected"|tr -d '\n'
}

EOF

    read_custom_settings
    assertEquals "broker" "$(broker )" "mqttbroker"
    assertEquals "connect_msg" "$(connect_msg )" '1629312459, foo, connected'
    assertEquals "update_msg" "$(update_msg )" '1629312459, foo, still connected'

    # cleanup
    cd ..
    rm -rf $test_dir

}
# actual processing
process() {
    echo "processing not yet implemented"
}

# parse arguments and dispatch
if [ $# -eq 0 ] # any args?
then
    process
else
    case $1 in
        -h|-\?|--help)
            usage
            ;;
        -t|--test)
            shift
            . shunit2
            ;;
        *)
            usage
            ;;
    esac
fi