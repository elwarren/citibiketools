#!/opt/local/bin/node
 // return last recorded trip as json object
'use strict';
var config = require('../lib/configger');
var CitibikeTrips = require('CitibikeTrips');
var ct = new CitibikeTrips(config);

ct.getLastTrip(function(err, result) {
	console.log(JSON.stringify(result, null, 2));
});