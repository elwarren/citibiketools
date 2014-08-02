#!/opt/local/bin/node
 // dump my entire citibike history to sqlite
'use strict';
var config = require('../lib/configger');
var trips = require(config.path.trips.json);

var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(config.path.sqldb, function(err) {
	if (err) {
		console.warn('Error opening database file [' + config.path.sqldb + ']');
		throw err;
	} else {
		console.log('Opened sqlite3 file [' + config.path.sqldb + ']');
	}
});

// example trip json
var tripJson = {
	"id": 5502331,
	"startStationId": 315,
	"startTimestamp": 1382217509,
	"endStationId": 512,
	"endTimestamp": 1382219612,
	"durationSeconds": 2103,
	"endDate": "2013-10-19T21:53:32.000Z",
	"startDate": "2013-10-19T21:18:29.000Z",
	"durationMins": 35,
	"nowSecs": 24276216,
	"nowMins": 404603,
	"isOpen": false,
	"retrievedTimestamp": 1382219612000
};

db.serialize(function() {
	db.run("CREATE TABLE IF NOT EXISTS trips ( id int PRIMARY KEY, startStationId int, startTimestamp int, endStationId int, endTimestamp int, durationSeconds int, endDate date, startDate date, durationMins int, nowSecs int, nowMins int, isOpen boolean, retrievedTimestamp int )");

	// TODO rewrite update as an object with named parameters.
	// db.run("UPDATE tbl SET name = $name WHERE id = $id", { $id: 2, $name: "bar" });
	// 13 columns 
	// id, startStationId, startTimestamp, endStationId, endTimestamp, durationSeconds, endDate, startDate, durationMins, nowSecs, nowMins, isOpen, retrievedTimestamp

	var stmt = db.prepare("INSERT OR REPLACE INTO trips VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	for (var trip in trips) {
		stmt.run(trips[trip].id,
			trips[trip].startStationId, trips[trip].startTimestamp, trips[trip].endStationId,
			trips[trip].endTimestamp, trips[trip].durationSeconds, trips[trip].endDate,
			trips[trip].startDate, trips[trip].durationMins, trips[trip].nowSecs,
			trips[trip].nowMins, trips[trip].isOpen, trips[trip].retrievedTimestamp);
	}
	stmt.finalize();

	db.each("SELECT count(*) totalTrips FROM trips", function(err, row) {
		if (err) {
			throw err;
		}
		console.log(row.totalTrips);
	});
});

db.close();
/* fin */