
if(isDedicated)exitWith{}; //Everything below this line is only executed on the client (player or local host)

//Wait until these variables are broadcasted to the client (usually happens before the init gets executed)
waitUntil{!isNil {SEM_AIdropGearChance}};
waitUntil{!isNil {SEM_removeWeaponsFromDeadAI}};
waitUntil{!isNil {SEM_removeMagazinesFromDeadAI}};
//diag_log format["#SEM DEBUG: variables received: Weapons %1 - Magazines %2", SEM_removeWeaponsFromDeadAI, SEM_removeMagazinesFromDeadAI];

SEM_client_createMissionMarker = {	private["_create","_markerPos","_markerName","_marker"];
	_create = _this select 0;
	
	if(!_create)then[{	//delete marker
		if (getMarkerColor "MissionMarker" != "")then{	//Only delete existing Marker
			deleteMarkerLocal "MissionMarker";
		}; 
	},{	//else create marker
	_markerPos = _this select 1;
	_markerName = _this select 2;
	
	_marker = createMarkerLocal ["MissionMarker", _markerPos];
	_marker setMarkerPosLocal _markerPos;
	_marker setMarkerTypeLocal "hd_destroy";  
	_marker setMarkerTextLocal format["%1",_markerName];  
	_marker setMarkerColorLocal "ColorRed";
	_marker setMarkerDirLocal -37;
	_marker setMarkerSizeLocal [0.8,0.8];
	}];
};

SEM_client_removeGear = {
	removeVest _this;
	//removeHeadgear _this;
	removeGoggles _this;
	removeAllItems _this;
	removeAllWeapons _this;
	removeBackpackGlobal _this;
	{_this removeMagazine _x}count magazines _this;
};

SEM_client_AIfiredEH = {
	if(isPlayer _this || !local _this)exitWith{systemChat "NEIN!"};
	
	call compile format["
		_this addEventHandler ['Fired',{
			if(_this select 2 in %1)then{
				_this select 0 addMagazines [_this select 5, 1];
			};
		}];
	", ["launch_RPG32_F","launch_NLAW_F","launch_Titan_short_F","launch_Titan_F"]];
};
	
SEM_client_AIaddKilledEH = {
	if(isPlayer _this || !local _this)exitWith{systemChat "NEIN!"};
	
	/* Remove Weapons when killed */
	call compile format["
		_this addEventHandler ['Killed',{ private ['_unit','_z','_ran'];
			_unit = _this select 0;
			{_unit removeWeaponGlobal _x}count (%1 + ['EpochRadio0','ItemMap','ItemRadio','ItemWatch','ItemCompass','ItemGPS']);
			{if(_x in (magazines _unit))then{_unit removeMagazines _x}}count %2;
			
			if(SEM_AIdropGearChance < ceil(random 100))then{
				_unit call SEM_client_removeGear;
				{deleteVehicle _x}forEach nearestObjects [(getPosATL _unit), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 1];
			};
			
			_unit spawn{
				sleep .1;
				{_z = _x;
				if(_x in (getweaponcargo _z))exitWith{deleteVehicle _z}count %1;
				if(_x in (getmagazinecargo _z))exitWith{deleteVehicle _z}count %2;
				}forEach nearestObjects [(getPos _this), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 12];
			};
		}];
	", SEM_removeWeaponsFromDeadAI, SEM_removeMagazinesFromDeadAI];
	
	/* AI run over by vehicle */
	_this addEventHandler ["killed", { private["_u","_k","_vk","_s"];
		_u = _this select 0;
		_k = _this select 1;
		_vk = vehicle _k;
		
		if(_vk isKindOf "Car")then{
		if(abs speed _vk > 0)then{
		if(_vk distance _u < 10)then{
		if(isEngineOn _vk || !isNull (driver _vk))then{
			_u call SEM_client_removeGear;
			{deleteVehicle _x}forEach nearestObjects [(getPosATL _u), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 3];
		
			if({alive _x}count units group _u < 1)then[{
				"R_PG32V_F" createVehicle (position _u);
			},{
				//_vk setVelocity [(velocity _vk select 0)*.25, (velocity _vk select 1)*.25, 2];
				_s = [	"wheel_1_1_steering","wheel_2_1_steering","wheel_1_2_steering","wheel_2_2_steering",
					"wheel_1_3_steering","wheel_2_3_steering","wheel_1_4_steering","wheel_2_4_steering",
					"MOTOR","glass1","glass2","glass3","door1","door2","door3","door4"];
				{_vk setHit [_x,(_vk getHit _x)+(.3+(random .2))]}count _s;
			}];
		}}}};
	}];
};

 /* DO NOT CALL "fn_animateAI" because the sleep commands will cause errors when used in a non-scheduled environment */
SEM_client_animateAI = {	private["_group","_pos","_checkPos","_firstLoop","_nearThreads","_doMove","_dir","_dist","_posX","_posY","_oldPos","_newPos","_z"];
	_group = _this select 0;
	_pos = _this select 1;
	_checkPos = _pos; _checkPos set [2,3];
	
	waitUntil{{owner _x == owner player}forEach units _group};	//Wait until the server gives You the ownership of the AI
	diag_log format["#SEM: Client taking over AI ownership at Pos %1, Distance %2, Units: (%3/%4)", _pos, (vehicle player) distance _pos, {alive _x}count units _group, count units _group];

	{
	_x call SEM_client_AIfiredEH;
	_x call SEM_client_AIaddKilledEH;
	_x enableAI "AUTOTARGET";
	//_x enableAI "TARGET";
	_x enableAI "MOVE";
	_x enableAI "ANIM";
	_x enableAI "FSM";
	_x stop false;
	_x setUnitPos "Middle"; //"Auto"
	}count units _group;
	_group setCombatMode "YELLOW";
	_group setBehaviour "COMBAT"; //"AWARE";

	//waitUntil{{alive _x}count units _group < 1 || ({owner _x != owner player}forEach units _group)};
	
	while{{alive _x}count units _group > 0 && ({owner _x == owner player}forEach units _group)}do{
		_nearThreads = _pos nearEntities [["Epoch_Man_base_F","Epoch_Female_base_F","Helicopter","Car","Motorcycle"], 1200];	//"Epoch_Man_base_F","Epoch_Female_base_F"
		
		{if(alive _x && isPlayer _x)then{ _z = _x;
			{if !(lineIntersects [eyePos _x, eyePos _z, (vehicle _x), (vehicle _z)] || terrainIntersectASL [eyePos _x, eyePos _z])then{
			_group reveal [_z,4];
			if((secondaryWeapon _x) == "")then[{
					 _x doWatch _z; _x doTarget _z;
					_x commandFire _z; _x suppressFor 3;
			},{
				if !(_z isKindOf "Epoch_Man_base_F" || _z isKindOf "Epoch_Female_base_F")then{
					_x doWatch _z; _x doTarget _z; _x commandFire _z;
				};
			}];
			}}forEach units _group;
			UIsleep (3+(random 2));
		}}forEach _nearThreads;
	UIsleep 3;
	};
	
	diag_log format["#SEM: AI ownership lost - Remaining AIs: (%1/%2)", {alive _x}count units _group, count units _group];
};

"SEM_globalHint" addPublicVariableEventHandler { private "_sound";
	_sound = (_this select 1) select 0;
	switch(_sound)do{
		case 0:{playSound "UAV_05"}; //Mission start
		case 1:{playSound "UAV_01"}; //Mission fail (object destroyed)
		case 2:{playSound "UAV_04"}; //Mission fail (time out)
		case 3:{playsound "UAV_03"}; //Mission success
	};
	hint parseText format["%1", (_this select 1) select 1]
};

if(!isNil "SEM_globalMissionMarker")then{SEM_globalMissionMarker call SEM_client_createMissionMarker};
"SEM_globalMissionMarker" addPublicVariableEventHandler {_this select 1 call SEM_client_createMissionMarker};

if(!isNil "SEM_takeAIownership")then{SEM_takeAIownership call SEM_client_animateAI};
"SEM_takeAIownership" addPublicVariableEventHandler {_this select 1 spawn SEM_client_animateAI}; //DO NOT CALL!


[] spawn {	/* This is the advertisement. If You don't like it, remove it */
	waitUntil{vehicle player == player && time > 5};
	systemChat format["Welcome to EPOCH %1 survivor %2", str(toUpper worldName), name player];
	systemChat format["This server is running %1 v0.7", str "Simple Epoch Missions"];
};	/* End of advertisement */

if(toLower worldName in ["chernarus","chernarus_summer"])then{
	([4654.62,9593.63,0] nearestObject 145259) setDamage 1;
	([4654.62,9593.63,0] nearestObject 145260) setDamage 1;
};	//Fix for something, find out ;)