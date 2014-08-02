#!/opt/local/bin/node
 // dump entire citibike station list json to console
'use strict';
var config = require('../lib/configger');
var Citibike = require('citibike');
var citibike = new Citibike;

citibike.getStations(null, function(data) {
	console.log(JSON.stringify(data, null, 2));
});


/* fin */