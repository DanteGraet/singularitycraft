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

    local function start()
        math.randomseed(os.time(), love.timer.getTime())
        local choice = {
            "classic/classicPistol";      
            "classic/classicShotgun";     
            "classic/classicSniper";      
            "classic/classicMinigun";     
            "classic/classicFlamethrower";
        }
        gameSettings.enemyGun = choice[math.random(1,#choice)]
        gameStateManager.setGameState("worldTest")
    end

    ui = graetUI:newUI("")
    ui:newObject("rectangleButton", "selectPistol", -200, 0, 400, 400, {.5,.5}, function()        gameSettings.playerGun = "classic/classicPistol";        start() end, love.graphics.newImage("image/gun/pistol.png"))
    ui:newObject("rectangleButton", "selectShotgun", -800, 0, 400, 400, {.5,.5}, function()       gameSettings.playerGun = "classic/classicShotgun";       start() end, love.graphics.newImage("image/gun/shotgun.png"))
    ui:newObject("rectangleButton", "selectSniper", 400, 0, 400, 400, {.5,.5}, function()         gameSettings.playerGun = "classic/classicSniper";        start() end, love.graphics.newImage("image/gun/sniper.png"))
    ui:newObject("rectangleButton", "selectMinigun", -500, 500, 400, 400, {.5,.5}, function()     gameSettings.playerGun = "classic/classicMinigun";       start() end, love.graphics.newImage("image/gun/minigun.png"))
    ui:newObject("rectangleButton", "selectFlamethrower", 100, 500, 400, 400, {.5,.5}, function() gameSettings.playerGun = "classic/classicFlamethrower";  start() end, love.graphics.newImage("image/gun/flamethrower.png"))
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
    love.graphics.printf("classic", 0, 150, 1920*2, "center")

    font.setFont("kulimPark", 250)
    love.graphics.printf( (gameSettings.save.kills or 0) .. ":" .. (gameSettings.save.deaths or 0) , 0, 650, 1920*2, "center")

    ui:draw()
end

return g