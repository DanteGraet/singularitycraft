local rectangleButton = {
    params = {},
}

function rectangleButton:new(elements, x, y, sx, sy, anchor, onClick, graphic)
    local obj = {
        collider = elements.rectangleCollider:new(0, 0, sx, sy),
        onClick = onClick,
        anchor = anchor or {
            0, 0
        },
        position = {
            x = x,
            y = y,
        },

        graphic = graphic,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end


function rectangleButton:onClicked()
    if self.onClick then
        self.onClick()
    end
end

function rectangleButton:draw(x, y)
    love.graphics.setColor(1,1,1)
    if self.graphic then
        if type(self.graphic) == "table" then
            self.graphic:draw(x, y)
        else
            love.graphics.draw(self.graphic, x, y)
        end
    else
        love.graphics.rectangle("fill", x, y, self.collider.sx, self.collider.sy)
    end
end

return rectangleButton