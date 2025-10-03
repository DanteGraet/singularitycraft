local itemManager = {}

local itemTypes = {}
local entities = {}

local nextItemID = 0

function itemManager.getItem(itemType)
    -- check the item type exists could be done in another function
    if not itemTypes[itemType] then
        local itemPath = "code/item/type/" .. itemType .. ".lua"

        if love.filesystem.getInfo(itemPath) then
            itemTypes[itemType] = love.filesystem.load(itemPath)()
        else

            debug.print("itemManager: No such item type '" .. itemType .. "' found")
            return nil
        end
    end

    return itemTypes[itemType]
end


function itemManager.load()
    itemTypes = {}
    entities = {}

    nextItemID = 0
end


return itemManager