/************************************************************************************************/
/* _randomPos = [ <position of origin>, <radius within which to generate> ] call BEN_randomPos; */
/************************************************************************************************/
BEN_randomPos = {

  private [ "_origin", "_radius", "_randomX", "_randomY", "_newX", "_newY" ];

  _origin = _this select 0;
  _radius = _this select 1;

  _randomX = random _radius - random _radius;
  _randomY = random _radius - random _radius;

  _newX = (_origin select 0) - _randomX;
  _newY = (_origin select 1) - _randomY;

  [ _newX, _newY, _origin select 2 ]

};


/***************************************************************************************/
/* _vipGroup = [ <position of origin>, <global var for vip> ] call BEN_createVIPGroup; */
/***************************************************************************************/
BEN_createVIPGroup = {

  private [ "_origin", "_grp", "_initString", "_wp" ];

  _origin = _this select 0;
  _vipVar = _this select 1;
  _initString = format [ "%1 = this;", _vipVar ];

  _grp = [ _origin, RESISTANCE, (configfile >> "CfgGroups" >> "Indep" >> "PG_Services" >> "Infantry" >> "PMC_VIP_Bodyguard") ] call BIS_fnc_spawnGroup;
  "PMC_VIP_F" createUnit [ _origin, _grp, _initString ];

  _wp = _grp addWaypoint [ _origin, 0 ];
  _wp setWaypointType "HOLD";
  _wp setWaypointFormation "DIAMOND";

  sleep 1;

  _grp

};


BEN_createBodyguards = {

  private [ "_origin", "_grp", "_wp" ];

  _origin = _this select 0;

  _grp = [ _origin, RESISTANCE, (configfile >> "CfgGroups" >> "Indep" >> "PG_Services" >> "Infantry" >> "PMC_VIP_Bodyguard") ] call BIS_fnc_spawnGroup;

  _wp = _grp addWaypoint [ _origin, 0 ];
  _wp setWaypointType "HOLD";

  sleep 1;

  _grp

};


BEN_towns = [
  "town_1", "town_2", "town_3", "town_4", "town_5", "town_6", "town_7", "town_8", "town_9", "town_10",
  "town_11", "town_12", "town_13", "town_14", "town_15", "town_16", "town_17", "town_18", "town_19", "town_20",
  "town_21", "town_22", "town_23", "town_24", "town_25", "town_26", "town_27", "town_28", "town_29", "town_30",
  "town_31", "town_32", "town_33"
];


BEN_randomTown = {
  BEN_towns call BIS_fnc_selectRandom
};


/*********************************************************/
/* _randomBldgPos = [ building ] call BEN_randomBldgPos; */
/*********************************************************/
BEN_randomBldgPos = {

  private [ "_bldg", "_positions", "_pos", "_p", "_rpos" ];

  _bldg = _this select 0;
  _positions = [];
  _pos = [ 1, 1, 1 ];
  _p = 0;

  while { _pos select 0 > 0 } do {
    _pos = _bldg buildingPos _p;
    _p = _p + 1;
    _positions = _positions + [ _pos ];
  };

  _rpos = _positions call BIS_fnc_selectrandom;
  if (_rpos select 0 == 0) then { _rpos = position _bldg; };

  _rpos

};


BEN_updateMarker = {

  private [ "_marker", "_text", "_color", "_alpha", "_type" ];

  _marker = _this select 0;
  _text = _this select 1;
  _color = _this select 2;
  _alpha = _this select 3;
  _type = _this select 4;

  _marker setMarkerText _text;
  _marker setMarkerColor _color;
  _marker setMarkerAlpha _alpha;
  _marker setMarkerType _type;

};

BEN_hideMarker = {

  private [ "_marker" ];

  _marker = _this select 0;

  _marker setMarkerText "";
  _marker setMarkerAlpha 0;

};
