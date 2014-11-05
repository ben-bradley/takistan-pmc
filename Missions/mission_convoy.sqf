/***************** Supply Truck Escort Contract *****************/
BEN_MISSION_ACTIVE = true;
publicVariable "BEN_MISSION_ACTIVE";
sleep 1;
private [
  "_hintEastSuccess", "_hintEastFailure", "_hintEastActive", "_hintEastStartup",
  "_hintWestSuccess", "_hintWestFailure", "_hintWestActive", "_hintWestStartup",
  "_convoyEscortMarkers", "_convoyEscortStartMarker", "_convoyEscortEndMarker",
  "_convoyEscortStartPos", "_convoyEscortEndPos",
  "_created", "_convoyGrp", "_linkedup", "_result", "_expiration"
];



/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_convoyEscortMarkers = [ "nato_convoy_1", "nato_convoy_2", "nato_convoy_3", "nato_convoy_4", "nato_convoy_5", "nato_convoy_6" ]; // list of markers

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/



/***************** Contract Hints *****************/
_hintWestSuccess = "<t align='center'><t size='2.2'>Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job getting those supplies delivered! Now we can get to work!<br/><br/>We should have another mission come up again soon.</t>";
_hintWestFailure = "<t align='center'><t size='2.2'>Mission</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The supplies didn't make it to their destination!<br/><br/>Let's hope that we're able to get another mission soon...</t>";
_hintWestActive = "<t align='center'><t size='2.2'>Mission</t><br/><t size='1.5' color='#00B2EE'>Linked up!</t><br/>____________________<br/>Get that truck moving!<br/><br/></t>";
_hintWestStartup = "<t align='center'><t size='2.2'>New Mission</t><br/><t size='1.5' color='#00B2EE'>Convoy</t><br/>____________________<br/>You've got 30 minutes to deliver supplies to one of our bases.  See that it gets there safely.</t>";
if (playerSide == west) then { hint parsetext _hintWestStartup; };

_hintEastSuccess = "<t align='center'><t size='2.2'>Infidel Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job stopping those supplies!<br/><br/>This should slow down the infidel cause.</t>";
_hintEastFailure = "<t align='center'><t size='2.2'>Infidel Mission</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The supplies made it to their destination!<br/><br/>Let's hope we can stop the next one...</t>";
_hintEastActive = "<t align='center'><t size='2.2'>Infidel Mission</t><br/><t size='1.5' color='#00B2EE'>Linked up!</t><br/>____________________<br/>The truck is moving!<br/><br/>Stop them!</t>";
_hintEastStartup = "<t align='center'><t size='2.2'>Infidel Mission</t><br/><t size='1.5' color='#00B2EE'>Convoy</t><br/>____________________<br/>A cargo truck needs an escort to deliver supplies to one of the NATO bases.  See that it doesn't make it there safely.</t>";
if (playerSide == east) then { hint parsetext _hintEastStartup; };

/***************** Select a start & end point *****************/
{ [ _x ] call BEN_hideMarker; } forEach _convoyEscortMarkers;
_convoyEscortStartMarker = _convoyEscortMarkers call BIS_fnc_selectrandom;
_convoyEscortEndMarker = _convoyEscortMarkers call BIS_fnc_selectrandom;
while { _convoyEscortStartMarker == _convoyEscortEndMarker } do { _convoyEscortEndMarker = _convoyEscortMarkers call BIS_fnc_selectrandom; };

/***************** Select a start & end position *****************/
_convoyEscortStartPos = getMarkerPos _convoyEscortStartMarker;
_convoyEscortEndPos = getMarkerPos _convoyEscortEndMarker;

/***************** Create the truck & driver *****************/
_created = [];
_convoyGrp = createGroup west;
"B_engineer_F" createUnit [ _convoyEscortStartPos, _convoyGrp, "BEN_NATO_TRUCKDRIVER = this;" ];
BEN_NATO_SUPPLYTRUCK = "B_Truck_01_box_F" createVehicle _convoyEscortStartPos;
BEN_NATO_SUPPLYTRUCK setDir markerDir _convoyEscortStartMarker;
_created = _created + [ BEN_NATO_TRUCKDRIVER, BEN_NATO_SUPPLYTRUCK ];

/***************** Update the map marker *****************/
[ _convoyEscortStartMarker, "NATO Convoy SP", "ColorGreen", 1, "mil_dot" ] call BEN_updateMarker;

/***************** Begin waiting for results *****************/
_result = "pending";
_linkedup = false;
_expiration = 0;
waitUntil {
  sleep 1;

  /***************** set the proximity trigger *****************/
  if ((player distance _convoyEscortStartPos) < 10 && !_linkedup) then {
    _linkedup = true;
    if (playerSide == west) then { hint parsetext format [ _hintWestActive ]; };
    if (playerSide == east) then { hint parsetext format [ _hintEastActive ]; };
    [ BEN_NATO_TRUCKDRIVER ] join player;
    [ _convoyEscortStartMarker ] call BEN_hideMarker;
    [ _convoyEscortEndMarker, "NATO Convoy EP", "ColorGreen", 1, "mil_dot" ] call BEN_updateMarker;
  };

  /***************** tick the expiration timer *****************/
  if (!_linkedup) then { _timer = _timer + 1; };

  /***************** check for win or fail *****************/
  if (!alive BEN_NATO_SUPPLYTRUCK) then { _result = "fail"; };
  if (alive BEN_NATO_SUPPLYTRUCK && BEN_NATO_SUPPLYTRUCK distance _convoyEscortEndPos < 10) then { _result = "win"; };
  if (_timer > 1800) then { _result = "fail"; };

  /***************** conditions for ending the wait *****************/
  (_result == "win") OR (_result == "fail")
};

/***************** handle 'fail' *****************/
if (_result == "fail") then {
  if (playerSide == west) then { hint parsetext _hintWestFailure; };
  if (playerSide == east) then { hint parsetext _hintEastSuccess; };
};

/***************** handle 'win' *****************/
if (_result == "win") then {
  if (playerSide == west) then { hint parsetext _hintWestSuccess; };
  if (playerSide == east) then { hint parsetext _hintEastFailure; };
};

/***************** do clean up *****************/
sleep 5;
{ [ _x ] call BEN_hideMarker; } forEach [ _convoyEscortEndMarker, _convoyEscortStartMarker ];

sleep 10;
{ deleteVehicle _x; } forEach _created;

BEN_MISSION_ACTIVE = false;
publicVariable "BEN_MISSION_ACTIVE";
