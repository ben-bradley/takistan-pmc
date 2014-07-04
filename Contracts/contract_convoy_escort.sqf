/***************** Supply Truck Escort Contract *****************/
BEN_CONTRACT_ACTIVE = true;
publicVariable "BEN_CONTRACT_ACTIVE";
sleep 1;
private [
  "_hintPmcSuccess", "_hintPmcFailure", "_hintPmcActive", "_hintPmcStartup",
  "_hintEastSuccess", "_hintEastFailure", "_hintEastActive", "_hintEastStartup",
  "_hintWestSuccess", "_hintWestFailure", "_hintWestActive", "_hintWestStartup",
  "_convoyEscortMarkers", "_convoyEscortStartMarker", "_convoyEscortEndMarker",
  "_convoyEscortStartPos", "_convoyEscortEndPos",
  "_created", "_convoyGrp", "_linkedup", "_result"
];



/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_convoyEscortMarkers = [ "convoy_escort_1", "convoy_escort_2", "convoy_escort_3", "convoy_escort_4", "convoy_escort_5", "convoy_escort_6" ]; // list of markers

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/



/***************** Contract Hints *****************/
_hintPmcSuccess = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job getting those supplies delivered! Maybe now NATO can get to work!<br/><br/>We should have another contract come up again soon.</t>";
_hintPmcFailure = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The supplies didn't make it to their destination!<br/><br/>Let's hope that we're able to get another contract soon...</t>";
_hintPmcActive = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>Linked up!</t><br/>____________________<br/>Get that truck moving!<br/><br/></t>";
_hintPmcStartup = "<t align='center'><t size='2.2'>New Contract</t><br/><t size='1.5' color='#00B2EE'>Supply Truck Escort</t><br/>____________________<br/>A cargo truck needs an escort to deliver supplies to one of the NATO bases.  See that it gets there safely.</t>";
if (playerSide == resistance) then { hint parsetext _hintPmcStartup; };

_hintEastSuccess = "<t align='center'><t size='2.2'>Infidel Convoy</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job stopping those supplies!<br/><br/>This should slow down the infidel cause.</t>";
_hintEastFailure = "<t align='center'><t size='2.2'>Infidel Convoy</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The supplies made it to their destination!<br/><br/>Let's hope we can stop the next one...</t>";
_hintEastActive = "<t align='center'><t size='2.2'>Infidel Convoy</t><br/><t size='1.5' color='#00B2EE'>Linked up!</t><br/>____________________<br/>The truck is moving!<br/><br/>Stop them!</t>";
_hintEastStartup = "<t align='center'><t size='2.2'>Infidel Convoy</t><br/><t size='1.5' color='#00B2EE'>Supply Truck Escort</t><br/>____________________<br/>A cargo truck needs an escort to deliver supplies to one of the NATO bases.  See that it doesn't make it there safely.</t>";
if (playerSide == east) then { hint parsetext _hintEastStartup; };

/***************** Select a start & end point *****************/
_convoyEscortStartMarker = _convoyEscortMarkers call BIS_fnc_selectrandom;
_convoyEscortEndMarker = _convoyEscortMarkers call BIS_fnc_selectrandom;
while { _convoyEscortStartMarker == _convoyEscortEndMarker } do { _convoyEscortEndMarker = _convoyEscortMarkers call BIS_fnc_selectrandom; };

/***************** Select a start & end position *****************/
_convoyEscortStartPos = getMarkerPos _convoyEscortStartMarker;
_convoyEscortEndPos = getMarkerPos _convoyEscortEndMarker;

/***************** Create the truck & driver *****************/
_created = [];
_convoyGrp = createGroup resistance;
"PMC_Engineer" createUnit [ _convoyEscortStartPos, _convoyGrp, "BEN_PMC_TRUCKDRIVER = this;" ];
BEN_PMC_SUPPLYTRUCK = "C_Van_01_box_F" createVehicle _convoyEscortStartPos;
BEN_PMC_SUPPLYTRUCK setDir markerDir _convoyEscortStartMarker;
_created = _created + [ BEN_PMC_TRUCKDRIVER, BEN_PMC_SUPPLYTRUCK ];

/***************** Update the map marker *****************/
[ _convoyEscortStartMarker, "Link up with supply truck", "ColorGreen", 1, "mil_dot" ] call BEN_updateMarker;

/***************** Begin waiting for results *****************/
_result = "pending";
_linkedup = false;
waitUntil {
  sleep 1;

  /***************** set the proximity trigger *****************/
  if ((player distance _convoyEscortStartPos) < 10 && !_linkedup) then {
    _linkedup = true;
    if (playerSide == resistance) then { hint parsetext format [ _hintPmcActive ]; };
    if (playerSide == east) then { hint parsetext format [ _hintEastActive ]; };
    [ BEN_PMC_TRUCKDRIVER ] join player;
    [ _convoyEscortStartMarker ] call BEN_hideMarker;
    [ _convoyEscortEndMarker, "Drop off supplies", "ColorGreen", 1, "mil_dot" ] call BEN_updateMarker;
  };

  /***************** check for win or fail *****************/
  if (!alive BEN_PMC_SUPPLYTRUCK) then { _result = "fail"; };
  if (alive BEN_PMC_SUPPLYTRUCK && BEN_PMC_SUPPLYTRUCK distance _convoyEscortEndPos < 10) then { _result = "win"; };

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
{ [ _x ] call BEN_hideMarker; } forEach [ _convoyEscortEndMarker, _convoyEscortStartMarker ];

sleep 10;
{ deleteVehicle _x; } forEach _created;

BEN_CONTRACT_ACTIVE = false;
publicVariable "BEN_CONTRACT_ACTIVE";
