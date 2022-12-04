#!/bin/bash

#Purpose: The purpose of this script is to pull the latitude and logitude of the the drone operator.

#Syntax: sudo ./geoPull.sh

RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NO_COLOR='\033[0m'

INT=`cat .ints.txt | cut -d " " -f 2 `
WLAN0_LINE=`ifconfig | grep -n $INT | cut -d ':' -f 1`
IP=`ifconfig | tail -n +$WLAN0_LINE | grep "broadcast" | cut -d ' ' -f 10 | cut -d '.' -f 1-3`
IP=$IP.1

echo "Conducting nmap scan of target"
nmap $IP -p 23 -n | grep telnet > /dev/null 2>&1
RC=$?

if [ $RC -eq 0 ]
then
	nc $IP 23 < .geoCommand.txt > .geoData.txt
	LAT=`cat .geoData.txt | grep "latitude" | cut -d '=' -f 2`
	LONG=`cat .geoData.txt | grep "longitude" | cut -d '=' -f 2`
	echo -e "\n\tLAT: ${YELLOW}$LAT${NO_COLOR}\n\tLONG: ${YELLOW}$LONG${NO_COLOR}"
else
	echo "Telnet not found, aborting..."
fi
