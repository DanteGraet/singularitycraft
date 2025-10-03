local physicsManager = {}

local physicsWorld
local walls

local worldBoarder = {objectType = "wall"}

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

    object.body:setUserData(object)

    if object.postPhysicsInsertion then
        object:postPhysicsInsertion()
    end
end

function physicsManager.update(dt)
    physicsWorld:update(dt)
end

function physicsManager.drawWorld()
    love.graphics.setColor(colours.wall)

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

-- have to fix this code
-- https://love2d.org/wiki/Contact
function physicsManager.beginContact(a, b, collision)
    local aData = a:getBody():getUserData()
    local bData = b:getBody():getUserData()

    if aData.beginContactWithObject then
        aData:beginContactWithObject(bData.objectType, bData, collision)
    end

    if bData.beginContactWithObject then
        bData:beginContactWithObject(aData.objectType, aData, collision)
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
