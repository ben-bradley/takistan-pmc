// This contract is to recover a VIP that has had his escort attacked and his vehicle disabled
BEN_CONTRACT_ACTIVE = true;
publicVariable "BEN_CONTRACT_ACTIVE";
sleep 1;
private [
  "_hintPmcSuccess", "_hintPmcFailure", "_hintPmcActive", "_hintPmcStartup",
  "_hintEastSuccess", "_hintEastFailure", "_hintEastActive", "_hintEastStartup",
  "_hintWestSuccess", "_hintWestFailure", "_hintWestActive", "_hintWestStartup",
  "_vipRecoveryMarkers", "_vipReturnMarkers", "_vipRecoveryMarker", "_vipRecoveryPos", "_carPos",
  "_created", "_rbp", "_vipPos", "_vipGrp", "_vipGrpHoldWaypoint", "_maxEIGroups", "_minEIGroups",
  "_EIGroups", "_EIGroupsCount", "_result", "_vipReturnTask", "_vipJoined", "_startTimeout", "_endTimeout",

  "_town", "_townPos"
];



/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_vipReturnMarkers = [ "vip_return_1", "vip_return_2", "vip_return_3" ];
_maxEIGroups = 6; // maximum number of 6-man groups?
_minEIGroups = 3; // minimum number of 6-man groups?

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/



/***************** Contract Hints *****************/
_hintPmcSuccess = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job getting that VIP back safely!<br/><br/>We should have another contract come up again soon.</t>";
_hintPmcFailure = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The VIP was killed before we could extract him!<br/><br/>Let's hope that we're able to get another contract soon...</t>";
_hintPmcActive = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>Linked up!</t><br/>____________________<br/>Get that VIP back to safety!<br/><br/></t>";
_hintPmcStartup = "<t align='center'><t size='2.2'>New Contract</t><br/><t size='1.5' color='#00B2EE'>VIP Recovery</t><br/>____________________<br/>A VIP escort team has been attacked and pinned down!<br/><br/>We need to go in and get the VIP before they're overrun!</t>";
if (playerSide == resistance) then { hint parsetext _hintPmcStartup; };

_hintEastSuccess = "<t align='center'><t size='2.2'>Infidel VIP</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>The infidel has been killed!<br/><br/>This will send a message that we are not to be trifled with.</t>";
_hintEastFailure = "<t align='center'><t size='2.2'>Infidel VIP</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The VIP was extracted before we could kill him!<br/><br/>We'll need to be quicker next time...</t>";
_hintEastActive = "<t align='center'><t size='2.2'>Infidel VIP</t><br/><t size='1.5' color='#00B2EE'>Infidel VIP moving!</t><br/>____________________<br/>The infidels are there, we're almost out of time!<br/><br/></t>";
_hintEastStartup = "<t align='center'><t size='2.2'>Infidel VIP</t><br/><t size='1.5' color='#00B2EE'>Infidel VIP attacked!</t><br/>____________________<br/>An infidel VIP escort team has been attacked and pinned down!<br/><br/>We need to get there and finish him off befor help arrives.</t>";
if (playerSide == east) then { hint parsetext _hintEastStartup; };

/***************** Select a start point *****************/
//{ [ _x ] call BEN_hideMarker; } forEach _vipRecoveryMarkers;
//_vipRecoveryMarker = _vipRecoveryMarkers call BIS_fnc_selectrandom;
//_vipRecoveryPos = getMarkerPos _vipRecoveryMarker;
{ [ _x ] call BEN_hideMarker; } forEach BEN_towns;
_town = call BEN_randomTown;
_townPos = getMarkerPos _town;
_vipRecoveryPos = [ _townPos, 200 ] call BEN_randomPos;

/***************** Create the VIP group *****************/
_created = [];
_vipGrp = [ _vipRecoveryPos, "BEN_PMC_VIP_VR" ] call BEN_createVIPGroup;
_carPos = _vipRecoveryPos findEmptyPosition [ 0, 100, "C_SUV_01_F" ];
BEN_PMC_VIP_SUV = "C_SUV_01_F" createVehicle _carPos;
BEN_PMC_VIP_SUV setDamage 0.9;
_created = _created + (units _vipGrp) + [ BEN_PMC_VIP_SUV ];

/***************** Place the VIP randomly *****************/
_rbp = [ nearestBuilding _vipRecoveryPos ] call BEN_randomBldgPos;
BEN_PMC_VIP_VR setPos _rbp;
BEN_PMC_VIP_VR playAction "die";
BEN_PMC_VIP_VR disableai "move";
_vipPos = position BEN_PMC_VIP_VR;

/***************** Make the bodyguards defend the VIP *****************/
_vipGrpHoldWaypoint = _vipGrp addWaypoint [ _vipPos, 0 ];
_vipGrpHoldWaypoint setWaypointBehaviour "STEALTH";
_vipGrpHoldWaypoint setWaypointCombatMode "RED";
_vipGrpHoldWaypoint setWaypointType "HOLD";

/***************** Update the map marker *****************/
_vipRecoveryMarker = createMarker [ "Recover the VIP", _vipPos ];
[ _vipRecoveryMarker, "Recover the VIP", "ColorRed", 1, "mil_dot" ] call BEN_updateMarker;

/***************** Create the enemy groups *****************/
_EIGroups = [];
_EIGroupsCount = floor random _maxEIGroups;
if (_EIGroupsCount < _minEIGroups) then { _EIGroupsCount = _minEIGroups };
while { count _EIGroups < _EIGroupsCount } do {
  _posEI = [ _vipPos, 1000 ] call BEN_randomPos;
  _grpEI = [ _posEI, EAST, (configfile >> "CfgGroups" >> "EAST" >> "caf_ag_me_t" >> "Infantry" >> "6_men_me_t") ] call BIS_fnc_spawnGroup;
  _sadWaypoint = _grpEI addWaypoint [ _vipPos, 0 ];
  _sadWaypoint setWaypointBehaviour "AWARE";
  _sadWaypoint setWaypointType "SAD";
  _EIGroups = _EIGroups + [ _grpEI ];
  _created = _created + (units _grpEI);
  sleep 1;
};

/***************** Begin waiting for results *****************/
_result = "pending";
_vipJoined = false;
_startTimeout = 0;
_endTimeout = 0;
waitUntil {
  sleep 1;

  /***************** set the proximity trigger *****************/
  if (player distance BEN_PMC_VIP_VR < 5 && !_vipJoined) then {
    _vipJoined = true;
    if (playerSide == resistance) then { hint parsetext format [ _hintPmcActive, _EIGroupsCount ]; };
    if (playerSide == east) then { hint parsetext format [ _hintEastActive, _EIGroupsCount ]; };
    BEN_PMC_VIP_VR enableai "move";
    BEN_PMC_VIP_VR playAction "agonystop";
    { [ _x ] join player; } forEach units _vipGrp;
    [ _vipRecoveryMarker ] call BEN_hideMaker;
    { [ _x, "Return the VIP", "ColorGreen", 1, "mil_dot" ] call BEN_updateMarker; } forEach _vipReturnMarkers;
  };

  /***************** check for timeout ******************/
  if (!_vipJoined) then {
    _startTimeout = _startTimeout + 1;
  };
  if(_vipJoined) then {
    _endTimeout = _endTimeout + 1;
  };
  if (_startTimeout > 900) then { _result = "fail"; };
  if (_endTimeout > 1800) then { _result = "fail"; };

  /***************** check for win or fail *****************/
  if (!alive BEN_PMC_VIP_VR) then { _result = "fail"; };
  { if ((alive BEN_PMC_VIP_VR) && (BEN_PMC_VIP_VR distance (getMarkerPos _x) < 15)) then { _result = "win"; }; } forEach _vipReturnMarkers;

  /***************** conditions for ending the wait *****************/
  (_result == "win") OR (_result == "fail")
};

/***************** handle 'fail' *****************/
if (_result == "fail") then {
  if (playerSide == resistance) then { hint parsetext _hintPmcFailure; };
  if (playerSide == east) then { hint parsetext _hintEastSuccess; };
};

/***************** handle 'win' *****************/
if (_result == "win") then {
  if (playerSide == resistance) then { hint parsetext _hintPmcSuccess; };
  if (playerSide == east) then { hint parsetext _hintEastFailure; };
};

/***************** do clean up *****************/
sleep 5;
//{ [ _x ] call BEN_hideMarker; } forEach _vipRecoveryMarkers;
deleteMarker _vipRecoveryMarker;
{ [ _x ] call BEN_hideMarker; } forEach _vipReturnMarkers;

sleep 10;
{ deleteVehicle _x; } forEach _created;

BEN_CONTRACT_ACTIVE = false;
publicVariable "BEN_CONTRACT_ACTIVE";
