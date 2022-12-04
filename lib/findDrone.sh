#!/bin/bash

#Purpose: The purpose of this file is to find all of the Parrot AR Drones in the area. This
#is done by filtering all of the routers in the area by mac address because Parrot owns the
#MAC addess blocks seen in a grep in the file. The data about the essid, mac, channel, and
#client for each drone is written to .dronesFound.txt.

#Syntax: sudo ./findDrone.sh

RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
NO_COLOR='\033[0m'

./toMonitorMode.sh
if [ `cat .ints.txt | cut -d ":" -f 2` = "None" ]
then
	exit
else
	echo "Searching for Drone AP"
	MON_INT=`cat .ints.txt | cut -d ":" -f 2`

	airodump-ng $MON_INT --output-format csv -w test &> /dev/null &
	RPID=$!
	sleep 15
	kill $RPID
	
	STATION_LINE=`grep -n Station test-01.csv | cut -d ':' -f 1`
	DRONE_APS=`head -n $STATION_LINE test-01.csv | grep -E '90:3A:E6|00:12:1C|90:03:B7|A0:14:3D|00:26:7E' | cut -d , -f 14`

	rm .dronesFound.txt

	if [ "$DRONE_APS" != "" ]
	then
		for drone in $DRONE_APS
		do
			NAME=`echo  $drone | sed -e 's/^[[:space:]]*//'`
			CHANNEL=`cat test-01.csv | grep -E $drone | cut -d , -f 4 | sed -e 's/^[[:space:]]*//'`
			MAC=`cat test-01.csv | grep -E $drone | cut -d , -f 1 | sed -e 's/^[[:space:]]*//'`
			CLIENT_MAC=`tail -n +$STATION_LINE test-01.csv | grep $MAC | cut -d ',' -f 1`

			echo -e "${YELLOW}Essid: $NAME${NO_COLOR}"
			echo -e "\t${GREEN}Channel: $CHANNEL${NO_COLOR}"
			echo -e "\t${GREEN}Bssid: $MAC${NO_COLOR}"
			echo -e "\t${GREEN}Client: $CLIENT_MAC${NO_COLOR}"
			echo -e "essid: $NAME" >> .dronesFound.txt
			echo -e "channel: $CHANNEL" >> .dronesFound.txt
			echo -e "bssid: $MAC" >> .dronesFound.txt
			echo -e "client: $CLIENT_MAC" >> .dronesFound.txt
		done
	else
		echo -e "${RED}No drones found in the area${NO_COLOR}"
	fi

	rm test-01.csv
	./toManagedMode.sh
fi
