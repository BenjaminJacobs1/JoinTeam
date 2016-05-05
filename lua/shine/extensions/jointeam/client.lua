--The registered table from shared.lua is passed as the global "Plugin".
Script.Load("lua/shine/extensions/jointeam/joinboard.lua")
local Plugin = Plugin
local Shine = Shine
local SGUI = Shine.GUI
local Hook = Shine.Hook
local Locale = Shine.Locale
local JoinBoard = Plugin.JoinBoard

--This is ran when the plugin is loaded on the client, which is when the client finished loading.
function Plugin:Initialise()
--	JoinBoard:CreateBoard()
	return true
end



