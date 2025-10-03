local camera = {
    xPosition = 0,
    yPosition = 0,
    scale = 0,
    screenWidth = love.graphics.getWidth(),
    screenHeight = love.graphics.getHeight(),
    veiwDistance = 0
}

function camera.setPosition(x, y, veiwDistance)
    camera.xPosition = x or camera.xPosition 
    camera.yPosition = y or camera.yPosition 
    camera.veiwDistance = veiwDistance
    camera.scale = (veiwDistance and math.min((camera.screenWidth)/(veiwDistance+50)/2, (camera.screenHeight)/(veiwDistance+50)/2)) or camera.scale
end

function camera.resize(w, h)
    camera.screenWidth = w
    camera.screenHeight = h
end

function camera.screenToWorld(x, y)
    local scale = camera.scale
    if love.keyboard.isDown("z") and DEV then
        scale = scale/2
    end

    -- undo translate
    local worldX = x / scale + camera.xPosition - camera.screenWidth / (2 * scale)
    local worldY = y / scale + camera.yPosition - camera.screenHeight / (2 * scale)

    return worldX, worldY
end

function camera.translateScreen()
    local scale = camera.scale
    if love.keyboard.isDown("z") and DEV then
        scale = scale/2
    end
    love.graphics.scale(scale)

    love.graphics.translate(-camera.xPosition + camera.screenWidth/2/scale, -camera.yPosition+ camera.screenHeight/2/scale)
end

return camera