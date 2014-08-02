#!/opt/local/bin/node
 // notify me about citibike open trip. plug this in to other things and run every 5 minutes in cron or something
'use strict';
var config = require('../lib/configger');
var CitibikeTrips = require('CitibikeTrips');
var ct = new CitibikeTrips(config);

ct.getLastTrip(function(err, result) {
	if (result.isOpen) {
		console.log('true');
		// set exit code to interact with shell scripts
		process.exit(result.nowMins);
	} else {
		console.log('false');
		process.exit(0);
	}
});