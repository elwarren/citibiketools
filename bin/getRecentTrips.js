#!/opt/local/bin/node
 // dump the calendar month's citibike history to json
'use strict';
var config = require('../lib/configger');
var CitibikeTrips = require('CitibikeTrips');
var ct = new CitibikeTrips(config);

ct.getRecentTrips(function(err) {
	if (err) {
		console.log(err);
	} else {
		console.log(JSON.stringify(ct.trips, 0, 2));
	}
});