--[[
	jointeam logic tests.
	
		To run the tests use: sh_luarun Script.Load("test/test_init.lua") in game
		The tests addbot with fake skills to show the balance stuff
		sh_luarun Script.Load("test/test_init.lua")
]]
local Shine = Shine
local UnitTest = Shine.UnitTest

local JoinTeam = UnitTest:LoadExtension( "jointeam" )

if not JoinTeam then return end

local rseed =math.randomseed( os.time() )

UnitTest:Test( "initPlayerSkill", function( Assert )
local skill = { }
local defaultskill=JoinTeam.defaultskill
skill[1]=JoinTeam:initPlayerSkill(nil)
skill[2]=JoinTeam:initPlayerSkill(-1)
local r = math.random(1, 3000)
skill[3]=JoinTeam:initPlayerSkill(r)

Assert:Equals( defaultskill, skill[1] )
Assert:Equals( defaultskill, skill[2] )
Assert:Equals( r, skill[3] )
end )

			
			
			
