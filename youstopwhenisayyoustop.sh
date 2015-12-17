#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "usage: $(basename $0) command [sleep_time]"
    exit 1
fi

cmd="$1"
sleep_time=${2:-3}

while true; do $cmd; sleep "$sleep_time"; done
