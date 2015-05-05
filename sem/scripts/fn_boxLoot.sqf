/*
	[_box] call fn_boxLoadout;	== Random loadout is selected

	[_box, 3] call fn_boxLoadout;	== Loadout 3 is selected
	
	15-05-03: Added MM DLC stuff by Beefheart.
*/
private ["_box","_loadout","_ran"];
_box = _this select 0;
if(count _this > 1)then[{_loadout = _this select 1},{_loadout = ceil(random 4)}];

_box call SEM_fnc_emptyGear;

_LMGs = [
	["m249_EPOCH",				"200Rnd_556x45_M249"],
	["m249Tan_EPOCH",			"200Rnd_556x45_M249"],
	["LMG_Mk200_F",				"200Rnd_65x39_cased_Box_Tracer"],
	["Arifle_MX_SW_F",			"100Rnd_65x39_caseless_mag_Tracer"],
	["Arifle_MX_SW_Black_F",	"100Rnd_65x39_caseless_mag_Tracer"],
	["LMG_Zafir_F",				"150Rnd_762x51_Box_Tracer"]
];

_rifleOptics = ["optic_Aco","optic_ACO_grn","optic_Holosight","optic_Hamr","optic_Arco"]; //"optic_Hamr","optic_Arco"


_DMRs = [
	["M14_EPOCH",			"20Rnd_762x51_Mag"],
	["M14Grn_EPOCH",		"20Rnd_762x51_Mag"],
	["srifle_EBR_F",		"20Rnd_762x51_Mag"],
	["srifle_DMR_01_F",		"10Rnd_762x51_Mag"],
	["arifle_MXM_F",		"30Rnd_65x39_caseless_mag_Tracer"],
	["arifle_MXM_Black_F",	"30Rnd_65x39_caseless_mag_Tracer"]
];

_Sniper = [
	["m107_EPOCH",		"5Rnd_127x108_Mag"],
	["m107Tan_EPOCH",	"5Rnd_127x108_Mag"],
	["Srifle_GM6_F",	"5Rnd_127x108_Mag"],
	["Srifle_LRR_F",	"7Rnd_408_Mag"]
];

_sniperOptics = ["optic_Nightstalker", "optic_SOS", "optic_LRPS", "optic_DMS"];

_MMLMG = [
	["MMG_01_hex_F","150Rnd_93x64_Mag"],	// Navid
	["MMG_01_tan_F","150Rnd_93x64_Mag"],
	["MMG_02_camo_F","130Rnd_338_Mag"],	// SPMG
	["MMG_02_sand_F","130Rnd_338_Mag"],
	["MMG_02_black_F","130Rnd_338_Mag"]
];

_MMDMR = [
	["srifle_DMR_02_F","10Rnd_338_Mag"],	//MAR-10
	["srifle_DMR_02_camo_F","10Rnd_338_Mag"],
	["srifle_DMR_02_sniper_F","10Rnd_338_Mag"],
	["srifle_DMR_03_F","20Rnd_762x51_Mag"],	//Mk-I EMR
	["srifle_DMR_03_tan_F","20Rnd_762x51_Mag"],
	["srifle_DMR_03_khaki_F","20Rnd_762x51_Mag"],
	["srifle_DMR_03_multicam_F","20Rnd_762x51_Mag"],
	["srifle_DMR_03_woodland_F","20Rnd_762x51_Mag"],
	["srifle_DMR_04_Tan_F","10Rnd_127x54_Mag"],	//ASP-1 Kir
	["srifle_DMR_05_blk_F","10Rnd_93x64_DMR_05_Mag"],	//Cyrus
	["srifle_DMR_05_hex_F","10Rnd_93x64_DMR_05_Mag"],
	["srifle_DMR_05_tan_F","10Rnd_93x64_DMR_05_Mag"],
	["srifle_DMR_06_camo_F","20Rnd_762x51_Mag"],	//Mk14
	["srifle_DMR_06_olive_F","20Rnd_762x51_Mag"]
];

_MMOptics = ["optic_AMS","optic_AMS_khk","optic_AMS_snd","optic_KHS_blk","optic_KHS_hex","optic_KHS_old","optic_KHS_tan"];

_riflesilencer = [
	"muzzle_snds_H",	//6.5
	"muzzle_snds_B"	//7.62
];

_mmsilencer = ["muzzle_snds_338_black","muzzle_snds_338_green","muzzle_snds_93mmg","muzzle_snds_93mmg_tan"];

_lmgsilencer = ["muzzle_snds_H_MG"];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

switch(_loadout)do{
	case 1:{	//2xLMG 1xDMR
		_wpn = _LMGs select (random (count _LMGs -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 3];
		_wpn = _LMGs select (random (count _LMGs -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 3];
		_wpn = _DMRs select (random (count _DMRs -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 5];
		_box addItemCargoGlobal ["optic_Hamr", 1];
		_box addItemCargoGlobal ["optic_Arco", 1];
		_box addItemCargoGlobal [_rifleOptics select (random (count _rifleOptics -1)), 1];
		_box addItemCargoGlobal [_rifleOptics select (random (count _rifleOptics -1)), 1];
		_box addItemCargoGlobal [_lmgsilencer select (random (count _lmgsilencer -1)), 1];
		_box addItemCargoGlobal ["NVG_EPOCH", 1];
	};

	case 2:{	//Sniper
		_wpn = _Sniper select (random (count _Sniper -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 5];
		_box addItemCargoGlobal [_sniperOptics select (random (count _sniperOptics -1)), 1];
		_box addItemCargoGlobal [_sniperOptics select (random (count _sniperOptics -1)), 1];
		_box addItemCargoGlobal ["NVG_EPOCH", 2];
		_box addItemCargoGlobal ["ItemGPS", 1];
		_box addItemCargoGlobal ["Rangefinder", 1];
	};

	case 3:{	//Marksmen DLC DMR
		_wpn = _MMDMR select (random (count _MMDMR -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 5];
		_box addItemCargoGlobal [_MMOptics select (random (count _MMOptics -1)), 1];
		_box addItemCargoGlobal [_MMOptics select (random (count _MMOptics -1)), 1];
		_box addItemCargoGlobal [_mmsilencer select (random (count _mmsilencer -1)), 1];
		_box addItemCargoGlobal ["NVG_EPOCH", 2];
		_box addItemCargoGlobal ["ItemGPS", 1];
		_box addItemCargoGlobal ["Rangefinder", 1];
	};

	case 4:{	//1xLMG, 1x MM LMG, 1xMMDMR
		_wpn = _LMGs select (random (count _LMGs -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 3];
		_wpn = _MMLMG select (random (count _MMLMG -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 3];
		_wpn = _MMDMR select (random (count _MMDMR -1));
		_box addWeaponCargoGlobal [(_wpn select 0), 1];
		_box addMagazineCargoGlobal [(_wpn select 1), 5];
		_box addItemCargoGlobal [_MMOptics select (random (count _MMOptics -1)), 1];
		_box addItemCargoGlobal [_rifleOptics select (random (count _rifleOptics -1)), 1];
		_box addItemCargoGlobal ["NVG_EPOCH", 1];
	};
};