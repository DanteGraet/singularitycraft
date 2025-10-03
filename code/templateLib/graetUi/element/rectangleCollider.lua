local debugColours = {
    none = {0,0,1},
    hover = {0,1,0},
    clicked = {1,0,0},
}

local rectangleCollider = {}

function rectangleCollider:new(x, y, sx, sy)
    local obj = {
        x = x,
        y = y,
        sx = sx,
        sy = sy,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function rectangleCollider:checkHover(x, y)
    return x > self.x and  x < self.x + self.sx and y > self.y and y < self.y + self.sy
end

function rectangleCollider:drawDebug(x, y, mouseState)
    love.graphics.setColor(debugColours[mouseState or "none"])
    love.graphics.rectangle("line", x + self.x, y + self.y, self.sx, self.sy)
end

return rectangleCollider