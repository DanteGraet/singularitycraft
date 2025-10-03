local CanvasEntity = {}

local gravity = 98*2
local horizontalFriction = 9.8

function CanvasEntity:new(team, gun)
    local entity = setmetatable({}, CanvasEntity)
    self.__index = self

    entity.gravity = gravity

    entity.angle = 0

    entity.health = entityManager.getComponent("health", 100)
    entity.hotbar = entityManager.getComponent("hotbar", 100)
    entity.hotbar:addItem("gun", team, gun)

    entity.shape = love.physics.newCircleShape(30)

    -- 'movement tech'
    entity.acceleration = 500
    entity.bounceMultiplyer = 1
    entity.bounceEffectiveness = 0

    entity.objectType = "charachter"
    entity.team = team

    return entity
end

function CanvasEntity:postPhysicsInsertion()
    self.body:setUserData(self)

    local isPlayer = self.team == "player"
    self.fixture:setCategory((isPlayer and 4) or 8)
    self.fixture:setMask(4, 8, (isPlayer and 5) or 9)
end

function CanvasEntity:manageInputs(input, dt)
    local input = input or {}
    local xDirection = 0

    if input.right == true then xDirection = xDirection + 1 end
    if input.left == true  then xDirection = xDirection - 1 end

    if input.up == true then
        if self.bounceEffectiveness == 0 then self.bounceEffectiveness = 1 end
        self.bounceEffectiveness = math.max(self.bounceEffectiveness-dt*5, 0.3)
    else
        self.bounceEffectiveness = 0
    end

    -- shooting
    local hotbarUse = "Passive"
    if input.primary == true then
        hotbarUse = "Primary"
    elseif input.secondary == true then
        hotbarUse = "Secondary"
    end

    return xDirection, hotbarUse
end


function CanvasEntity:update(dt, input)
    if self.body then
        local vx, vy = self.body:getLinearVelocity()
        local friction = -vx *0.9
        local fx, fy = 0, self.gravity
        

        local xDirection, hotbarUse = self:manageInputs(input, dt)

        fx = fx + xDirection*self.acceleration

        self.angle = math.atan2(input.target[2] - self.body:getY(), input.target[1] - self.body:getX())
        self.hotbar:update(self, hotbarUse, dt)


        fx = fx + friction

        self.body:applyForce(fx, fy)

        return true
    end

    return false
end

function CanvasEntity:bounce()
    
end

function CanvasEntity:onDeath()
    --gameSettings.onGameOver(self)
end

function CanvasEntity:draw()
    if self.body then
        if self.team == "player" then
            love.graphics.setColor(.4,.2,.5)
        else
            love.graphics.setColor(.6,.2,.1)
        end
        love.graphics.circle("fill", self.body:getX(), self.body:getY(), 30)
    end
end

function CanvasEntity:drawCollider()
    love.graphics.setColor(1,1,1)

    --love.graphics.circle("line", self.xPosition, self.yPosition, self.collisionRadius)
end

return CanvasEntity