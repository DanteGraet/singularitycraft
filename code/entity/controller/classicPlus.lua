local c = {
    input = {
        target = {0,0}
    },

    maxOffsetDistance = 10,
    minOffsetDistance = 10,
    offsetDistance = 10,
    offsetDirection = math.rad(math.random(1, 360)),
    changeDir = 0,
    changeDis = 0,
}

function c.update(self, enemy, dt)
    c.input = {
        target = {0,0}
    }

    if not self.body or not enemy.body then
        return
    end
    local g = self.hotbar.items[self.hotbar.selectedItem]


    if not c.gunStats then
        c.gunStats = {
            range = g.bulletSpeed*g.bulletLife
        }

        c.maxOffsetDistance = math.min(c.gunStats.range/2, 1000)
        c.minOffsetDistance = math.min(c.gunStats.range/10, 500)
    end

    c.changeDir = math.max(math.abs(c.changeDir) - dt, 0) * quindoc.sign(c.changeDir)
    c.changeDis = math.max(math.abs(c.changeDis) - dt, 0) * quindoc.sign(c.changeDis)

    if c.changeDir == 0 then
        c.changeDir = math.random(-50, 50)/100
    end
    if c.changeDis == 0 then
        c.changeDis = math.random(-50, 50)/100
    end

    c.offsetDistance = quindoc.clamp(c.offsetDistance + quindoc.sign(c.changeDis)*dt*25, c.minOffsetDistance, c.maxOffsetDistance)
    c.offsetDirection = (c.offsetDirection + quindoc.sign(c.changeDis)*dt) % (math.pi*2)

    local x, y =    self.body:getX(), self.body:getY()
    local ex, ey =  enemy.body:getX(), enemy.body:getY()
    local distToEnemy = quindoc.pythag(x, y, ex, ey)

    local targetPosition = {math.cos(c.offsetDirection)*c.offsetDistance,math.sin(c.offsetDirection)*c.offsetDistance}
    if g.bulletCount <= 0 then
        -- run
        targetPosition = {targetPosition[1] - ex, targetPosition[2] - ey}
    else
        --chase
        targetPosition = {targetPosition[1] + ex, targetPosition[2]+ ey}
    end

    if targetPosition[1] < -960 then targetPosition[1] = targetPosition[1] + 960 end
    if targetPosition[1] > 960 then targetPosition[1] = targetPosition[1] - 960 end

    if targetPosition[2] < -540 then targetPosition[2] = targetPosition[2] + 540 end
    if targetPosition[2] >  540 then targetPosition[2] = targetPosition[2] - 540 end

    if targetPosition[1] < x then
        c.input.left = true
    else
        c.input.right = true
    end

    if targetPosition[2] < y then
        c.input.down = true
    else
        c.input.up = true
    end

    c.input.target = {ex, ey}
    if distToEnemy < c.gunStats.range then
        c.input.primary = true
    end

    if distToEnemy > c.gunStats.range or g.bulletCount <= 0  then
        -- always try to reload
        c.input.secondary = true
        c.input.primary = false
    end
end

return c