// Simple IED System ------------------------------------------------------------------------ //
waitUntil { time > 5 };

BEN_IEDS_SET = false;
publicVariable "BEN_IEDS_SET";

while {true} do
{
  BEN_IEDS_SET = true;
  publicVariable "BEN_IEDS_SET";

  execVM "IEDs\ieds_set.sqf";

  waitUntil { !BEN_IEDS_SET };
  sleep ((random 120) + 60);
};
// ---------------------------------------------------------------------------------------------- //
