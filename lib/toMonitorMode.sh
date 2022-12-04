#!/bin/bash

#Purpose: The purpose of this script is to place one of or the only network adapter
#present into monitor mode. This does not do it over a specific channel and will be
#open to all wifi channels for scanning. For a specific channel, use channelMonitorMode.sh

#Syntax: sudo ./toMonitorMode.sh

COUNT=`ifconfig | grep "wlan" | cut -d ":" -f 1 | wc -l`
STATUS=`cat .ints.txt | cut -d ":" -f 1`

BAD='\033[1;31m'
GOOD='\033[1;32m'
NO_COLOR='\033[0m'

if [ $COUNT -lt 1 ]
then
	echo -e "${BAD}No wlan interface detected${NO_COLOR}"
	echo "None" > .ints.txt
elif [ "$STATUS" == "Mon" ]
then
	MON_INT=`grep "Mon" .ints.txt | cut -d " " -f 2`
	echo -e "${GOOD}$MON_INT${NO_COLOR} is already in monitor mode"
elif [ $COUNT -gt 1 ]
then
	echo -e "Two Wireless interfaces found"
	WLAN0=`ifconfig | grep "wlan" | cut -d ":" -f 1 | head -n 1`
	echo -e "Placing ${GOOD}$WLAN0${NO_COLOR} into monitor mode"
	airmon-ng start $WLAN0 &> /dev/null
	MON_INT=`ifconfig | grep $WLAN0 | cut -d ":" -f 1`
	echo -e "Monitor interface: ${GOOD}$MON_INT${NO_COLOR}"
	echo "Mon: $MON_INT" > .ints.txt
	
else
	INT=`ifconfig | grep "wlan" | cut -d ":" -f 1`
	echo -e "Wireless interface found: ${GOOD}$INT${NO_COLOR}"
	echo "Placing into monitor mode"
	airmon-ng start $INT &> /dev/null
	MON_INT=`ifconfig | grep "wlan" | cut -d ":" -f 1`
	echo -e "Monitor interface: ${GOOD}$MON_INT${NO_COLOR}"
	echo "Mon: $MON_INT" > .ints.txt
fi

