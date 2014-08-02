// simple config file loader switches between command line and file in package etc directory
// command line config file always overrides filesystem configfile
//   if cmd parameter is not a file, try to load fs config
// if no cmd parameter, try to load fs config
// exit hard if all fail, code cannot run without config

'use strict';
var fs = require('fs');
var config = {};

if (process.argv[2]) {
	if (fs.existsSync(process.argv[2])) {
		config = require(process.argv[2]);
	} else {
		console.warn("Config " + process.argv[2] + " is not available");
		if (fs.existsSync('../etc/config.json')) {
			config = require('../etc/config.json');
		} else {
			console.warn("Must provide config file in package etc or on command line");
			process.exit(1);
		}
	}
} else {
	if (fs.existsSync('../etc/config.json')) {
		config = require('../etc/config.json');
	} else {
		console.warn("Must provide config file in package etc or on command line2");
		process.exit(1);
	}
}

exports = module.exports = config;