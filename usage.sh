#!/usr/bin/env bash
################################################################################
# Captures all traffic through the device with ip $hostip, and gives the
# total bytes on the wire. Press ctrl + c to stop the capture and display the
# results.
#
# This script calls the program, 'bytes2mb' which should either be in the same
# directory as this script, or it's path should be specified by the variable
# 'bytes2mb'.
#
# Usage: usage [-a <ip_address>][-i <interface>][previous_usage]
#
# -a    The IP address of the connected device that you wish to measure.
#       The default value is specified by the variable 'hostip'.
#
# -i    The interface that you want to capture on.
#       The default value is specified by the variable 'capInterface'.
#
#       You can also enter a number which is the previously used data (in MB).
#       If this argument is given, then it will be added to the captured total
#       and displayed under the "Including Old Data" heading. This is just for
#       convenience so you don't have to do the math yourself.
#
# Author: Dean Morin
################################################################################

path="$HOME/Documents/archive/usage_pcaps"
bytes2mb="$(cd $(dirname $0); pwd -P)/bytes2mb"
baseName="wifi_"
currentTime=$(date +"%Y%m%d_%H%M")
extension=".pcap"
hostip="10.0.2.17"
capInterface="en1"
capSize="128"

while (( "$#" )); do

    if [ "$ipArgNext" = true ]; then
        if ! [[ $1 =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})+[.]([0-9]{1,3})+$ ]]; then
            echo "error: invalid ip" >&2
            exit
        fi
        hostip=$1
        ipArgNext=false
    elif [ "$interfaceArgNext" = true ]; then
        capInterface=$1
        interfaceArgNext=false
	elif [ $1 = "-a" ]; then
        ipArgNext=true
    elif [ $1 = "-i" ]; then
        interfaceArgNext=true
    elif [[ $1 =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        prevUsage=$1
    else
        echo "error: invalid argument: $1" >&2
        exit
	fi

	shift
done

fileName=$baseName$hostip_$currentTime$extension

if [ ! -d $path ]; then
    mkdir $path
fi

echo $hostip
tcpdump -i $capInterface -s $capSize -w $path/$fileName host $hostip and ip

bytes=$(capinfos -d $path/$fileName | grep "Data size:" | tr -dc '[0-9]')
packets=$(capinfos -c $path/$fileName | grep "Number of packets:" | tr -dc '[0-9]')

if [ $packets -eq "0" ]; then
    echo "Nothing was captured."
    rm $path/$fileName
    exit
fi;

# keeps a copy of the latest capture to make it easier to find
cp $path/$fileName $path/${baseName}new$extension

echo "=================="
echo "| Capture Totals |"
echo "=================="
$bytes2mb $bytes

if [ $prevUsage ]; then
    bytes=$(echo "$bytes + $prevUsage * 1024 * 1024" | bc)
    echo "======================"
    echo "| Including Old Data |"
    echo "======================"
    $bytes2mb $bytes
fi
