#!/opt/local/bin/node
 // dump my entire citibike history to sqlite
'use strict';
var config = require('../lib/configger');
// var trips = require(config.path.trips.json);

var csv = require('fast-csv');
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(config.path.sqldb, function(err) {
	if (err) {
		console.warn('Error opening database file [' + config.path.sqldb + ']');
		throw err;
	} else {
		console.log('Opened sqlite3 file [' + config.path.sqldb + ']');
	}
});

var counter = 0;
var b = 0;
var bs = 2000;

db.serialize(function() {
	// csv header
	// "tripduration", "starttime", "stoptime", "start station id", "start station name", "start station latitude", "start station longitude", "end station id", "end station name", "end station latitude", "end station longitude", "bikeid", "usertype", "birth year", "gender"
	// 
	// csv row
	// "158", "2014-05-01 00:08:32", "2014-05-01 00:11:10", "438", "St Marks Pl & 1 Ave", "40.72779126", "-73.98564945", "428", "E 3 St & 1 Ave", "40.72467721", "-73.98783413", "20997", "Subscriber", "1961", "1"
	//

	db.run("CREATE TABLE IF NOT EXISTS history (tripDuration number, startTime date, stopTime date, " + "startStationId number, startStationName text, startStationLatitude float, " + "startStationLongitude float, endStationId number, endStationName text, endStationLatitude float, " + "endStationLongitude float, bikeId number, userType text, birthYear number, gender text) ");
	var stmt = db.prepare("INSERT OR REPLACE INTO history VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

	csv.fromPath(config.path.history.csv)
		.on("record", function(data) {
			// console.log(data);
			// console.log(counter++);
			counter++;
			b++;
			stmt.run(data);
			if (b == bs) {
				stmt.finalize();
				b = 0;
				console.log(counter);
			}
		})
		.on("end", function() {
			console.log("done");
			console.log(counter);
			// stmt.finalize();
			db.close();
		});

});

/* fin */