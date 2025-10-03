local c = {
    input = {
        target = {0,0}
    },
    keybinds = {
        k_a = "left",
        k_left = "left",

        k_d = "right",
        k_right = "right",

        k_w = "up",
        k_up = "up",
        k_space = "up",

        m_1 = "primary",
        m_2 = "secondary",
    }
}

function c.keypressed(key)
    local key = "k_" .. key

    local input = c.keybinds[key] or nil
    if input then
        c.input[input] = true
    end
end

function c.keyreleased(key)
    local key = "k_" .. key

    local input = c.keybinds[key] or nil
    if input then
        c.input[input] = false
    end
end

function c.mousepressed(button)
    local key = "m_" .. button

    local input = c.keybinds[key] or nil
    if input then
        c.input[input] = true
    end
end

function c.mousereleased(button)
    local key = "m_" .. button

    local input = c.keybinds[key] or nil
    if input then
        c.input[input] = false
    end
end

function c.update()
    local tx, ty = screen.translatePosition(love.mouse.getX(), love.mouse.getY(), "")

    c.input.target = {tx, ty}
end

return c