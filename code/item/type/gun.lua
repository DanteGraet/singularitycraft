local CanvasItem = itemManager.getItem("canvasItem")

local Gun = setmetatable({}, {__index = CanvasItem})
Gun.__index = Gun

function Gun:new(team, data)
    -- call parent constructor
    local obj = CanvasItem:new()
    
    setmetatable(obj, self)

    obj.radius = 10
    obj.reloadTime = 3
    obj.reloadTimer = 0

    obj.bulletCount = 6
    obj.maxBulletCount = 6
    obj.bulletsFired = 1

    obj.fireTime = .5
    obj.fireTimer = 0

    obj.accuracy = 10


    obj.bulletLife = 2.4
    obj.bulletSpeed = 1000
    obj.damage = 10

    obj.recoil = 0

    dante.mergeTables(obj, data)

    obj.team = team


    return obj
end


function Gun:usePassive(entity, dt) 
    self.fireTimer = math.max(self.fireTimer - dt, 0)
end


function Gun:startPrimary(entity) 
    if self.bulletCount > 0 then
        drawMouse = function(mx, my)
            love.graphics.setColor(0,0,0)
            love.graphics.draw(mouseImage.shootOutline, mx, my, 0, 1, 1, 78/2, 78/2)
            love.graphics.setColor(.3,.5,.6)
            love.graphics.draw(mouseImage.shoot, mx, my, 0, 1, 1, 78/2, 78/2)
        end
    end
end

function Gun:endPrimary(entity) 
    drawMouse = function(mx, my)
        love.graphics.setColor(0,0,0)
        love.graphics.draw(mouseImage.aimOutline, mx, my, 0, 1, 1, 78/2, 78/2)
        love.graphics.setColor(.3,.5,.6)
        love.graphics.draw(mouseImage.aim, mx, my, 0, 1, 1, 78/2, 78/2)
    end
end

function Gun:usePrimary(entity, dt) 
    self.fireTimer = math.max(self.fireTimer - dt, 0)

    if self.fireTimer <= 0 and self.bulletCount > 0 then
        self.fireTimer = self.fireTime

        for i = 1,math.min(self.bulletCount, self.bulletsFired) do
            local mx, my = screen.translatePosition(love.mouse.getX(), love.mouse.getY(), "")
            local ex, ey = entity.body:getPosition()

            local angleOffset = math.rad(math.random(-self.accuracy*1000, self.accuracy*1000)/1000)
            local rotation = entity.angle + angleOffset
            --math.atan2(my-ey, mx-ex) + angleOffset

            if self.recoil ~= 0 then
                entity.body:applyLinearImpulse(-math.cos(rotation)*self.recoil, -math.sin(rotation)*self.recoil)
            end
            entityManager.summon("bullet", true,
                    entity.body:getX(), entity.body:getY(), self.radius,
                    rotation, 
                    self.damage, 
                    self.bulletLife, self.bulletSpeed, nil, self.team
                )
        end

        self.bulletCount = math.max(self.bulletCount - self.bulletsFired, 0)

        if self.bulletCount == 0 then
            drawMouse = function(mx, my)
                love.graphics.setColor(0,0,0)
                love.graphics.draw(mouseImage.aimOutline, mx, my, 0, 1, 1, 78/2, 78/2)
                love.graphics.setColor(.3,.5,.6)
                love.graphics.draw(mouseImage.aim, mx, my, 0, 1, 1, 78/2, 78/2)
            end
        end
    end
end


function Gun:startSecondary(entity) 
    self.reloadTimer = self.reloadTime

    drawMouse = function(mx, my)
        if self.reloadTimer > 0 and self.bulletCount < self.maxBulletCount then
            love.graphics.setColor(0,0,0)
            love.graphics.circle("fill", mx, my, 66/2)

            love.graphics.setColor(.3,.5,.6)
            love.graphics.circle("fill", mx, my, 66/2-6)

            
            love.graphics.setColor(0,0,0)
            love.graphics.circle("fill", mx, my, (60/2)*(self.reloadTimer/self.reloadTime))
        else
            love.graphics.setColor(0,0,0)
            love.graphics.draw(mouseImage.aimOutline, mx, my, 0, 1, 1, 78/2, 78/2)
            love.graphics.setColor(.3,.5,.6)
            love.graphics.draw(mouseImage.aim, mx, my, 0, 1, 1, 78/2, 78/2)
        end
    end
end

function Gun:endSecondary(entity) 
    self.reloadTimer = 0
    self.fireTimer = self.fireTime

    drawMouse = function(mx, my)
        love.graphics.setColor(0,0,0)
        love.graphics.draw(mouseImage.aimOutline, mx, my, 0, 1, 1, 78/2, 78/2)
        love.graphics.setColor(.3,.5,.6)
        love.graphics.draw(mouseImage.aim, mx, my, 0, 1, 1, 78/2, 78/2)
    end
end

function Gun:useSecondary(entity, dt) 
    if self.bulletCount < self.maxBulletCount then
        self.reloadTimer = math.max(self.reloadTimer - dt, 0)
    end

    if self.reloadTimer <=0 then
        self.bulletCount = self.maxBulletCount
    end
end

return Gun