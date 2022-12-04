Developed for Capitol Technology University Cyber Battle Lab by Thomas Mahr and Valerie Kehrer

Purpose:
	The purpose of this project is to be able to preform various WiFi attacks against Parrot 
	AR Drones.
Hardware:
	- Kali Linux OS (other linux OS's will work but kali has default software installed)
	- 2 Network adapters capable of monitor mode (Developed with 2 Alfa AWUS036NHA)
		- 1 adapter will work for all attacks other than full flight control
		- 2 adapters will allow full flight control by constantly deauthing
		client with one, and connecting on the other.
Software:
	- Listed in the checkInstalled.sh script in lib/
	- Additionally the airecrack-ng suite which is default installed in kali

Attacks:
	- full flight control (offered in connectToDrone.sh script)
	- Clone camera stream (done with video.js)
	- Command injection (shutdown and geoPull)
	- Current Navigation Data (droneStatus.py)


Process:
	1) Run sudo checkInstalled.sh in lib/ --> will show necessary software that may not be installed
		by default on kali. Green mean it's installed, red means it is not installed
	2) Run sudo findDrone.sh in lib/ --> will find all the drones in the area
	3) Run sudo connectToDrone.sh in lib/ --> will allow connection to a selected drone
		Read the script header for info about flight contol vs non-flight control
	4) Run other attck scripts
		lib/geoPull.sh --> pulls lat and long from the drone
		lib/shutdown.sh --> shutdowns the drone you're connected to
		video.js --> hijacks camera feed from drone and hosts over 127.0.0.1:8080, mash f5 to refresh
		keyboard.js --> takes full flight control (ASSUMING you selected flight control in
			connectToDrone.sh)
		droneStatus.py --> shows flight navadata (altitide, pitch, yaw, roll, and battery) of the drone
		
