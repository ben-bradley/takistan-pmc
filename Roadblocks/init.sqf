call compile preprocessFile "Roadblocks\fire.sqf";

private [ "_rbMarkers", "_civs", "_created", "_create", "_pos", "_rb", "_fire", "_grp", "_civGrp", "_probability" ];

_rbMarkers = [ "rb_1", "rb_2", "rb_3", "rb_4", "rb_5", "rb_6", "rb_7", "rb_8", "rb_9", "rb_10", "rb_11", "rb_12", "rb_13", "rb_14", "rb_15", "rb_16", "rb_17", "rb_18", "rb_19", "rb_20" ];
_civs = [ "CAF_AG_ME_CIV_04", "CAF_AG_ME_CIV_03", "CAF_AG_ME_CIV_02", "CAF_AG_ME_CIV" ];
_probability = 3; // 1 in _probability chance of placing a road block

while {true} do {
  _created = [];
  {
    _create = floor random _probability;
    if (_create == 0) then {
      _pos = getMarkerPos _x;
      _rb = createVehicle [ "Land_Tyres_F", _pos, [], 0, "CAN_COLLIDE" ];
      [ getPos _rb, "FIRE_BIG" ] call BIS_fn_createFireEffect;
      _grp = [ _pos, EAST, (configfile >> "CfgGroups" >> "EAST" >> "caf_ag_me_t" >> "Infantry" >> "6_men_me_t") ] call BIS_fnc_spawnGroup;
      _civGrp = createGroup civilian;
      { _civ = _civGrp createUnit [ _x, _pos, [], 5, "" ]; } forEach _civs;
      _created = _created + [ _rb ] + units _grp + units _civGrp;
    };
  } forEach _rbMarkers;
  sleep 300 + (random 300);
  {
    { if (typeOf _x == "#particlesource" || typeOf _x == "#lightpoint") then { deleteVehicle _x; }; } forEach (_x nearObjects 5);
    deleteVehicle _x;  
  } forEach _created;
  sleep 5;
};
