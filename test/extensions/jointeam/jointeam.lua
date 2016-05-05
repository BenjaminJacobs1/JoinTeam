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

UnitTest:Test( "GetCanJoinTeam", function( Assert )
	--(avgt1, avgt2, numPlayert1, numPlayert2, playerskill)
	local avgt1=1200
	local avgt2=1300
	local numPlayert1=4
	local numPlayert2=4
	local playerskill=40
	local maxskill=3000
	local expected={}
	local result={}
	local i=0
	--use excel to get the expected values!
    for i=0, 6 do
      expected[i] = 4
    end
	
	for i=7, 28 do
      expected[i] = 2
    end
	
	for i=29, 31 do
      expected[i] = 0
    end
	
	for i=32, 54 do
      expected[i] = 1
    end
	
	for i=55, 74 do
      expected[i] = 3
    end
	
	expected[75]=7
	
	i=0
	while(playerskill <= 3000) do
		result[i]=JoinTeam:GetCanJoinTeam(avgt1, avgt2, numPlayert1, numPlayert2, playerskill)
		
		playerskill=playerskill+40
		i=i+1
	end
	
	result[75]=JoinTeam:GetCanJoinTeam(avgt1, avgt2, numPlayert1, numPlayert2, -1)
	
	
	for i=0, 75 do
		  Assert:Equals( result[i], expected[i] )
	end
	

end )

			
			
			
