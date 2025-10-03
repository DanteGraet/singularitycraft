font = {}

local fonts = {}
local fontLookUp = {}

local lastFontSize = 32
local lastFontName = ""

function font.loadFont(location, name)
    fontLookUp[name] = location
    fonts[name] = {}
end


function font.setFont(name, size)
    love.graphics.setFont(font.getFont(name, size))

    lastFontSize = size or lastFontSize
    lastFontName = name or lastFontName
end


function font.getFont(name, size)
    local name = name or lastFontSize
    local size = size or lastFontName
    
    if type(name) == "table" then
        size = name[2] or lastFontSize
        name = name[1] or lastFontName
    end

    if not size or not name then error("name or size is nil " .. name .. "  " .. size ) end

    if not fonts[name] then
        if fontLookUp[name] then
            fonts[name] = {}
        else
            error("No Loaded font " .. name)
        end
    end

    if not fonts[name][size] then
        fonts[name][size] = love.graphics.newFont(fontLookUp[name], tonumber(size))
    end

    return fonts[name][size]
end