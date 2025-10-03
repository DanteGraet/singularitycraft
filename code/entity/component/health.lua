local Health = {}

function Health:new(maxHitPoints)
    local health = setmetatable({}, Health)
    self.__index = self

    health.isInvincible =   false

    health.maxHitPoints =   maxHitPoints or 10
    health.hitPoints    =   health.maxHitPoints

    return health
end


function Health:takeDamage(parentEntity, amount, type)
    if self.isInvincible then return false end

    self.hitPoints = quindoc.clamp(self.hitPoints-amount, 0, self.maxHitPoints)    

    if self.hitPoints <= 0 then
        if parentEntity.body then
            parentEntity.kill = true
            parentEntity.body:destroy()
            parentEntity.body = nil
            parentEntity:onDeath()
        end
    end

    return true
end

return Health