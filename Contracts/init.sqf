// Contracts System ------------------------------------------------------------------------ //
call compile preprocessFile "Contracts\BEN_fns.sqf";
waitUntil { time > 5 };

BEN_CONTRACT_ACTIVE = false;
publicVariable "BEN_CONTRACT_ACTIVE";

_contracts = [
  "Contracts\contract_vip_escort.sqf",
  "Contracts\contract_vip_recovery.sqf",
  "Contracts\contract_convoy_escort.sqf",
  "Contracts\contract_terrorist_kill.sqf",
  "Contracts\contract_site_defense.sqf"
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
