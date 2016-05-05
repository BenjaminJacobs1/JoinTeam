--It is the job of shared.lua to create the plugin table.
local Plugin = {}
local avgglobal=0
local avgteam1=0
local avgteam2=0
local playersinfo
local Shine=Shine
local totPlayersMarines=0
local totPlayersAliens=0
local defaultskill=750 --mainly for bots, change the average skill values! TO DO: adapt it to be coherent with what display NS2+ in scoreboard as average.
local tag="[JoinTeam]"
Plugin.avgglobal = avgglobal
Plugin.avgteam1 = avgteam1
Plugin.avgteam2 = avgteam2
Plugin.bestavgmin = bestavgmin
Plugin.bestavgmax = bestavgmax
Plugin.playersinfo= playersinfo 
Plugin.tolerance=tolerance
Plugin.totPlayersMarines =totPlayersMarines
Plugin.totPlayersAliens =totPlayersAliens
Plugin.defaultskill=defaultskill
Plugin.tag=tag
--local rseed =math.randomseed( os.time() )

--This table will be passed into server.lua and client.lua as the global value "Plugin".
Shine:RegisterExtension( "jointeam", Plugin )


function Plugin:JoinTeam( Gamerules, Player, NewTeam, force, ShineForce ) -- jointeam is hook on server side only
		
		--TO DO, do something about the NS2 vote randomize ready room. 
		--This vote don't use the force value :x
		if(force) then
			--Print("Jointeam: You Have been forced to join the team X  by NS2")
			return
		elseif(ShineForce) then
			--Print("Jointeam: You Have been forced to join the team X  by Shine")
			return
		end
		
		if(NewTeam < 1) or (NewTeam > 2) then --join spec or RR
			--Print("Jointeam: If you want to go into the RR or spectate, I let you do")
			return
		end
		 
		local gamerules = GetGamerules()
		local team1Players = gamerules.team1:GetNumPlayers()
        local team2Players = gamerules.team2:GetNumPlayers()
            
			-- check if trying to join the team with the more players
            if (team1Players > team2Players) and (NewTeam == gamerules.team1:GetTeamNumber()) then
				--Shine:NotifyColour( Player, 255, 0, 0, string.format("there is too many players in this team %s", Shine:GetTeamName(NewTeam, true)))
                return false, 0
            elseif (team2Players > team1Players) and (NewTeam == gamerules.team2:GetTeamNumber()) then
				--Shine:NotifyColour( Player, 255, 0, 0, string.format("there is too many players in this team %s", Shine:GetTeamName(NewTeam, true)))
                return false, 0
            end
			
			--check if trying to join the team with less players
			--TO DO check if there is many people in RR and if enough of them can improve the balance, then also restrict the join.
			if (team1Players > team2Players) and (NewTeam == gamerules.team2:GetTeamNumber()) then
				Shine:NotifyColour( Player, 0, 150, 255, "You can always join the team where there is less players")
                Shine:NotifyColour( Player, 0, 150, 255, string.format("Welcome in %s!", Shine:GetTeamName(NewTeam, true)))
				return 
            elseif (team2Players > team1Players) and (NewTeam == gamerules.team1:GetTeamNumber()) then
				Shine:NotifyColour( Player, 0, 150, 255, "You can always join the team where there is less players")
                Shine:NotifyColour( Player, 0, 150, 255, string.format("Welcome in %s!", Shine:GetTeamName(NewTeam, true)))
                return 
            end
			
			
			local playerskill=Shared.GetEntity(Player.playerInfo.playerId):GetPlayerSkill()
			--It let us only the case where the number of players in each team is equal.
			
			local canjoin = self:GetCanJoinTeam(self.avgteam1, self.avgteam2, team1Players, team2Players, playerskill)
			
			
			if(NewTeam == gamerules.team1:GetTeamNumber()) then
			-- try to join marines
				if(canjoin == 0) then
					Shine:NotifyColour( Player, 0, 255, 0, string.format("%s Welcome to the team of your choice!", self.tag))
					return
				elseif(canjoin == 1) then
					Shine:NotifyColour( Player, 0, 255,  0, string.format("%s Welcome in Marines team!", self.tag))
					return
				elseif(canjoin == 2) then
					Shine:NotifyColour( Player, 255, 0,  0, string.format("%s Sorry, You cannot join this team due to the teams balance", self.tag))
					Shine:NotifyColour( Player, 255, 0,  0, string.format("%s Wait a change in team balance or join the opposite team", self.tag))
					return false, 0
				elseif(canjoin == 3) then
					Shine:NotifyColour( Player, 0, 0,  255, string.format("%s Welcome in Marines team!", self.tag))
					return
				elseif(canjoin == 4) then
					Shine:NotifyColour( Player, 255, 0,  0, string.format("%s Sorry, You cannot join this team due to the teams balance", self.tag))
					Shine:NotifyColour( Player, 255, 0,  0, string.format("%s Wait a change in team balance or join the opposite team", self.tag))
					return false, 0
				elseif(canjoin == 5) then
					Shine:NotifyColour( Player, 0, 150, 255, string.format("%s Welcome to the team of your choice!", self.tag))
					return
				elseif(canjoin == 7) then
					Print("%s Bot can always join the team of their choice! Are you a bot?", self.tag)
					return
				else --6
					Print("%s GetCanJoinTeam error", self.tag)
					return
				end
			else --aliens
				if(canjoin == 0) then
					Shine:NotifyColour( Player, 0, 255, 0, string.format("%s Welcome to the team of your choice!", self.tag))
					return
				elseif(canjoin == 1) then
					Shine:NotifyColour( Player, 255, 0,  0, string.format("%s Sorry, You cannot join this team due to the teams balance", self.tag))
					Shine:NotifyColour( Player, 255, 0,  0, string.format("%s Wait a change in team balance or join the opposite team", self.tag))
					return false, 0
				elseif(canjoin == 2) then
					Shine:NotifyColour( Player, 0, 255,  0, string.format("%s Welcome in Aliens team!", self.tag))
					return
				elseif(canjoin == 3) then
					Shine:NotifyColour( Player, 255, 0,  0, string.format("%s Sorry, You cannot join this team due to the teams balance", self.tag))
					Shine:NotifyColour( Player, 255, 0,  0, string.format("%s Wait a change in team balance or join the opposite team", self.tag))
					return false, 0
				elseif(canjoin == 4) then
					Shine:NotifyColour( Player, 0, 0,  255, string.format("%s Welcome in Aliens team!", self.tag))
					return
				elseif(canjoin == 5) then
					Shine:NotifyColour( Player, 0, 150, 255, string.format("%s Welcome to the team of your choice!", self.tag))
					return
				elseif(canjoin == 7) then
					Print("%s Bot can always join the team of their choice! Are you a bot?", self.tag)
					return
				else --6
					Print("%s GetCanJoinTeam error", self.tag)
					return
				end
			end
			
			
			
			local newTeamskillmarine=(self.avgteam1*team1Players+playerskill)/(team1Players+1)
			local newTeamskillalien=(self.avgteam2*team2Players+playerskill)/(team2Players+1)
			Print("newTeamskillmarine %d newTeamskillalien %d", newTeamskillmarine, newTeamskillalien)
			Print("bestavgmin %d bestavgmax %d",self.bestavgmin,self.bestavgmax)
			--if the new player let the team within bestavgmin, bestavgmax (tolerance included), let him join the team of his choice
			if(NewTeam == gamerules.team1:GetTeamNumber()) then --Join Marine
				
				if(newTeamskillmarine >= self.bestavgmin) and (newTeamskillmarine <= self.bestavgmax) then
					Shine:NotifyColour( Player, 0, 150, 255, "You are within balance limit, welcome to the team of your choice")
					Shine:NotifyColour( Player, 0, 150, 255, string.format("Old avg: %d new avg: %d",self.avgteam1, newTeamskillmarine))
					return
				end
			else --join alien
				if(newTeamskillalien >= self.bestavgmin) and (newTeamskillalien <= self.bestavgmax) then
					Shine:NotifyColour( Player, 0, 150, 255, "You are within balance limit, welcome to the team of your choice")
					Shine:NotifyColour( Player, 0, 150, 255, string.format("Old avg: %d new avg: %d",self.avgteam2, newTeamskillalien))
					return
				end
			end
			
			--it leaves only the case where the player can only enter the team if balance "is improved"
			--It means that it let strong player join the weak team, and weak join the strong team only.
			--When everyone made a choice, the balance could be out of limit, due to:
			--	people leaving, 
			--	people abusing the fact that they are free to join the team with less players
			local deltaIfJoiningMarine=math.abs(newTeamskillmarine-self.avgteam2)
			local deltaIfJoiningAlien=math.abs(self.avgteam1-newTeamskillalien)
			--local teamforced=0
			--if(math.abs(deltaIfJoiningMarine == deltaIfJoiningAlien) then 
			--	teamforced=0 
			if(deltaIfJoiningMarine < deltaIfJoiningAlien) then --the player must join marines
				teamforced=1
			else --(deltaIfJoiningMarine > deltaIfJoiningAlien) then --the player must join aliens
				teamforced=2
			end
			
			--[[
			if(teamforced == 0) then
				Shine:NotifyColour( Player, 0, 150, 255, "Welcome to the team of your choice")
				if(NewTeam == gamerules.team1:GetTeamNumber()) then
					Shine:NotifyColour( Player, 0, 150, 255, string.format("Old avg: %d new avg: %d",self.avgteam1, newTeamskillmarine))
				else
					Shine:NotifyColour( Player, 0, 150, 255, string.format("Old avg: %d new avg: %d",self.avgteam2, newTeamskillalien))
				end
				return
			end
			]]--
			
			
			if(NewTeam == gamerules.team1:GetTeamNumber()) and (teamforced==1) then --Join Marine
						Shine:NotifyColour( Player, 0, 255, 0, string.format("Welcome in %s!", Shine:GetTeamName(NewTeam, true)))
						Shine:NotifyColour( Player, 0, 255, 0, string.format("Old avg: %d new avg: %d",self.avgteam1, newTeamskillmarine))
						return
			elseif (NewTeam == gamerules.team2:GetTeamNumber()) and (teamforced==2) then
						Shine:NotifyColour( Player, 0, 255, 0, string.format("Welcome in %s!", Shine:GetTeamName(NewTeam, true)))
						Shine:NotifyColour( Player, 0, 255, 0, string.format("Old avg: %d new avg: %d",self.avgteam2, newTeamskillalien))
						return
			else
						Shine:NotifyColour( Player, 255, 0, 0, "Joining this team would badly influence the teams balance!")
						Shine:NotifyColour( Player, 255, 0, 0, "Please Join the opposite team or wait.")
						if(NewTeam == gamerules.team1:GetTeamNumber()) then
						Shine:NotifyColour( Player, 255, 0, 0, string.format("Old avg: %d new avg: %d",self.avgteam1, newTeamskillmarine))
						else
						Shine:NotifyColour( Player, 255, 0, 0, string.format("Old avg: %d new avg: %d",self.avgteam2, newTeamskillalien))
						end
						return false
			end
			---------------------------------------------------------------
			
			
		
		
		Shine:NotifyColour( Player, 0, 255, 0, string.format("This message should never appear", Shine:GetTeamName(NewTeam, true)))
		return   --allow the player to join the team, return false to not allow
	
end

function Plugin:PostJoinTeam( Gamerules, Player, OldTeam, NewTeam, Force, ShineForce )
	self:updateValues()
end

function Plugin:ClientConfirmConnect( Client )
	--Print("ClientConfirmConnect - update AVG values")
	self:updateValues()
end

function Plugin:ClientDisconnect( Client )
	--Print("Player disconnect - update AVG values")
	self:updateValues()
end

function Plugin:updateValues()
	playersinfo = Shared.GetEntitiesWithClassname("PlayerInfoEntity")
	--first create an Array with the skills values and teams associate
	local totPlayer=playersinfo:GetSize()
	local skills = {}
	local teams = {}
	for i, Ent in ientitylist( playersinfo ) do
		local playerskill=self:initPlayerSkill(Ent.playerSkill)
		if(Ent.teamNumber ~= 3 ) then --not spectating
			table.insert(teams, Ent.teamNumber)
			table.insert(skills, playerskill)
			--Print(string.format("Playername: %s steamid: %s teamname: %s skill: %d", Ent.playerName,  tostring( Ent.steamId ), Shine:GetTeamName( Ent.teamNumber, true ), Ent.playerSkill))
		end
	end
	self:RefreshGlobalsValues(teams, skills, totPlayer)
	
end

--some players connect with a skill == nil or -1
-- and Bots connect with a skill of -1
--For plugin sanity the default skill value is set to 750
--TODO add it as option
function Plugin:initPlayerSkill(s)
	local playerskill = defaultskill
	--Print("skill? %s", s)
	if s ~= nil and s ~= -1 then
					playerskill = s
					
					
	else
		--Print("Invalid skill or Bot ==> skill set to %d",defaultskill)
		
	end
	return playerskill
end

--Refresh the AVG skill of the connected players, the marines, the aliens and ignore spectators skill
function Plugin:RefreshGlobalsValues(teams, skills, totPlayer)
		
		local totPlayersMarines=0
		local totPlayersAliens=0
		local avg=0
		local avgt1=0
		local avgt2=0
		
		for key,teamNumber in ipairs(teams) do
			
			
			if(teamNumber == 1 ) then --Marines 
				totPlayersMarines=totPlayersMarines+1
				avgt1=avgt1+skills[key]
				avg=avg+skills[key]
			elseif (teamNumber == 2 ) then --Aliens
				totPlayersAliens=totPlayersAliens+1
				avgt2=avgt2+skills[key]
				avg=avg+skills[key]
			elseif (teamNumber ==  3) then --Spectate
				--Ignore the players in spectators
				totPlayer=totPlayer-1
			else --ReadyRoom (4)
				avg=avg+skills[key]
			end

		end
		
		if totPlayer ~= 0 then
			avg=avg/totPlayer			
		end
		if totPlayersMarines ~= 0 then
			avgt1=avgt1/totPlayersMarines
		end
		if totPlayersAliens ~= 0 then
			avgt2=avgt2/totPlayersAliens
		end
		self.avgglobal = avg
		self.avgteam1 = avgt1
		self.avgteam2 = avgt2
		self.totPlayersMarines=totPlayersMarines
		self.totPlayersAliens=totPlayersAliens
		
		Print("RefreshGlobalsValues(): G: %d - %d M: %d - %d A: %d - %d", totPlayer, self.avgglobal, totPlayersMarines, avgt1, totPlayersAliens, avgt2)
		
end

--The function define if a player witch team(s), he can join.
--The value returned is:
	-- 0: Can join any team
	-- 1: can join only marines and improve balance
	-- 2: can join only aliens and improve balance
	-- 3: can join marines and decrease balance (but less than aliens)
	-- 4: can join aliens and decrease balance (but less than  marines)
	-- 5: can join any team and decrease the balance identically whatever the team he choose
	-- 6: can join anyteam, function malfunctionned.
	-- 7: playerskill == -1, the player is probably a bot

--For testing we must pass all arguments, instead of using plugins variables
function Plugin:GetCanJoinTeam(avgt1, avgt2, numPlayert1, numPlayert2, playerskill)

	if(playerskill == -1) then
		return 7
	end
	
	local newavgt1=(avgt1*numPlayert1+playerskill)/(numPlayert1+1)
	local newavgt2=(avgt2*numPlayert2+playerskill)/(numPlayert2+1)

	--Print("Skill: %d  t1(count/avg/newavg): %d/%d/%d t2(count/avg/newavg): %d/%d/%d", playerskill, numPlayert1, avgt1, newavgt1, numPlayert2, avgt2, newavgt2 )

	local deltaCurrent = math.abs((avgt1-avgt2))
	local deltaT1 = math.abs((newavgt1-avgt2))
	local deltaT2 = math.abs((newavgt2-avgt1))

	if((deltaT1 <= deltaCurrent) and (deltaT2 <= deltaCurrent)) then
		--Improve balance when joining anyteam
		return 0	
	elseif((deltaT1 <= deltaCurrent) and (deltaT2 > deltaCurrent)) then
		--Improve balance when joining marines team only 
		return 1
	elseif((deltaT1 > deltaCurrent) and (deltaT2 <= deltaCurrent)) then
		--Improve balance when joining aliens team only 
		return 2
	elseif((deltaT1 > deltaCurrent) and (deltaT2 > deltaCurrent)) then
		--Never improve balance when joining, we need to find the team where he does less damage
		if(deltaT1 < deltaT2) then
			return 3
		elseif(deltaT1 > deltaT2)then
			return 4
		else --deltaT1 == deltaT2
			return 5
		end
	else
	--Should never be reach
		return 6
	end
	
	

end