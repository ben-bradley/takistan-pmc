// Missions System ------------------------------------------------------------------------ //
private [ "_missions", "_missionMarkers" ];

waitUntil { time > 5 };

_missionMarkers = [
  "occupation_1", "occupation_2", "occupation_3", "occupation_4", "occupation_5", "occupation_6", "occupation_7", "occupation_8", "occupation_9", "occupation_10",
  "nato_convoy_1", "nato_convoy_2", "nato_convoy_3", "nato_convoy_4", "nato_convoy_5", "nato_convoy_6"
];

BEN_MISSION_ACTIVE = false;
publicVariable "BEN_MISSION_ACTIVE";

_missions = [
  "Missions\mission_occupation.sqf"
  //"Missions\mission_convoy.sqf"
];

/******************** Hide all the markers ********************/
{ [ _x ] call BEN_hideMarker; } forEach _missionMarkers;

while {true} do
{
  BEN_MISSION_ACTIVE = true;
  publicVariable "BEN_MISSION_ACTIVE";

  execVM (_missions call BIS_fnc_selectrandom);

  waitUntil { !BEN_MISSION_ACTIVE };
  sleep ((random 120) + 300);
};
// ---------------------------------------------------------------------------------------------- //
