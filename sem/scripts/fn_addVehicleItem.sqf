/*
	File: fn_addVehicleItem.sqf
	Author: Beefheart, RockEumel
	usage : [_vehicle, (_x select 0), (_x select 1), ( (round (random _addnumofitems)) + (_x select 3) )] call Beef_fnc_addVehicleItem;
	
	_vehicle = _this select 0;
	_itemtype = _this select 1
	_item = _this select 2;
	_numofitems = _this select 3;

*/

	if ((_this select 1) == 0) then { (_this select 0) addWeaponCargoGlobal [(_this select 2),(_this select 3)]; };
	if ((_this select 1) == 1) then { (_this select 0) addMagazineCargoGlobal [(_this select 2),(_this select 3)]; };
	if ((_this select 1) == 2) then { (_this select 0) addItemCargoGlobal [(_this select 2),(_this select 3)]; };
	if ((_this select 1) == 3) then { (_this select 0) addBackpackCargoGlobal [(_this select 2),(_this select 3)]; };
