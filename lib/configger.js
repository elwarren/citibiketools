// simple config file loader switches between command line and file in package etc directory
// command line config file always overrides filesystem configfile
//   if cmd parameter is not a file, try to load fs config
// if no cmd parameter, try to load fs config
// exit hard if all fail, code cannot run without config

'use strict';
var fs = require('fs');
var config = {};
var configFile = 'etc/config.json';

if (process.argv[2]) {
	if (fs.existsSync(process.argv[2])) {
		config = require(process.argv[2]);
	} else {
		console.warn(Date() + ' ' + "Config " + process.argv[2] + " is not available");
		if (fs.existsSync(configFile)) {
			config = require('../' + configFile);
		} else {
			console.warn(Date() + ' ' + "Config " + configFile + " is not available");
			console.warn(Date() + ' ' + "Must provide config file in package etc or on command line");
			process.exit(1);
		}
	}
} else {
	// TODO this works now but fs and require seem to be called from different start points. Need to cleanup ugliness.
	if (fs.existsSync(configFile)) {
		config = require('../' + configFile);
	} else {
		console.warn(Date() + ' ' + "Config " + configFile + " is not available");
		console.warn(Date() + ' ' + "Must provide config file in package etc or on command line2");
		process.exit(1);
	}
}

exports = module.exports = config;