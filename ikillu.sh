#! /bin/bash
port=25252

if [ "$1" == "-l" ]; then
    # running as a server; listen for the kill command
    echo 'Starting server'
    while [ 1 ]; do
        nc -l $port
        pid=$(ps aux | grep -v grep | grep Transmission | awk '{print $2}')
        kill $pid &>/dev/null
    done
fi

# running as a client; send the kill command
user=someone
ifconfig en1 | grep '192.168.0.101' &>/dev/null && user=me
if [ $user == "me" ]; then
    ips=($(sudo fping -a -g 192.168.0.100 192.168.0.130))
else
    local_ip=$(ifconfig | grep '192.168.0.' | awk '{print $2}')
    ips=('192.168.0.100' '192.168.0.101' $local_ip)
fi

for ip in "${ips[@]}"; do
    (nc -z $ip $port&) &> /dev/null
    sleep 1
    pid=$(ps aux | grep -v 'grep' | grep "nc -z $ip $port" | awk '{print $2}')
    kill $pid &>/dev/null && sleep 1
done
