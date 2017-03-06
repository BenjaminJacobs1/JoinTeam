# NS2 Shine JoinTeam
ModID: 287aa07b

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

Configuration:

The plugin has the following options available in /shine/plugins/JoinTeam.json

    {
    "InformPlayer":true, --Display a colored message to players in ready room, making them aware of the skill balance
    "ForcePlayer":true,  --Enable the jointeam restriction for players that are trying to join teams
    }

Recommandations:
-	--> not recommended on rookie server
-	This plugin let players choose their teams and the balance obtained will be less
	precise than a shuffle.
-	You should display the hive skill of the teams and players in the scoreboard using NS2+ mod options. 
	(it will be less confusing for players, who cannot join the team of their choice) 
-	The plugin ignore bots for the average skill calculation. This influence the team average skills and players count in each team. 

Please report any issue.
The plugin is available in github: https://github.com/BenjaminJacobs1/JoinTeam
If you are looking for documentation about shine in general, take a look here:
https://github.com/Person8880/Shine/wiki

known issues:
-	NS2 vote randomize ready room will problably not work properly (when ForcePlayer=true)
-	Some People might be able to join a team, because the plugin was not able to get their skill
	or their skill is equal to -1.


Potential improvments:
-	restrict the case where a player want to join the team with less people but decrease balance. 
	Depending on the number of people in RR, and the skill of those peoples.
	
Note:
Test folder comes from Shine github repository and is only present on github.

Version:
0.1: First version
0.2: Added translations for English, German and French
0.3: Added information message to players in RR
0.4: Ignore bots skill to solve warmup issue

