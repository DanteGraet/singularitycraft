require("code/templateLib/debug")

debug.print("[LOADING] Start")

-- load libraries
local libraryList = love.filesystem.getDirectoryItems("code/templateLib")
for _, library in pairs(libraryList) do
    -- remove the ".lua"
    local libraryName = library:gsub("%.lua$", "")
    require("code/templateLib/" .. libraryName)
    debug.print("[LOADING] Loaded Library " .. libraryName)
end

if love.filesystem.getInfo("code/globals.lua", "file") then
    love.filesystem.load("code/globals.lua")()
    debug.print("[LOADING] Loaded Globals" )
end

font.loadFont("font/kulimParkRegular.ttf", "kulimPark")


debug.print("[LOADING] End")