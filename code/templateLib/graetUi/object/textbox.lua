local textbox = {
    params = {},
}

function textbox:new(elements, x, y, sx, sy, anchor, font, updateField)
    local obj = {
        selected = false,
        collider = elements.rectangleCollider:new(0, 0, sx, sy),
        text = "",
        font = font or love.graphics.newFont(12),
        updateField = updateField,
        anchor = anchor or {
            0, 0
        },
        position = {
            x = x,
            y = y,
        }
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function textbox:onClickOff()
    if self.selected == true then
        if self.updateField then self.updateField(self.text) end
        self.selected = false
    end
end

function textbox:onClicked()
    self.selected = true
end

function textbox:draw(x, y)
    if self.selected == true then
        love.graphics.setColor(1,1,1)
    else
        love.graphics.setColor(1,1,1,.6)
    end

    love.graphics.rectangle("fill", x, y, self.collider.sx, self.collider.sy)

    love.graphics.setColor(0, 0 , 0, 1)
    love.graphics.setFont(self.font)

    love.graphics.print(self.text, x+10, y)

end

function textbox:textinput(key)
    if self.selected then
        self.text = self.text .. key
        if self.updateField then self.updateField(self.text) end
        return true
    end
end

function textbox:keypressed(key)
    if self.selected then
        if key == "return" or key == "escape" then
            if self.updateField then self.updateField(self.text) end
            self.selected = false
            return true
       
        elseif key == "backspace" then
            self.text = string.sub(self.text, 0, #self.text - 1)  
            if self.updateField then self.updateField(self.text) end
            return true
        end
    end
end

return textbox