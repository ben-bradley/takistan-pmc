BEN_debug = {
  hint format [ "%1", _this ];
};


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


/*****************************************************************/
/* _vipGroup = [ <position of origin> ] call BEN_createVIPGroup; */
/*****************************************************************/
BEN_createVIPGroup = {

  private [ "_origin", "_grp" ];
  
  _origin = _this select 0;
  
  _grp = [ _origin, RESISTANCE, (configfile >> "CfgGroups" >> "Indep" >> "PMC_POMI" >> "Infantry" >> "PMC_VIP_Bodyguard") ] call BIS_fnc_spawnGroup;
  "PMC_VIP_F" createUnit [ _origin, _grp, "BEN_PMC_VIP = this;" ];
  
  _grp

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