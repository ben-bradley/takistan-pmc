// Missions System ------------------------------------------------------------------------ //
call compile preprocessFile "Missions\BEN_fns.sqf";
waitUntil { time > 5 };

BEN_MISSION_ACTIVE = false;
publicVariable "BEN_MISSION_ACTIVE";

_missions = [
  "Missions\mission_occupation.sqf"
];

while {true} do
{
	BEN_MISSION_ACTIVE = true;
	publicVariable "BEN_MISSION_ACTIVE";

  execVM (_missions call BIS_fnc_selectrandom);
  
	waitUntil { !BEN_MISSION_ACTIVE };
	sleep ((random 120) + 300);
};
// ---------------------------------------------------------------------------------------------- //