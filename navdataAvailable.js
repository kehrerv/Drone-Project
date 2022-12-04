var arDrone = require('ar-drone');
const fs = require('fs');
var client = arDrone.createClient();


client.on('navdata', console.log);

//client.on('navdata', console.log(navdata.demo.altitude);
