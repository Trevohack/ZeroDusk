#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <ip> <pwd>"
    exit 1
fi 

ip="$1"
pwd="$2" 

sshpass -p "$pwd" scp -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null libsnoopy.so root@$ip:/usr/local/lib/libsnoopy.so 
sshpass -p "$pwd" ssh -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null root@$ip "echo '/usr/local/lib/libsnoopy.so' >> /etc/ld.so.preload; echo '[snoopy]' > /etc/snoopy.ini; service apache2 restart; service koth restart"

