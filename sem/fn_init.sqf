diag_log "#SEM: Start Simple Epoch Missions";
execVM "sem\initMissions.sqf";

diag_log "#EPOCH_allowPlayerDamage: Waiting for Server to initialize.";
waitUntil{!isNil "epoch_centerMarkerPosition"};
["KS_Random_id", "onPlayerConnected", "KS_fnc_allowPlayerDamage"] call BIS_fnc_addStackedEventHandler;
diag_log "#EPOCH_allowPlayerDamage: Stacked EventHandler ""onPlayerConnected"" added.";
{_x allowDamage true}count playableUnits;	/* failsafe */
