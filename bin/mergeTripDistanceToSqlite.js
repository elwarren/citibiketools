#!/opt/local/bin/node
 // dump my entire citibike station list to sqlite
'use strict';
var config = require('../lib/configger.js');
var async = require('async');
var sqlite3 = require('sqlite3').verbose();
var LookupStation = require('../lib/lookupStation.js');
var CitibikeTrips = require('CitibikeTrips');
var Citibike = require('citibike');
var distance = require('google-distance');
var ls = new LookupStation(config);

var db = new sqlite3.Database(config.path.sqldb, function(err) {
	if (err) {
		console.warn('Error opening database file [' + config.path.sqldb + ']');
		throw err;
	}
});

var dbSaveTripLength = function dbSaveTripLengthF(err, newRow) {
	// save a distance record to database
	if (err) return console.log(err);
	var stmt = db.prepare("INSERT OR REPLACE INTO distance VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

	stmt.run(newRow);
	stmt.finalize();
}


var computeTripLength = function computeTripLengthF(homeId, destId, callback) {
	// get a distance record from database if exists, else lookup from google and save it
	// console.log("compute from " + homeId + " to " + destId);

	db.get("SELECT * FROM distance WHERE startStationId == ? AND endStationId == ?", homeId, destId, function(err, row) {
		// if (err) throw err;
		// console.log("results from " + row);

		if (row === undefined) {
			// no row, go do lookup

			async.parallel([

					function(async_callback) {
						ls.id2LatCommaLong(homeId, async_callback);
					},
					function(async_callback) {
						ls.id2LatCommaLong(destId, async_callback);
					}
				],
				function(err, homeDestLatLong) {
					// results is now equals to: {one: 1, two: 2}

					// console.log("Getting distance from " + homeId + " to " + destId + ' latlong ' + homeDestLatLong);

					distance.get({
							origin: homeDestLatLong[0],
							destination: homeDestLatLong[1],
							mode: 'bicycling',
							units: 'imperial'
						},
						function(err, data) {
							if (err) return console.log(err);
							// console.log(data);

							// save result before returning it
							dbSaveTripLength(err, [homeId,
								destId,
								data.distance,
								data.distanceValue,
								data.duration,
								data.durationValue,
								data.origin,
								data.destination
							]);

							// FIXME serve a row reset back instead of passing it along to dbSaveTrip, is this ok?
							callback(err, {
								startStationId: homeId,
								endStationId: destId,
								distance: data.distance,
								distanceMeters: data.distanceValue,
								duration: data.duration,
								durationSec: data.durationValue,
								startStationAddr: data.origin,
								endStationAddr: data.destination
							})
						}
					);
				}
			);
		} else {
			// we got a cached row
			callback(null, row);
		}
	});
};


// main ---
db.serialize(function() {

	db.run("CREATE TABLE IF NOT EXISTS distance ( startStationId int, endStationId int, distance text, distanceMeters int, duration text, durationSec int, startStationAddr text, endStationAddr text)");
	db.run("CREATE UNIQUE INDEX IF NOT EXISTS distanceun ON distance (startStationId, endStationId)");
	var homeStationId = 512;

	// startStationId , endStationId , distance , distanceMeters , duration , durationSec , startStationAddr , endStationAddr
	db.each("select distinct startStationId, endStationId from trips order by 1, 2", function(err, row) {
		computeTripLength(row.startStationId, row.endStationId, function(err, row) {
			console.log(JSON.stringify(row));
		});
	});

	db.each("select startStationId id from trips union select endStationId id from trips", function(err, row) {
		computeTripLength(homeStationId, row.id, function(err, row) {
			console.log(JSON.stringify(row));
		});
	});
	// db.close();
});
/* fin */