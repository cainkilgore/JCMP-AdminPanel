class 'admin'

local adminPrefix = "[Admin] "

-- Change this value to whatever your STEAM ID is! (Type /id in-game)

local admins = { }
				
local admincount = 0

local invalidArgs = "You have entered invalid arguments."
local nullPlayer = "That player does not exist."
local kicked = " has been kicked from the server."
local moneyset = "'s bank account now has $"
local moneyadd = "'s bank account got an additional $"
local inVehicle = "You must be inside a vehicle."
local playerInVehicle = "That player is now inside your vehicle."
local playerTele = " teleported you to them."
local playerTele2 = " teleported to you."
local killedSelf = "You killed yourself."
local playerKill = " killed you."
local playerKill2 = "You killed "
local invalidPermissions = "You must be an administrator to use this."
local vehicleRepaired = "Your vehicle has been repaired."
local notEnoughMoneyRepair = "You need at least $300 to repair your vehicle."
local vehicleKilled = "Your vehicle has been destroyed."
local notEnoughMoneyKill = "You need at least $100 to destroy your vehicle."
local steamID = "Your Steam ID is: "
local playerTeleport = "You teleported to "

local showJoin = true
local showLeave = true
local adminKillReward = true

timerAdmin = ""

-- Cain's Admin Commands and Functions
-- Version: 0.0.0.7

-- Available Commands:
-- /kill
-- /kill <player> (ADMIN)
-- /kick <player> (ADMIN)
-- /setmoney <player> <amount> (ADMIN)
-- /forcepassenger <player> (ADMIN)
-- /ptphere <player> (ADMIN) 
-- /repair (Cost $300)
-- /killcar (Cost $100)
-- /id
-- /ptp <player>
-- /online
-- /sky
-- /addmoney <player> <amount> (ADMIN)
-- /getmoney <player> (ADMIN)
-- /ban <player> (ADMIN)
-- /clear
-- /pinkmobile
-- /down

function admin:loadAdmins(filename)
	local file = io.open(filename, "r")
	local i = 0

	if file == nil then
		print("admins were not found!!")
		return
	end
	
	for line in file:lines() do
		i = i + 1
		
		if string.sub(filename, 1, 2) ~= "--" then
			admins[i] = line
			print("Admins Found: " .. line)
		end
	end
	file:close()
	
end

function admin:__init()
    Events:Subscribe( "PlayerChat", self, self.PlayerChat )
	Events:Subscribe( "PlayerJoin", self, self.PlayerJoin )
	Events:Subscribe( "PlayerQuit", self, self.PlayerQuit )
	Events:Subscribe( "PlayerDeath", self, self.PlayerDeath )
	self:loadAdmins("server/admins.txt")
end

function isAdmin( player )
	local adminstring = ""
	for i,line in ipairs(admins) do
		adminstring = adminstring .. line .. " "
	end

	if(string.match(adminstring, tostring(player:GetSteamId()))) then
		return true
	end
	
	return false
end

function admin:PlayerJoin( args )
	if showJoin then 
		Chat:Broadcast("Join> " .. args.player:GetName() .. " joined the server!", Color(255,215,0))
	end
end

function admin:PlayerQuit( args )
	if showLeave then
		Chat:Broadcast("Leave> " .. args.player:GetName() .. " left the server!", Color(255,215,0))
	end
end

function admin:PlayerDeath ( args )
	if adminKillReward then
		if args.killer then
			if(isAdmin(args.player)) then
				for p in Server:GetPlayers() do
					p:SetMoney(p:GetMoney() + 1000)
				end
				
				Chat:Broadcast(args.killer:GetName() .. " killed the Admin " .. args.player:GetName() .. ", everyone receives $1,000! (Except them, " ..  args.player:GetName() .. " doesn't like them)", Color(255, 0, 0))
			end
		else 
			if(isAdmin(args.player)) then
				for p in Server:GetPlayers() do
					p:SetMoney(p:GetMoney() + 1000)
				end
				Chat:Broadcast(args.player:GetName() .. " died terribly. Everyone receives $1,000!", Color(255, 0, 0))
			end
		end
	end
end

-- User-created functions

function confirmationMessage( player, message )
	Chat:Send(player, message, Color(124, 242, 0))
end

function deniedMessage( player, message )
	Chat:Send(player, message, Color(255, 0, 0))
end

function admin:PlayerChat( args )
		
    local cmd_args = args.text:split( " " )
	sender = args.player
	
	if(isAdmin(args.player)) then
		if(cmd_args[1]) == "/kick" then
			if #cmd_args < 1 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				deniedMessage(sender, nullPlayer)
				return false
			end
			
			Chat:Broadcast(player:GetName() .. kicked, Color(255, 0, 0))
			player:Kick()
			return true
		end
		
		if(cmd_args[1]) == "/setmoney" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			if cmd_args[2] == "*" then
				for p in Server:GetPlayers() do
					p:SetMoney(tonumber(cmd_args[3]))
				end
				Chat:Broadcast("Everyone now has $" .. tonumber(cmd_args[3]) .. " in their bank account, courtesy of " .. args.player:GetName() .. ".", Color(255, 0, 0))
				return true
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				deniedMessage(sender, nullPlayer)
				return false
			end
			
			player:SetMoney(tonumber(cmd_args[3]))
			confirmationMessage(sender, cmd_args[2] .. moneyset .. cmd_args[3])
			return true
		end
		 -- AddMoney 
		if(cmd_args[1]) == "/addmoney" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			if cmd_args[2] == "*" then
				for p in Server:GetPlayers() do
					p:SetMoney(p:GetMoney() + tonumber(cmd_args[3]))
				end
				Chat:Broadcast("Everyone now has an additional $" .. tonumber(cmd_args[3]) .. " in their bank account, courtesy of " .. args.player:GetName() .. ".", Color(255, 0, 0))
				return true
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				deniedMessage(sender, nullPlayer)
				return false
			end
			
			player:SetMoney(player:GetMoney() + tonumber(cmd_args[3]))
			confirmationMessage(sender, cmd_args[2] .. moneyadd .. cmd_args[3])
			return true
		end
		
		-- Ban
		if(cmd_args[1]) == "/ban" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				deniedMessage(sender, nullPlayer)
				return false
			end
			
			Chat:Broadcast(player:GetName() .. " has been banned from the server. (" .. tostring(player:GetSteamId()) .. ")", Color(255, 0, 0))
			Server:AddBan(player:GetSteamId())
			player:Kick("You have been banned from the server.")
			return true
		end
		
		if(cmd_args[1]) == "/getmoney" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				deniedMessage(sender, nullPlayer)
				return false
			end
			
			confirmationMessage(sender, player:GetName() .. " currently has $" .. player:GetMoney() .. " in their bank.")
			return true
		end
		
		if(cmd_args[1]) == "/forcepassenger" then
			if #cmd_args < 1 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				deniedMessage(sender, nullPlayer)
				return false
			end
			
			if not args.player:GetVehicle() then
				deniedMessage(sender, inVehicle)
				return false
			end
			
			player:EnterVehicle(args.player:GetVehicle(), VehicleSeat.Passenger)
			-- args.player:EnterVehicle(args.player:GetVehicle(), VehicleSeat.Passenger)
			confirmationMessage(sender, playerInVehicle)
			return true
		end
		
		if(cmd_args[1]) == "/ptphere" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			if cmd_args[2] == "*" then
				for p in Server:GetPlayers() do
					p:Teleport(sender:GetPosition(), sender:GetAngle())
					confirmationMessage(p, sender:GetName() .. " has teleported all players to them.")
				end
				confirmationMessage(sender, "All players have been teleported to you.")
				return true
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				deniedMessage(sender, nullPlayer)
				return false
			end
			
			player:Teleport(args.player:GetPosition(), args.player:GetAngle())
			confirmationMessage(player, args.player:GetName() .. playerTele)
			confirmationMessage(sender, player:GetName() .. playerTele2)
			return true
		end
		
		if(cmd_args[1]) == "/notice" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			local stringname = args.text:sub(9, 256)
			
			for p in Server:GetPlayers() do
				Network:Send(p, "Test", stringname)
			end
		end
		
		if(cmd_args[1]) == "/mass" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			playerVehicle = sender:GetVehicle()
			
			if not playerVehicle then
				deniedMessage(sender, inVehicle)
				return false
			end
			
			playerVehicle:SetMass(tonumber(cmd_args[2]))
			confirmationMessage(sender, "Your vehicle mass has been set to " .. tonumber(cmd_args[2]))
			return true
		end
		
		if(cmd_args[1]) == "/remveh" then
			for veh in Server:GetVehicles() do
				veh:Remove()
			end
			
			confirmationMessage(sender, "All vehicles on the server have been removed.")
			return true
		end
		
		if(cmd_args[1]) == "/settime" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			time = tonumber(cmd_args[2])
			DefaultWorld:SetTime(time)
			confirmationMessage(sender, "The server time has been changed to " .. time)
			return true
		end
		
		if(cmd_args[1]) == "/weather" then
			if #cmd_args < 2 then
				deniedMessage(sender, invalidArgs)
				return false
			end
			
			weatherSev = tonumber(cmd_args[2])
			DefaultWorld:SetWeatherSeverity(weatherSev)
			confirmationMessage(sender, "The worlds weather has been set to " .. weatherSev)
			return true
		end
		
	end
	
	if(cmd_args[1]) == "/kill" then
		if #cmd_args < 2 then
			args.player:SetHealth(0)
			confirmationMessage(sender, killedSelf)
			return true
		end
		
		if #cmd_args > 1 then
			if(isAdmin(args.player)) then
				local player = Player.Match(cmd_args[2])[1]
				if not IsValid(player) then
					deniedMessage(sender, nullPlayer)
					return false
				end
				
				player:SetHealth(0)
				confirmationMessage(player, args.player:GetName() .. playerKill)
				confirmationMessage(sender, playerKill2 .. player:GetName())
				return true
			else 
				deniedMessage(sender, invalidPermissions)
				return false
			end
		end
	end
	
	if(cmd_args[1]) == "/repair" then
		if not args.player:GetVehicle() then
			deniedMessage(sender, inVehicle)
			return false
		end
		if(args.player:GetMoney() >= 300) then
			veh = args.player:GetVehicle()
			args.player:GetVehicle():SetHealth(1)
			args.player:GetVehicle():Respawn()
			
			args.player:EnterVehicle(veh, 0)
			args.player:SetMoney(args.player:GetMoney() - 300)
			confirmationMessage(sender, vehicleRepaired)
		else
			deniedMessage(sender, notEnoughMoneyRepair)
		end
	end
	
	if(cmd_args[1]) == "/killcar" then
		if not args.player:GetVehicle() then
			deniedMessage(sender, inVehicle)
			return false
		end
		if(args.player:GetMoney() >= 100) then
			args.player:GetVehicle():SetHealth(0)
			args.player:SetMoney(args.player:GetMoney() - 100)
			confirmationMessage(sender, vehicleKilled)
		else
			deniedMessage(sender, notEnoughMoneyKill)
		end
	end
	
	if(cmd_args[1]) == "/id" then
		deniedMessage(sender, steamID .. tostring(args.player:GetSteamId()))
	end
	
	if(cmd_args[1]) == "/ptp" then
		if #cmd_args < 2 then
			deniedMessage(sender, invalidArgs)
			return false
		end
	
		local player = Player.Match(cmd_args[2])[1]
		if not IsValid(player) then
			deniedMessage(sender, nullPlayer)
			return false
		end
		
		if(player:GetName() == sender:GetName()) then
			deniedMessage(sender, "You cannot teleport to yourself.")
			return false
		end
		
		args.player:Teleport(player:GetPosition(), player:GetAngle())
		confirmationMessage(sender, playerTeleport .. tostring(player:GetName()))
		confirmationMessage(player, args.player:GetName() .. playerTele2)
		return true
	end
	
	if(cmd_args[1]) == "/online" then
		local count = 0
		playernames = ""
		for p in Server:GetPlayers() do
			count = count + 1
			playernames = p:GetName() .. ", " .. playernames
		end
		confirmationMessage(sender, "There are currently " .. count .. " players online right now.")
		confirmationMessage(sender, playernames)
		return true
	end
	
	if(cmd_args[1]) == "/sky" then
		if #cmd_args < 2 then
			local pos = args.player:GetPosition()
			args.player:Teleport(Vector3(pos.x, pos.y + 800, pos.z), args.player:GetAngle())
			confirmationMessage(sender, "Weee!")
			return true
		else 
			if(isAdmin(args.player)) then
				local player = Player.Match(cmd_args[2])[1]
				if not IsValid(player) then
					args.player:SendChatMessage(nullPlayer)
					return false
				end
				
				local pos = player:GetPosition()
				player:Teleport(Vector3(pos.x, pos.y + 800, pos.z), player:GetAngle())
				confirmationMessage(player, args.player:GetName() .. " shot you up into the sky.")
				confirmationMessage(sender, "You sent " .. player:GetName() .. " into the sky.")
				return true
			else
				deniedMessage(sender, invalidPermissions)
				return true
			end
		end
	end
	
	if(cmd_args[1]) == "/test" then
		if(isAdmin(args.player)) then
			confirmationMessage(sender, "It worked!")
		else 
			deniedMessage(sender, "No, you're not an administrator.")
		end
	end
	
	if(cmd_args[1]) == "/clear" then
		if #cmd_args < 2 then
			sender:ClearInventory()
			confirmationMessage(sender, "Your inventory has been cleared.")
			return true
		end
		if #cmd_args >= 2 then
			if not isAdmin(sender) then
				deniedMessage(sender, invalidPermissions)
				return false
			end
			
			player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				deniedMessage(sender, nullPlayer)
				return false
			end
			
			player:ClearInventory()
			confirmationMessage(player, "Your inventory was cleared by " .. sender:GetName())
			confirmationMessage(sender, "You cleared " .. player:GetName() .. "'s inventory.")
			return true
		end
	end
	
	if(cmd_args[1]) == "/pinkmobile" then
	
		if not sender:GetVehicle() then
			deniedMessage(sender, inVehicle)
			return false
		end
		
		if sender:GetMoney() >= 300 then
			sender:SetMoney(sender:GetMoney() - 300)
			confirmationMessage(sender, "$300 has been taken from your account. Enjoy your Pink Mobile.")
			
			veh = sender:GetVehicle()
			veh:SetColors(Color(255, 62, 150), Color(205, 41, 144))
			veh:Respawn()
			sender:EnterVehicle(veh, VehicleSeat.Driver)
			return true
		else
			deniedMessage(sender, "You need at least $300 to purchase a pinkmobile.")
		end
	end
	
	if(cmd_args[1]) == "/down" then
		pos = sender:GetPosition()
		sender:Teleport(Vector3(pos.x, pos.y - 10,  pos.z), sender:GetAngle())
		confirmationMessage(sender, "Down we go.")
	end
		
	
	if(isAdmin(args.player)) then
		local text = args.text
		if string.sub(text, 1, 1) ~= "/" then
			Chat:Broadcast(adminPrefix .. args.player:GetName() .. ": " .. text, Color(255, 48, 48))
			return false
		end
	end
	

end

admin = admin()
