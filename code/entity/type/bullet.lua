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

function Bullet:beginContactWithObject(objectType, object, collision)
    if objectType == "charachter" then
        object.health:takeDamage(object, self.damage)
        self.kill = true
        collision:setEnabled(false)

        return
    else

    end
end

function Bullet:draw()
    local c = colours[self.team]
    love.graphics.setColor(c[1],c[2],c[3], self.life*10)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius)
end

return Bullet