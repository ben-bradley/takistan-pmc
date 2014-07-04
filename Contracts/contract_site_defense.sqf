/***************** Site Defense Contract *****************/
BEN_CONTRACT_ACTIVE = true;
publicVariable "BEN_CONTRACT_ACTIVE";
sleep 1;
private [
  "_hintPmcSuccess", "_hintPmcFailure", "_hintPmcActive", "_hintPmcStartup",
  "_hintEastSuccess", "_hintEastFailure", "_hintEastActive", "_hintEastStartup",
  "_hintWestSuccess", "_hintWestFailure", "_hintWestActive", "_hintWestStartup",
  "_lengthOfMeeting", "_maxEIGroups", "_minEIGroups", "_siteDefenseMarkers",
  "_defendWaypoint", "_siteDefenseMarker", "_sitePos", "_vipGrp", "_rbp", "_vipPos",
  "_EIGroups", "_EIGroupsCount", "_created"
];



/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_siteDefenseMarkers = [ "site_defense_1", "site_defense_2", "site_defense_3", "site_defense_4", "site_defense_5", "site_defense_6", "site_defense_7", "site_defense_8", "site_defense_9", "site_defense_10" ]; // list of markers
_maxEIGroups = 10; // maximum number of 6-man groups?
_minEIGroups = 3; // minimum number of 6-man groups?
_lengthOfMeeting = 300 + (random 300); // the length in seconds that the meeting will take before successfully completing

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/



/***************** Contract Hints *****************/
_hintPmcSuccess = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job securing that location!  Let's hope the meeting was worth it.<br/><br/>We should have another contract come up again soon.</t>";
_hintPmcFailure = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The site was overrun and the VIP was killed!<br/><br/>Let's hope that we're able to get another contract soon...</t>";
_hintPmcActive = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#FF0000'>Dig In</t><br/>____________________<br/>We're getting reports of %1 groups of hostiles approaching your location<br/><br/>Dig in and hold them off!</t>";
_hintPmcStartup = "<t align='center'><t size='2.2'>New Contract</t><br/><t size='1.5' color='#00B2EE'>Site Defense</t><br/>____________________<br/>A client has asked us to provide security for a VIP meeting.<br/><br/>Get to the meeting and secure that location.</t>";
if (playerSide == resistance) then { hint parsetext _hintPmcStartup; };

_hintEastSuccess = "<t align='center'><t size='2.2'>VIP Meeting</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job overrunning the meeting and killing those infidels.<br/><br/>They should fear to tread in our land.</t>";
_hintEastFailure = "<t align='center'><t size='2.2'>VIP Meeting</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The meeting was completed!<br/><br/>Our brothers were defeated, let's hope we're able to recover from this set back...</t>";
_hintEastActive = "<t align='center'><t size='2.2'>VIP Meeting</t><br/><t size='1.5' color='#FF0000'>Attack!</t><br/>____________________<br/>You're being joined by %1 groups of brothers!<br/><br/>Aid them in their righteous jihad!</t>";
_hintEastStartup = "<t align='center'><t size='2.2'>VIP Meeting</t><br/><t size='1.5' color='#00B2EE'>Site Assault</t><br/>____________________<br/>An infidel VIP meeting is meeting with a collaborator.<br/><br/>Get to the meeting and them both.</t>";
if (playerSide == east) then { hint parsetext _hintEastStartup; };


/***************** Select a starting point *****************/
_siteDefenseMarker = _siteDefenseMarkers call BIS_fnc_selectrandom;
_sitePos = getMarkerPos _siteDefenseMarker;

/***************** Create the VIP group *****************/
_created = [];
_vipGrp = [ _sitePos, "BEN_PMC_VIP_SD" ] call BEN_createVIPGroup;
_civs = [ "CAF_AG_ME_CIV_04", "CAF_AG_ME_CIV_03", "CAF_AG_ME_CIV_02", "CAF_AG_ME_CIV" ];
(_civs call BIS_fnc_selectrandom) createUnit [ _sitePos, _vipGrp, "BEN_CIV_VIP_SD = this;" ];
BEN_PMC_VIP_SUV = "C_SUV_01_F" createVehicle _sitePos;
_created = _created + (units _vipGrp) + [ BEN_PMC_VIP_SUV ];

/***************** Place the VIPs randomly *****************/
_rbp = [ nearestBuilding _sitePos ] call BEN_randomBldgPos;
{
  _x setPos _rbp;
  _x playAction "sitdown";
  _x disableai "move";
} forEach [ BEN_PMC_VIP_SD, BEN_CIV_VIP_SD ];
_vipPos = position BEN_PMC_VIP_SD;

/***************** Create the defense waypoint for the VIP group *****************/
_defendWaypoint = _vipGrp addWaypoint [ _vipPos, 0 ];
_defendWaypoint setWaypointCombatMode "RED";
_defendWaypoint setWaypointType "HOLD";

/***************** Update the marker on the map *****************/
[ _siteDefenseMarker, "Secure location", "ColorRed", 1, "mil_dot" ] call BEN_updateMarker;

/***************** Begin waiting for results *****************/
_result = "pending";
_sadStarted = false;
_t = 0;
waitUntil {
  sleep 1;

  /***************** set the proximity trigger *****************/
  if ((player distance _rbp) < 10 && !_sadStarted) then {
    _sadStarted = true;

    /***************** Create the enemy groups *****************/
    _EIGroups = [];
    _EIGroupsCount = floor random _maxEIGroups;
    if (_EIGroupsCount < _minEIGroups) then { _EIGroupsCount = _minEIGroups };
    if (playerSide == resistance) then { hint parsetext format [ _hintPmcActive, _EIGroupsCount ]; };
    if (playerSide == east) then { hint parsetext format [ _hintEastActive, _EIGroupsCount ]; };
    while { count _EIGroups < _EIGroupsCount } do {
      _posEI = [ _sitePos, 1000 ] call BEN_randomPos;
      _grpEI = [ _posEI, EAST, (configfile >> "CfgGroups" >> "EAST" >> "caf_ag_me_t" >> "Infantry" >> "6_men_me_t") ] call BIS_fnc_spawnGroup;
      _sadWaypoint = _grpEI addWaypoint [ _vipPos, 0 ];
      _sadWaypoint setWaypointBehaviour "AWARE";
      _sadWaypoint setWaypointType "SAD";
      _EIGroups = _EIGroups + [ _grpEI ];
      _created = _created + (units _grpEI);
      sleep 1;
    };
  };

  /***************** check for win or fail *****************/
  _deadEIGroups = 0;
  if (_sadStarted) then { _t = _t + 1; };
  if (!alive BEN_PMC_VIP_SD || !alive BEN_CIV_VIP_SD) then { _result = "fail"; };
  if (alive BEN_PMC_VIP_SD && alive BEN_CIV_VIP_SD && _t >= _lengthOfMeeting) then { _result = "win"; };
  { if (({alive _x} count units _x) < 1) then { _deadEIGroups = _deadEIGroups + 1; }; } forEach _EIGroups;
  if (_deadEIGroups == _EIGroupsCount) then { _result = "win"; };

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
[ _siteDefenseMarker ] call BEN_hideMarker;

sleep 10;
{ deleteVehicle _x; } forEach _created;

BEN_CONTRACT_ACTIVE = false;
publicVariable "BEN_CONTRACT_ACTIVE";