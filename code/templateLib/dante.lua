--===================================================================================================--
--                                                                                                   --
--    88888888ba,                                                     88                             --
--    88      `"8b                             ,d         _,.         88                             --
--    88        `8b                            88       ""'           88                             --
--    88         88  ,adPPYYba,  8b,dPPYba,  MM88MMM  ,adPPYba,       88  88       88  ,adPPYYba,    --
--    88         88  ""     `Y8  88P'   `"8a   88    a8P_____88       88  88       88  ""     `Y8    --
--    88         8P  ,adPPPPP88  88       88   88    8PP"""""""       88  88       88  ,adPPPPP88    --
--    88      .a8P   88,    ,88  88       88   88,   "8b,   ,aa  888  88  "8a,   ,a88  88,    ,88    --
--    88888888Y"'    `"8bbdP"Y8  88       88   "Y888  `"Ybbd8"'  888  88   `"YbbdP'Y8  `"8bbdP"Y8    --
--                                                                                                   --
--                                                                                                   --
--    ┌─┐┌─┐┬  ┬┬┌┐┌┌─┐   ┬  ┌─┐┌─┐┌┬┐┬┌┐┌┌─┐   ┌─┐┌┐┌┌┬┐  ┌┬┐┌─┐┌┐ ┬  ┌─┐  ┌─┐┌─┐┬─┐┌┐ ┌─┐┌─┐┌─┐    --
--    └─┐├─┤└┐┌┘│││││ ┬   │  │ │├─┤ │││││││ ┬   ├─┤│││ ││   │ ├─┤├┴┐│  ├┤   │ ┬├─┤├┬┘├┴┐├─┤│ ┬├┤     --
--    └─┘┴ ┴ └┘ ┴┘└┘└─┘┘  ┴─┘└─┘┴ ┴─┴┘┴┘└┘└─┘┘  ┴ ┴┘└┘─┴┘   ┴ ┴ ┴└─┘┴─┘└─┘  └─┘┴ ┴┴└─└─┘┴ ┴└─┘└─┘    --
--                                                                                                   --
--===================================================================================================--

dante = {}

function dante.isKeyValue(table)
    local i = 1
    for key, value in pairs(table) do
        if key ~= i then
            return false
        else
            i = i + 1
        end
    end
    return true
end

function dante.varToString(var)
    if var == nil then
        return "nil"
    elseif type(var) == "function" then
        return "function"
    elseif type(var) == "image" then
        return "image"
    elseif type(var) == "string" then
        return '"' .. var .. '"'
    elseif type(var) == "number" then
        return tostring(var)
    elseif type(var) == "boolean" then
        if var then
            return "true"
        else
            return "false"
        end
    end
end

function dante.dataToString(data, indent, oneLine)
    local indent = indent or 0
    local string = ""
    local indentString = ""
    local endLineString = ",\n"

    if oneLine then endLineString = ","
    else indentString = string.rep("    ", indent) end

    if type(data) == "table" then

        -- each table starts with a "{"
        string = "{" .. string.sub(endLineString, 2, #endLineString)

        if dante.isKeyValue(data) then
            -- we dont have to add the name
            for key, value in pairs(data) do
                if type(data) == "table" then

                    local cocatString = dante.dataToString(value, indent + 1)

                    if cocatString then
                        local indent = (oneLine and indentString) or (indentString .. "    ")
                        string = string .. indent .. cocatString  .. endLineString
                    end
                else
                    string = string .. indentString .. dante.varToString(data) .. endLineString
                end
            end
        else
            -- we do have to add the name  
            for key, value in pairs(data) do
                local name = tostring(key)

                if type(key) == "number" then name = "[" .. key .. "]" 
                elseif tostring(name):find("[/:]") then name = "['" .. key .. "']" end

                if type(data) == "table" then
                    local cocatString = dante.dataToString(value, indent + 1)

                    if cocatString then
                        local indent = (oneLine and indentString) or (indentString .. "    ")
                        string = string .. indent .. name .. " = " .. cocatString  .. endLineString
                    end
                else
                    string = string .. indentString .. name .. " = " .. dante.varToString(data) .. endLineString
                end
            end
        end

        -- each table starts with a "}"
        string = string .. indentString .. "}"

    else
        -- not a table
        string = dante.varToString(data)
    end

    return string
end

function dante.printTable(table, prefix)
    print((prefix or "") .. " = " .. dante.dataToString(table))
end

function dante.save(data, file, compress)

    -- split into directory
    local directoryTable = {}
    for dir in string.gmatch(file, "([^/]+)") do
        table.insert(directoryTable, dir)
    end

    -- check if directory not exists
    if not love.filesystem.getInfo(file) then
        -- create the directory
        local dir = ""
        for i = 1,#directoryTable-1 do

            dir = dir .. directoryTable[i]

            if not love.filesystem.getInfo( dir, "directory" ) then love.filesystem.createDirectory( dir ) end

            dir = dir .. "/"

        end
    end

    local saveData

    if compress then
        local saveLine = "return " .. dante.dataToString(data, nil, true)
        local formatType = (type(compress) == "string" and compress) or "lz4"
        local compressed = love.data.compress("string", formatType, saveLine)
        local base64 = love.data.encode("string", "base64", compressed)
        saveData = "return love.data.decompress('string','" .. formatType .. "',love.data.decode('string','base64','" .. base64 .. "'))"
    else
        saveData = "return " .. dante.dataToString(data)
    end

    love.filesystem.write(file, saveData)
end

function dante.load(file)
    if love.filesystem.getInfo(file, "file") then
        local fileContents = love.filesystem.load(file)

        return fileContents()
    end
end

function dante.noQuantumEntanglememt(table)
    local temp = {}
    for key, value in pairs(table) do
        if type(table[key]) == "table" then
            temp[key] = dante.noQuantumEntanglememt(table[key])
        else
            temp[key] = value
        end
    end

    return temp
end


-- ty: https://www.youtube.com/watch?v=FadWgT4_dbk
function dante.encode(data)
    if type(data) ~= "table" then return end

    local encodedData = ""

    for key, value in pairs(data) do
        local currentData = value .. ";"
        
        encodedData = encodedData .. currentData 
    end

    return encodedData
end

function dante.decode(data)
--[[    if type(data) ~= "string" then return end

    local decodedData = {}

    for line in string.gmatch(data, "([^;]+)") do
        local key, value = string.match(line, "([^;]+)")

        table.insert(decodedData, value)
    end

    return decodedData]]

    if type(data) ~= "string" then return end
    local decodedData = {}
    for value in string.gmatch(data, "([^;]+)") do
        table.insert(decodedData, value)
    end
    return decodedData
end

function dante.encodeKeyValue(data)
    if type(data) ~= "table" then return end

    local encodedData = ""

    for key, value in pairs(data) do
        local currentData = key .. ":" .. value .. ";"
        
        encodedData = encodedData .. currentData 
    end

    return encodedData
end

function dante.decodeKeyValue(data)
    if type(data) ~= "string" then return end

    local decodedData = {}

    for line in string.gmatch(data, "([^;]+)") do
        local key, value = string.match(line, "([^:]+):([^;]+)")

        decodedData[key] = value
    end

    return decodedData
end

function dante.mergeTables(table1, table2, noNewFields)
    local merged = table1 or {}

    if type(table2) ~= "table" then
        return
    end

    for key, value in pairs(table2) do
        if noNewFields then
            if merged[key] ~= nil then
                if type(value) == "table" then
                    merged[key] = dante.mergeTables(merged[key] or {}, value, noNewFields)
                else
                    merged[key] = value
                end
            end
        else
            if type(value) == "table" then
                merged[key] = dante.mergeTables(merged[key] or {}, value, noNewFields)
            else
                merged[key] = value
            end
        end
    end
    return merged
end

function dante.splitString(str, sep)
    local result = {}
    for part in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(result, part)
    end
    return unpack(result)
end