# Citibike Tools

Some simple node.js programs to manipulate and report on your Citibike trip 
history.  To be used to used with the Citibike and CitibikeTrips modules.

## Install
TODO this has not been released to NPM yet

```
$ git clone https://github.com/elwarren/citibiketools.git
$ cd citibiketools
$ npm install
$ cp etc/example-config.json etc/config.json
 or
$ cp etc/example-config.json ~/.citibike-config.json
```

## Usage

You'll need to provide your username and password to the http://citibikenyc.com
site in a config file.  Either save this config.json in the package etc directory
or pass it in on the command line as the first parameter.

Currently the get*.js code will query the Citibike website and dump results to
STDOUT for simplicity.  Eventually these will go into files defined in config.json.

The merge*.js code will read these json files from disk and create a sqlite 
database.  This can then be used to query and report on your trip history.

Build trip and station database:

```
$ cd citibiketools
$ bin/getAllTrips.js ~/.citibike-config.json > ~/data/citibike/trips.js
$ bin/getAllStations.js ~/.citibike-config.json > ~/data/citibike/stations.js
$ bin/mergeStationsToSql.js ~/.citibike-config.json
$ bin/mergeTripsToSql.js ~/.citibike-config.json
```

What days of the week do you ride most?  Weekends, weekdays, wednesdays?  Week starts with 0=Sunday.

```
sqlite> select strftime('%w', startTimestamp, 'unixepoch', 'localtime') dayofweek, count(*) from trips group by 1 order by 1;
0|5
1|13
2|7
3|12
4|14
5|7
6|6
```

Show top two trips you've ridden:

```
$ sqlite3 ~/data/citibike/citibike.sqlite3
sqlite>  select startStationId, endStationId, count(*)
   ...> from trips 
   ...> where startStationId != endStationId 
   ...> group by startStationId, endStationId 
   ...> order by 3 desc limit 2;
512|434|12
212|512|11
```

For me this shows my ride to work and my ride home.  Let's add station names:

```
sqlite> select t.startStationId, sa.label, t.endStationId, sb.label, count(*)
   ...>   from trips t
   ...>      , stations sa
   ...>      , stations sb
   ...>  where t.startStationId != t.endStationId 
   ...>    and t.startStationId = sa.id
   ...>    and t.endStationId = sb.id
   ...>  group by t.startStationId, t.endStationId 
   ...>  order by 5 desc limit 2;
512|W 29 St & 9 Ave|434|9 Ave & W 18 St|12
212|W 16 St & The High Line|512|W 29 St & 9 Ave|11
```

## Database schema
This is changing as I add and rename columns.  It mostly resembles the json source objects.  Currently:

```
sqlite> .schema
CREATE TABLE trips ( id int PRIMARY KEY, startStationId int, startTimestamp int, endStationId int, endTimestamp int, durationSeconds int, endDate date, startDate date, durationMins int, nowSecs int, nowMins int, isOpen boolean, retrievedTimestamp int );

CREATE TABLE stations ( id int PRIMARY KEY, status varchar2(20), latitude float, longitude float, label varchar2(60), stationAddress varchar2(60), availableBikes int, availableDocks int, nearbyStations varchar2(2000));

CREATE TABLE stationsNearby ( id int, nearbyId, distance float );

CREATE UNIQUE INDEX snun ON stationsNearby (id, nearbyId);

```

## Config file format
The config file is shared between citibiketools and citibiketrips because they're generally used together.

```
config.json = {
    "debug": 0,
    "path": {
        "dir": "/tmp",
        "trips": {
            "json": "/tmp/alltrips.json",
            "csv": "/tmp/alltrips.csv"
        },
        "stations": {
            "json": "/tmp/allstations.json",
            "csv": "/tmp/allstations.csv"
        },
        "sqldb": "/tmp/citibike.sqlite3"
    },
    "commuter": {
	    "wait": 300,
	    "intervalMins": 3,
	    "stopMins": 60,
	    "msg": "I'm riding a bike! I've been out for at least %d mins.",
	    "tz": "America/New_York"
	},
    "citibikenyc": {
        "user": "yourusername",
        "pass": "yourpassword!",
        "homeStations": [123, 456],
        "workStations": [789],
        "memberId": 123456,
        "bikeKey": 1234567
    },
    "twitter": {
        "dm": "elwarren",
        "consumer_key": "yourkey",
        "consumer_secret": "yoursecret",
        "access_token_key": "yourtokenkey",
        "access_token_secret": "yourtokensecret"
    }
}
```

## Thanks

Special thanks to the Citibike program operated by NYC Bike Share.  I ride these bikes everyday, sometimes 3-4 trips in a single day.

Please do not abuse their servers with excessive polling.  I've read the Citibike TOS http://www.citibikenyc.com/assets/pdf/terms-of-use.pdf
and it appears to be OK to do this for personal use.


