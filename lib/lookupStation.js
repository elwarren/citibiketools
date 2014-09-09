// dump my entire citibike station list to sqlite
'use strict';
var sqlite3 = require('sqlite3').verbose();

var LookupStation = function LookupStationF(config) {
	this.debug = config.debug;

	this.db = new sqlite3.Database(config.path.sqldb, function(err) {
		if (err) {
			console.warn(Date() + ' ' + 'Error opening database file [' + config.path.sqldb + ']');
			throw err;
		} else {
			console.log(Date() + ' ' + 'db open');
		}
	});
}

LookupStation.prototype.id2LatLong = function id2LatLongF(lookupId, callback) {
	this.db.get("SELECT latitude, longitude FROM stations where id == ?", lookupId, callback);
};

LookupStation.prototype.id2LatCommaLong = function id2LatCommaLongF(lookupId, callback) {
	this.db.get("SELECT latitude||','||longitude latlong FROM stations where id == ?", lookupId, function(err, row) {
		if (row === undefined) {
			// no row, sumtin aint right
			callback('no row', row);
		} else {
			// console.log(Date() + ' ' + 'err:' + JSON.stringify(err, null, 2));
			// console.log(Date() + ' ' + 'row:' + JSON.stringify(row, null, 2));
			callback(err, row);
		}
	});
};

LookupStation.prototype.id2Label = function id2LabelF(lookupId, callback) {
	this.db.get("SELECT label FROM stations where id == ?", lookupId, callback);
};

exports = module.exports = LookupStation;
/* fin */