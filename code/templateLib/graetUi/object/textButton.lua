local textButton = {
    params = {},
}

function textButton:new(elements, x, y, text, font, anchor, onClick, colour)
    local textElement, sx, sy = elements.textGraphic:new(text, font, 0,0, colour, anchor or {0, 0})
    local obj = {
        text = textElement,
        collider = elements.rectangleCollider:new(0- sx*anchor[1], 0- sy*anchor[2], sx, sy),
        onClick = onClick,
        anchor = anchor or {
            0, 0
        },
        position = {
            x = x ,
            y = y ,
        },
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end


function textButton:onClicked()
    if self.onClick then
        self.onClick()
    end
end

function textButton:draw(x, y)
    love.graphics.setColor(1,1,1)
    self.text:draw(x, y, self.mouseState)
end

return textButton