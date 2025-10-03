local CanvasItem = {}

function CanvasItem:new()
    local item = setmetatable({}, CanvasItem)
    self.__index = self

    return item
end

function CanvasItem:startPassive(entity) end

function CanvasItem:endPassive(entity) end

function CanvasItem:usePassive(entity, dt) end


function CanvasItem:startPrimary(entity) end

function CanvasItem:endPrimary(entity) end

function CanvasItem:usePrimary(entity, dt) end


function CanvasItem:startSecondary(entity) end

function CanvasItem:endSecondary(entity) end

function CanvasItem:useSecondary(entity, dt) end

return CanvasItem