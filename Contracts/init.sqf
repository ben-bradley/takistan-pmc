// Contracts System ------------------------------------------------------------------------ //
private [ "_contracts", "_contractMarkers" ];
_contractMarkers = [
  "vip_return_1", "vip_return_2", "vip_return_3",
  "vip_escort_1", "vip_escort_2", "vip_escort_3", "vip_escort_4", "vip_escort_5", "vip_escort_6", "vip_escort_7", "vip_escort_8", "vip_escort_9", "vip_escort_10",
  "convoy_escort_1", "convoy_escort_2", "convoy_escort_3", "convoy_escort_4", "convoy_escort_5", "convoy_escort_6"
];
{ [ _x ] call BEN_hideMarker; } forEach _contractMarkers;

waitUntil { time > 5 };

BEN_CONTRACT_ACTIVE = false;
publicVariable "BEN_CONTRACT_ACTIVE";

_contracts = [
  "Contracts\contract_vip_escort.sqf",
  "Contracts\contract_vip_recovery.sqf",
  "Contracts\contract_convoy_escort.sqf",
  "Contracts\contract_site_defense.sqf"
  // the terrorist kill missions are a bit too buggy at the moment
//  "Contracts\contract_terrorist_kill.sqf",
];

while {true} do
{
  BEN_CONTRACT_ACTIVE = true;
  publicVariable "BEN_CONTRACT_ACTIVE";

  execVM (_contracts call BIS_fnc_selectrandom);

  waitUntil { !BEN_CONTRACT_ACTIVE };
  sleep ((random 120) + 60);
};
// ---------------------------------------------------------------------------------------------- //
