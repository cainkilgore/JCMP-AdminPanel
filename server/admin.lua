class 'admin'

local adminPrefix = "[Admin] "

-- Change this value to whatever your STEAM ID is! (Type /id in-game)

local admins = { }
				
local admincount = 0

local invalidArgs = "You have entered invalid arguments."
local nullPlayer = "That player does not exist."
local kicked = " has been kicked from the server."
local moneyset = " money has been set to $"
local moneyadd = " money has been added to $"
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

local timerMessage = ""

-- Cain's Admin Commands and Functions
-- Version: 0.0.0.6

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

function admin:loadAdmins(filename)
	local file = io.open(filename, "r")
	local i = 0

	if file == nil then
		print("admins were not found!!")
		return
	end
	
	for line in file:lines() do
		i = i + 1
		
		if string.sub(text, 1, 2) ~= "--" then
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
			if(tostring(args.player:GetSteamId()) == adminId) then
				for p in Server:GetPlayers() do
					p:SetMoney(p:GetMoney() + 1000)
				end
				
				Chat:Broadcast(args.killer:GetName() .. " killed the Admin " .. args.player:GetName() .. ", everyone receives $1,000! (Except them, " ..  args.player:GetName() .. " doesn't like them)", Color(255, 0, 0))
			end
		else 
			if(tostring(args.player:GetSteamId()) == adminId) then
				for p in Server:GetPlayers() do
					p:SetMoney(p:GetMoney() + 1000)
				end
				Chat:Broadcast(args.player:GetName() .. " died terribly. Everyone receives $1,000!", Color(255, 0, 0))
			end
		end
	end
end

function admin:PlayerChat( args )
		
    local cmd_args = args.text:split( " " )
	
	if(isAdmin(args.player)) then
		if(cmd_args[1]) == "/kick" then
			if #cmd_args < 1 then
				args.player:SendChatMessage(invalidArgs, Color(255,255,0))
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				args.player:SendChatMessage(nullPlayer, Color(255, 0, 0))
				return false
			end
			
			Chat:Broadcast(player:GetName() .. kicked, Color(255, 0, 0))
			player:Kick()
			return true
		end
		
		if(cmd_args[1]) == "/setmoney" then
			if #cmd_args < 2 then
				args.player:SendChatMessage(invalidArgs, Color(255, 255, 255))
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				args.player:SendChatMessage(nullPlayer, Color(255, 255, 255))
				return false
			end
			
			player:SetMoney(tonumber(cmd_args[3]))
			args.player:SendChatMessage(cmd_args[2] .. moneyset .. cmd_args[3], Color(255, 0, 0))
			return true
		end
		 -- AddMoney 
		if(cmd_args[1]) == "/addmoney" then
			if #cmd_args < 2 then
				args.player:SendChatMessage(invalidArgs, Color(255, 255, 255))
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				args.player:SendChatMessage(nullPlayer, Color(255, 255, 255))
				return false
			end
			
			player:SetMoney(player:GetMoney() + tonumber(cmd_args[3]))
			args.player:SendChatMessage(cmd_args[2] .. moneyadd .. cmd_args[3], Color(255, 0, 0))
			return true
		end
		
		if(cmd_args[1]) == "/getmoney" then
			if #cmd_args < 2 then
				args.player:SendChatMessage(invalidArgs, Color(255, 0, 0))
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				args.player:SendChatMessage(nullPlayer, Color(255, 0, 0))
				return false
			end
			
			args.player:SendChatMessage(player:GetName() .. " currently has $" .. player:GetMoney() .. " in their bank.", Color(255, 0, 0))
			return true
		end
		
		if(cmd_args[1]) == "/forcepassenger" then
			if #cmd_args < 1 then
				args.player:SendChatMessage(invalidArgs, Color(255,0,0))
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				args.player:SendChatMessage(nullPlayer, Color(255, 0, 0))
				return false
			end
			
			if not args.player:GetVehicle() then
				args.player:SendChatMessage(inVehicle, Color(255, 0, 0))
				return false
			end
			
			player:EnterVehicle(args.player:GetVehicle(), VehicleSeat.Passenger)
			-- args.player:EnterVehicle(args.player:GetVehicle(), VehicleSeat.Passenger)
			args.player:SendChatMessage(playerInVehicle, Color(255,255,255))
			return true
		end
		
		if(cmd_args[1]) == "/ptphere" then
			if #cmd_args < 2 then
				args.player:SendChatMessage(invalidArgs, Color(255, 0, 0))
				return false
			end
			
			local player = Player.Match(cmd_args[2])[1]
			if not IsValid(player) then
				args.player:SendChatMessage(nullPlayer, Color(255, 0, 0))
				return false
			end
			
			player:Teleport(args.player:GetPosition(), args.player:GetAngle())
			player:SendChatMessage(args.player:GetName() .. playerTele, Color(255, 0, 0))
			args.player:SendChatMessage(player:GetName() .. playerTele2, Color(255, 0, 0))
			return true
		end
	end
	
	if(cmd_args[1]) == "/kill" then
		if #cmd_args < 2 then
			args.player:SetHealth(0)
			args.player:SendChatMessage(killedSelf, Color(255, 0, 0))
			return true
		end
		
		if #cmd_args > 1 then
			if(isAdmin(args.player)) then
				local player = Player.Match(cmd_args[2])[1]
				if not IsValid(player) then
					args.player:SendChatMessage(nullPlayer, Color(255, 0, 0))
					return false
				end
				
				player:SetHealth(0)
				player:SendChatMessage(args.player:GetName() .. playerKill,  Color(255, 0, 0))
				args.player:SendChatMessage(playerKill2 .. player:GetName(), Color(255, 0, 0))
				return true
			else 
				args.player:SendChatMessage(invalidPermissions, Color(255, 0, 0))
				return false
			end
		end
	end
	
	if(cmd_args[1]) == "/repair" then
		if not args.player:GetVehicle() then
			args.player:SendChatMessage(inVehicle, Color(255, 0, 0))
			return false
		end
		if(args.player:GetMoney() >= 300) then
			args.player:GetVehicle():SetHealth(1)
			args.player:SetMoney(args.player:GetMoney() - 300)
			args.player:SendChatMessage(vehicleRepaired, Color(200, 10, 200))
		else
			args.player:SendChatMessage(notEnoughMoneyRepair, Color(255, 0, 0))
		end
	end
	
	if(cmd_args[1]) == "/killcar" then
		if not args.player:GetVehicle() then
			args.player:SendChatMessage(inVehicle, Color(255, 0, 0))
			return false
		end
		if(args.player:GetMoney() >= 100) then
			args.player:GetVehicle():SetHealth(0)
			args.player:SetMoney(args.player:GetMoney() - 100)
			args.player:SendChatMessage(vehicleKilled, Color(200, 10, 200))
		else
			args.player:SendChatMessage(notEnoughMoneyKill, Color(255, 0, 0))
		end
	end
	
	if(cmd_args[1]) == "/id" then
		args.player:SendChatMessage(steamID .. tostring(args.player:GetSteamId()), Color(255, 255, 255))
	end
	
	if(cmd_args[1]) == "/ptp" then
		if #cmd_args < 2 then
			args.player:SendChatMessage(invalidArgs, Color(255, 0, 0))
			return false
		end
	
		local player = Player.Match(cmd_args[2])[1]
		if not IsValid(player) then
			args.player:SendChatMessage(nullPlayer, Color(255,0,0))
			return false
		end
		
		args.player:Teleport(player:GetPosition(), player:GetAngle())
		args.player:SendChatMessage(playerTeleport .. tostring(player:GetName()), Color(250, 0, 0))
		player:SendChatMessage(args.player:GetName() .. playerTele2, Color(250, 0, 0))
		return true
	end
	
	if(cmd_args[1]) == "/online" then
		local count = 0
		for p in Server:GetPlayers() do
			count = count + 1
		end
		args.player:SendChatMessage("There are currently " .. count .. " players online right now.", Color(255, 0, 0))
		return true
	end
	
	if(cmd_args[1]) == "/sky" then
		if #cmd_args < 2 then
			local pos = args.player:GetPosition()
			args.player:Teleport(Vector3(pos.x, pos.y + 800, pos.z), args.player:GetAngle())
			args.player:SendChatMessage("Weee!", Color(255, 0, 0))
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
				player:SendChatMessage(args.player:GetName() .. " shot you up into the sky.", Color(255, 0, 0))
				args.player:SendChatMessage("You sent " .. player:GetName() .. " into the sky.", Color(255, 0, 0))
				return true
			else
				args.player:SendChatMessage(invalidPermissions, Color(255, 0, 0))
				return true
			end
		end
	end
	
	if(cmd_args[1]) == "/test" then
		if(isAdmin(args.player)) then
			args.player:SendChatMessage("It worked!", Color(255, 0, 0))
		else 
			args.player:SendChatMessage("No permission. Dangit.", Color(255, 0, 0))
		end
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
