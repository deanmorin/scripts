#!/bin/bash

################################################################################
# Captures all traffic through the device with the specified ip, and gives the     
# total bytes on the wire.
# 
# It takes two optional arguments. One is the previously data used (in MB). 
# If this argument is given, then it will be added to the captured total and 
# displayed under the "Including Old Data" heading. The other is the -i switch
# followed by the IP adress to filter on (10.0.2.3 is used if none is given).
# 
# Author: Dean Morin
# Last Updated: Oct 27, 2011
################################################################################

SAVE_PATH="$HOME/Documents/mic_pcaps"
BASE_NAME="mic_"
currentTime=$(date +"%Y%m%d_%H%M")
extension=".pcap"
fileName=$BASE_NAME$currentTime$extension
HOST_IP="10.2.219.22"
capInterface="eth1"
capSize="128"

while (( "$#" )); do

    if [ "$ipArgNext" = true ]; then
        if ! [[ $1 =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})+[.]([0-9]{1,3})+$ ]]; then
            echo "error: invalid ip" >&2
            exit
        fi
        HOST_IP=$1 
        ipArgNext=false
    elif [ "$interfaceArgNext" = true ]; then
        capInterface=$1
        interfaceArgNext=false
	elif [ $1 = "-a" ]; then
        ipArgNext=true
    elif [ $1 = "-i" ]; then
        interfaceArgNext=true
    elif [[ $1 =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        PREV_USAGE=$1
    else
        echo "error: invalid argument: $1" >&2
        exit
	fi

	shift
done

if [ ! -d $SAVE_PATH ]; then
    mkdir -p $SAVE_PATH
fi

ssh root@69.31.181.54
#tcpdump -i $capInterface -s $capSize -w $SAVE_PATH/$fileName host $HOST_IP
tcpdump -i $capInterface -s $capSize -w test1.pcap host $HOST_IP
exit

bytes=$(capinfos -d $SAVE_PATH/$fileName | grep "Data size:" | tr -dc '[0-9]')
packets=$(capinfos -c $SAVE_PATH/$fileName | grep "Number of packets:" | tr -dc '[0-9]') 

if [ $packets -eq "0" ]; then
    echo "Nothing was captured."
    rm $SAVE_PATH/$fileName
    exit
fi;

# keeps a copy of the latest capture to make it easier to find
cp $SAVE_PATH/$fileName $SAVE_PATH/${BASE_NAME}new$extension

echo "=================="
echo "| Capture Totals |"
echo "=================="
bytes2mb $bytes

if [ $PREV_USAGE ]; then
    bytes=$(echo "$bytes + $PREV_USAGE * 1024 * 1024" | bc)
    echo "======================"
    echo "| Including Old Data |"
    echo "======================"
    bytes2mb $bytes
fi
