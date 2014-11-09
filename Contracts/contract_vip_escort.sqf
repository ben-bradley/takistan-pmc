// This contract is to escort a VIP from one location to another
BEN_CONTRACT_ACTIVE = true;
publicVariable "BEN_CONTRACT_ACTIVE";
sleep 1;
private [
  "_hintPmcSuccess", "_hintPmcFailure", "_hintPmcActive", "_hintPmcStartup",
  "_hintEastSuccess", "_hintEastFailure", "_hintEastActive", "_hintEastStartup",
  "_hintWestSuccess", "_hintWestFailure", "_hintWestActive", "_hintWestStartup",
  "_vipEscortMarkers", "_vipEscortStartMarker", "_vipEscortEndMarker",
  "_vipEscortStartPos", "_vipEscortEndPos", "_vipGrp1", "_vipGrp2", "_created", "_result", "_vipJoined", "_startTimeout", "_endTimeout"
];



/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_vipMarkers = [ "vip_escort_1", "vip_escort_2", "vip_escort_3", "vip_escort_4", "vip_escort_5", "vip_escort_6", "vip_escort_7", "vip_escort_8", "vip_escort_9", "vip_escort_10" ];

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/



/***************** Contract Hints *****************/
_hintPmcSuccess = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job getting that VIP where he needed to be!<br/><br/>We should have another contract come up again soon.</t>";
_hintPmcFailure = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The VIP was killed before we could get him to his destination!<br/><br/>Let's hope that we're able to get another contract soon...</t>";
_hintPmcActive = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>Linked up!</t><br/>____________________<br/>Get that VIP to his destination safely!<br/><br/></t>";
_hintPmcStartup = "<t align='center'><t size='2.2'>New Contract</t><br/><t size='1.5' color='#00B2EE'>VIP Escort</t><br/>____________________<br/>A VIP needs to get to an appointment and needs us to escort him.  Go pick him up and make sure he gets to his destination safely.</t>";
if (playerSide == resistance) then { hint parsetext _hintPmcStartup; };

_hintEastSuccess = "<t align='center'><t size='2.2'>Infidel VIP</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job getting that VIP!<br/><br/>Perhaps they'll think twice before sending another.</t>";
_hintEastFailure = "<t align='center'><t size='2.2'>Infidel VIP</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The VIP got to his destination!<br/><br/>This does not help our cause...</t>";
_hintEastActive = "<t align='center'><t size='2.2'>Infidel VIP</t><br/><t size='1.5' color='#00B2EE'>Infidel VIP moving!</t><br/>____________________<br/>The VIP is moving to his destination!<br/><br/>Now is the time!</t>";
_hintEastStartup = "<t align='center'><t size='2.2'>Infidel VIP</t><br/><t size='1.5' color='#00B2EE'>Infidel VIP</t><br/>____________________<br/>An infidel VIP is in the area to talk with collaborators<br/><br/>We need to find him and kill him.</t>";
if (playerSide == east) then { hint parsetext _hintEastStartup; };

/***************** Select a start & end point *****************/
{ [ _x ] call BEN_hideMarker; } forEach _vipMarkers;
_vipEscortStartMarker = _vipMarkers call BIS_fnc_selectrandom;
_vipEscortEndMarker = _vipMarkers call BIS_fnc_selectrandom;
while { _vipEscortStartMarker == _vipEscortEndMarker } do { _vipEscortEndMarker = _vipMarkers call BIS_fnc_selectrandom; };

/***************** Select a start & end position *****************/
_vipEscortStartPos = getMarkerPos _vipEscortStartMarker;
_vipEscortEndPos = getMarkerPos _vipEscortEndMarker;

/***************** Create the VIP group *****************/
_created = [];
_vipGrp1 = [ _vipEscortStartPos, "BEN_PMC_VIP_VE" ] call BEN_createVIPGroup;
_vipGrp2 = [ _vipEscortEndPos ] call BEN_createBodyguards;
_created = _created + (units _vipGrp1) + (units _vipGrp2);

/***************** Update the map marker *****************/
[ _vipEscortStartMarker, "Escort the VIP", "ColorGreen", 1, "mil_dot" ] call BEN_updateMarker;

/***************** Begin waiting for results *****************/
_result = "pending";
_vipJoined = false;
_startTimeout = 0;
_endTimeout = 0;
waitUntil {
  sleep 1;

  /***************** set the proximity trigger *****************/
  if (player distance BEN_PMC_VIP_VE < 10 && !_vipJoined) then {
    _vipJoined = true;
    if (playerSide == resistance) then { hint parsetext _hintPmcActive; };
    if (playerSide == east) then { hint parsetext _hintEastActive; };
    [ BEN_PMC_VIP_VE ] join player;
    [ _vipEscortStartMarker ] call BEN_hideMaker;
    [ _vipEscortEndMarker, "Deliver VIP", "ColorGreen", 1, "mil_dot" ] call BEN_updateMarker;
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
  if (!alive BEN_PMC_VIP_VE) then { _result = "fail"; };
  if (alive BEN_PMC_VIP_VE && BEN_PMC_VIP_VE distance _vipEscortEndPos < 10) then { _result = "win"; };

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
{ [ _x ] call BEN_hideMarker; } forEach [ _vipEscortStartMarker, _vipEscortEndMarker ];

sleep 10;
{ deleteVehicle _x; } forEach _created;

BEN_CONTRACT_ACTIVE = false;
publicVariable "BEN_CONTRACT_ACTIVE";
