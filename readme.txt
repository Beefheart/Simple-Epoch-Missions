
 This is a basic Mission "framework" in a early stadium and therefore lacks content and options that may/or may not be implemented in the future by its author.
 The "Simple Epoch Missions" are originally based on the Code that machine6fd postet in the Epoch Forums: http://epochmod.com/forum/index.php?/topic/30223-ai-missions-have-em/

 This Mission "framework" only allows one mission at a time (for now).

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
	Use the pbos provided in this download, they already have the files "init.sqf" and "semClient.sqf" included.
	OR
	Manually add the "semclient.sqf" and the "init.sqf" to the mission pbo file (epoch.<island>.pbo).


Step 3.
	IMPORTANT: Update Your BattlEye filters!
	Add the following exceptions to Your BE filters:

 - scripts.txt Line 21:
	After the filter named 'allowDamage' add:
		!="if(!isPlayer _x)then{_x allowDamage"
	
 - scripts.txt Line 22:
	After the filter named 'exec' add:
		!="execVM \"semClient.sqf\""

 - scripts.txt Lines 41, 42 and 43:
	After the filter named 'deleteMarker' add:
		!="deleteMarkerLocal format[\"SEM_MissionMarker"

	After the filter named 'setMarker' add:
		!="Local"

	After the filter named 'createMarker' add:
		!="createMarkerLocal [format[\"SEM_MissionMarker"


Step 4.
	IMPORTANT: If You use infiSTAR AntiHack change the following setting from "true" to "false":
	/*  Check Local Markers  */ _CLM = false; /* true or false */

	
Step 5.
	Start Your server, join and have fun.



Edit/Change settings:

	You can change some basic settings like time between missions, minimum players etc. in the file "initMissions.sqf" which is located inside the file "sem.pbo"
	You can change the weapons and magazines that are deleted when dropped by the AI, also inside the "initMissions.sqf".
	You can change the sounds that are played when a mission starts or ends inside the file "semClient.sqf" (the one You have to integrate into the mission pbo).
	
	After You edited the files, You have to re-pack them into a pbo again!
	All changes You made on the files outside the sem.pbo or the mission pbo will be ignored!

29.01.2015 KiloSwiss