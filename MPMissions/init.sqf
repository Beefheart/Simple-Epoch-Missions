
if(isDedicated)exitWith{}; //Everything below this line is only executed on the client (player or local host)

SEM_client_createMissionMarker = {	private ["_create","_markerTimeout","_markerPos","_markerID","_markerA","_markerB"];
	_create = _this select 0;
	
	//Create Marker
	if(_create)then[{
	
	_markerPos = _this select 1;
	_markerID = _this select 2;
	
	_markerA = createMarkerLocal [format["SEM_MissionMarkerA_%1", _markerID], _markerPos];
	_markerB = createMarkerLocal [format["SEM_MissionMarkerB_%1", _markerID], _markerPos];
	
	{	_x setMarkerShapeLocal "ELLIPSE"; _x setMarkerSizeLocal [350,350];
		_x setMarkerPosLocal _markerPos}forEach [_markerA,_markerB];
	
	_markerA setMarkerBrushLocal "Cross";
	_markerA setMarkerColorLocal "ColorYellow";

	_markerB setMarkerBrushLocal "Border";
	_markerB setMarkerColorLocal "ColorRed";
	
	},{	//else delete marker

	_this spawn { private ["_markerTimeout","_markerID"];
		_markerTimeout = _this select 1;
		_markerID = _this select 2;
		
		if(_markerTimeout > 0)then{
			format["SEM_MissionMarkerB_%1", _markerID] setMarkerColorLocal "ColorGreen";
			sleep _markerTimeout;
		};
		
		if (getMarkerColor format["SEM_MissionMarkerA_%1", _markerID] != "")then{	//Only delete existing Marker
			deleteMarkerLocal format["SEM_MissionMarkerA_%1", _markerID];
			deleteMarkerLocal format["SEM_MissionMarkerB_%1", _markerID];
		};
	};	
	}];
};

if(!isNil "SEM_globalMissionMarker")then{SEM_globalMissionMarker call SEM_client_createMissionMarker};
"SEM_globalMissionMarker" addPublicVariableEventHandler {_this select 1 call SEM_client_createMissionMarker};

"SEM_globalHint" addPublicVariableEventHandler { private "_sound";
	_sound = (_this select 1) select 0;
	switch(_sound)do{
		case 0:{playSound "UAV_05"}; //Mission start
		case 1:{playSound "UAV_01"}; //Mission fail (object destroyed)
		case 2:{playSound "UAV_04"}; //Mission fail (time out)
		case 3:{playsound "UAV_03"}; //Mission success
	};
	hint parseText format["%1", (_this select 1) select 1];
};

"SEM_vehDamage" addPublicVariableEventHandler { private ["_vk","_vP","_s"];
	_vk = _this select 1;
	_vP = vehicle player;
	if(!local _vk)exitWith{};
	if(_vk != _vP)exitWith{};
	_s = [	"MOTOR","karoserie","palivo","glass1","glass2","glass3","door1","door2","door3","door4",
	"wheel_1_1_steering","wheel_2_1_steering","wheel_1_2_steering","wheel_2_2_steering",
	"wheel_1_3_steering","wheel_2_3_steering","wheel_1_4_steering","wheel_2_4_steering"];
	{_vk setHit [_x,(_vk getHit _x)+(.2+(random .15))]}count _s;
};


[] spawn {	/* This is the advertisement. If You don't like it, remove it */
	waitUntil{vehicle player == player && time > 120 && !isNil "SEM_version"};
	systemChat format["Welcome to EPOCH survivor %2", str(toUpper worldName), name player];
	systemChat format["This server is running %1 v%2", str "Simple Epoch Missions", SEM_version];
};	/* End of advertisement */