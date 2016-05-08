local Plugin = {}
Shine:RegisterExtension( "jointeam", Plugin )


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