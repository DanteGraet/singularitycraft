vector = {}
-- yea, im only supporting 3 dimentions. shut up.

-- all* of this is taken form the "HAESE - Mathematics 12 for Australia - Specialist Mathematics"?

local enum = {
    "x",
    "y",
    "z"
}

-- Dont know why anyone would use this
function vector.new(x, y, z)
    return {x = x, y = y, z = z}
end

-- or this one
function vector.newLine( position, direction )
    return { position = position, direction = direction}
end

function vector.getInxex(v, i)
    return v[enum[i]] or 0
end

function vector.dot(v1, v2)
    local dot = 0

    for i = 1,3 do
        dot = dot + vector.getInxex(v1, i) * vector.getInxex(v2, i)
    end

    return dot
end

function vector.legnth(v)
    local sum  = 0

    for i = 1,#v do
        local index = vector.getInxex(v, i)
        sum = sum + ( index * index )
    end

    return math.sqrt(sum)
end

function vector.difference(start, final)
    local v = {}

    for i = 1,3 do
        table.insert(v, vector.getInxex( final, i ) - vector.getInxex( start, i ) )
    end

    return v
end

function vector.distance(start, final)
    return vector.legnth( vector.difference( start, final ) )
end

function vector.scale(v, scaleFactor)
    v.x = ( v.x and v.x * scaleFactor ) or 0
    v.y = ( v.y and v.y * scaleFactor ) or 0
    v.z = ( v.z and v.z * scaleFactor ) or 0
end

function vector.scaleNum(v, scaleFactor)
    v[1] = ( v[1] and v[1] * scaleFactor ) or 0
    v[2] = ( v[2] and v[2] * scaleFactor ) or 0
    v[3] = ( v[3] and v[3] * scaleFactor ) or 0

    return v
end

function vector.normalise(v, legnth)
    vector.scale( v, ( legnth or 1 ) / vector.legnth( v ) )
end

function vector.angleDiff(v1, v2)
    local num = vector.dot( v1, v2 ) / ( vector.distance( v1 ) * vector.distance( v2 ) )
    return math.acos( num )
end


-- do these later™
function vector.lineOverlaps(l1, l2)
    
end

function vector.lineSegemtnOverlaps(l1, l2)
    
end

function vector.lineOverlapPoint(l1, l2)
    
end

function vector.lineSegemtnOverPoint(l1, l2)
    
end