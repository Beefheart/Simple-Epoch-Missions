/*
	Returns world Center position and world size/radius from center in a array.
	
	_return = [] call SEM_fnc_getWorldData;
	
	25.12.2014 by KiloSwiss
*/

private["_worldRadius","_worldCenterPos","_worldData"];

if(isNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize"))then[{
	_worldRadius = (getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize")/2);
	_worldCenterPos = [_worldRadius, _worldRadius, 0];	//Source: http://feedback.arma3.com/view.php?id=16257
	_worldData = [_worldRadius, _worldCenterPos];
},{
	_worldRadius = switch(toLower worldName)do{
						//case "altis":{15360};
						//case "stratis":{4096};
						case "chernarus":{7680};
						case "chernarus_summer":{7680};
						case "woodland_acr":{3840}; //Bystrica
						case "bootcamp_acr":{1920}; //Bukovina
						case "utes":{2560};
						case "sara":{10240};
						case "saralite":{5120};
						case "sara_dbe1":{10240};
						case "takistan":{6400};
						case "zargabad":{4096};
						default {-1};
					};
	_worldCenterPos = if(_worldRadius > 0)then{[_worldRadius,_worldRadius,0]}else{
						if(getMarkerColor "center" != "")then[{getMarkerPos "center"},{
						getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition")}];
					};
	_worldData = [_worldRadius, _worldCenterPos];
}];

_worldData

/*	To check size on different islands, use this code:
private["_worldRadius","_worldCenterPos","_marker"];
deleteMarkerLocal "Center";
_worldRadius = (getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize")/2);
_worldCenterPos = [ _worldRadius, _worldRadius, 0];
_marker = createMarkerLocal ["Center", _worldCenterPos];
_marker setMarkerPosLocal _worldCenterPos;
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_worldRadius, _worldRadius];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.5;
_marker setMarkerBrushLocal "SolidFull";
copytoClipboard format["%1 / %2 / %3", toLower worldName, _worldRadius*2, _worldCenterPos];
hint format["Copy to clipboard\nUse %4 to paste this information:\n\nWorldName: %1\nSize: %2\nCenter: %3", worldName, _worldRadius*2, _worldCenterPos, str (ctrl+v)];
*/