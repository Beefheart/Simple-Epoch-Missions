	/* KiloSwiss */
if(isDedicated)exitWith{}; //Everything below this line is only executed on the client (player or local host)

[] spawn {	waitUntil{player == player && !isNil "SEM_version"};
	if(isMultiplayer)then{
		waitUntil{!isNull (uiNameSpace getVariable ["EPOCH_loadingScreen", displayNull])};
		waitUntil{isNull (uiNameSpace getVariable "EPOCH_loadingScreen")};
	};
	/* This is the advertisement. */
	private "_worldName";
	_worldName = switch(toLower worldName)do{
		case "bootcamp_acr"		:{"Bukovina"};
		case "woodland_acr"		:{"Bystrica"};
		case "chernarus_summer"	:{"Chernarus (summer)"};
		case "mbg_celle2"		:{"Celle"};
		case "isladuala"		:{"Isla-Duala"};
		case "panthera2"		:{"Panthera"};
		case "panthera3" 		:{"Panthera"};
		case "smd_sahrani_a2"	:{"Sahrani"};
		case "sara"				:{"Sahrani"};
		case "saralite"			:{"Sahrani"};
		case "sara_dbe1"		:{"Sahrani"};
		case "tavi"				:{"Taviana"};
		case "vr"				:{"Virtual Reality"};
		default{worldName};
	};
	[[format["Welcome to EPOCH %1", _worldName],"", format["Do Your best to survive %1", name player],"","","","","","",""," ","Good luck...","","",""], -.5, .85] call BIS_fnc_typeText;
	//sleep 2;
	[["This server is running:",format["%1 v%2", str 'Simple Epoch Missions', SEM_version],"","","","",""], .5, .85] call BIS_fnc_typeText;
	/* End of advertisement */
	"SEM_version" addPublicVariableEventHandler {titleText [format["This server is running %1 v%2",	str "Simple Epoch Missions", _this select 1], "PLAIN DOWN"]};
};	


SEM_client_createMissionMarker = {	private ["_create","_markerPos","_markerID","_markerA","_markerB","_markerC","_markerD","_markerC_Pos","_markerName","_markerColor"];
	_create = _this select 0;
	
	//Create Marker
	if(_create)then[{
	
	_markerPos = _this select 1;
	_markerID = _this select 2;
	_markerName = _this select 3;
	_markerColor = (	switch(_this select 4)do{
							case 0:	{"ColorWhite"};
							case 1:	{"ColorUNKNOWN"};
							case 2:	{"ColorOrange"};
							case 3:	{"ColorEAST"};
							case 4:	{"ColorCIV"};
							case 5:	{"ColorBlack"};
							default	{"Default"};
						});
	_staticMission = (	switch(_this select 5)do{
							case "static":	{true};
							case "dynamic":	{false};
							default	{true};
						});
	
	
	if(_staticMission)then{	//Static Mission
		_markerA = createMarkerLocal [format["SEM_MissionMarkerA_%1", _markerID], _markerPos];
		_markerB = createMarkerLocal [format["SEM_MissionMarkerB_%1", _markerID], _markerPos];
		_markerC = createMarkerLocal [format["SEM_MissionMarkerC_%1", _markerID], _markerPos];
		
		{	_x setMarkerShapeLocal "ELLIPSE"; _x setMarkerSizeLocal [500,500];
			_x setMarkerPosLocal _markerPos}forEach [_markerA,_markerB];
		
		_markerA setMarkerBrushLocal "Cross";
		_markerA setMarkerColorLocal _markerColor;
		
		_markerB setMarkerBrushLocal "Border";
		_markerB setMarkerColorLocal "ColorRed";
		
		_markerC_Pos = [(_markerPos select 0) - (count _markerName * 15), (_markerPos select 1) - 530, 0];
		_markerC setMarkerShapeLocal "Icon";
		_markerC setMarkerTypeLocal "HD_Arrow";
		_markerC setMarkerColorLocal _markerColor;
		_markerC setMarkerPosLocal _markerC_Pos;
		_markerC setMarkerTextLocal _markerName;
		_markerC setMarkerDirLocal 37;
	}else{	//Dynamic Mission
		_markerD = createMarkerLocal [format["SEM_MissionMarkerD_%1", _markerID], _markerPos];
		_markerD setMarkerShapeLocal "Icon";
		_markerD setMarkerTypeLocal "mil_circle";	//"HD_Destroy";
		_markerD setMarkerColorLocal _markerColor;
		_markerD setMarkerPosLocal _markerPos;
		_markerD setMarkerTextLocal _markerName;
		//_markerD setMarkerDirLocal -37;
	};
	
	},{	//else delete marker

	_this spawn { private ["_endCondition","_deleteMarkerID","_endMissionType"];
		_endCondition = _this select 1;
		_deleteMarkerID = _this select 2;
		_endMissionType = _this select 3;
		
		if(_endCondition == 3)then[{
			{
			if (getMarkerColor format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] != "")then{
				format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] setMarkerColorLocal "ColorIndependent";
			}}forEach (if(_endMissionType == "static")then[{["A","B","C"]},{["D"]}]);
			sleep 120;
		},{
			{
			if (getMarkerColor format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] != "")then{
				format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] setMarkerColorLocal "ColorGrey";
			}}forEach (if(_endMissionType == "static")then[{["A","B","C"]},{["D"]}]);
			sleep 30;
		}];
		
		{		/* Only delete existing Marker */
		if (getMarkerColor format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] != "")then{
			deleteMarkerLocal format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID];
		}}forEach (if(_endMissionType == "static")then[{["A","B","C"]},{["D"]}]);
	};	
	}];
};

if(!isNil "SEM_globalMissionMarker")then{SEM_globalMissionMarker call SEM_client_createMissionMarker};
"SEM_globalMissionMarker" addPublicVariableEventHandler {_this select 1 call SEM_client_createMissionMarker};

SEM_client_updateMissionMarkerPos = { private["_updateMarkerID","_updateMarkerPos"];
	_updateMarkerID = _this select 0;
	_updateMarkerPos = _this select 1;

	if (getMarkerColor format["SEM_MissionMarkerD_%1", _updateMarkerID] != "")then{
		format["SEM_MissionMarkerD_%1", _updateMarkerID] setMarkerPosLocal _updateMarkerPos;
	};
};

if(!isNil "SEM_updateMissionMarkerPos")then{SEM_updateMissionMarkerPos call SEM_client_updateMissionMarkerPos};
"SEM_updateMissionMarkerPos" addPublicVariableEventHandler {_this select 1 call SEM_client_updateMissionMarkerPos};

SEM_lastEvent = 0;
"SEM_globalHint" addPublicVariableEventHandler { 
	_this select 1 spawn {	private "_sound";
	//waitUntil{time - SEM_lastEvent > 20}; SEM_lastEvent = time;
	waitUntil{if(time - SEM_lastEvent > 20)exitwith{SEM_lastEvent = time; true}; false};
		_sound = _this select 0;
		switch(_sound)do{
			case 0:{playSound "UAV_05"}; //Mission start
			case 1:{playSound "UAV_01"}; //Mission fail (object destroyed)
			case 2:{playSound "UAV_04"}; //Mission fail (time out)
			case 3:{playsound "UAV_03"}; //Mission success
		};
		hint parseText format["%1", _this select 1];
	};
};

"SEM_vehDamage" addPublicVariableEventHandler { private ["_vk","_vP","_s"];
	_vk = _this select 1;
	_vP = vehicle player;
	if(!local _vk)exitWith{};
	if(_vk != _vP)exitWith{};
	_s = [	"MOTOR","karoserie","palivo","glass1","glass2","glass3","door1","door2","door3","door4",
	"wheel_1_1_steering","wheel_2_1_steering","wheel_1_2_steering","wheel_2_2_steering",
	"wheel_1_3_steering","wheel_2_3_steering","wheel_1_4_steering","wheel_2_4_steering"];
	{_vk setHit [_x,(_vk getHit _x)+(.15+(random .15))]; true}count _s;
};

"SEM_Krypto_AIkill" addPublicVariableEventHandler {
	EPOCH_playerCrypto = (EPOCH_playerCrypto + (_this select 1)) min 25000;
};

"SEM_Krypto_AIroadkill" addPublicVariableEventHandler {
	EPOCH_playerCrypto = EPOCH_playerCrypto - (_this select 1);
};


[] spawn {
	waitUntil{!isNil "SEM_AIsniperDamageDistance"};
	waitUntil{!isNil "SEM_AI_Units"};

	while{true}do{	private "_units";
		_units = SEM_AI_Units;
		{	sleep 0.05;
		if(_x isEqualTo objNull)then{
			if(_x distance (vehicle player) > SEM_AIsniperDamageDistance)then[{
				if(!isPlayer _x)then{_x allowDamage false};
			},{
				if(!isPlayer _x)then{_x allowDamage true};
			}];
		}
		}forEach _units;
	};
};
//if(!isNil "SEM_AIsniperDamageEH")then{SEM_AI_Units call SEM_client_AIaddDamageEH};
//"SEM_AI_Units" addPublicVariableEventHandler {_this select 1 call SEM_client_AIaddDamageEH};