private ["_caller"];
_caller = _this select 1;

_caller removeAction GRPMNU_groupActions;

GRPMNU_addToGroup = _caller addAction["<t color='#EB7FAF'>Add to Group</t>", "groupsMenu\addToGroup.sqf", nil, -200, false, false, "", "(cursorTarget distance _this) < 4 && side cursorTarget == side _this"];
GRPMNU_removeFromGroup = _caller addAction["<t color='#EB7FAF'>Remove from Group</t>", "groupsMenu\removeFromGroup.sqf", nil, -200, false, false, "", "(cursorTarget distance _this) < 4 && side cursorTarget == side _this"];
GRPMNU_joinGroup = _caller addAction["<t color='#EB7FAF'>Join Group</t>", "groupsMenu\joinGroup.sqf", nil, -200, false, false, "", "(cursorTarget distance _this) < 4 && (count units group _this) == 1 && side cursorTarget == side _this"];
GRPMNU_leaveGroup = _caller addAction["<t color='#EB7FAF'>Leave Group</t>", "groupsMenu\leaveGroup.sqf", nil, -200, false, false, "", "(count units group _this) > 1"];
GRPMNU_makeLead = _caller addAction["<t color='#EB7FAF'>Become Group Lead</t>", "groupsMenu\leadGroup.sqf", nil, -200, false, false, "", "(count units group _this) > 1 && leader group _this != _this"];
GRPMNU_quitLead = _caller addAction["<t color='#EB7FAF'>Step Down as Group Lead</t>", "groupsMenu\quitLead.sqf", nil, -200, false, false, "", "(count units group _this) > 1 && leader group _this == _this"];
GRPMNU_exitGroup = _caller addAction["<t color='#EB7FAF'>Exit Groups Menu</t>", "groupsMenu\exitGroup.sqf", nil, -201, false, false, "", "_target == vehicle _this || _target == _this"];

if true exitWith {};
