local image = love.graphics.newCanvas(20, 20)
love.graphics.setCanvas(image)
love.graphics.setColor(1,1,1)
love.graphics.circle("fill", 10, 10, 10)
love.graphics.setCanvas()


local dust = love.graphics.newParticleSystem(image, 500)

dust:setParticleLifetime(.25, 1)
dust:setSizes(1, 0)
dust:setColors(0, 0, 0, 1, 0, 0, 0, 0) -- yellow to transparent
dust:setLinearDamping(1.5, 2.5)
dust:setOffset(10, 10)
dust:setSpeed(25, 75)
dust:setSpread(math.pi/3)
dust:setRelativeRotation(false)

return dust