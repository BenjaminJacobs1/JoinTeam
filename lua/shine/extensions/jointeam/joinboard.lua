
local Plugin = Plugin
local Shine = Shine
local SGUI = Shine.GUI
local Hook = Shine.Hook
local Locale = Shine.Locale
local JoinBoard = {Window={}}
Plugin.JoinBoard=JoinBoard


function JoinBoard:CreateBoard()
Print("creating board1")
	

local Button = SGUI:Create( "Button" )
Button:SetAnchor( "CentreMiddle" )
Button:SetSize( Vector( 128, 32, 0 ) )
Button:SetPos( Vector( -64, -16, 0 ) )
Button:SetText( "Button1" )
Button:SetIsVisible(true)

Print("creating board2")


local List = SGUI:Create( "List" )
Print("creating board3")
List:SetAnchor( "CentreMiddle" )
Print("creating board4")
Print("creating board5")
List:SetSize( Vector( 200, 200, 0 ) )
Print("creating board6")
List:SetPos( Vector( 100, 100, 0 ) )
Print("creating board7")
--List:SetHeaderTextScale( Scale )
--List:SetHeaderTextColour( Col )
--List:SetHeaderFont( Font )
List:SetColumns( "col1","col2","col3" )
List:SetSpacing( 0.33, 0.33 ,0.34 )
Print("creating board8")
--List:SetRowTextScale( Scale )
List:AddRow( "a","b","c")
Print("creating board9")
List:AddRow( "d","e","f")
Print("creating board10")
List:SetIsVisible(true)
Print("creating board11")

Print("creating board--")
--[[ 

local ParametersTable = {
    Elements = {Button, List}, -- A table containing your objects/layouts that live inside this one
    Pos = Vector2( 0, 0 ), -- Usually, position can be left out, as it will be dependent on padding.
    AutoSize = UnitVector( Percentage( 100 ), Percentage( 100 ) ), -- AutoSize determines how to size this layout when it's part of another layout.
    Size = Vector2( 0, 0 ), -- Sets the absolute size of the layout, usually determined by the parent.
    Margin = Spacing( 0, 0, 0, 0 ), -- Sets the space between this layout and other elements of its parent layout.
    Padding = Spacing( 0, 0, 0, 0 ), -- Sets how much space to add inside the layout.
    Parent = Element, -- Sets the layout's parent element.
    Fill = true -- Sets whether the layout should fill the space of its container, if omitted this defaults to true.
}

local Layout = Shine.GUI.Layout:CreateLayout( "JoinTeamBoard", ParametersTable )
Layout:SetIsVisible(true)


Print("creating board3")
local Pos = Vector( -400, -300, 0 )
Print("creating board4")
local Size = Vector( 800, 600, 0 )
Print("creating board5")
Window = SGUI:Create( "TabPanel" )
Print("creating board6")
	Window:SetAnchor( "CentreMiddle" )
	Print("creating board7")
	Window:SetPos( Pos )
	Print("creating board8")
	Window:SetSize( Size )
	Print("creating board9")
	Window:SetIsVisible( true )
	Print("board should be visible 10")
	JoinBoard.Window = Window
	Print("creating board11")
]]--

end