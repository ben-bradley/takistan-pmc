BEN_IEDS_SET = true;
publicVariable "BEN_IEDS_SET";
sleep 1;

private [
  "_iedObjects", "_probability", "_t",
  "_created", "_place", "_ied", "_pos", "_boom", "_ieds",
  "_expirationTimer", "_nearVehicles", "_disarmAction", "_actionAdded",
  "_townPos", "_roads", "_probabilityVBIED"
];

/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_iedObjects = [
  "IEDUrbanSmall_F", "IEDLandSmall_F", "IEDUrbanBig_F", "IEDLandBig_F"
];
_probability = 3; // 1 in _probability chance of having an IED in a _town
_probabilityVBIED = 4; // 1 in _probabilityVBIED of _probability chance of a VBIED
_expirationTimer = 300 + (random 300);

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/

_created = [];
_ieds = [];
_actionAdded = false;
_t = 0;

/*** PLACE THE IEDS ***/
{
  [ _x ] call BEN_hideMarker;
  _place = floor random _probability;
  if (_place == 0) then {
    _townPos = getMarkerPos _x;
    _roads = _townPos nearRoads 200;
    _pos = position (_roads call BIS_fnc_selectRandom);
    while { isOnRoad _pos } do {
      _pos = [ _pos, 2 ] call BEN_randomPos;
    };
    if (floor random _probabilityVBIED == 0) then {
      _ied = createVehicle [ "C_Van_01_fuel_F", _pos, [], 0, "CAN_COLLIDE" ];
    } else {
      _ied = createMine [ (_iedObjects call BIS_fnc_selectrandom), _pos, [], 0 ];
    };
    _ied addAction [ "Disarm IED", "IEDs\disarm_ied.sqf", _x, 0, true, true, "", "(_this distance _target) < 2" ];
    _created = _created + [ _ied ];
    _ieds = _ieds + [ _ied ];
  };
} forEach BEN_towns;

waitUntil {
  sleep 1;
  _t = _t + 1;

  /*** WAIT FOR AN IED TO GET TRIGGERED ***/
  {
    _pos = position _x;
    _nearVehicles = nearestObjects [ _pos, [ "Car", "Tank" ], 10 ];
    {
      if (typeOf _x == "C_Van_01_fuel_F") then {
        _nearVehicles = _nearVehicles - [ _x ];
      };
    } forEach _nearVehicles;
    if (count _nearVehicles > 0) then {
      _boom = "M_Mo_82mm_AT_LG" createVehicle _pos;
      if (typeOf _x == "C_Van_01_fuel_F") then {
        _x setDamage 1; // detonate the fuel truck;
      } else {
        deleteVehicle _x; // remove the object
        _created = _created - [ _x ];
      };
      _ieds = _ieds - [ _x ];
    };
  } forEach _ieds;

  (_t == _expirationTimer)
};

/*** Timer expired, reset the IEDs ***/
{ deleteVehicle _x; } forEach _created;

sleep 5;

BEN_IEDS_SET = false;
publicVariable "BEN_IEDS_SET";

//  "RoadCone_F", "Land_Pallets_F", "Land_WheelCart_F",
//  "Land_Tyre_F", "Land_Bucket_F", "Land_GarbageWashingMachine_F",
//  "Land_Bucket_painted_F", "Land_CanisterPlastic_F", "Land_JunkPile_F"
