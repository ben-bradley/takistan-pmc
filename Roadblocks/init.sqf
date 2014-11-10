call compile preprocessFile "Roadblocks\fire.sqf";

private [ "_civs", "_created", "_create", "_pos", "_rb", "_fire", "_grp", "_civGrp", "_probability", "_grpHoldWaypoint", "_townPos", "_roads" ];

_civs = [ "CAF_AG_ME_CIV_04", "CAF_AG_ME_CIV_03", "CAF_AG_ME_CIV_02", "CAF_AG_ME_CIV" ];
_probability = 4; // 1 in _probability chance of placing a road block

while {true} do {
  _created = [];
  {
    _create = floor random _probability;
    if (_create == 0) then {
      _townPos = getMarkerPos _x;
      _roads = _townPos nearRoads 250;
      _pos = position (_roads call BIS_fnc_selectRandom);
      while { position player distance _pos < 100 } do {
        _pos = position (_roads call BIS_fnc_selectRandom);
      };

      _rb = createVehicle [ "Land_Tyres_F", _pos, [], 0, "CAN_COLLIDE" ];
      [ getPos _rb, "FIRE_BIG" ] call BIS_fn_createFireEffect;
      _grp = [ _pos, EAST, (configfile >> "CfgGroups" >> "EAST" >> "caf_ag_me_t" >> "Infantry" >> "6_men_me_t") ] call BIS_fnc_spawnGroup;
      _grpHoldWaypoint = _grp addWaypoint [ _pos, 10 ];
      _grpHoldWaypoint setWaypointCombatMode "RED";
      _grpHoldWaypoint setWaypointType "HOLD";
      _civGrp = createGroup civilian;
      { _civ = _civGrp createUnit [ _x, _pos, [], 5, "" ]; } forEach _civs;
      _created = _created + [ _rb ] + units _grp + units _civGrp;
    };
  } forEach BEN_towns;
  sleep 300 + (random 300);
  {
    while { position _x distance position player < 100 } do { sleep 1; };
    { if (typeOf _x == "#particlesource" || typeOf _x == "#lightpoint") then { deleteVehicle _x; }; } forEach (_x nearObjects 5);
    deleteVehicle _x;
  } forEach _created;
  sleep 5;
};
