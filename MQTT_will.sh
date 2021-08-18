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
EOF

    read_custom_settings
    assertEquals "broker" "$(broker )" "mqttbroker"
    assertEquals "connect_msg" "$(connect_msg )" '1629312459, foo, connected'

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