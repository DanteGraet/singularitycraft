local textGraphic = {}

function textGraphic:new(text, font, x, y, colour, anchor)
    local obj = {
        x = x,
        y = y,
        text = text,
        colour = colour,
        font = font
    }

    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight(text)

    obj.x = x - textWidth * anchor[1]
    obj.y = y - textHeight * anchor[2]


    setmetatable(obj, self)
    self.__index = self
    return obj, textWidth, textHeight
end

function textGraphic:draw(x, y, mouseState)
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.colour)
    love.graphics.print(self.text, x + self.x, y + self.y)
end

return textGraphic