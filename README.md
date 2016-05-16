# NS2 Shine JoinTeam

The goal of this mod/plugin is to improve the team balance.
It restricts the team a player can join depending on the teams averages skills,
and on the skill of the player itself.

This plugin require Shine mod enabled on the server to be able to run.
You also need to add the plugin in your shine/BaseConfig.json, 
under the "ActiveExtensions" add: "JoinTeam":true

The plugin applies the following rules on a player who is trying to join a team.
(The rules are checked from top to down, until one of them match)

-	let him always join the team with the less players
-	let him join the team of his choice if the balance of both team improve or stay equal
-	let him join only the team where he improves the balance / block the opposite team
-	let him join only the team where he does less damage to the balance,
	if the balance decrease in either team / block the opposite team
-	let him join anyteam if all above failed. (bots, playerskill=-1, 
	damage to balance is equal for both team)

-	Don't block anyone from joining spectator and ready room
-	Admins and all kind of votes can ovveride the above rules and force the player team

Recommandations:
-	This plugin depends on the Hive skill system and cannot be better than the system itself 
	--> not recommended on rookie server
-	The hive system need a lot of time to get an accurate player skill, players coming back 
	after XX/2014 will also start at 1000 skill point instead of 0.
-	This plugin let players choose their teams and the balance obtained will be less
	precise than a shuffle.
-	The current calculation will lead to strange result with bots.
-	You display the hive skill of the teams and players in the scoreboard using NS2+ mod options. 
	(it will be less confusing for players, who cannot join the team of their choice) 

This Plugin is under development,
Please report any issue.
The plugin is available in github: https://github.com/BenjaminJacobs1/JoinTeam
If you are looking for documentation about shine in general, take a look here:
https://github.com/Person8880/Shine/wiki

known issues:
-	NS2 vote randomize ready room will problably not work properly
-	The plugin set bots skill to 750. This influence the team average skills. 
-	Some People might be able to join a team, because the plugin was not able to get their skill
	, or their skill is equal to -1.


TODO list:
-	The skill calculation/displayed should be coherent with NS2+ scoreboard, regarding bots 
	and defaultskill=750 parameter
-	restrict the case where a player want to join the team with less people but decrease balance. 
	Depending on the number of people in RR, and the skill of those peoples.
-	Improve notifcations, so the players know excatly why they cannot join a team.
	
Note:
Test folder comes from Shine github repository and is only present on github.

Version:
0.1: First version
0.2: Added translations for English, German and French

