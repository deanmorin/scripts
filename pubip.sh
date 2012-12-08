#!/bin/bash
command -v curl &>/dev/null
if [ $? -eq 0 ]; then 
    ip=$(curl --silent http://ipecho.net/plain)
else
    command -v wget &>/dev/null
    if [ $? -eq 0]; then
        ip=$(wget -q -O - http://ipecho.net/plain)
    else
        echo 'This machine does not have curl or wget installed' 1>&2;
        exit 1
    fi
fi
echo $ip
