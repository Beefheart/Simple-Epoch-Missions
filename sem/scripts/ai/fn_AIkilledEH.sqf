
/* Remove Weapons when killed */
call compile format["
	_this addEventHandler ['Killed',{ private['_unit','_z','_ran'];
		_unit = _this select 0;
		{_unit removeWeaponGlobal _x}count (%1 + ['EpochRadio0','ItemMap','ItemRadio','ItemWatch','ItemCompass','ItemGPS']);
		{if(_x in (magazines _unit))then{_unit removeMagazines _x}}count %2;
		
		if(SEM_AIdropGearChance < ceil(random 100))then{
			_unit call SEM_fnc_removeGear;
			{deleteVehicle _x}forEach nearestObjects [(getPosATL _unit), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 1];
		};
		
		_unit spawn{
			sleep .1;
			{_z = _x;
			if(_x in (getweaponcargo _z))exitWith{deleteVehicle _z}count %1;
			if(_x in (getmagazinecargo _z))exitWith{deleteVehicle _z}count %2;
			}forEach nearestObjects [(getPosATL _this), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 12];
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
		_u call SEM_fnc_removeGear;
		{deleteVehicle _x}forEach nearestObjects [(getPosATL _u), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 3];
		
		if({alive _x}count units group _u < 1)then[{
			"R_PG32V_F" createVehicle (position _u);
		},{
			//_vk setVelocity [(velocity _vk select 0)*.25, (velocity _vk select 1)*.25, 2];
			_s = [	"wheel_1_1_steering","wheel_2_1_steering","wheel_1_2_steering","wheel_2_2_steering",
					"wheel_1_3_steering","wheel_2_3_steering","wheel_1_4_steering","wheel_2_4_steering",
					"MOTOR","glass1","glass2","glass3","door1","door2","door3","door4"];
			{_vk setHit [_x,(_vk getHit _x)+(.3+(random .2))]}count _s;
			
			vehicle player setHit [_x,((vehicle player) getHit _x) +.3]
		}];
	}}}};
}];