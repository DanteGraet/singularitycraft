local physicsManager = {}

local physicsWorld
local walls

local worldBoarder = {}

function physicsManager.load()
    math.random(os.time(), love.timer.getTime())
    -- delete evrything
    if physicsWorld then
        physicsWorld:destroy()
    end

    love.physics.setMeter( 100 ) -- shape sizes from 1 to 1000 pls

    physicsWorld = love.physics.newWorld()
    physicsWorld:setCallbacks( physicsManager.beginContact, physicsManager.endContact, physicsManager.preSolve, physicsManager.postSolve )

    -- create the world boarder
    local boarderWidth = 50
    local worldBoarderShape = love.physics.newChainShape(true, {
        960 - boarderWidth, 540 - boarderWidth,
        -960 + boarderWidth, 540 - boarderWidth,
        -960 + boarderWidth, -540 + boarderWidth,
        960 - boarderWidth, -540 + boarderWidth,
    })

    physicsManager.addObjectToWorld(worldBoarder, worldBoarderShape)

    walls = love.filesystem.load("code/worldGan/classic.lua")()(physicsManager)
    --worldBoarder.body = love.physics.newBody(physicsWorld, 0, 0, "static")
    --worldBoarder.fixture = love.physics.newFixture(worldBoarder.body, worldBoarderShape)
end

function physicsManager.unload()
    if physicsWorld then
        physicsWorld:destroy()
    end
end

function physicsManager.addObjectToWorld(object, shape, x, y, type)
    object.body = love.physics.newBody(physicsWorld, x or 0, y or 0, type or "static")
    object.body:setFixedRotation(true)
    object.fixture = love.physics.newFixture(object.body, shape)
    object.fixture:setFriction(0)

    if object.postPhysicsInsertion then
        object:postPhysicsInsertion()
    end
end

function physicsManager.update(dt)
    physicsWorld:update(dt)
end

function physicsManager.drawWorld()
    love.graphics.setColor(0,0,0)

    for i = 1,#walls do
        local body = walls[i].body
        local shape = walls[i].fixture:getShape()
        local shapeType = shape:getType()

        if shapeType == "polygon" then
            love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
        else
            print("no shape tyupe" ..shapeType)
        end
    end
end

function physicsManager.drawColliders()
    -- man i love the internet
     for _, body in ipairs(physicsWorld:getBodies()) do
        for _, fixture in ipairs(body:getFixtures()) do
            local shape = fixture:getShape()
            local shapeType = shape:getType()

            love.graphics.setColor(1, 1, 1)

            if shapeType == "circle" then
                local x, y = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("line", x, y, shape:getRadius())

            elseif shapeType == "polygon" then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))

            elseif shapeType == "edge" then
                love.graphics.line(body:getWorldPoints(shape:getPoints()))

            elseif shapeType == "chain" then
                local points = {body:getWorldPoints(shape:getPoints())}
                love.graphics.line(points)
            end
        end
    end
end

-- https://love2d.org/wiki/Contact
function physicsManager.beginContact(a, b, collision)
    local aData = a:getBody():getUserData()
    local bData = b:getBody():getUserData()

    if (aData and bData) and ((aData.objectType == "charachter" and bData.objectType == "bullet") or (aData.objectType == "bullet" and bData.objectType == "charachter")) then
        local charBody, bulletBody
        if aData.objectType == "charachter" then
            charBody = aData
            bulletBody = bData
        else
            bulletBody = aData
            charBody = bData
        end

        charBody.health:takeDamage(charBody, bulletBody.damage)
        bulletBody.kill = true
        collision:setEnabled(false)
        return
    end

    if aData and aData.objectType == "charachter" then
        local body = a:getBody()
        local vx, vy = body:getLinearVelocity()
        local nx, ny = collision:getNormal( )

        if ny < 0 then  -- falling down
            body:setLinearVelocity(vx, -600*(aData.bounceMultiplyer + 0.5*math.min((aData.bounceEffectiveness+0.2), 1)) - math.abs(vx/5))
        end
        return

    elseif aData and aData.objectType == "bullet" then
        local body = a:getBody()
        local vx, vy = body:getLinearVelocity()
        local nx, ny = collision:getNormal( )
        --body:setLinearVelocity(math.abs(vx)*nx, math.abs(vy)*ny)
       -- print(nx, ny)

       return
    end

    if bData and bData.objectType == "charachter" then
        local body = b:getBody()
        local vx, vy = body:getLinearVelocity()
        local nx, ny = collision:getNormal( )
        local x, y = collision:getPositions()

        if ny < 0 then  -- falling down
            body:setLinearVelocity(vx, -600*(bData.bounceMultiplyer + 0.5*math.min((bData.bounceEffectiveness+0.2), 1)) - math.abs(vx/5))

            particleSystem.emit("dust", math.floor(bData.bounceEffectiveness*25 + math.abs(vx/500)), x, y, -math.pi/2)
        end
        return
    elseif bData and bData.objectType == "bullet" then
        local body = b:getBody()
        local vx, vy = body:getLinearVelocity()
        local nx, ny = collision:getNormal( )
        --body:setLinearVelocity(math.abs(vx)*nx, math.abs(vy)*ny)
        --print(nx, ny)
        return
    end
end

function physicsManager.endContact(a, b, collision)

end

function physicsManager.preSolve(a, b, collision)

end

function physicsManager.postSolve(a, b, collision, normalImpulse, tangentImpulse)

end



physicsManager.load()
    

return physicsManager
