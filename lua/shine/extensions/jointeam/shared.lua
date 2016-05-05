--It is the job of shared.lua to create the plugin table.
local Plugin = {}
local avgglobal=0
local avgteam1=0
local avgteam2=0
local bestavgmin=0
local bestavgmax=0
local playersinfo
local Shine=Shine
local tolerance=25
local totPlayersMarines=0
local totPlayersAliens=0
local defaultskill=750
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
local rseed =math.randomseed( os.time() )



function Plugin:Initialise()
	return true --Loading successfull
end
--This table will be passed into server.lua and client.lua as the global value "Plugin".
Shine:RegisterExtension( "jointeam", Plugin )

Plugin.Conflicts = {
    --Which plugins should we force to be disabled if they're enabled and we are?
    DisableThem = {
         
    },
    --Which plugins should force us to be disabled if they're enabled and we are?
    DisableUs = {
         
    }
}

function Plugin:JoinTeam( Gamerules, Player, NewTeam, force, ShineForce ) -- jointeam is hook on server side only
		
		if(force) then
			Print("Jointeam: You Have been forced to join the team X  by NS2")
			return
		elseif(ShineForce) then
			Print("Jointeam: You Have been forced to join the team X  by Shine")
			return
		end
		
		if(NewTeam < 1) or (NewTeam > 2) then --join spec or RR
			Print("Jointeam: If you want to go into the RR or spectate, I let you do")
			return
		end
		 
		
		--values should be ok before receiving any JoinTeamEvent
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
			playerskill=self:initPlayerSkill(playerskill)
			--It let us only the case where the number of players in each team is equal.
			--team2Players == team1Players
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
	Print("ClientConfirmConnect - update AVG values")
	self:updateValues()
end

function Plugin:ClientDisconnect( Client )
	Print("Player disconnect - update AVG values")
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
			
			--to test with bots, override their skill values
			--doen't work
			--if(playerskill==defaultskill) then
			--local r =math.random(1, 3000)
			--playerskill=r
			--Ent.playerSkill=r
			--end
			
			table.insert(skills, playerskill)
			Print(string.format("Playername: %s steamid: %s teamname: %s skill: %d", Ent.playerName,  tostring( Ent.steamId ), Shine:GetTeamName( Ent.teamNumber, true ), Ent.playerSkill))
		end
	end
	self:RefreshGlobalsValues(teams, skills, totPlayer)
	--!GetBestAVG remove all element in skills.
	self:GetBestAVG(skills)
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
		Print("Invalid skill or Bot ==> skill set to %d",defaultskill)
		
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

--calculate the Best teams AVG we can have
function Plugin:GetBestAVG(skills)
	
	table.sort(skills)
	--Print("Player sorted by skill DESC: ")
	for i,n in ipairs(skills) do Print("%d: %d", i, n) end  --Print to check if it sort correctly the table
	--Print("END Player sorted by skill ")
	
	local totplayert1=0
	local totplayert2=0
	local avgt1=0
	local avgt2=0
	local totplayer=table.getn(skills)

	--Print("number of players %d", table.getn(skills))
	while (table.getn(skills) ~= 0) do
		if totplayert1 <= totplayert2 then --there is more player in t2
			if avgt1 <= avgt2 then
				avgt1=avgt1+table.remove(skills) --strongest remaining skill
			else
				avgt1=avgt1+table.remove(skills, 1) --weakest remaining skill
			end
			totplayert1=totplayert1+1
		else --there is more player in t1
			if avgt2 <= avgt1 then
				avgt2=avgt2+table.remove(skills) --strongest remaining skill
			else
				avgt2=avgt2+table.remove(skills, 1) --weakest remaining skill
			end
			totplayert2=totplayert2+1
		end
	end
	if totplayert1 ~= 0 then
			avgt1=avgt1/totplayert1
	end
	if totplayert2 ~= 0 then
		avgt2=avgt2/totplayert2
	end
	
	--Print(string.format("Best AVG? %d %d", avgt1, avgt2))
	
	if avgt1 <= avgt2 then
		avgt1=avgt1-tolerance
		avgt2=avgt2+tolerance
		self.bestavgmin = avgt1
		self.bestavgmax = avgt2
	else
		avgt1=avgt1+tolerance
		avgt2=avgt2-tolerance
		self.bestavgmin = avgt2
		self.bestavgmax = avgt1
	end
	
	
	
	
	Print(string.format("Best AVG with tolerance? min: %d max: %d tol:", self.bestavgmin, self.bestavgmax, tolerance))
	
	
	
end