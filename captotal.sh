#!/bin/bash

if [ ! -f "$1" ]; then
    echo "usage: "$0" <pcap_file>"
    exit
fi

pcap="$1"
bytes=$(capinfos -d $pcap | grep "Data size:" | tr -dc '[0-9]')
packets=$(capinfos -c $pcap | grep "Number of packets:" | tr -dc '[0-9]') 

echo "=================="
echo "| Capture Totals |"
echo "=================="
bytes2mb $bytes
