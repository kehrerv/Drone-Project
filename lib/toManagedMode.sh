#!/bin/bash

#Purpose: The goal of this is to script is to place the network adapter currently in monitor
#mode into managed mode. This is done to associate with an access point

#Syntax: sudo ./toManagedMode.sh

COUNT=`ifconfig | grep "wlan" | cut -d ":" -f 1 | wc -l`

BAD='\033[1;31m'
GOOD='\033[1;32m'
NO_COLOR='\033[0m'

STATUS=`cat .ints.txt | cut -d ":" -f 1`

if [ $COUNT -lt 1 ]
then
	echo -e "${BAD}No monitor interface detected${NO_COLOR}"
	echo "None" > .ints.txt
elif [ "$STATUS" == "Man" ]
then
	INT=`cat .ints.txt | cut -d " " -f 2`
	echo -e "${GOOD}$INT${NO_COLOR} already in managed mode"
else
	#Comment out if you do not wish to remove auto-connect for other networks
	#Change to remvoe specific network connections
	rm /etc/NetworkManager/system-connections/* &> /dev/null


	MON_INT=`grep "Mon" .ints.txt | cut -d " " -f 2`
	echo -e "Monitor interface found: ${GOOD}$MON_INT${NO_COLOR}"
	echo "Placing into managed mode"
	airmon-ng stop $MON_INT &> /dev/null
	sleep 2

	#ifconfig `iwconfig | grep "wlan" | tail -n 1 | cut -d ' ' -f 1` up
	ifconfig wlan0 up #FIX THIS
	ifconfig wlan1 up #FIX THIS

	INT=`ifconfig | grep "wlan" | cut -d ":" -f 1 | head -n 1`
	echo -e "Managed interface: ${GOOD}$INT${NO_COLOR}"
	echo "Man: $INT" > .ints.txt
fi

