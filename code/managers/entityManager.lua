local entityManager = {}

local entityComponents = {}
local entityTypes = {}
local entities = {}

local nextEntityID = 0


function entityManager.getComponent(component, ...)
    if not entityComponents[component] then
        local componentPath = "code/entity/component/" .. component .. ".lua"

        if love.filesystem.getIdentity(componentPath) then

            entityComponents[component] = love.filesystem.load(componentPath)()

        else

            debug.print("entityManager: No such component '" .. component .. "' found")
            return nil

        end
    end

    return entityComponents[component]:new(...)
end

function entityManager.getEntity(entityType)
    -- check the entity type exists could be done in another function
    if not entityTypes[entityType] then
        local entityPath = "code/entity/type/" .. entityType .. ".lua"

        if love.filesystem.getIdentity(entityPath) then
            entityTypes[entityType] = love.filesystem.load(entityPath)()
        else

            debug.print("entityManager: No such entity type '" .. entityType .. "' found")
            return nil
        end
    end

    return entityTypes[entityType]
end

function entityManager.summon(entityType, addToEntityList, x, y, ...)
    local entity = entityManager.getEntity(entityType):new(...) 

    physicsManager.addObjectToWorld(entity, entity.shape, x, y, "dynamic")

    if addToEntityList then
        entities["e" .. nextEntityID] = entity
        nextEntityID = nextEntityID + 1
    end

    return entity
end

function entityManager.load()
    entityComponents = {}
    entityTypes = {}
    entities = {}

    nextEntityID = 0
end

--[[function entityManager.getClosestEntityOnLine(xPosition, yPosition, sx, sy, exclusionTags)
    local entity = nil
    local currentClosestDistance = math.huge
    local cx, cy = 0,0
    for key, value in pairs(entities) do
        
        if not (value.xPosition and value.yPosition and value.collisionRadius) then
            goto checkClosestNextEntity
        end 

        for i = 1,#exclusionTags do
            if value.tags[exclusionTags[i] ] == true then
                goto checkClosestNextEntity
            end
        end

        local percentageThroughLine = ( - sx * ( xPosition - value.xPosition ) - sy * ( yPosition - value.yPosition ) ) / ( sx * sx + sy * sy )

        percentageThroughLine = quindoc.clamp(percentageThroughLine, 0, 1)

        local closestX = xPosition + sx*percentageThroughLine
        local closestY = yPosition + sy*percentageThroughLine

        local distanceToLine = quindoc.pythag(closestX, closestY, value.xPosition, value.yPosition)

        if distanceToLine < value.collisionRadius then
            local distFromLineOrigin = quindoc.pythag(closestX, closestY, xPosition, yPosition)

            if distFromLineOrigin < currentClosestDistance then
                currentClosestDistance = distFromLineOrigin
                entity = entities[key]
                cx = closestX
                cy = closestY
            end
        end

        ::checkClosestNextEntity::
    end

    return entity, cx, cy
end]]

function entityManager.update(dt)
    for id, entity in pairs(entities) do
        if entity.update then
            entity:update(dt)

            if entity.kill == true then
                entity.body:destroy()
                
                if entity.onDeath then entity:onDeath() end
                entities[id] = nil
            end
        end
    end
end

function entityManager.draw()
    for id, entity in pairs(entities) do
        if entity.draw then
            entity:draw()
        else
            dante.printTable(entity, id)
        end
    end
end

return entityManager