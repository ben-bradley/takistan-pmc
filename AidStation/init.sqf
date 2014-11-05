private [ "_bldgClass", "_medicClass", "_pos", "_grp", "_medic", "_medicPos", "_aidMarker" ];

// assign values to these to suit your mission
_bldgClass = "Land_Medevac_house_V1_F";
_medicClass = "PMC_Medic";
_aidMarker = "aidStation";

// Edit below here at your own risk /////////////////////
_pos = getMarkerPos _aidMarker;
_grp = createGroup resistance;

aidStation = _bldgClass createVehicle _pos;
aidStation setDir (markerDir _aidMarker);

_medicPos = [ (_pos select 0), (_pos select 1), 0.75 ];
_medicClass createUnit [ _medicPos, _grp, "_medic = this;" ];
_medic disableAI "move";
removeAllWeapons _medic;

while {true} do {
  sleep 1;
  if (((_medic distance player) < 2) && ((damage player) > 0)) then {
    disableUserInput true;
    player setPos ([ (_medicPos select 0) - 0.35, (_medicPos select 1) + 0.25, _medicPos select 2]);
    player setDir 90;
    waitUntil {
      player playAction "agonyStart";
      _medic playAction "medicStart";
      player setDamage ((damage player) - 0.05);
      player groupChat "healing...";
      sleep 2;
      (!alive player) OR (damage player == 0)
    };
    player groupChat "You're all patched up!";
    sleep 1;
    _medic playAction "medicStop";
    player playAction "agonyStop";
    disableUserInput false;
  };

};
