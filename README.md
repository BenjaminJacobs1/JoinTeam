# NS2 Shine JoinTeam

version 0.1

The goal of this mod/plugin is to improve the team balance.
It restricts the team a player can join depending on the teams averages skills, and on skill of the player itself.

This plugin require Shine mod enabled on the server to be able to run.

The plugin applies the following rules on players who are trying to join a team:

-	let them always join the team with the less players
-	let them join any team if the balance of both team improve or stay equal
-	let them join the team where they improve the balance/ block the opposite team
-	let them join the team where they do less damage to the balance, if the balance decrease in either team / block the opposite team
-	let them join anyteam if all above failed. (bots, playerskill=-1, damage to balance is equal for both team)

-	Don't block anyone from joining spectator and ready room
-	Let admin and all kind of votes force player teams 

Recommandations:
-	This plugin depends on the Hive skill system and cannot be better than the system itself --> not recommended on rookie server
-	The hive system need a lot of time to get an accurate player skill, players coming back after XX/2014 will also start at 1000 skill point instead of 0.
-	This plugin let players choose their teams and the balance obtained will be less precise than a shuffle.
-	The current calculation will lead to strange result with bots. 

This Plugin is under development,
Please report any issue.
The plugin is available in github: https://github.com/BenjaminJacobs1/JoinTeam

known issues:
-	NS2 vote randomize ready room will problably not work properly
-	The plugin set bots skill to 750. This influence the team average skills. 
-	Some People might be able to join a team, because the plugin was not able to get their skill, or their skill is equal to -1.


TODO list:
-	The skill calculation/displayed should be coherent with NS2+ scoreboard, regarding bots and defaultskill=750 parameter
-	restrict the case where a player want to join the team with less people but decrease balance. 
	Depending on the number of people in RR, and the skill of those peoples.
	



