{ call compile preprocessFile _x; } forEach [
  "vehicle_maintenance\x_reload.sqf"
];

{ [ player ] execVM _x; } forEach [
  "AidStation\init.sqf",
  "Contracts\init.sqf",
  "Missions\init.sqf",
  "Roadblocks\init.sqf",
  "IEDs\init.sqf",
  "Lights\init.sqf"
];
