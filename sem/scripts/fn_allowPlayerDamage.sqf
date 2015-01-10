/* KiloSwiss */
[_uid,_name] spawn {	private ["_uid","_name","_found"];
	_uid = _this select 0;
	_name = _this select 1;

	if(_name == "__SERVER__")exitWith{};
		/* Only clients */

	waitUntil{ UIsleep 5; _found = false;
		{ UIsleep .1;
			if(getPlayerUID _x == _uid)then{	/* Get the current player object with the UID */
				if(_x getVariable["SETUP",false])then{	/* Check if setup is finished */
					if(isPlayer _x)exitWith{ _found = true;	/* Done */
						_x allowDamage true;	/* Enable damage from server side AI for this session */
						diag_log format["#KS-DEBUG: AllowDamage set true on %1 : %2 : %3", str (typeOf _x), str _name, _uid];
					};
				};
			};
		}count playableUnits;
	(_found)
	};
};