local nextGameState = "classicMenu"

local textList = {
    string.upper("'Jaraph'"),
}

local timer

local squares = {
    {x = 0, y = 0,      timeOffset = 0.2  + 0.1,       s = { -.5, -.5, -.5, .5, -.5, -.5, .5, -.5 }},
    {x = 1, y = 1,      timeOffset = 0.2  + 2.2,       s = { 1.5, 1.5, 1.5, 0.5,  0,  0, 0.5, 1.5 }},
    {x = 2, y = 2,      timeOffset = 0.2  + 0.3,       s = { 2.5, 2.5, 2.5, 1.5,  0,  0, 1.5, 2.5 }},
    {x = -1, y = -1,    timeOffset = 0.2  + 0.0,       s = { -1.5, -1.5, -1.5, -0.5,  0,  0, -0.5, -1.5 }},
    {x = -2, y = -2,    timeOffset = 0.2  + 0.5,       s = { -2.5, -2.5, -2.5, -1.5,  0,  0, -1.5, -2.5 }},
    {x =  0, y = -2,    timeOffset = 0.2  + 1.5,       s = { -.5 , -1.5, -0.5, -2.5, 0.5, -2.5, 0.5, -1.5, 0, 0}},
    {x = 1, y = -2,     timeOffset = 0.2  + 1.0,       s = { 1.5, -2.5, 1.5, -1.5,  0,  0, 0.5, -2.5 }},
    {x = 1, y = -1,     timeOffset = 0.2  + 1.6,       s = { 1.5, -1.5, 1.5, -0.5,  0,  0, 0.5, -1.5 }},
    {x = 1, y = 0,      timeOffset = 0.2  + 0.0,       s = { .5, .5, 1.5, 0.5, 1.5, -.5, .5, -.5, 0, 0}},
    {x = -1, y = 1,     timeOffset = 0.2  + 0.6,       s = { -1.5, 1.5, -1.5, 0.5,  0,  0, -0.5, 1.5 }},
    {x = -1, y = 0,     timeOffset = 0.2  + 1.5,       s = { -.5, .5, -1.5, 0.5, -1.5, -.5, -.5, -.5, 0, 0}},
    {x = -1, y = 2,     timeOffset = 0.2  + 1.3,       s = { -1.5, 2.5, -1.5, 1.5,  0,  0, -0.5, 2.5 }},
    {x = 0, y = 2,      timeOffset = 0.2  + 0.9,       s = {-.5 , 1.5, -0.5, 2.5, 0.5, 2.5, 0.5, 1.5, 0, 0}},
}

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local function resize()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
end


local function load()
    love.mouse.setVisible(false)

    timer = 0
end

local function unload()
    love.mouse.setVisible(true)
end


local function update(dt)
    timer = timer + dt
    if timer >= 6 then
        debug.print("[Splash] Finished")
        if nextGameState then
            gameStateManager.setGameState(nextGameState)
        end
    end
end

local function sineOut(percent)
    return (math.sin((percent/2)*math.pi))
end

local function draw()
    local scaleAll = math.min(width/1920, height/1080)
    local scaleAlleY = height/1080
    love.graphics.translate(width/2, height/2)

    local squareSize = scaleAll * 100

    for i = 1,#squares do
        local s = squares[i]
        local time = quindoc.clamp(timer  - s.timeOffset, 0, 1)

        local sizeMult = (1-time)*25 + 1
        love.graphics.setColor(54/255/2, 1/255/2, 63/255/2, time)
        
        local p = {}
        if #s.s > 6 then
            for i = 1,#s.s do
                table.insert(p, s.s[i]*squareSize*sizeMult)
            end

            love.graphics.polygon("fill", p)
        end
    end

    for i = 1,#squares do
        local s = squares[i]
        local time = quindoc.clamp(timer  - s.timeOffset, 0, 1)

        local sizeMult = (1-time)*25 + 1
        love.graphics.setColor(60/255, 1/255, 75/255, time*2)
        --love.graphics.rectangle("fill", (s.x*squareSize - squareSize/2)*sizeMult, (s.y*squareSize - squareSize/2)*sizeMult, squareSize*sizeMult, squareSize*sizeMult)
        local points = {
            (s.x-0.5)*squareSize*sizeMult,  (s.y+0.5)*squareSize*sizeMult, 
            (s.x-0.5)*squareSize*sizeMult,  (s.y-0.5)*squareSize*sizeMult,
            (s.x+0.5)*squareSize*sizeMult,  (s.y-0.5)*squareSize*sizeMult, 
            (s.x+0.5)*squareSize*sizeMult,  (s.y+0.5)*squareSize*sizeMult,
        }
        love.graphics.polygon("fill", points)

    end

    local time = quindoc.clamp(timer  - 5, 0, 1)
    local sizeMult = (1-time)*25 + 1
        love.graphics.setColor(0, 0, 0, time*2)

    love.graphics.rectangle("fill", -5*squareSize*sizeMult, -5*squareSize*sizeMult, 10*squareSize*sizeMult, 10*squareSize*sizeMult)
end


return {
    load = load,
    unload = unload,
    resize = resize,
    update = update,
    draw = draw,

    isFirst = (true),
    noTransform = true,
}