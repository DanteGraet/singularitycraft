--local drawDebug = true
--local mouseControll = true

--local clicked = false

--local ui = {}

graetUI = {}

-- load all elements
local elements = {}
elements.rectangleCollider =    require("code/templateLib/graetUi/element/rectangleCollider")
elements.circleCollider =       require("code/templateLib/graetUi/element/circleCollider")

local objects = {}
objects.textbox =              require("code/templateLib/graetUi/object/textbox")
objects.rectangleButton =              require("code/templateLib/graetUi/object/rectangleButton")





-- function
function graetUI:newUI(screenLayer)
    local obj = {
        ui = {},

        screenLayer = screenLayer,

        drawDebug = true,
        mouseControll = true,
        clicked = false,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function graetUI:newObject(type, id, ...)
    local b = objects[type]:new(elements, ...)
    b.id = id
    table.insert(self.ui, b)
end

function graetUI:reset(layer)
    if self.ui.mouseState == "clicked" then
        self.clicked = false
    end

    self.ui = {}
end

function graetUI:toggleClick(pressed)
    for i = 1,#self.ui do
        local b = self.ui[i]

        if pressed == true then
            if b.mouseState == "hover" then
                b.mouseState = "clicked"
                self.clicked = true

                if b.onClicked then b:onClicked(b.params.onClicked) end

                for j = 1,#self.ui do
                    if i ~= j then
                        local b = self.ui[j]
                        if b.onClickOff then b:onClickOff(b.params.onClickOff) end
                    end
                end

                return
            end
        else
            if b.mouseState == "clicked" then
                self.clicked = false
                self:checkHover(self.screenLayer)

                return

            end
        end
    end

    for j = 1,#self.ui do
        if self.ui[j].mouseState ~= "clicked" then
            local b = self.ui[j]
            if b.onClickOff then b:onClickOff(b.params.onClickOff) end
        end
    end
end

function graetUI:checkHover(screenLayer)
    if self.clicked == false then

        local mx, my = screen.translatePosition(love.mouse.getX(), love.mouse.getY(), screenLayer or "")
        local targetWidth, targetHeight, offsetX, offsetY = screen.getScaledSize(screenLayer or "")

        for i = 1,#self.ui do
            local b = self.ui[i]    

            if b.collider then
                local anchorX, anchorY = targetWidth * b.anchor[1],  targetHeight * b.anchor[2]
                local x = mx - anchorX - b.position.x --+ offsetX
                local y = my - anchorY - b.position.y --+ offsetY

                if b.collider:checkHover(x, y) then 
                    b.mouseState = "hover"

                    if b.onHover then b:onHover(b.params.onHover) end
                else
                    b.mouseState = "none"
                    if b.onReleased then b:onReleased(b.params.onReleased) end

                end
            end 
        end
    end
end

function graetUI:draw(layer)
    if not layer then layer = "" end

    local targetWidth, targetHeight, offsetX, offsetY = screen.getScaledSize(layer)

    -- draw the object
    for i = 1,#self.ui do
        local b = self.ui[i]

        local x = b.position.x +  targetWidth * b.anchor[1] -- offsetX
        local y = b.position.y + targetHeight * b.anchor[2] --- offsetY

        if b.draw then b:draw(x, y) end
    end

    -- draw all the debug later (here)
    if self.drawDebug then
        for i = 1,#self.ui do
            local b = self.ui[i]

            local x = b.position.x +  targetWidth * b.anchor[1] -- offsetX
            local y = b.position.y + targetHeight * b.anchor[2] -- offsetY

            if b.collider and b.collider.drawDebug then b.collider:drawDebug(x, y, b.mouseState) end

        end
    end
end

function graetUI:generalCallback(callback, ...)
    for i = 1,#self.ui do
        local b = self.ui[i]

        if b[callback] and b[callback](b, ...) then
            return true
        end
    end
end
