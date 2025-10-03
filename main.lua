function love.resize(width, height)
    -- update screen
    screen.update()
end

function love.keypressed(key)
	if key == "f11" then
		love.window.setFullscreen(not love.window.getFullscreen()) 
		return true
	end
end


function love.run()
    love.filesystem.load("load.lua")()

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0
    local gameState = gameStateManager.updateGameState() or {}

	-- Main loop time.
	return function()
        -- update gameState here, update will be using it
        gameState = gameStateManager.updateGameState() or gameState

		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end

				if love[name] then
					if love[name](a,b,c,d,e,f) ~= true then
						if gameState[name] then
							gameState[name](a,b,c,d,e,f)
						end
					end
				else
                	--love.handlers[name](a,b,c,d,e,f)
					if gameState[name] then
					gameState[name](a,b,c,d,e,f)
					end	
				end
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
		if gameState.update then gameState.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			--love.graphics.origin()
            --love.graphics.reset()
			love.graphics.clear(love.graphics.getBackgroundColor())


            if screen.draw then screen.draw(gameState) end
			

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end