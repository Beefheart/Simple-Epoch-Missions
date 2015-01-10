
 This is a basic Mission "framework" in a early stadium and therefore lacks content and options that may/or may not be implemented in the future by its author.
 The "Simple Epoch Missions" are originally based on the Code that machine6fd postet in the Epoch Forums: http://epochmod.com/forum/index.php?/topic/30223-ai-missions-have-em/

 This Mission "framework" only allows one mission at a time (for now).
 It has the following features:
	- JIP compatible mission marker
	- CPU friendly (AI is inactive until a thread is nearby)
	- AI processing is outsourced to nearby players
	- AI kills fresh spawned players (which was one of the bigger problems so far)

 Use, edit, share as You like, all code provided in this download is free to use, as long as You share it with others.
 Only restrictions are:
	Do not share the files You downloaded under your own name.
	Do not use any parts of this download in a commercial product.
	Do not remove the names in the file headers, simply add Your name if You made any significant changes to the code or added new code by Yourself.



Install:

Step 1.
	Copy the file "sem.pbo" into the "@epochhive/addons/" folder.

	OR

	1a. Copy the folder "@sem" into the root folder of Your ArmA3 dedicated server
	2b. Add the modfolder to Your server startup parameters: -mod=@Epoch;@epochhive;@sem



Step 2.	
	Use the pbos provided in this download, they already have the init.sqf included.

	OR

	Manually add the init.sqf inside the mission pbo file (epoch.altis.pbo, epoch.stratis.pbo or epoch.chernarus.pbo)



Step 3.
	IMPORTANT: Update Your BattlEye filters!
	Add the following exceptions to Your BE filters:
	
 - scripts.txt Line 24:
	After the filter named 'addMagazine' add:
		!="_this select 0 addMagazines [_this select 5, 1];"

 - scripts,txt Lines 28, 29 and 30:
	After the filter named 'removeAllWeapons' add:
		!="removeAllWeapons _this;"
	After the filter named 'removeAllItems' add:
		!="removeAllItems _this;"
	After the filter named 'removeBackpack' add:
		!="removeBackpackGlobal _this;"

 - scripts.txt Lines 41, 42 and 43:
	After the filter named 'deleteMarker' add:
		!="deleteMarkerLocal \"MissionMarker\""
	After the filter named 'setMarker' add:
		!="_marker setMarkerPosLocal _markerPos" !="_marker setMarkerTypeLocal \"hd_destroy\"" !="_marker setMarkerTextLocal format[\"%1\",_markerName]" !="_marker setMarkerColorLocal \"ColorRed\"" !="_marker setMarkerDirLocal -37" !="_marker setMarkerSizeLocal [0.8,0.8]"
	After the filter named 'createMarker' add:
		!="createMarkerLocal [\"MissionMarker\", _markerPos]"

 - scripts.txt Line 47:
	After the filter named 'setDamage' add:
		!="([4654.62,9593.63,0] nearestObject 145259) setDamage 1" !="([4654.62,9593.63,0] nearestObject 145260) setDamage 1"

 - scripts.txt Line 52:
	After the filter named 'addEventHandler' add:
		!"Fired"

 - createvehicle.txt First Line:
	After the filter named "" add:
		!="R_PG32V_F" !="R_TBG32V_F"

 - addweaponcargo.txt First Line:
	After the filter named "" add:
		!="launch_(RPG32|NLAW|Titan_short|Titan)_F"



Step 4.
	IMPORTANT: If You use infiSTAR AntiHack change the following settings from "true" to "false":
	/*  Check Global Markers */ _CGM = false; /* true or false */
	/*  Check Local Markers  */ _CLM = false; /* true or false */


	
Step 5.
	Start Your server, join and have fun.



Edit/Change settings:

	You can change some basic settings like time between missions, minimum players etc. in the file "initMissions.sqf" which is located inside the file "sem.pbo"
	You can change the weapons and magazines that are deleted when dropped by the AI, also inside the "initMissions.sqf".
	You can change the sounds that are played when a mission starts or ends inside the file "init.sqf" (the one You have to integrate into the mission pbo.
	
	After You edited the files, You have to re-pack them into a pbo again!
	All changes You made on the files outside the sem.pbo or the mission pbo will be ignored!

03.01.2015 KiloSwiss