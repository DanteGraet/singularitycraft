local c = {
    input = {
        target = {0,0}
    },

    direction = 0
}

function c.update(self, enemy, dt)

    c.direction = math.max(math.abs(c.direction)-dt, 0)*quindoc.sign(c.direction)

    if c.direction == 0 then
        c.direction = (math.random(0, 1) == 1 and 1) or -1
    end

    if c.direction < 0 then
        c.input.left = true
        c.input.right = false 
    elseif c.direction > 0 then
        c.input.right = true
        c.input.left = false 
    end

    if enemy.body then
        c.input.target = {enemy.body:getX(), enemy.body:getY()}
    end


    c.input.primary = true
end

return c