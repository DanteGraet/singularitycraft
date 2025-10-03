local Hotbar = {}

function Hotbar:new()
    local hotbar = setmetatable({}, Hotbar)
    self.__index = self

    hotbar.items = {}
    hotbar.selectedItem = 0

    hotbar.currentUse = "Passive"

    return hotbar
end

function Hotbar:addItem(item, ...)
    table.insert(self.items, itemManager.getItem(item):new(...))
    if self.selectedItem == 0 then
        self.selectedItem = 1
    end
end


function Hotbar:scroll(direction)
    if #self.items > 0 then
        Hotbar.selectedItem = Hotbar.selectedItem + quindoc.sign(direction)

        if Hotbar.selectedItem > #self.items then
            Hotbar.selectedItem = 1
        elseif Hotbar.selectedItem <= 0 then
            Hotbar.selectedItem = #self.items
        end
    end
end

function Hotbar:update(entity, use, dt)
    if self.items[self.selectedItem] then
        local item = self.items[self.selectedItem]

        if (use or "Passive") ~= self.currentUse then
            item["end" .. self.currentUse](item, entity)

            item["start" .. use](item, entity)
            self.currentUse = use
        end

        item["use" .. self.currentUse](item, entity, dt)
    end
end


return Hotbar