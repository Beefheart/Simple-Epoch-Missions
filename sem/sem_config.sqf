/*
	SEM - "Simple Epoch Missions" configuration file

	Update 18.02.2015
	By KiloSwiss
	
	150503: Loadout-arrays by Beefheart
*/


	/* Mission start/timer settings */

SEM_MinPlayerStatic = 1;	// Minimum number of online players for basic missions to spawn.
SEM_MinPlayerDynamic = 1; 	// Minimum number of online players for additional/parallel running missions.

SEM_MissionTimerMin = 1;	// Minimum minutes between missions. 10
SEM_MissionTimerMax = 2;	// Maximum minutes between missions. 15


	/* Reward/punish settings */

SEM_reward_AIkill = true;	// Defines if players get some Krypto as reward for each AI they kill.

SEM_punish_AIroadkill = true;	// Defines if players should be punished for killing AI units by driving them over with cars.
SEM_damage_AIroadkill = true;	// Defines if the players car should be damaged when driving over an AI unit.
SEM_Krypto_AIroadkill = 150;	// How much Krypto will be removed by punishing players for AI roadkills.


	/* Advanced mission settings */

// Minutes after a finished mission where all mission objects (including AI) will be deleted.
SEM_MissionCleanup = 10;	// 0 or -1 equals never. -1
	
// Allow captured Vehicles do be permanent (saved to Database).
SEM_permanentVehicles = true;	// true or false

// Chance of AI dropping their guns and keeping their gear (vests, backpacks and magazines) when killed.
SEM_AIdropGearChance = 40;		//	Values: 0-100%	Where 0 means all gear gets removed from dead AI units.

// Disable Damage over a specific distance so players can't snipe the mission AI from safe distance.
SEM_AIdisableSniperDamage = true;	// Set to false to allow sniper damage from any distance.
SEM_AIsniperDamageDistance = 600;	// Max. distance (in meters) where AI takes damage (min. 300 -  max. 1000).


	/* Loadout-arrays
		To-do:
			- Normale ammo rein, tracer raus
	*/

SEM_LdOut_LMG = ["m249_EPOCH","m249Tan_EPOCH","LMG_Mk200_F","Arifle_MX_SW_F","Arifle_MX_SW_Black_F","LMG_Zafir_F"];
SEM_LdOut_LMG_ammo = ["200Rnd_556x45_M249","200Rnd_65x39_cased_Box_Tracer","100Rnd_65x39_caseless_mag_Tracer","150Rnd_762x51_Box_Tracer"];

SEM_LdOut_DMR = ["M14_EPOCH","M14Grn_EPOCH","srifle_EBR_F","srifle_DMR_01_F","arifle_MXM_F","arifle_MXM_Black_F"];
SEM_LdOut_DMR_ammo = ["20Rnd_762x51_Mag","10Rnd_762x51_Mag","30Rnd_65x39_caseless_mag_Tracer"];

SEM_LdOut_Sniper = ["m107_EPOCH","m107Tan_EPOCH","Srifle_GM6_F","Srifle_LRR_F"];
SEM_LdOut_Sniper_ammo = ["5Rnd_127x108_Mag","7Rnd_408_Mag"];

SEM_LdOut_MMLMG = ["MMG_01_hex_F","MMG_01_tan_F","MMG_02_camo_F","MMG_02_sand_F","MMG_02_black_F"];
SEM_LdOut_MMLMG_ammo = ["150Rnd_93x64_Mag","130Rnd_338_Mag"];

SEM_LdOut_MMDMR = [
	"srifle_DMR_02_F","srifle_DMR_02_camo_F","srifle_DMR_02_sniper_F",	//MAR-10
	"srifle_DMR_03_F","srifle_DMR_03_tan_F","srifle_DMR_03_khaki_F","srifle_DMR_03_multicam_F","srifle_DMR_03_woodland_F",	//Mk-I EMR
	"srifle_DMR_04_Tan_F",	//ASP-1 Kir
	"srifle_DMR_05_blk_F","srifle_DMR_05_hex_F","srifle_DMR_05_tan_F",	//Cyrus
	"srifle_DMR_06_camo_F","srifle_DMR_06_olive_F"	//Mk14
];
SEM_LdOut_MMDMR_ammo = ["10Rnd_338_Mag","20Rnd_762x51_Mag","10Rnd_127x54_Mag"];

SEM_LdOut_rifleOptics = ["optic_Aco","optic_ACO_grn","optic_Holosight","optic_Hamr","optic_Arco"]; //"optic_Hamr","optic_Arco"

SEM_LdOut_sniperOptics = ["optic_Nightstalker", "optic_SOS", "optic_LRPS", "optic_DMS"];

SEM_LdOut_MMOptics = [
	["optic_AMS"],
	["optic_AMS_khk"],
	["optic_AMS_snd"],
	["optic_KHS_blk"],
	["optic_KHS_hex"],
	["optic_KHS_old"],
	["optic_KHS_tan"]
];

SEM_LdOut_riflesilencer = [
	"muzzle_snds_H",	//6.5
	"muzzle_snds_B"	//7.62
];

SEM_LdOut_mmsilencer = [
	"muzzle_snds_338_black",
	"muzzle_snds_338_green",
	"muzzle_snds_93mmg",
	"muzzle_snds_93mmg_tan"
];

SEM_LdOut_lmgsilencer = [
	"muzzle_snds_H_MG"
];



	/* ################# */			/* ################# */			/* ################# */
	/* Advanced settings */			/* Advanced settings */			/* Advanced settings */
	/* ################# */			/* ################# */			/* ################# */


SEM_removeWeaponsFromDeadAI = [];	// Weapons that should be removed from killed AI
SEM_removeMagazinesFromDeadAI = [];	// Magazines that should be removed from killed AI

//Marker Names where mission spawning is blocked.
SEM_blockMarker = ["respawn_west"];

	/* Static Missions */
SEM_staticMissionsPath = "sem\missionsStatic\";
SEM_staticMissions = [
	["bSupplyCrash",	"Supply Van",		45,	1,	1,	false],
	["bPlaneCrash",		"Plane Crashsite",	45,	1,		2,	false],
	["bHeliCrash",		"Heli Crashsite",	45,	1,		2,	false],
	["bCamp",			"Bandit Camp",		90,	100,		3,	false],
	["bDevice",			"Strange Device",	45,	1,		0,	false],
	/* example */
	["file name",		"marker name",		-1,	-1,		5,	false]	//NO COMMA AT THE LAST LINE!
/*	 1.					2.					3.	4.		5.	6.

	1. "file name"  	MUST be equal to the sqf file name!
	2. "marker name" 	Name of the mission marker.
	3. time out,		(Number) Minutes until running mission times out (0 or -1 equals no mission time out).
	4. probability		(Number) Percentage of probability how often a mission will spawn: 1 - 100 (0 and -1 equals OFF).
	5. danger level		(Number) Color for the mission marker (0=white, 1=yellow, 2=orange, 3=red, 4=violet, 5=black)
	6. static/dynamic	Use dynamic (true) for convoys and static (false) for stationary missions.
*/];

	/* Dynamic Missions */
SEM_dynamicMissionsPath = "sem\missionsDynamic\";
SEM_dynamicMissions = [
	["convoySupply",	"Supply Convoy",	90,	100,	0,	true],
	["convoyRepair",	"Repair Convoy",	90,	80,		1,	true],
	["convoyStrider",	"Strider Convoy",	90,	80,		2,	true],
	["convoyWeapon",	"Weapon Convoy",	90,	100,	3,	true]	//NO COMMA AT THE LAST LINE!
/*	 1.					2.					3.	4.		5.	6.

	1. "file name"  	MUST be equal to the sqf file name!
	2. "marker name" 	Name of the mission marker.
	3. time out,		(Number) Minutes until running mission times out (0 or -1 equals no mission time out).
	4. probability		(Number) Percentage of probability how often a mission will spawn: 1 - 100 (0 and -1 equals OFF).
	5. danger level		(Number) Colour for the mission marker (0=white, 1=yellow, 2=orange, 3=red, 4=violet, 5=black)
	6. static/dynamic	Use dynamic (true) for convoys and static (false) for stationary missions.
*/];


SEM_debug = "off"; // Valid values: "off", "log" and "full" or 0, 1 and 2.
/*Debug settings explained:

	0 or "off"	= Debug is off
		- This is the default setting.
	
	1 or "log"	= Only additional logging is active.
		- For debugging and proper error reports, please activate this!
		- Any RPT submitted for bug reports with debug off will be ignored!

	2 or "full"	= Many settings are changed + additional logging is active.
		- Missions time out after 10min.
		- Minimum players is set to 0 (for both static and dynamic missions).
		- Time between missions is 30sec.
		- Mission clean up happens after 2min.
		- AI only takes damage from below 100m.
		- More events and additional data is logged to the .rpt.
*/

/* DO NOT EDIT BELOW THIS LINE */
/**/SEM_config_loaded = true;/**/