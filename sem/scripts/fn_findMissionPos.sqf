/* KiloSwiss */
private["_defaultCenterPos","_previousPos","_worldRadius","_worldCenterPos","_searchRadius","_blockRadius","_found","_dir","_posX","_posY","_searchPos","_newPos"];

_defaultCenterPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");

_previousPos = _this select 0;
_worldRadius = (_this select 1) select 0;
_worldCenterPos = (_this select 1) select 1;

_searchRadius = (_worldRadius/2)*0.9;
_blockRadius = _searchRadius/5 max 500;

_found = false;

while{!_found}do{ UIsleep .1; _found = true;

		/* Get a position */
	_dir = random 360;
	_posX = (_worldCenterPos select 0) + sin(_dir) * _searchRadius;
	_posY = (_worldCenterPos select 1) + cos(_dir) * _searchRadius;
	_searchPos = [_posX, _posY, 0];

	_newPos = [_searchPos,0,_searchRadius,45,0,0.5,0] call BIS_fnc_findSafePos;
	
		/* Now check this position */
	if(_newPos isEqualTo _defaultCenterPos)then{_found = false};
	
	if(_found)then{	/* Check it again */
		{if(_x distance _newPos < _blockRadius)exitWith{_found = false}}forEach _previousPos;

		if(_found)then{	/* And again */
			{if(isPlayer _x)then[{if(_x distance _newPos < _blockRadius)exitWith{_found = false}},{UIsleep .05}]}forEach playableUnits;

			if(_found)then{	/* And do a few last checks */
				for "_i" from 0 to 300 step 60 do{ private "_checkPos";	_dir = _i;
					_posX = (_newPos select 0) + sin (_dir) * 40;
					_posY = (_newPos select 1) + cos (_dir) * 40;
					if(surfaceIsWater [_posX, _posY])exitWith{_found = false};
				};
			};
		};
	};
};
_newPos set [2,0];

_newPos;
