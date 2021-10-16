#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate


############### Instructions (for installing to remote system)
# 
# user=hbarta
# remote_host=allred
# target=$user@${remote_host}
# scp MQTT_will.service.system MQTT_will.sh custom_settings ${target}:
# ssh $target
# mkdir -p /home/$USER/MQTT_will
# mkdir -p /home/$USER/bin
# (edit custom_settings and service file)
# mv custom_settings /home/$USER/MQTT_will
# sudo cp MQTT_will.service.system /etc/systemd/system/MQTT_will.service
# sudo systemctl daemon-reload
# sudo systemctl status MQTT_will.service
# sudo systemctl enable MQTT_will.service
# sudo systemctl start MQTT_will.service
###############

# usage ...
usage() {
    echo "$0 [-h|-?|-t|[-b broker -i interval ]"
}

# function to return broker hostname
get_broker() {
    echo "localhost"    # default to localhost
}

# function to return connect message, seconds since epoch, hostname and status
# JSON format
# e.g. {"t":1629312351, "host":"olive", "status": "connected" }
connect_msg() {
    echo "{\"t\":$(date +%s), \"status\": \"connected\" }"
}

# function to return periodic status update message, seconds since epoch, 
# hostname and status in JSON format
# e.g. {"t":1629312351, "host":"olive", "status": "still connected" }
update_msg() {
    echo "{\"t\":$(date +%s), \"status\": \"still connected\" }"
}

# function to return lass will message, seconds since epoch, hostname and status
# JSON format
# Note: the "t" value will be the time the connection was established, now when it
# has been detected that it has dropped.
# e.g. {"t":1629312351, "host":"olive", "status": "connection dropped" }
will_msg() {
    echo "{\"t\":$(date +%s), \"status\": \"connection dropped\" }"
}

# pull custom settings if provided
read_custom_settings() {
    if [ -e ./custom_settings ]
    then
    . ./custom_settings 
    fi
}

# actual processing
process() {
    (
        connect_msg; \
        while(:)
        do
            if [ "$interval" -ne 0 ]
            then
                sleep "$interval"
               update_msg
            else
                while true
                do 
                    sleep 86400
                done; 
            fi
        done 
    ) | \
    mosquitto_pub   -t "CM/${HOSTNAME}/live" \
                    -h "$broker" \
                    --will-payload "$(will_msg)" \
                    --will-topic "CM/${HOSTNAME}/will" -l
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
                exit
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

if [ $testing -eq 0 ]
then
    process
fi
