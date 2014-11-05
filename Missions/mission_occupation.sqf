/***************** Site Defense Contract *****************/
BEN_MISSION_ACTIVE = true;
publicVariable "BEN_MISSION_ACTIVE";
sleep 1;
private [
  "_hintPmcSuccess", "_hintPmcFailure", "_hintPmcActive", "_hintPmcStartup",
  "_hintEastSuccess", "_hintEastFailure", "_hintEastActive", "_hintEastStartup",
  "_hintWestSuccess", "_hintWestFailure", "_hintWestActive", "_hintWestStartup",
  "_occupationMarkers", "_occupationMarker", "_occupationPos", "_sitePos", "_occupationRadius",
  "_groupsCount", "_groups", "_created", "_timer", "_t", "_grpTypes", "_grpType"
];



/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_occupationMarkers = [ "occupation_1", "occupation_2", "occupation_3", "occupation_4", "occupation_5", "occupation_6", "occupation_7", "occupation_8", "occupation_9", "occupation_10" ]; // list of markers
_occupationRadius = 250; // meters within which to spawn EI
_grpTypes = [ "4_men_me_t", "6_men_me_t", "8_men_me_t", "10_men_me_t", "Technicals_me_t", "Technicals2_me_t" ];
_groupsCount = 10; // the number of groups
_timer = 1800; // 30 mins (if there are still opfor alive after _timer then opfor wins)
_ratio = 0.25; // if there are less than this percentage of opfor, then the west wins)

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/



/***************** Occupation Hints *****************/
_hintPmcSuccess = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>The terrorists were driven from the village.<br/><br/>We should be able to operate freely in the area again.</t>";
_hintPmcFailure = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The terrorists held the village.<br/><br/>This may not bode well for our economic future...</t>";
_hintPmcActive = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#FF0000'>Village Occupied</t><br/>____________________<br/>We're getting reports that the terrorists are being engaged!<br/><br/>If you're in the area, keep your head down!</t>";
_hintPmcStartup = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#00B2EE'>Village Occupied</t><br/>____________________<br/>The terrorists have moved in to a village and set up shop.<br/><br/>We probably should stay clear while NATO clears them out.</t>";
if (playerSide == resistance) then { hint parsetext _hintPmcStartup; };

_hintEastSuccess = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>NATO was unable to push us from the village.<br/><br/>We should be able to operate freely in the area again.</t>";
_hintEastFailure = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The infidels drove our brothers from the village.<br/><br/>This may not bode well for our cause...</t>";
_hintEastActive = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#FF0000'>Village Occupied</t><br/>____________________<br/>Our brothers are being engaged!<br/><br/>If you're in the area, get there quick and help them defeat the infidels!</t>";
_hintEastStartup = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#00B2EE'>Village Occupied</t><br/>____________________<br/>Our brothers have siezed a village.<br/><br/>Help them hold it and prevent NATO from driving them out!</t>";
if (playerSide == east) then { hint parsetext _hintEastStartup; };

_hintWestSuccess = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job! The terrorists were driven from the village.<br/><br/>We should be able to operate freely in the area again.</t>";
_hintWestFailure = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The terrorists held the village.<br/><br/>This will further destabilize the region...</t>";
_hintWestActive = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#FF0000'>Village Occupied</t><br/>____________________<br/>We're getting reports that the terrorists are being engaged!<br/><br/>If you're not in the area, get there quick!</t>";
_hintWestStartup = "<t align='center'><t size='2.2'>Occupation</t><br/><t size='1.5' color='#00B2EE'>Village Occupied</t><br/>____________________<br/>Terrorists have moved in to a village and set up shop.<br/><br/>We need to get in there and clear them out.</t>";
if (playerSide == west) then { hint parsetext _hintWestStartup; };


/***************** Select a starting point *****************/
_occupationMarker = _occupationMarkers call BIS_fnc_selectrandom;
_occupationPos = getMarkerPos _occupationMarker;

/***************** Update the marker on the map *****************/
[ _occupationMarker, "Occupied Village", "ColorRed", 1, "mil_objective" ] call BEN_updateMarker;

/***************** Update the ALiVE targets *****************/
{ [ _x, "addObjective", ["Occupied Village", _occupationPos, 100, "CIV"] ] call ALiVE_fnc_OPCOM; } foreach OPCOM_INSTANCES;

/***************** Build the OPFOR units *****************/
_groups = 0;
_created = [];
while { _groups < _groupsCount } do {
  _posEI = [ _occupationPos, _occupationRadius ] call BEN_randomPos;
  _grpType = _grpTypes call BIS_fnc_selectrandom;
  _grp = [ _posEI, EAST, (configfile >> "CfgGroups" >> "EAST" >> "caf_ag_me_t" >> "Infantry" >> _grpType) ] call BIS_fnc_spawnGroup;
  _eiWp = _grp addWaypoint [ _posEI, 0 ];
  _eiWp setWaypointType "LOITER";
  _created = _created + units _grp;
  _groups = _groups + 1;
  sleep 1;
};

/***************** Begin waiting for results *****************/
_result = "pending";
_t = 0;

waitUntil {
  sleep 1;

  _t = _t + 1; // timer count +1
  _leftAlive = { alive _x } count _created;

  /***************** check for win or fail *****************/
  if (_leftAlive < (_ratio * (count _created))) then { _result = "win"; };
  if (_t >= _timer) then { _result = "fail"; };

  /***************** conditions for ending the wait *****************/
  (_result == "win") OR (_result == "fail")
};

/***************** handle 'fail' *****************/
if (_result == "fail") then {
  if (playerSide == resistance) then { hint parsetext _hintPmcFailure; };
  if (playerSide == east) then { hint parsetext _hintEastSuccess; };
  if (playerSide == west) then { hint parsetext _hintWestFailure; };
};

/***************** handle 'win' *****************/
if (_result == "win") then {
  if (playerSide == resistance) then { hint parsetext _hintPmcSuccess; };
  if (playerSide == east) then { hint parsetext _hintEastFailure; };
  if (playerSide == west) then { hint parsetext _hintWestSuccess; };
};

/***************** do clean up *****************/
sleep 5;
[ _occupationMarker ] call BEN_hideMarker;

sleep 10;
{ deleteVehicle _x; } forEach _created;

BEN_MISSION_ACTIVE = false;
publicVariable "BEN_MISSION_ACTIVE";
