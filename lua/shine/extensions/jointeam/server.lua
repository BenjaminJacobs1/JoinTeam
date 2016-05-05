--The plugin table registered in shared.lua is passed in as the global "Plugin".
local Plugin = Plugin


Plugin.HasConfig = true
Plugin.ConfigName = "JoinTeam.json"
Plugin.DefaultConfig = { 
	--Tolerance = 50 --TO DO IMPLEMENT IT
	--IgnoreSpectator=true
	--checkSmallerTeam=false check balance also when player want to join the team with less players
}
Plugin.CheckConfig = true --Should we check for missing/unused entries when loading?
Plugin.CheckConfigTypes = true --Should we check the types of values in the config to make sure they match our default's types?
Plugin.DefaultState = true --Should the plugin be enabled when it is first added to the config?

function Plugin:Initialise()
	self:CreateCommands()
	self.Enabled = true
	return true
end

--Here we create two commands that set our datatable values.
function Plugin:CreateCommands()
	local Commands = Plugin.Commands

	local function Runtest()
		Print("testing plugin Jointeam...")
		Script.Load( "test/test_init.lua")
		return true
	end
	
	self:BindCommand( "sh_jointeam_ut", "jointeam_ut", Runtest, false )
end

--We call the base class cleanup to remove the console commands.
function Plugin:Cleanup()
	self.BaseClass.Cleanup( self )
	Print "Disabling server plugin..."
end