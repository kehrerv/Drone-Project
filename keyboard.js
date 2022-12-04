/* Purpose: Allows the user to have full flight control of the drone.
 *
 * This is to be run AFTER the user selects flight control in the
 * connectToDrone.sh script in lib/
 *
 * End with [ctrl] c after the drone is landed
 *
 * syntax: sudo node keyboard.js
 * 
 */

var arDrone = require('ar-drone');
var client = arDrone.createClient();


var readline = require('readline');


//_________drone pic and words
const { exec } = require("child_process");


exec("cat textStuff/dronePic.txt | lolcat -f ; figlet '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tDRONEZ!!!' | lolcat -f", (error, stdout, stderr) => {
    if (error) {
        console.log(`error: ${error.message}`);
        return;
    }
    if (stderr) {
        console.log(`stderr: ${stderr}`);
        return;
    }
    console.log(`${stdout}`);
});
//________________


readline.emitKeypressEvents(process.stdin);
var flag = false;

if (process.stdin.isTTY)
        process.stdin.setRawMode(true);
console.log("q = quit\nUp arrow = takeoff\nDown arrow = land\nLeft arrow = FTRIM (do not use during flight)\nRight arrow = magnetometer callibration (used in air)\nSpace = hover");
process.stdin.on('keypress', (chunk, key) => {
	
flag = false;

        if (key && key.name == "q")
                process.exit();
	else if (key && key.name == "up"){
		client.takeoff();
		flag=true;
	}
	else if (key && key.name == "down"){
		client.land();
		flag=true;
	}
	else if (key && key.name == "space"){
		client.stop();
	}
	else if (key && key.name == "left"){ //FTRIM - do NOT use during flight
		client.callibrate(1);
	}
	else if (key && key.name == "right"){ //magnetometer callibration - can be used during flight
		client.callibrate(0);
	}
/*----------------------left hand control--------------------------*/
	if (key && key.name == "w")
		client.up(.6);
	else if (key && key.name == "s"){
		client.down(.6);
	}
	else if (key && key.name == "d"){
		client.clockwise(.7);

	}
	else if (key && key.name == "a"){
		client.counterClockwise(.7);
	}
/*----------------------right hand control--------------------------*/
	if (key && key.name == "i"){
		client.front(.2);
		flag=true;
	}
	else if (key && key.name == "k"){
		client.back(.2);
		flag=true;
	}
	else if (key && key.name == "j"){
		client.left(.2);
		flag=true;
	}
	else if (key && key.name == "l"){
		client.right(.2);
		flag=true;
	}
	



	//client.stop();
});
