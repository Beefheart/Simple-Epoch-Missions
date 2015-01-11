
["KS_APD_id", "onPlayerConnected", "SEM_fnc_allowPlayerDamage"] call BIS_fnc_addStackedEventHandler;
diag_log "#EPOCH_allowPlayerDamage: Stacked EventHandler ""onPlayerConnected"" added before server initialization.";

diag_log "#EPOCH_allowPlayerDamage: Waiting for Server to initialize.";
waitUntil{!isNil "epoch_centerMarkerPosition"};

["KS_APD_id", "onPlayerConnected"] call BIS_fnc_removeStackedEventHandler;
diag_log "#EPOCH_allowPlayerDamage: Old stacked EventHandler ""onPlayerConnected"" removed after server initialization.";

["KS_APD_id", "onPlayerConnected", "SEM_fnc_allowPlayerDamage"] call BIS_fnc_addStackedEventHandler;
diag_log "#EPOCH_allowPlayerDamage: New stacked EventHandler ""onPlayerConnected"" added after server initialization.";