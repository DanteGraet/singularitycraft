local Bullet = {}

local bulletShapes = {}

function Bullet:new(radius,  rotation, damage, lifeTime, speed, image, team)
    local obj = setmetatable({}, Bullet)
    self.__index = self

    if not bulletShapes[tostring(radius)] then
        bulletShapes[tostring(radius)] = love.physics.newCircleShape(radius)
    end

    obj.radius = radius
    obj.shape = bulletShapes[tostring(radius)]

    obj.objectType = "bullet"
    obj.team = team


    obj.damage = damage

    obj.life = lifeTime

    obj.speed = speed
    obj.rotation = rotation

    return obj
end

function Bullet:postPhysicsInsertion()
    self.fixture:setRestitution(1)

    self.body:setMass(0.1)
    self.body:setLinearVelocity(math.cos(self.rotation)*self.speed, math.sin(self.rotation)*self.speed)

    self.rotation = nil
    self.speed = nil

    self.body:setUserData(self) 

    self.fixture:setSensor(false)
    self.fixture:setFriction(0)

    local isPlayer = self.team == "player"
    self.fixture:setCategory((isPlayer and 5) or 9)
    self.fixture:setMask(5, 9, (isPlayer and 4) or 8)
end


function Bullet:update(dt)
    self.life = self.life - dt

    if self.life <= 0 then
        self.kill = true
    end
end

function Bullet:draw()
    if self.team == "player" then
        love.graphics.setColor(.4,.2,.5, self.life*10)
    else
        love.graphics.setColor(.6,.2,.1, self.life*10)
    end
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius)
end

return Bullet