
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
			}forEach nearestObjects [(getPosATL _this), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 3];
		};
	}];
", SEM_removeWeaponsFromDeadAI, SEM_removeMagazinesFromDeadAI];

/* AI run over by vehicle */
if(SEM_punish_AIroadkill || SEM_reward_AIkill)then{
	_this addEventHandler ["killed", { private["_u","_k","_vk","_s"];
		_u = _this select 0;
		_k = _this select 1;
		_vk = vehicle _k;
		
		if(SEM_damage_AIroadkill)then[{
			if(_vk isKindOf "Car")then{
			if(abs speed _vk > 0)then{
			if(_vk distance _u < 10)then{
			if(isEngineOn _vk || !isNull (driver _vk))then{
				
				SEM_vehDamage = _vk;
				(owner _vk) publicVariableClient "SEM_vehDamage";
				
				if(SEM_Krypto_AIroadkill > 0)then{
					{if(isPlayer _x)then{
						(owner _x) publicVariableClient "SEM_Krypto_AIroadkill";
					}}forEach (crew _vk);
				};
				
				{deleteVehicle _x}forEach nearestObjects [(getPosATL _u), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 3];
				_u call SEM_fnc_removeGear;
				
				if({alive _x}count units group _u < 1)then{
					_u spawn{sleep 5; createMine ["APERSTripMine", (position _this),[],0]};
				};
				
			}}}}else{
				if(SEM_reward_AIkill)then{
					SEM_Krypto_AIkill = ceil(skill _u * 10);
					(owner _vk) publicVariableClient "SEM_Krypto_AIkill";
				};
			};
		},{
			if(SEM_reward_AIkill)then{
				SEM_Krypto_AIkill = ceil(skill _u * 10);
				(owner _vk) publicVariableClient "SEM_Krypto_AIkill";
			};
		}];
	}];
};