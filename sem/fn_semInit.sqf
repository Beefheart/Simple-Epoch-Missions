/*
	Update 09.02.2015
	By KiloSwiss
*/
diag_log "#SEM INIT: Initialize Simple Epoch Missions";

private ["_handle","_end"];
_handle = execVM "@EpochHive\addons\SEM_config.sqf";
if(isNil "_handle")then{	//Config not found
	diag_log format["Ignoring %1 message, config file will be loaded from parent folder", "Warning Message: Script @EpochHive\addons\SEM_config.sqf not found"];
	_handle = execVM "@EpochHive\SEM_config.sqf";
	if(isNil "_handle")then{	//Config not found
		diag_log format["Ignoring %1 message, default config file will be loaded from addon pbo", "Warning Message: Script @EpochHive\SEM_config.sqf not found"];
		_handle = scriptNull;
		SEM_config_loaded = false;
	};
};
_end = time + 3;
waitUntil{isNull _handle || time > _end};
if(!SEM_config_loaded)then{
	_handle = execVM "sem\sem_config.sqf";
	waitUntil{isNull _handle};
	diag_log "#SEM: No external config file found or file is corrupt. Loaded default settings.";
};

if((typeName SEM_debug) isEqualTo "SCALAR")then{
	SEM_debug = (switch(round SEM_debug)do{
					case 0:{"off"};
					case 1:{"log"};
					case 2:{"full"};
					default{"log"};
				});
};
if !(SEM_debug in ["off","log","full"])then{SEM_debug = "log"};

if(SEM_debug in ["log","full"])then{
	SEM_version = getText(configFile >> "CfgPatches" >> "sem" >> "SEM_version");
	diag_log format ["#SEM Version %1 is running on %2 %3 version %4 [%5] %6 branch.",
	SEM_version,
	(productVersion select 1),
	str(if(isDedicated)then[{"dedicated server"},{if(hasInterface)then[{if(isServer)then[{"localhost"},{"client"}]},{"headless client"}]}]),
	str(floor((productVersion select 2)/100)) + "." + str((productVersion select 2)-((floor((productVersion select 2)/100))*100)),
	str(productVersion select 3),
	(productVersion select 4)];
};

	/* Set up variables */

SEM_MinPlayerStatic = (if(isMultiPlayer)then[{1 max SEM_MinPlayerStatic},{0}]);
SEM_MinPlayerDynamic = (if(isMultiPlayer)then[{1 max SEM_MinPlayerDynamic},{0}]);
SEM_MissionTimerMin = 1 max SEM_MissionTimerMin;
SEM_MissionTimerMax = 1 max SEM_MissionTimerMax;
SEM_MissionCleanup = -1 max SEM_MissionCleanup;
if(SEM_MissionTimerMin > SEM_MissionTimerMax)then{
	private "_tempValueHolder";
	_tempValueHolder = SEM_MissionTimerMax;
	SEM_MissionTimerMax = SEM_MissionTimerMin;
	SEM_MissionTimerMin = _tempValueHolder;
};

SEM_Krypto_AIroadkill = 1 max (abs SEM_Krypto_AIroadkill);

{if !(_x in SEM_removeWeaponsFromDeadAI)then{SEM_removeWeaponsFromDeadAI pushBack _x}}forEach ["launch_RPG32_F","Srifle_GM6_F","Srifle_LRR_F","m107_EPOCH","m107Tan_EPOCH"];
{if !(_x in SEM_removeMagazinesFromDeadAI)then{SEM_removeMagazinesFromDeadAI pushBack _x}}forEach ["RPG32_F","RPG32_HE_F","5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","7Rnd_408_Mag"];
SEM_AIdropGearChance = 0 max SEM_AIdropGearChance min 100;
SEM_AIsniperDamageDistance = 300 max SEM_AIsniperDamageDistance min 1000;
SEM_AIsniperDamageEHunits = [];

if(SEM_debug isEqualTo "full")then{ /* Load debug settings */
	SEM_MinPlayerStatic = 0; SEM_MinPlayerDynamic = 0; SEM_MissionCleanup = 2;
	SEM_AIdisableSniperDamage = true; SEM_AIsniperDamageDistance = 100;
	[] spawn {
		SEM_version = SEM_version + " - DEBUG IS ON!";
		while{true}do{publicVariable "SEM_version"; UIsleep 180};
	};
}else{publicVariable "SEM_version"; UIsleep 30};

SEM_worldData = call SEM_fnc_getWorldData;
if(SEM_debug in ["log","full"])then{diag_log format["#SEM DEBUG: World Data received. Counting %1 locations on island %2", count (SEM_worldData select 2), str worldName]};

publicVariable "SEM_AIsniperDamageDistance";
SEM_lastMissionPositions = [];
SEM_MissionID = 0;

if(hasInterface && isServer)then{waitUntil{isPlayer player}};

[
	[SEM_staticMissions, SEM_staticMissionsPath ,"static"]//,
	//[SEM_dynamicMissions, SEM_dynamicMissionsPath ,"dynamic"]
] call SEM_fnc_missionController;