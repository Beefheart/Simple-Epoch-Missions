private ["_vehicle","_itemarray","_addnumofitems"];

/*
	File: fn_setVehicleLoadout.sqf
	Author: Beefheart, RockEumel
	usage : [_box, <itemarray>] call fn_setVehicleLoadout;
	
	_itemtype = _x select 0
		0 = weapons (addweapon)
		1 = magazines (addmagazines)
		2 = items (additems)
		3 = backpacks (addbackpacks)
	_itemname = _x select 1;
	_dropchance = _x select 2;
	_numofitems = _x select 3;
	_addnumofitems = _x select 4;

	
	<itemarray> = [[	0,	"m107_EPOCH",	0.3,	1,	0]];
						1	2				3		4	5

						1: _itemtype		--> Type of _itemname. See above for valid types.
						2: _itemname		--> classname
						3: _dropchance		--> percentage chance for _itemname to spawn. 1 = 100%, 0.01 = 1%
						4: _numofitems		--> quantity of _itemname (any integer >0)
						5: _addnumofitems 	--> maximal random quantity of additional _itemname (any integer > 0)
*/

_vehicle = _this select 0;
_itemarray = _this select 1;
{
	_addnumofitems = 0;
	if (count _x > 4) then { _addnumofitems = _x select 4; };
	
	if ( (random 1) <= (_x select 2) ) then {
		[_vehicle, (_x select 0), (_x select 1), ( (round (random _addnumofitems)) + (_x select 3) )] call SEM_fnc_addVehicleItem;
	};
} foreach _itemarray;
