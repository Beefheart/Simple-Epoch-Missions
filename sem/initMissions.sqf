private["_debug","_minimumPlayers","_minMissionTime","_maxMissionTime","_missionCleanup","_missionsPath","_missions","_worldCenterPos","_playerOnline","_start","_wait","_missionPos","_lastPositions","_randomMission","_lastMission","_runningMission"];
/*
	Update 07.01.2015
	By KiloSwiss
*/

_minimumPlayers = 1;	// Minimum number of online players for missions to spawn
_minMissionTime = 20;	// Minimum minutes between missions
_maxMissionTime = 35;	// Maximum minutes between missions
_missionCleanup = -1;	// Minutes after a mission finished where all mission objects (including AI) will be deleted (0 or -1 equals never).

// Chance of AI dropping their guns and keeping their gear (vests, backpacks and magazines) when killed.
SEM_AIdropGearChance = 40;	//	Values: 0-100%	Where 0 means all gear gets removed from dead AI units.

// Weapons that should be removed from killed AI
SEM_removeWeaponsFromDeadAI = [];

// Magazines that should be removed from killed AI
SEM_removeMagazinesFromDeadAI = [];


_missions = [
	["supplyVanCrash",	"Supply Van",		45,	100],
	["bPlaneCrash",		"Plane Crashsite",	45,	90],
	["bHeliCrash",		"Heli Crashsite",	45,	85],
	["bCamp",			"Bandit Camp",		90,	80],
	["bDevice",			"Strange Device",	45,	75],
	
	["file name",		"marker name",		-1,	-1]	//NO COMMA AT THE LAST LINE!
/*	 1.					2.					3.	4.

	1. "file name"  	MUST be equal to the sqf file name!
	2. "marker name" 	Name of the marker that is shown to all players.
	3. time out,		(Number) Minutes until running missions time out (0 or -1 equals no mission timeout).
	4. probability		(Number) Percentage of probability how often a mission will spawn: 1 - 100 (0 and -1 equals OFF).
*/];


//	DO NOT EDIT BELOW THIS LINE!
//##############################################
_debug = false;
/*	Debug settings:
	- Missions time out after 10min
	- Minimum players is set to 0
	- Time between missions is 60sec
	- Mission clean up happens after 2min
	- More events and additional data is logged
*/
_minimumPlayers = _minimumPlayers max 1;
_minMissionTime = _minMissionTime max 1;
_maxMissionTime = _maxMissionTime max 1;
_missionCleanup = _missionCleanup max -1;
if(_minMissionTime > _maxMissionTime)then{
	private "_tempValueholder";
	_tempValueholder = _maxMissionTime;
	_maxMissionTime = _minMissionTime;
	_minMissionTime = _tempValueholder;
};

for "_i" from 0 to (count _missions -1) step 1 do{	// Remove inactive missions
	if((_missions select _i) select 3 < 1)then[{_missions set [_i, "delete"]},
	{(_missions select _i) set [3, 1 max ((_missions select _i) select 3) min 10]}];
};	_missions = _missions - ["delete"];

{if !(_x in SEM_removeWeaponsFromDeadAI)then{SEM_removeWeaponsFromDeadAI pushBack _x}}forEach ["launch_RPG32_F","Srifle_GM6_F","Srifle_LRR_F","m107_EPOCH","m107Tan_EPOCH"];
{if !(_x in SEM_removeMagazinesFromDeadAI)then{SEM_removeMagazinesFromDeadAI pushBack _x}}forEach ["RPG32_F","RPG32_HE_F","5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","7Rnd_408_Mag"];
SEM_AIdropGearChance = 0 max SEM_AIdropGearChance min 100;
publicVariable "SEM_AIdropGearChance";
publicVariable "SEM_removeWeaponsFromDeadAI";
publicVariable "SEM_removeMagazinesFromDeadAI";

_worldData = [] call SEM_fnc_getWorldData;
_worldRadius = _worldData select 0;
_worldCenterPos = _worldData select 1;
if(_debug)then{diag_log format["#SEM DEBUG: World Data (%1 %2) received, waiting for missions to start", str worldName ,[_worldRadius*2,_worldCenterPos]]};

if(_debug)then[{{_x set [2,10]}count _missions; _minimumPlayers = 0; _missionCleanup = 2;},{UIsleep 120}];
_missionsPath = "sem\missions\";
_lastPositions = [];
_lastMission = "";

while{true}do{
	_playerOnline = playersNumber civilian;
	if(_debug)then{diag_log format["#SEM DEBUG: Online players: %1", playersNumber civilian]};
	if(_playerOnline < _minimumPlayers)then{
	diag_log format ["#SEM: Waiting for players (%1/%2)", _playerOnline, _minimumPlayers];
		waitUntil{	sleep 3; 
			if(playersNumber civilian != _playerOnline)then{	_playerOnline = playersNumber civilian;
				diag_log format ["#SEM: Waiting for players (%1/%2)", _playerOnline, _minimumPlayers];
			};
		(_playerOnline >= _minimumPlayers)
		};
	diag_log format["#SEM: Online players: (%1/%2) - Starting next Mission", _playerOnline, _minimumPlayers];
	};

	_start = time;
	if(_debug)then[{sleep 30},{_wait = (_minMissionTime*60) max random(_maxMissionTime*60); waitUntil{sleep 1; (time - _start) >= _wait}}];

	_missionPos = [_lastPositions,_worldData] call SEM_fnc_findMissionPos;
	_lastPositions pushBack _missionPos;
	if(count _lastPositions > 5)then{_lastPositions deleteAt 0};
	if(_debug)then{diag_log format["#SEM DEBUG: previous mission pos: %1 %2",count _lastPositions, _lastPositions]};

	_randomMission = [_missions, _lastMission] call SEM_fnc_selectMission;
	_lastMission = _randomMission select 0;
	_runningMission = [_missionPos, _randomMission select 2, _missionCleanup] execVM format["%1%2.sqf", _missionsPath, _randomMission select 0];
	diag_log format["#SEM: Running Mission %1 at Position %2", str (_randomMission select 1), _missionPos];

	SEM_globalMissionMarker = [true,_missionPos,_randomMission select 1];
	publicVariable "SEM_globalMissionMarker";	// Let clients create a Marker
	/*localhost*/if(!isDedicated)then{SEM_globalMissionMarker call SEM_fnc_createMissionMarker};

	waitUntil{sleep 1; scriptDone _runningMission};
	diag_log format["#SEM: Mission %1 finished", str (_randomMission select 1)];

	sleep 30; //Time until marker is deleted after mission ending
	SEM_globalMissionMarker = [false]; 	// Let clients delete the Marker
	publicVariable "SEM_globalMissionMarker";
	/*localhost*/if(!isDedicated)then{SEM_globalMissionMarker call SEM_fnc_createMissionMarker};
};