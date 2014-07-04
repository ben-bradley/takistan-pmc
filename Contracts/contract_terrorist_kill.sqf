/***************** Site Defense Contract *****************/
BEN_CONTRACT_ACTIVE = true;
publicVariable "BEN_CONTRACT_ACTIVE";
sleep 1;
private [
  "_hintPmcSuccess", "_hintPmcFailure", "_hintPmcActive", "_hintPmcStartup",
  "_hintEastSuccess", "_hintEastFailure", "_hintEastActive", "_hintEastStartup",
  "_hintWestSuccess", "_hintWestFailure", "_hintWestActive", "_hintWestStartup",
  "_terroristKillMarkers", "_markerSet", "_sp", "_ep", "_spPos", "_epPos", "_terroristGrp", "_created"
];



/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_terroristKillMarkers = [
  [ "ctk1_1", "ctk1_2" ],
  [ "ctk2_1", "ctk2_2" ],
  [ "ctk3_1", "ctk3_2" ],
  [ "ctk4_1", "ctk4_2" ],
  [ "ctk5_1", "ctk5_2" ],
  [ "ctk6_1", "ctk6_2" ],
  [ "ctk7_1", "ctk7_2" ],
  [ "ctk8_1", "ctk8_2" ],
  [ "ctk9_1", "ctk9_2" ],
  [ "ctk10_1", "ctk10_2" ]
];

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/



/***************** PMC  Hints *****************/
_hintPmcSuccess = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job! Not only does this make Takistan safer, it also brings in a hefty bounty.<br/><br/>We should have another contract come up again soon.</t>";
_hintPmcFailure = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The terrorists arrived safely.<br/><br/>We just missed a lucrative opportunity...</t>";
_hintPmcActive = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#FF0000'>Target moving!</t><br/>____________________<br/>The cell is on the road between the villages marked on the map.<br/><br/>Track them down before they reach safety!</t>";
_hintPmcStartup = "<t align='center'><t size='2.2'>Contract</t><br/><t size='1.5' color='#00B2EE'>Bounty!</t><br/>____________________<br/>A terrorist cell with a large bounty is going to be on the road soon.<br/><br/>Kill them before they make it to their destination.</t>";
if (playerSide == resistance) then { hint parsetext _hintPmcStartup; };

/***************** EAST  Hints *****************/
_hintEastSuccess = "<t align='center'><t size='2.2'>Relocation</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Good job! The cell reached the safehouse.<br/><br/>They should be able to continue fighting the infidels.</t>";
_hintEastFailure = "<t align='center'><t size='2.2'>Relocation</t><br/><t size='1.5' color='#FF0000'>FAILURE</t><br/>____________________<br/>The infidels murdered our brothers!<br/><br/>They shall be avenged...</t>";
_hintEastActive = "<t align='center'><t size='2.2'>Relocation</t><br/><t size='1.5' color='#FF0000'>Cell moving!</t><br/>____________________<br/>The cell is on the road between the villages marked on the map.<br/><br/>Make sure they reach safety!</t>";
_hintEastStartup = "<t align='center'><t size='2.2'>Relocation</t><br/><t size='1.5' color='#00B2EE'>They're closing in!</t><br/>____________________<br/>The infidels are closing in on us and we need to relocate.<br/><br/>Make sure they get to their destination.</t>";
if (playerSide == east) then { hint parsetext _hintEastStartup; };

/***************** Select a start & end point *****************/
_markerSet = _terroristKillMarkers call BIS_fnc_selectrandom;
_sp = _markerSet call BIS_fnc_selectrandom;
_ep = _markerSet call BIS_fnc_selectrandom;
while { _sp == _ep } do { _ep = _markerSet call BIS_fnc_selectrandom; };

_spPos = getMarkerPos _sp;
_epPos = getMarkerPos _ep;

_spLoc = nearestLocation [ _spPos, "nameCity" ];
_epLoc = nearestLocation [ _epPos, "nameCity" ];

[ _sp, "Start point", "ColorRed", 1, "mil_dot" ] call BEN_updateMarker;
[ _ep, "End point", "ColorRed", 1, "mil_dot" ] call BEN_updateMarker;

/***************** Create the terrorist group and get them moving *****************/
_created = [];
BEN_TERRORIST_TRUCK = "CAF_AG_ME_T_Offroad" createVehicle _spPos;
BEN_TERRORIST_TRUCK setDir markerDir _sp;
_terroristGrp = [ _spPos, EAST, (configfile >> "CfgGroups" >> "EAST" >> "caf_ag_me_t" >> "Infantry" >> "4_men_me_t") ] call BIS_fnc_spawnGroup;
"CAF_AG_EEUR_R_AK47" createUnit [ _spPos, _terroristGrp, "BEN_TERRORIST_VIP = this;" ];
(units _terroristGrp select 0) moveInDriver BEN_TERRORIST_TRUCK; // put a regular in the driver seat
(units _terroristGrp select 4) moveInCargo BEN_TERRORIST_TRUCK; // put the VIP in the passenger seat
{ _x moveInCargo BEN_TERRORIST_TRUCK; } forEach units _terroristGrp; // put the rest in the back
_created = _created + (units _terroristGrp) + [ BEN_TERRORIST_TRUCK ];

/***************** Give the hint *****************/
sleep (random 30) + 60;
if (playerSide == resistance) then { hint parsetext format [ _hintPmcActive, _spPos, _epPos ]; };
if (playerSide == east) then { hint parsetext format [ _hintEastActive, _spPos, _epPos ]; };
_terroristGrp move _epPos;

/***************** Begin waiting for results *****************/
_result = "pending";
waitUntil {
  sleep 1;
  
  /***************** check for win or fail *****************/
  if (({alive _x} count units _terroristGrp) < 1) then { _result = "win"; };
  { if ((_x distance _epPos) < 10) then { _result = "fail"; }; } forEach units _terroristGrp;
  
  /***************** conditions for ending the wait *****************/
  (_result == "win") OR (_result == "fail")
};

/***************** handle 'fail' *****************/
if (_result == "fail") then {
  hint format [ "fail: %1", playerSide ];
  if (playerSide == resistance) then { hint parsetext _hintPmcFailure; };
  if (playerSide == east) then { hint parsetext _hintEastSuccess; };
};

/***************** handle 'win' *****************/
if (_result == "win") then {
  hint format [ "win: %1", playerSide ];
  if (playerSide == resistance) then { hint parsetext _hintPmcSuccess; };
  if (playerSide == east) then { hint parsetext _hintEastFailure; };
};

/***************** do clean up *****************/
sleep 5;
[ _sp ] call BEN_hideMarker;
[ _ep ] call BEN_hideMarker;

sleep 10;
{ deleteVehicle _x; } forEach _created;

BEN_CONTRACT_ACTIVE = false;
publicVariable "BEN_CONTRACT_ACTIVE";