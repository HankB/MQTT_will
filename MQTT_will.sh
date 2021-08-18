#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset

# usage ...
usage() {
    echo "$0 [-h|-?|-t"
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