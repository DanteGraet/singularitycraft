local wallShape = love.physics.newRectangleShape(300, 40)
math.randomseed(os.time(), love.timer.getTime())

local walls = {}

return function(physicsManager)
    local y = 540 - 50 - math.random(180, 220)

    while y >= -540 + 50 + 120  do
        --physicsManager.addObjectToWorld(obj, wallShape, 0, y, "static")

        for i = 1,math.random(1, 2) do
            local x = math.random(-960 + 150, 150)
            local obj = {}
            local obj2 = {}

            physicsManager.addObjectToWorld(obj, wallShape, x, y, "static")
            physicsManager.addObjectToWorld(obj2, wallShape, x*-1, y, "static")

            table.insert(walls, obj)
            table.insert(walls, obj2)
        end

        y = y - math.random(180, 220)

    end

    return walls
end

