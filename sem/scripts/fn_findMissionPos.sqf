/* KiloSwiss */
private["_defaultCenterPos","_previousPos","_worldRadius","_worldCenterPos","_blockPos","_searchDist","_searchRadius","_blockRadius","_blockMarker","_found","_dir","_posX","_posY","_searchPos","_newPos"];

_defaultCenterPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");

_worldsize = (_this select 0) select 0;
_worldCenterPos = (_this select 0) select 1;
_previousPos = _this select 1;
_blockMarker = _this select 2;

_worldRadius = (1500 max ((_worldsize*0.9)/2));
_searchRadius = (150 max (_worldRadius/5) min 300);
_blockRadius = (500 max (_worldRadius/3) min 3000);

_blockPos = [];
{_blockPos pushBack _x}forEach _previousPos;
{_blockPos pushBack (getMarkerPos _x)}forEach _blockMarker;

_found = false;
while{!_found}do{ UIsleep .1;

		/* Randomize the search area */
	_dir = random 360;
	_searchDist = (_searchRadius max (random _worldRadius) min (_worldRadius - _searchRadius));
	_posX = (_worldCenterPos select 0) + sin(_dir) * _searchDist;
	_posY = (_worldCenterPos select 1) + cos(_dir) * _searchDist;
	_searchPos = [_posX, _posY, 0];
		/* Get a position using "BIS_fnc_findSafePos" */
	_newPos = [_searchPos,0,_searchRadius,45,0,0.5,0] call BIS_fnc_findSafePos;
		/* Let's suppose this position is ready to spawn a mission on it */
	_found = true;
	
		/* Now check this position */
	if(_newPos isEqualTo _defaultCenterPos)then{_found = false};
	
	if(_found)then{	/* Check it again */
		{if(_x distance _newPos < _blockRadius)exitWith{_found = false}}forEach _blockPos;

		if(_found)then{	/* And again */
			for "_i" from 0 to 300 step 60 do{	_dir = _i;
				_posX = (_newPos select 0) + sin (_dir) * 40;
				_posY = (_newPos select 1) + cos (_dir) * 40;
				if(surfaceIsWater [_posX, _posY])exitWith{_found = false};
			};

			if(_found)then{	/* And do a last check */
				{if(isPlayer _x)then[{if(_x distance _newPos < _blockRadius)exitWith{_found = false}},{UIsleep .05}]}forEach playableUnits;
			};
		};
	};
};
_newPos set [2,0];

_newPos;
