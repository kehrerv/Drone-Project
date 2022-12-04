#!/bin/bash

#Purpose: This script will place the network adatper into monitor mode
#over a specified channel for deauth purposes. The status of the network
#adapter is updated in the .ints.txt file

#Syntax: sudo ./channelMonitorMode.sh

#1st command line argument is the channel to switch to

COUNT=`ifconfig | grep "wlan" | cut -d ":" -f 1 | wc -l`
STATUS=`cat .ints.txt | cut -d ":" -f 1`

BAD='\033[1;31m'
GOOD='\033[1;32m'
INFO='\033[1;33m'
NO_COLOR='\033[0m'

if [ $COUNT -lt 1 ]
then
	echo -e "${BAD}No wlan interface detected${NO_COLOR}"
	echo "None" > .ints.txt
else
	WLAN1=`ifconfig | grep "wlan" | cut -d ":" -f 1 | tail -n 1`
	CHANNEL=$1
	echo -e "Placing ${GOOD}$WLAN1${NO_COLOR} into monitor mode"
	echo -e "Channel: ${INFO}$CHANNEL${NO_COLOR}"
	airmon-ng start $WLAN1 $CHANNEL &> /dev/null
	MON_INT=`ifconfig | grep $WLAN1 | cut -d ":" -f 1`
	echo -e "Monitor interface: ${GOOD}$MON_INT${NO_COLOR}"
	echo "Mon: $MON_INT" > .ints.txt
fi
