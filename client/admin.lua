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