var arDrone = require('ar-drone');
const fs = require('fs');
var client = arDrone.createClient();

//Main script
var lastNavDataMs = 0;

client.on('navdata', function(d) {
	var nowMs = new Date().getTime();
	if (nowMs - lastNavDataMs > 250) {
		lastNavDataMs = nowMs;
		if (d.demo){
			var string = "Battery = ";
			string += String(d.demo.batteryPercentage);
			string += "\nAltitude = ";
			string += String(d.demo.altitude);
			string += "\nPitch = ";
			string += String(d.demo.rotation.pitch);
			string += "\nRoll = ";
			string += String(d.demo.rotation.roll);
			string += "\nYaw = ";
			string += String(d.demo.rotation.yaw);
			string += "\n";
			fs.appendFile('.output.txt', string, err => {
				if (err) {
					console.error(err)
					return
				}
			})
		}
	}
});
