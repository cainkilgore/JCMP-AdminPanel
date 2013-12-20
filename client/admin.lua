timer = nil

message = ""
RenderMessage = function()
	
	if timer then
		local test = Render:GetTextSize( message )
		local testpos = Vector2( 
			(Render.Width - test.x)/6, 
			(Render.Height - test.y)/6 )
		Render:DrawText( testpos, message, Color( 255, 210, 0 ),TextSize.Huge / 2)
	
		if timer:GetSeconds() > 10 then
			timer = nil
			message = ""
		end		
	end

end
Events:Subscribe("Render", RenderMessage)

ClientFunction = function(sentMessage)
	timer = Timer()
	message = sentMessage
end
-- Subscribe ClientFunction to the network event "Test".
Network:Subscribe("Test", ClientFunction)

function ModulesLoad()
	Events:FireRegisteredEvent( "HelpAddItem",
        {
            name = "Cain's Admin",
            text = 
                "This script gives Administrators/Players various uses of gameplay mechanics.\n\n" ..
                "User Commands: /kill, /repair, /killcar, /id, /ptp <player>, /online, /sky\n" ..
                "User Commands: /clear, /pinkmobile\n\n" ..
                "Admin Commands: /kill <player>, /kick <player>, /setmoney <player> <amount>\n" ..
				"Admin Commands: /forcepassenger <player>, /ptphere */<player>\n" ..
				"Admin Commands: /ban <player>, /addmoney */<player> <amount>, /clear <player>,\n" ..
				"Admin Commands: /notice <message>, /remveh, /mass <mass>, /settime <time>, /weather <value>\n\n" ..
				"This Script was created by Cain from jc-mp.com.\nCurrent Version: v0.0.0.7\n\n" ..
				"If you want to add more administrators, open admins.txt and insert Steam ID's." ..
				"\n\nVisit the official script's server @ jc-mp.co.uk (IP and Website)"
        } )
end

function ModuleUnload()
    Events:FireRegisteredEvent( "HelpRemoveItem",
        {
            name = "Cain's Admin"
        } )
end

Events:Subscribe("ModulesLoad", ModulesLoad)
Events:Subscribe("ModuleUnload", ModuleUnload)