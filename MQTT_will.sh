#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

# usage ...
usage() {
    echo "$0 [-h|-?|-t|[-b broker -i interval ]"
}

# function to return broker hostname
broker() {
    echo "localhost"|tr -d "\\n"    # default to localhost
}

test_broker() {
    assertEquals "broker" "$(broker )" "localhost"
}


# function to return connect message, seconds since epoch, hostname and status
# JSON format
# e.g. {"t":1629312351, "host":"olive", "status": "connected" }
connect_msg() {
    echo "{\"t\":$(date +%s), \"host\":\"$HOSTNAME\", \"status\": \"connected\" }"|tr -d "\\n"
}

# function to return periodic status update message, seconds since epoch, hostname and status
# JSON format
# e.g. {"t":1629312351, "host":"olive", "status": "still connected" }
update_msg() {
    echo "{\"t\":$(date +%s), \"host\":\"$HOSTNAME\", \"status\": \"still connected\" }"|tr -d "\\n"
}

# function to return lass will message, seconds since epoch, hostname and status
# JSON format
# Note: the "t" value will be the time the connection was established, now when it
# has been detected that it has dropped.
# e.g. {"t":1629312351, "host":"olive", "status": "connection dropped" }
will_msg() {
    echo "{\"t\":$(date +%s), \"host\":\"$HOSTNAME\", \"status\": \"connection dropped\" }"|tr -d "\\n"
}

# pull custom settings if provided
read_custom_settings() {
    if [ -e ./custom_settings ]
    then
    # shellcheck disable=SC1091 # this file isn't part of the project
    . ./custom_settings 
    fi
}

# actual processing
process() {
    (
        echo $(connect_msg); \
        while(:)
        do
            if [ $interval -ne 0 ]
            then
                sleep $interval
                echo $(update_msg)
            else
                while true
                do 
                    sleep 86400; 
                done; 
            fi
        done 
    ) | \
    mosquitto_pub   -t TEST \
                    -h localhost \
                    --will-payload \"$(will_msg)\" \
                    --will-topic \"TEST/will\" -l
}

# default values for some things provided as command line args
# exported to suppress shellcheck SC2034
export broker="localhost"
export interval=0
export testing=0

# parse arguments and dispatch
parse_args() {
    while [ $# -ne 0 ] # any args?
    do
        case $1 in
            -h|-\?|--help)
                usage
                shift
                ;;
            -t|--test)
                shift
                testing=1
                ;;
            -b|--broker)
                shift
                broker=$1
                shift
                ;;
            -i|--interval)
                shift
                interval=$1
                shift
                ;;
            *)
                usage
                shift
                ;;
        esac
    done
}

parse_args "$@"

if [ ! $testing ]
then
    process
fi
