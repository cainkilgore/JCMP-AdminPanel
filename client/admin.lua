timer = nil

message = ""
adminname = "default"
showMenu = false

RenderMessage = function()
	
	if timer then
		local test = Render:GetTextSize( message )
		local testpos = Vector2( 
			(Render.Width - test.x)/6, 
			(Render.Height - test.y)/6 )
						
		Render:DrawText( testpos, "<" .. adminname .. "> " .. message, Color( 255, 210, 0 ),TextSize.Huge / 2)
	
		if timer:GetSeconds() > 10 then
			timer = nil
			message = ""
		end		
	end
	
	if showMenu then
	
		-- local file = io.open("server/server.txt", "r")
		-- if file == nil then
			-- Render:DrawText(Vector2(Render.Width - 380, Render.Height / 4 + 20), "Your server administrator has not setup server.txt.", Color(255, 0, 0))
			-- Render:DrawText(Vector2(Render.Width - 380, Render.Height / 4 + 30), "It should be in server/server.txt", Color(255, 0, 0))
			-- return
		-- end
		-- for line in file:lines() do
			-- confirmationMessage(sender, line)
		-- end
		
		Render:FillArea(Vector2(Render.Width - 400, Render.Height / 4), Vector2(Render.Width - 200, (Render.Height / 2) - 320), Color(0, 0, 0, 127))
		Render:FillArea(Vector2(Render.Width - 200, Render.Height / 4), Vector2(Render.Width - 200, (Render.Height / 2) - 480), Color(0, 0, 0, 127))
		Render:DrawText(Vector2(Render.Width - 380, Render.Height / 4 + 20), "Cain's Admin Script", Color(255, 255, 255), 20)
		Render:DrawText(Vector2(Render.Width - 380, Render.Height / 4 + 40), "Created by Cain from http://jc-mp.com", Color(255, 255, 255))
		Render:DrawText(Vector2(Render.Width - 380, Render.Height / 4 + 60), "Visit Cain's Server at jc-mp.co.uk", Color(255, 255, 255))
		Render:DrawText(Vector2(Render.Width - 380, Render.Height / 4 + 80), "Current Script Version: v0.0.0.9", Color(255, 255, 255))
		Render:DrawText(Vector2(Render.Width - 380, Render.Height / 4 + 100), "F5 and Click 'Cain's  Admin' for Command Help", Color(255, 255, 255))
		
		Render:DrawText(Vector2(Render.Width - 140, Render.Height / 2 - 240), "P TO CLOSE", Color(255, 255, 255))
		
		
	end

end

KeyCheck = function(args)
	if args.key == string.byte("P") then
		-- Chat:Print("You pressed the P key" , Color(255, 255, 255))
		if showMenu then
			showMenu = false
		else
			showMenu = true
		end
	end
end

Events:Subscribe("Render", RenderMessage)
Events:Subscribe("KeyDown", KeyCheck)

ClientFunction = function(sentMessage)
	timer = Timer()
	message = sentMessage
end

GetAdminName = function(sentMessage)
	adminname = sentMessage
end

-- Subscribe ClientFunction to the network event "Test".
Network:Subscribe("Test", ClientFunction)
Network:Subscribe("Admin", GetAdminName)

function ModulesLoad()
	Events:FireRegisteredEvent( "HelpAddItem",
        {
            name = "Cain's Admin",
            text = 
                "This script gives Administrators/Players various uses of gameplay mechanics.\n\n" ..
                "User Commands: /kill, /repair, /killcar, /id, /ptp <player>, /online, /sky\n" ..
                "User Commands: /clear, /pinkmobile, /server\n\n" ..
                "Admin Commands: /kill <player>, /kick <player>, /setmoney <player> <amount>\n" ..
				"Admin Commands: /forcepassenger <player>, /ptphere */<player>\n" ..
				"Admin Commands: /ban <player>, /addmoney */<player> <amount>, /clear <player>,\n" ..
				"Admin Commands: /notice <message>\n\n" ..
				"This Script was created by Cain from jc-mp.com.\nCurrent Version: v0.0.0.9\n\n" ..
				
				"Command Usage: \n" ..
				"/kill <player> \n" .. 
				"Specify no arguments and you will kill yourself. If you're an admin, specify\n" ..
				"a name after it and you will kill another player.\n\n" ..
				
				"/repair \n" .. 
				"Specify no arguments and you will repair your vehicle. It costs $300 to repair.\n\n" ..
				
				"/killcar \n" .. 
				"Specify no arguments and your car will be destroyed. It cost $100 to destroy.\n\n" ..
				
				"/id \n" .. 
				"Specify no arguments and it will tell you your Steam ID.\n\n" .. 
				
				"/ptp <player> \n" .. 
				"Specify a player afterwards and you will teleport to that player.\n\n" .. 
				
				"/online \n" .. 
				"Specify no arguments and you will receive a countup of how many players are on\n" ..
				"and will show you the players that are currently online.\n\n" ..
				
				"/sky <player> \n" .. 
				"Specify no arguments and you will teleport yourself high in the sky. If you're an\n"..
				"admin, specify a player and it will teleport that player into the sky.\n\n" .. 
				
				"/clear <player> \n" ..
				"Specify no arguments and it will clear your inventory. If you're an admin, specify a\n"..
				"player and it will clear that player's inventory.\n\n" .. 
				
				"/pinkmobile \n" .. 
				"Specify no arguments and your car's colour will be changed to pink. It costs $300 to do.\n\n"..
				
				"/kick <player> \n" .. 
				"If an admin does this, specify a player and it will kick that player from the server.\n\n" ..
				
				"/setmoney  */<player> <amount>\n" .. 
				"If an admin does this, specify a player and an amount of money and it will set the player's\n"..
				"money. Change player to * and it will set everyone that's online's money.\n\n" .. 
				
				"/forcepassenger <player>\n" ..
				"If an admin does this, specify a player and it will force that player to be in that vehicle\n"..
				"with you.\n\n"..
				
				"/ptphere <player>\n" ..
				"If an admin does this, specify a player and it will teleport that player to you. Replace player\n"..
				"with * and it will teleport all online players to you.\n\n"..
				
				"/ban <player>\n"..
				"If an admin does this, specify a player and it will ban them from the server.\n\n"..
				
				"/addmoney */<player> <amount>\n"..
				"If an admin does this, specify a player ( or * ) and an amount of money and it will give them\n"..
				"that amount of money to their bank account.\n\n"..
				
				"/notice <message>\n"..
				"Specify a message and it will print that message out vibisibly to all players on the screen.\n\n"..
				
				"/server\n" ..
				"Shows the contents of server/server.txt in-chat. Useful for MOTD's and such.\n\n"..
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