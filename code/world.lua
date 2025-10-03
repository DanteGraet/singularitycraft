local fillType = "line"

local object = { 
        wall = love.filesystem.load("code/object/wall.lua")()
    }

local world = {
    -- chuknk
        -- objects &walls
}

local worldData = {}

function world.addRectWall(x, y, sx, sy, isTransparent)
    local chunk = tostring(math.floor(x/1000) .. "|" .. math.floor(y/1000))
    if not worldData then worldData = {} end

    table.insert(worldData, object.wall.new(x, y, sx, 0, isTransparent))
    table.insert(worldData, object.wall.new(x, y+sy, sx, 0, isTransparent))
    table.insert(worldData, object.wall.new(x, y, 0, sy, isTransparent))
    table.insert(worldData, object.wall.new(x+sx, y, 0, sy, isTransparent))
end

function world.load(pathToWorld)
    worldData = {
        
    }

    -- world boarder
    --local screenBaorder = 50
    --world.addRectWall(-960+screenBaorder, -540+screenBaorder, (960-screenBaorder)*2, (540-screenBaorder)*2)


    --world.addRectWall(-960+screenBaorder, -540+screenBaorder, (960-screenBaorder)*2, (540-screenBaorder)*2)

    --world.addRectWall(-150, 0, 300, 40)


--[[

    world.addRectWall(1512, 1496, 36, 20)
    world.addRectWall(1512, 1515, 20, 537)
    world.addRectWall(1531, 1940, 109, 12)

    world.addRectWall(1744, 1940, 396, 12)

    world.addRectWall(1740, 1496, 168, 20)
    world.addRectWall(1760, 1515, 12, 426)
    world.addRectWall(2124, 1496, 272, 20)


    world.addRectWall(2260, 1515, 12, 441)
    world.addRectWall(2248, 1940, 13, 12)
    world.addRectWall(2604, 1496, 128, 20)

    world.addRectWall(2712, 1515, 20, 585)
    world.addRectWall(2260, 2048, 16, 12)
    world.addRectWall(2271, 2052, 442, 12)

    world.addRectWall(2352, 2063, 12, 258)
    world.addRectWall(2260, 2320, 120, 12)
    world.addRectWall(2260, 2483, 12, 718)
    world.addRectWall(2476, 2320, 237, 12)
    world.addRectWall(2712, 2288, 20, 60)
    world.addRectWall(2488, 2331, 12, 25)

    world.addRectWall(2260, 2472, 28, 12)
    world.addRectWall(2400, 2472, 313, 12)
    world.addRectWall(2488, 2448, 12, 25)
    world.addRectWall(2712, 2456, 20, 128)
    world.addRectWall(2271, 2924, 442, 12)
    world.addRectWall(2712, 2820, 20, 116)
    world.addRectWall(2731, 2916, 92, 20)
    world.addRectWall(2804, 2935, 20, 49)
    world.addRectWall(2536, 2935, 12, 129)
    world.addRectWall(2248, 3200, 144, 12)
    world.addRectWall(2536, 3176, 12, 36)
    world.addRectWall(2547, 3200, 166, 12)
    world.addRectWall(2804, 3164, 120, 56)
    world.addRectWall(2712, 3200, 93, 20)
    world.addRectWall(2712, 3219, 20, 497)
    world.addRectWall(2612, 3696, 101, 20)
    world.addRectWall(1512, 2312, 20, 128)
    world.addRectWall(1420, 2420, 93, 20)
    world.addRectWall(1531, 2428, 149, 12)

    world.addRectWall(1668, 2439, 12, 201)
    world.addRectWall(2108, 2424, 12, 340)
    world.addRectWall(1132, 2420, 76, 20)
    world.addRectWall(1132, 2439, 20, 954)
    world.addRectWall(1112, 3392, 232, 20)
    world.addRectWall(1151, 2820, 518, 12)
    world.addRectWall(1668, 2784, 12, 124)
    world.addRectWall(1679, 2896, 321, 12)
    world.addRectWall(1896, 2907, 12, 170)
    world.addRectWall(1896, 3076, 224, 12)
    world.addRectWall(2108, 2888, 12, 189)
    world.addRectWall(2092, 2896, 17, 12)
    world.addRectWall(1692, 3392, 220, 20)
    world.addRectWall(1896, 3284, 12, 109)
    world.addRectWall(2108, 3200, 28, 12)
    world.addRectWall(2108, 3211, 12, 182)
    world.addRectWall(2076, 3392, 44, 20)
    world.addRectWall(2100, 3411, 20, 305)
    world.addRectWall(2119, 3696, 145, 20)
    world.addRectWall(688, 3392, 32, 20)


    --world.addRectWall("0|0", 1, 1, 1, 1)
    ]]
end

function world.resolveCollisionsInChunk(x, y, radius, direction)
    for i = 1,#worldData do
        local wall = worldData[i]
        local distance, closestX, closestY = object.wall.distToWall(wall, x, y)
        
        if distance < radius then

            local normalX = closestX - x
            local normalY = closestY - y

            local angle = direction or math.atan2(normalY, normalX)

            x, y = closestX - math.cos(angle)*(radius+0.01), closestY - math.sin(angle)*(radius+0.01)
        end
    end

    return x, y
end

function world.findFirstLineCollision(xInitial, yInitial, sx, sy)
    local closestPercentage = math.huge
    local x, y, wallAngle = xInitial + sx, yInitial + sy, nil

    for i = 1,#worldData do
        local wall = worldData[i]
        local isColliding, percentage, xCollision, yCollision = object.wall.isCollidingWithLine(wall, xInitial, yInitial, sx, sy)
        
        if isColliding and percentage < closestPercentage then
            closestPercentage = percentage

            x, y, wallAngle = xCollision, yCollision, math.atan2(wall.sy, wall.sx)
        end
    end

    return x, y, wallAngle
end

function world.draw(chunk, x, y, veiwX, veiwY)


    fillType = ((love.keyboard.isDown("f") and DEV) and "line") or "fill"

    love.graphics.setColor(1,1,1)

    for i = 1,#worldData do
        local wall = worldData[i]
        object.wall.draw(wall)
    end

    love.graphics.setColor(0,0,0)
    -- please clean up later
    --[[for chunk, data in pairs(worldData.chunk) do
        local chunkX, chunkY = dante.splitString(tostring(chunk), "|")
        chunkX = tonumber(chunkX)
        chunkY = tonumber(chunkY)

        local isXInRange = (x/1000 - veiwX/1000 - 2) <= chunkX and (x/1000 + veiwX/1000) >= chunkX
        local isYInRange = (y/1000 - veiwY/1000 - 2) <= chunkY and (y/1000 + veiwY/1000) >= chunkY

        if isXInRange and isYInRange then
            for i = 1,#data do
                if data[i].isTransparent == false then
                    local distance, closestX, closestY = object.wall.distToWall(data[i], x, y)
                    if distance <= veiwDistance then
                        local startAngle = math.atan2(data[i].y - y, data[i].x - x) 
                        local endAngle = math.atan2(data[i].y + data[i].sy - y, data[i].x + data[i].sx - x)


                        local remainingDistance = (veiwDistance - distance + 10) -- 10 px buffer
                        
                        local polygon = {
                            data[i].x + math.cos(startAngle)*remainingDistance,     data[i].y + math.sin(startAngle)*remainingDistance,
                            data[i].x, data[i].y,

                            data[i].x + data[i].sx, data[i].y + data[i].sy,

                            data[i].x + data[i].sx + math.cos(endAngle)*remainingDistance,     data[i].y + data[i].sy + math.sin(endAngle)*remainingDistance,
                        }

                        love.graphics.polygon(fillType, polygon)


                        local arcAngle = math.atan2(polygon[2] - polygon[8], polygon[1] - polygon[7])
                        local arcRadius = quindoc.pythag(polygon[1], polygon[2], polygon[7], polygon[8])/2
                        local arcCenter = {
                            (polygon[1] + polygon[7])/2,
                            (polygon[2] + polygon[8])/2,
                        }

                        local cameraWallAngle = math.atan2(y - arcCenter[2], x - arcCenter[1])
                        if (cameraWallAngle - arcAngle + math.pi) % (2 * math.pi) - math.pi < 0 then
                            love.graphics.arc(fillType, arcCenter[1], arcCenter[2], arcRadius, arcAngle, arcAngle+math.pi)
                        else
                            arcAngle = math.atan2(polygon[8] -polygon[2], polygon[7] - polygon[1])
                            love.graphics.arc(fillType, arcCenter[1], arcCenter[2], arcRadius, arcAngle, arcAngle+math.pi)
                        end
                    end
                end
            end
        end
    end]]

    love.graphics.setColor(1,1,1)



    love.graphics.setStencilTest()
    --love.graphics.rectangle("fill", camera.xPosition - 2000, camera.yPosition - 2000, 4000, 4000)

end


return world