-- 
-- 
-- "tripduration","starttime","stoptime","start station id","start station name","start station latitude","start station longitude","end station id","end station name","end station latitude","end station longitude","bikeid","usertype","birth year","gender"
-- 
-- "158","2014-05-01 00:08:32","2014-05-01 00:11:10","438","St Marks Pl & 1 Ave","40.72779126","-73.98564945","428","E 3 St & 1 Ave","40.72467721","-73.98783413","20997","Subscriber","1961","1"
create table history
( "tripDuration" number
,"startTime" date
,"stopTime" date
,"startStationId" number
,"startStationName" text
,"startStationLatitude" float
,"startStationLongitude" float
,"endStationId" number
,"endStationName" text
,"endStationLatitude" float
,"endStationLongitude" float
,"bikeId" number
,"userType" text
,"birthYear" number
,"gender" text
);