local layers = {
    -- default layer
    {
        name = "",
        scaleType = "none",
        scale = 1,
        useOffset = false,
        isBoarderd = false,
    }
}

screen = {
    defaultTargetWidth = TARGET_WIDTH,
    defaultTargetHeight = TARGET_HEIGHT,
}

function screen.translatePosition(x, y, layer)
    for i = 1,#layers do
        if layers[i].name == layer then
            local l = layers[i]

            local offsetX, offsetY = l.offsetX or 0, l.offsetY or 0

            local translatedX = x / l.scale                 - offsetX
            local translatedY = y / (l.scaleY or l.scale)   - offsetY

            return translatedX, translatedY
        end
    end
end

function screen.getLayerList()
    local list = {}

    for i = 1,#layers do
        table.insert(list, layers[i].name)
    end
    
    return list
end

function screen.update()
    for i = 1,#layers do
        local layer = layers[i]

        local targetWidth, targetHeight = (layer.targetWidth or screen.defaultTargetWidth), (layer.targetHeight or screen.defaultTargetHeight)
        local scaleX, scaleY = love.graphics.getWidth() / targetWidth, love.graphics.getHeight() / targetHeight

        layer.scaleY = nil
        if layer.scaleType == "none" then
            layer.scale = 1
        elseif layer.scaleType == "fill" then
            layer.scale = math.max(scaleX, scaleY)
        elseif layer.scaleType == "fit" then
            layer.scale = math.min(scaleX, scaleY)
        elseif layer.scaleType == "streach" then
            layer.scale = scaleX
            layer.scaleY = scaleY
        end

        if layer.useOffset and layer.scaleType ~= "none" then
            layer.offsetX = ((love.graphics.getWidth() / layer.scale) - targetWidth)/2
            layer.offsetY = ((love.graphics.getHeight() / (layer.scaleY or layer.scale)) - targetHeight)/2
        else
            layer.offsetX, layer.offsetY = 0, 0
        end

        if layer.anchor then
            layer.offsetX = layer.offsetX + love.graphics.getWidth()*layer.anchor[1]/layer.scale
            layer.offsetY = layer.offsetY + love.graphics.getHeight()*layer.anchor[2]/(layer.scaleY or layer.scale)
        end
    end
end

function screen.load(layerData)
    layers = layerData or {{
        name = "",
        scaleType = "none",
        scale = 1,
        useOffset = false,
        isBoarderd = false,
        anchor = {0,0}
    }}
    
    screen.update()
end

function screen.getScaledSize(layer)
    for i = 1,#layers do
        if layers[i].name == layer then
            local l = layers[i]

            local targetWidth, targetHeight = (l.targetWidth or screen.defaultTargetWidth), (l.targetHeight or screen.defaultTargetHeight)
            local offsetX, offsetY = l.offsetX or 0, l.offsetY or 0

            if not l.useOffset and not l.isBoarderd then
                targetWidth = love.graphics.getWidth()/l.scale
                targetHeight = love.graphics.getHeight() / (l.scaleY or l.scale)
            end

            return targetWidth, targetHeight, offsetX, offsetY
        end
    end

    return 0, 0, 0, 0
end

function screen.draw(gameState)
    
    for i = 1,#layers do
        local layer = layers[i]

        local targetWidth, targetHeight = (layer.targetWidth or screen.defaultTargetWidth), (layer.targetHeight or screen.defaultTargetHeight)

        love.graphics.origin()

        love.graphics.scale(layer.scale, layer.scaleY or layer.scale)
        love.graphics.translate(layer.offsetX or 0, layer.offsetY or 0)

        -- draw the layer
        if layer.isBoarderd == true then
            love.graphics.setScissor((layer.offsetX or 0) * layer.scale, (layer.offsetY or 0) * layer.scale, targetWidth * layer.scale, targetHeight * (layer.scaleY or layer.scale))
            if gameState["draw" .. layer.name] then gameState["draw" .. layer.name](targetWidth, targetHeight, layer.offsetX or 0, layer.offsetY or 0) end
            love.graphics.setScissor()
        else
            if gameState["draw" .. layer.name] then gameState["draw" .. layer.name](targetWidth, targetHeight, layer.offsetX or 0, layer.offsetY or 0) end
        end

        
        --love.graphics.pop()
    end

end