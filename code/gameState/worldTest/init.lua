local g = { noTransform = true,}

mouseImage = {}
local mouseImagePath = love.filesystem.getDirectoryItems("image/mouse")
for i = 1,#mouseImagePath do
    local name = mouseImagePath[i]:gsub("%.png$", "")
    mouseImage[name] = love.graphics.newImage("image/mouse/" .. mouseImagePath[i])
end

function g.load()
    screen.load({
        {
            name = "",
            scaleType = "fit",
            scale = 1,
            useOffset = false,
            isBoarderd = false,
            anchor = {0.5,0.5}
        },
        {
            name = "UI",
            scaleType = "fit",
            scale = 1,
            useOffset = true,
            isBoarderd = false,
            targetWidth = 1920*2,
            targetHeight = 1080*2,
        },
    })

    entityManager = love.filesystem.load("code/managers/entityManager.lua")()
    itemManager = love.filesystem.load("code/managers/itemManager.lua")()
    physicsManager = love.filesystem.load("code/managers/physicsManager.lua")()

    particleSystem = love.filesystem.load("code/particle/init.lua")()

    --camera = love.filesystem.load("code/camera.lua")()


    playerController = love.filesystem.load("code/entity/controller/player.lua")()
    player = entityManager.summon("canvasEntity", false, -800, 0, "player", love.filesystem.load("code/item/gunStats/" .. gameSettings.playerGun .. ".lua")())
    
    enemyController = love.filesystem.load("code/entity/controller/classic.lua")()     -- temporaty trust me
    enemy =  entityManager.summon("canvasEntity", false, 800, 0, "enemy", love.filesystem.load("code/item/gunStats/" .. gameSettings.enemyGun .. ".lua")())

    love.mouse.setVisible(false)
end

function g.unload()
    physicsManager.unload()
    love.mouse.setVisible(true)
end


function g.keypressed(key)
    playerController.keypressed(key)

    if key == 'r' then
        gameStateManager.setGameState("classicMenu")
    end
end
function g.keyreleased(key)
    playerController.keyreleased(key)
end
function g.mousepressed(x, y, button)
    playerController.mousepressed(button)
end
function g.mousereleased(x, y, button)
    playerController.mousereleased(button)
end


function g.update(dt)
    playerController.update(player, enemy, dt)
    enemyController.update(enemy, player, dt)

    local playerAlive = player:update(dt, playerController.input)
    local enemyAlive  = enemy:update(dt,  enemyController.input)

    if not (playerAlive and enemyAlive) and gameSettings.fade < 0 then
        gameSettings.onGameOver((playerAlive and player) or enemy, (enemyAlive and player) or enemy)
    end

    entityManager.update(dt)
    particleSystem.update(dt)

    physicsManager.update(dt)

    if gameSettings.fade >= 0 then
        gameSettings.fade = gameSettings.fade + dt
        if gameSettings.fade >= 1 then
            gameStateManager.setGameState(gameSettings.gamemode .. "Menu")

        end
    end
end


function g.draw()
    local boarderWidth = 50
    love.graphics.setColor(colours.background)
    love.graphics.rectangle("fill", -960 + boarderWidth, -540 + boarderWidth, 1920 - boarderWidth*2, 1080 - boarderWidth*2)
    
    player:draw()
    enemy:draw()
    physicsManager.drawWorld()

    entityManager.draw()

    particleSystem.draw()
end

function drawMouse(mx, my) end -- this function changes for some reason, dont delete it pls

function g.drawUI(w, h, ox, oy)
    local mx, my = screen.translatePosition(love.mouse.getX(), love.mouse.getY(), "UI")

    drawMouse(mx, my)

    if gameSettings.fade >= 0.5 then
        love.graphics.setColor(0,0,0, tweens.sineIn(gameSettings.fade*2 - 1))
        love.graphics.rectangle("fill", 0 - ox, 0 - oy, w + ox*2, h + oy*2)
    end
 
end


return g