local g = {}

local ui

function g.load()
    gameSettings.fade = -1

    screen.load({
        {
            name = "",
            scaleType = "fill",
            useOffset = false,
            isBoarderd = false,
            targetWidth = 1920*2,
            targetHeight = 1080*2,
        },
    })

    love.mouse.setVisible(true)


    ui = graetUI:newUI()

    -- add text buttons for each gamemode here
    local gamemodes = love.filesystem.getDirectoryItems("gamemode")

    local currentFont = font.getFont("kulimPark", 250)
    for i = 1,#gamemodes do
        ui:newObject("textButton", gamemodes[i], 0, 650 + (i-1)*300, gamemodes[i], currentFont, {.5,0}, function() gameSettings = dofile("gamemode/" .. gamemodes[i]); gameStateManager.setGameState(gameSettings.gamemode .. "Menu") end, {1,1,1})
    end

end


function g.mousepressed(x, y, button)
    ui:toggleClick(true)
end

function g.mousereleased(x, y, button)
    ui:toggleClick(false)
end

function g.update(dt)
    ui:checkHover("")
end


function g.draw()
    font.setFont("kulimPark", 400)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1,1,1)
    love.graphics.printf("singularitycraft", 0, 150, 1920*2, "center")


    ui:draw()
end

return g