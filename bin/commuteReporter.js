#!/opt/local/bin/node
 // citibiketweet will monitor your citibike trips history and tweet during open trips
// TODO do we need timezone support?
// TODO set tweet location to the citibike station the bike was checked out from?
// TODO add 4sq checkin to stations? Should be a new script

// requires 
var time = require('time');
var util = require('util');
var CronJob = require('cron').CronJob;
var twitter = require('twitter');
var CitibikeTrips = require('CitibikeTrips');
var config = require('../etc/config.json');
// vars
config.debug = process.argv[2] || config.debug;
var bike = new CitibikeTrips(config);
// TODO move cronSched into config file
var cronSched = '10 */' + config.intervalMins + ' 7-23 * * *';
var twit = new twitter(config.twitter);

var notifyMe = function notifyMeF(timerMinutes) {
    var msg = util.format(config.msg, timerMinutes);

    twit.verifyCredentials(function(data) {
        config.debug > 2 && console.log(Date() + ' ' + 'TWIT BEG ' + JSON.stringify(data));
    });

    if (config.twitter.dm) {
        twit.sendDirectMessage(config.twitter.dm, msg, function(data) {
            config.debug && console.log(Date() + ' ' + 'TWIT DIRECT MSG:' + msg);
            config.debug > 2 && console.log(Date() + ' ' + 'TWIT END ' + JSON.stringify(data));
        });
    } else {
        twit.updateStatus(msg, function(data) {
            config.debug && console.log(Date() + ' ' + 'TWIT UPDATE MSG:' + msg);
            config.debug > 2 && console.log(Date() + ' ' + 'TWIT END ' + JSON.stringify(data));
        });
    }
}

var cronJson = {
    cronTime: cronSched,
    onTick: function() {
        // job start
        config.debug && console.log(Date() + ' ' + 'BEG');
        bike.getLastTrip(function(err, trip) {
            if (!trip) {
                // XXX this should not happen but it did
                config.debug && console.error(Date() + ' ' + 'ERR no trip downloaded');
                return null;
            } else {
                config.debug && console.log(Date() + ' ' + 'trip: ' + JSON.stringify(trip));
            }

            if (trip.isOpen) {
                config.debug && console.log(Date() + ' ' + 'open min: ' + trip.nowMins);
                return notifyMe(trip.nowMins);
            } else {
                config.debug && console.log(Date() + ' ' + 'NOP');
            }
        });
    },
    onComplete: function() {
        // job end
        return console.log(Date() + ' ' + 'END');
    },
    start: true,
    timeZone: config.tz
};

var job = new CronJob(cronJson);

job.start();

// stop after an hour or whatever stopMins is
setTimeout(function() {
    console.log(Date() + ' ' + 'KILL');
    job.stop();
}, config.stopMins * 60 * 1000);

/* fin */
