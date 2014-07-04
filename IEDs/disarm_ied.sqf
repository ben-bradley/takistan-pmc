private [ "_ied", "_per", "_act", "_d20", "_pos", "_boom", "_eod" ];

_ied = _this select 0;
_per = _this select 1;
_act = _this select 2;

_eod = [ "B_engineer_F", "B_soldier_exp_F", "B_soldier_repair_F", "PMC_Engineer" ];

_per removeAction _act;
_per playAction "medicstart";

sleep 5;

_d20 = floor random 20;

// if the player is in the EOD list, they get a +5
if ((typeOf _per) in _eod) then { _d20 = _d20 + 5; };

// if the player has a toolkit, they get a +3
if ("ToolKit" in backpackItems _per) then { _d20 = _d20 + 3; };

if (_d20 < 10) then { // failure, boom
  _pos = position _ied;
  deleteVehicle _ied;
  if (_d20 == 0) then { // critical failure, big boom
    _boom = "M_Mo_120mm_AT_LG" createVehicle _pos;
  } else { // regular failure, regular boom
    _boom = "M_Mo_82mm_AT_LG" createVehicle _pos;
  };
} else { // win, disarm the IED
  _per playAction "medicstop";
  deleteVehicle _ied;
};
