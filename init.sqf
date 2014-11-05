{ call compile preprocessFile _x; } forEach [
  "vehicle_maintenance\x_reload.sqf",
  "BEN_fns\BEN_fns.sqf"
];

{ [ _x ] call BEN_hideMarker; } forEach BEN_towns;

{ [ player ] execVM _x; } forEach [
  "GroupsMenu\initGroups.sqf",
//  "AidStation\init.sqf",
  "Contracts\init.sqf",
//  "Missions\init.sqf",
  "Roadblocks\init.sqf",
  "IEDs\init.sqf"
];
