local currentGameState = ""
local previousGameState = ""
local reload = false
local gameStates = {}

local loadParam

gameStateManager = {}


function gameStateManager.setGameState(gameState, forceReload, param)
    currentGameState = gameState
    loadParam = param
    if forceReload then
        reload = true
    end
end

function gameStateManager.updateGameState()
    if currentGameState ~= previousGameState or reload then
        
        if currentGameState == previousGameState then
            -- reloading
            if gameStates[currentGameState] and gameStates[currentGameState].unload then gameStates[currentGameState].unload() end
        else
            -- unloading
            if gameStates[previousGameState] and gameStates[previousGameState].unload then gameStates[previousGameState].unload() end
        end
        
        if gameStates[currentGameState].load then gameStates[currentGameState].load(loadParam) end

        previousGameState = currentGameState

        reload = false

        return gameStates[currentGameState]
    end

    return nil
end



-- initially load all game states in gameState folder
local gameStateList = love.filesystem.getDirectoryItems("code/gameState")

for _, state in pairs(gameStateList) do
    -- remove the ".lua"
    local stateName = state:gsub("%.lua$", "")

    gameStates[stateName] = require("code/gameState/" .. stateName)
    debug.print("[gameStateManager] Loading game state " .. stateName)

    if type(gameStates[stateName]) == "table" then
        if gameStates[stateName] and gameStates[stateName].isFirst then
            currentGameState = stateName
            gameStateManager.setGameState(stateName, true)
        end
    else
        gameStates[stateName] = nil
        debug.print("[gameStateManager] unloading game state " .. stateName)
    end
end