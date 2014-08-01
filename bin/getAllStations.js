#!/opt/local/bin/node
// dump my entire citibike history to sqlite
'use strict';
var stations_sql = '../alltrips.sqlite3';
var config = require('../etc/config.json');
var sqlite3 = require('sqlite3').verbose();
var Citibike = require('citibike');
var citibike = new Citibike;

var db = new sqlite3.Database(stations_sql, function(err) {
	if (err) {
		console.warn('Error opening database file [' + stations_sql + ']');
		throw err;
	}
});

// id , status,	latitude, longitude, label, stationAddress, availableBikes, availableDocks, nearbyStations;

db.serialize(function() {
	/* 12 columns */
	db.run("CREATE TABLE IF NOT EXISTS stations ( id int PRIMARY KEY, status varchar2(20), latitude float, longitude float, label varchar2(60), stationAddress varchar2(60), availableBikes int, availableDocks int, nearbyStations varchar2(2000))");
	db.run("CREATE TABLE IF NOT EXISTS stationsNearby ( id int, nearbyId, distance float )");
    db.run("CREATE UNIQUE INDEX IF NOT EXISTS snun ON stationsNearby (id, nearbyId)");

	// example station json
	var station = {
		"id": 72,
		"status": "Active",
		"latitude": 40.76727216,
		"longitude": -73.99392888,
		"label": "W 52 St & 11 Ave",
		"stationAddress": "",
		"availableBikes": 12,
		"availableDocks": 22,
		"nearbyStations": [{
			"id": 480,
			"distance": 0.17780736685282
		}]
	};

	citibike.getStations(null, function(data) {
		var stmt = db.prepare("INSERT OR REPLACE INTO stations VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
		var stmtNearby = db.prepare("INSERT OR REPLACE INTO stationsNearby VALUES (?, ?, ?)");
		for (var i = 0, d = data.results.length; i < d; i++) {
			stmt.run(data.results[i].id,
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
		stmt.finalize();
		stmtNearby.finalize();

		db.each("SELECT count(*) stations FROM stations", function(err, row) {
		 	console.log(row.stations);
		});

		db.close();
	});
});
/* fin */
