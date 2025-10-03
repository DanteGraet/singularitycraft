local wall = {}

function wall.distToWall(wall, x, y)
    --[[local direction = {wall.sx, wall.sy}
    local perpendicular = {
        wall.x - x + wall.sx(t)
        wall.y - y + wall.sy(t)
    }

    local dot = wall.sx(wall.x - x + wall.sx(t)) + wall.sy(wall.y - y + wall.sy(t)) = 0
    wall.sx(wall.x) - wall.sx(x) + wall.sx(wall.sx(t)) + wall.sy(wall.y) - wall.sy(y) + wall.sy(wall.sy(t)) = 0
    wall.sx(wall.sx(t)) + wall.sy(wall.sy(t)) = 0 - wall.sx(wall.x) + wall.sx(x) - wall.sy(wall.y) + wall.sy(y)
    t(wall.sx(wall.sx) + wall.sy(wall.sy)) = 0 - wall.sx(wall.x - x) - wall.sy(wall.y - y)]]
    local percentageThroughLine = ( - wall.sx * ( wall.x - x ) - wall.sy * ( wall.y - y ) ) / ( wall.sx * wall.sx + wall.sy * wall.sy )
    local p = quindoc.clamp(percentageThroughLine, 0, 1)

    local closestX = wall.x + wall.sx*p
    local closestY = wall.y + wall.sy*p

    return quindoc.pythag(closestX, closestY, x, y), closestX, closestY
end

function wall.isCollidingWithLine(wall, xInitial, yInitial, sx, sy)
    -- no idea why this ain't falling apart ¯\_(ツ)_/¯
    local sx, sy = -sx, -sy
    local tx, ty = wall.sx, wall.sy
    local cx, cy = wall.x - xInitial, wall.y - yInitial

    local denominator = tx * sy - ty * sx

    if denominator == 0 then
        return false -- parallel, no unique intersection
    end

    -- Solve for parameters
    local tw = (cx * sy - cy * sx) / denominator
    local tl = (cx * ty - cy * tx) / denominator

    -- Check if intersection lies on the segment (0 <= tl <= 1) 
    -- and same with wallf
    if tl >= 0 and tl <= 1 and tw <= 0 and tw >= -1 then
        local ix = xInitial - sx * tl
        local iy = yInitial - sy * tl
        return true, tl, ix, iy
    end
   
    return false
end

-- donno why this is in a function, something about good code ¯\_(ツ)_/¯
function wall.new(x, y, sx, sy)
    return {
        x = x,
        y = y,
        sx= sx,
        sy = sy,
    }
end

function wall.draw(wall)
    love.graphics.line(wall.x, wall.y, wall.x+wall.sx, wall.y+wall.sy)    
end


return wall