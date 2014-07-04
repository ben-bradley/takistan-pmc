BEN_IEDS_SET = true;
publicVariable "BEN_IEDS_SET";
sleep 1;

private [ "_iedMarkers", "_iedObjects", "_probability", "_t", "_created", "_place", "_ied", "_pos", "_obj", "_boom", "_expirationTimer", "_nearVehicles", "_disarmAction", "_actionAdded" ];

/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/
/***************** Start configurable variables *****************/

_iedMarkers = [ "ied_1", "ied_2", "ied_3", "ied_4", "ied_5", "ied_6", "ied_7", "ied_8", "ied_9", "ied_10", "ied_11", "ied_12", "ied_13", "ied_14", "ied_15", "ied_16", "ied_17", "ied_18", "ied_19", "ied_20" ];
_iedObjects = [ "RoadCone_F", "Land_Pallets_F", "Land_WheelCart_F", "Land_Tyre_F", "Land_Bucket_F", "Land_GarbageWashingMachine_F", "Land_Bucket_painted_F", "Land_CanisterPlastic_F", "Land_JunkPile_F" ];
_probability = 1; // 1 in _probability chance of having an IED on each _iedMarkers
_expirationTimer = 300 + (random 300);

/***************** End configurable variables *****************/
/***************** End configurable variables *****************/
/***************** End configurable variables *****************/

_created = [];
_actionAdded = false;
_t = 0;

waitUntil {
  sleep 1;
  _t = _t + 1;
  
  /*** PLACE THE IEDS ***/
  if (count _created < 1) then {
    {
      _place = floor random _probability;
      if (_place == 0) then {
        _pos = getMarkerPos _x;
        _obj = _iedObjects call BIS_fnc_selectrandom;
        _ied = createVehicle [ _obj, _pos, [], 0, "CAN_COLLIDE" ];
        _ied addAction [ "Disarm IED", "IEDs\disarm_ied.sqf", _x, 0, true, true, "", "(_this distance _target) < 2" ];
        _created = _created + [ _ied ];
      };
    } forEach _iedMarkers;
  };
  
  /*** WAIT FOR AN IED TO GET TRIGGERED ***/
  {
    _pos = position _x;
    _nearVehicles = nearestObjects [ _pos, [ "Car", "Tank" ], 10 ];
    if (count _nearVehicles > 0) then {
      deleteVehicle _x;
      _boom = "M_Mo_82mm_AT_LG" createVehicle _pos;
      _created = _created - [ _x ];
    };
  } forEach _created;
  
  (_t == _expirationTimer)
};

/*** Timer expired, reset the IEDs ***/
{ deleteVehicle _x; } forEach _created;

sleep 5;

BEN_IEDS_SET = false;
publicVariable "BEN_IEDS_SET";
