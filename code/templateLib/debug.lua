local printDebug = DEV

debug = {}

function debug.print(...)
    if printDebug then
        print(...)
    end
end
