#!/opt/local/bin/node
 // dump my entire citibike history to sqlite
'use strict';
var config = require('../lib/configger');
var CitibikeTrips = require('CitibikeTrips');
var Citibike = require('Citibike');
var citibike = new Citibike;
var ct = new CitibikeTrips(config);
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(config.path.sqldb, function(err) {
	if (err) {
		console.warn(Date() + ' ' + 'Error opening database file [' + config.path.sqldb + ']');
		throw err;
	} else {
		config.debug > 1 && console.log(Date() + ' ' + 'Opened sqlite3 file [' + config.path.sqldb + ']');
	}
});

ct.getRecentTrips(function(err) {
	if (err) {
		console.warn(Date() + ' ' + err);
		return;
	}

	console.log(Date() + ' ' + 'Got trips');

	if (config.path.sqldb) {
		citibike.getStations(null, function(data) {
			console.log(Date() + ' ' + 'Got stations');

			// id , status,	latitude, longitude, label, stationAddress, availableBikes, availableDocks, nearbyStations;
			db.serialize(function() {
				db.run("CREATE TABLE IF NOT EXISTS stations ( id int PRIMARY KEY, status varchar2(20), latitude float, longitude float, label varchar2(60), stationAddress varchar2(60), availableBikes int, availableDocks int, nearbyStations varchar2(2000))");
				db.run("CREATE TABLE IF NOT EXISTS stationsNearby ( id int, nearbyId, distance float )");
				db.run("CREATE UNIQUE INDEX IF NOT EXISTS snun ON stationsNearby (id, nearbyId)");
				db.run("CREATE TABLE IF NOT EXISTS trips (" +
					"id int PRIMARY KEY, startStationId int, startTimestamp int, " +
					"endStationId int, endTimestamp int, durationSeconds int, " +
					"endDate date, startDate date, durationMins int, nowSecs int, " +
					"nowMins int, isOpen boolean, retrievedTimestamp int )");

				var stmtStations = db.prepare("INSERT OR REPLACE INTO stations VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
				var stmtNearby = db.prepare("INSERT OR REPLACE INTO stationsNearby VALUES (?, ?, ?)");

				for (var i = 0, d = data.results.length; i < d; i++) {
					stmtStations.run(data.results[i].id,
						data.results[i].status,
						data.results[i].latitude,
						data.results[i].longitude,
						data.results[i].label,
						data.results[i].stationAddress,
						data.results[i].availableBikes,
						data.results[i].availableDocks,
						data.results[i].nearbyStations);

					// nearbyStations is nested within station
					for (var c = 0; c < 5; c++) {
						stmtNearby.run(data.results[i].id,
							data.results[i].nearbyStations[c].id,
							data.results[i].nearbyStations[c].distance);
					}
				}

				stmtStations.finalize();
				stmtNearby.finalize();
				console.log(Date() + ' ' + 'Saved stations');


				var stmtTrips = db.prepare("INSERT OR REPLACE INTO trips " +
					"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				for (var trip in ct.trips) {
					stmtTrips.run(ct.trips[trip].id,
						ct.trips[trip].startStationId, ct.trips[trip].startTimestamp,
						ct.trips[trip].endStationId, ct.trips[trip].endTimestamp,
						ct.trips[trip].durationSeconds, ct.trips[trip].endDate,
						ct.trips[trip].startDate, ct.trips[trip].durationMins,
						ct.trips[trip].nowSecs, ct.trips[trip].nowMins, ct.trips[trip].isOpen,
						ct.trips[trip].retrievedTimestamp);
				}
				stmtTrips.finalize();
				console.log(Date() + ' ' + 'Saved trips');

				db.close();
			});
		});
	} else {
		console.log(Date() + ' ' + JSON.stringify(ct.trips, 0, 2));

	}
});

/* fin */