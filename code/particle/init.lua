local particleSystems = {
    -- load each one from file here
    dust = love.filesystem.load("code/particle/dust.lua")()
}
local particleManager = {}

function particleManager.update(dt)
    for name, system in pairs(particleSystems) do
        particleSystems[name]:update(dt)
    end
end

function particleManager.draw(dt)
    for name, system in pairs(particleSystems) do
        love.graphics.draw(particleSystems[name])
    end
end

function particleManager.emit(name, count, x, y, r)
    if x and y then
        particleSystems[name]:setPosition(x, y)
    end
    if r then
        particleSystems[name]:setDirection(r)
    end
    particleSystems[name]:emit(count)
end

return particleManager