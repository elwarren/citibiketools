-- show 5 nearest stations with name and distance
select sn.id, sn.nearbyId, s.label, sn.distance 
  from stationsNearby sn, stations s 
 where sn.id = ? 
   and sn.nearbyId = s.id;
