// dump my entire citibike station list to sqlite
'use strict';
var sqlite3 = require('sqlite3').verbose();

var LookupStation = function LookupStationF(config) {
	this.debug = config.debug;

	this.db = new sqlite3.Database(config.path.sqldb, function(err) {
		if (err) {
			console.warn('Error opening database file [' + config.path.sqldb + ']');
			throw err;
		} else {
			console.log('db open');
		}
	});
}

LookupStation.prototype.id2LatLong = function id2LatLongF(lookupId, callback) {
	this.db.get("SELECT latitude, longitude FROM stations where id == ?", lookupId, callback);
};

LookupStation.prototype.id2LatCommaLong = function id2LatCommaLongF(lookupId, callback) {
	this.db.get("SELECT latitude||','||longitude latlong FROM stations where id == ?", lookupId, function(err, row) {
		callback(err, row.latlong);
	});
};

LookupStation.prototype.id2Label = function id2LabelF(lookupId, callback) {
	this.db.get("SELECT label FROM stations where id == ?", lookupId, callback);
};

exports = module.exports = LookupStation;
/* fin */