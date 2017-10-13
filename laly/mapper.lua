laly.map.EXITS_SHORT = {
    "n",
    "s",
    "e",
    "w",
    "ne",
    "nw",
    "se",
    "sw",
    "u",
    "d",
}

laly.map.EXITS_LONG = {
    "north",
    "south",
    "east",
    "west",
    "northeast",
    "northwest",
    "southeast",
    "southwest",
    "up",
    "down",
}

laly.map.EXITS_SHRINK = {
    north = "n",
    south = "s",
    east = "e",
    west = "w",
    northeast = "ne",
    northwest = "nw",
    southeast = "se",
    southwest = "sw",
    up = "u",
    down = "d",
}

laly.map.EXITS_EXPAND = {
    n = "north",
    s = "south",
    e = "east",
    w = "west",
    ne = "northeast",
    nw = "northwest",
    se = "southeast",
    sw = "southwest",
    u = "up",
    d = "down",
}

laly.map.TRANSLATE = {
    n = function(x, y, z) return x, y + 1, z end,
    s = function(x, y, z) return x, y - 1, z end,
    e = function(x, y, z) return x + 1, y, z end,
    w = function(x, y, z) return x - 1, y, z end,
    ne = function(x, y, z) return x + 1, y + 1, z end,
    nw = function(x, y, z) return x - 1, y + 1, z end,
    se = function(x, y, z) return x + 1, y - 1, z end,
    sw = function(x, y, z) return x - 1, y - 1, z end,
    u = function(x, y, z) return x, y, z + 1 end,
    d = function(x, y, z) return x, y, z - 1 end,
}

function onSysLoadEvent()
    laly.log:debug("onSysLoadEvent")
end

function onSysDataSendRequest(event, args)
    laly.command = args
end

function onGmcpRoomData()
    local area_name = gmcp.room.info.zone
    local room_name = gmcp.room.info.name
    local area_id, area_created = getOrCreateArea(area_name)
    local room_id, room_created = getOrCreateRoom(gmcp.room.info.num)
   
    if area_created then
        laly.log:debug("Created new area '"..area_name.."' ("..area_id..")")
    end

    if laly.map.curr_area ~= area_name then
        laly.map.prev_area = laly.map.curr_area
        laly.map.curr_area = area_name
        laly.map.prev_room = nil
        laly.log:debug("Area changed from '"..laly.map.prev_area.."' to '"..laly.map.curr_area.."'")
    end

    if room_created then
        laly.log:debug("Created new room '"..room_name.."' ("..room_id..") in area '"..area_name.."' ("..area_id..")")
    end

    setRoomArea(room_id, area_name)    
end

function getAreaId(area_name)
    local areas = getAreaTable()
    for name, id in pairs(areas) do
        if name == area_name then return id end
    end
    return nil
end

function getOrCreateArea(area_name)
    local areas = getAreaTable()
    for name, id in pairs(areas) do
        if name == area_name then return id, false end
    end
    local area_id, err = addAreaName(area_name)
    return area_id, true
end

function getOrCreateRoom(room_id)
    if roomExists(room_id) then return room_id, false end
    return room_id, addRoom(room_id)
end

registerAnonymousEventHandler("sysLoadEvent", "onSysLoadEvent")
registerAnonymousEventHandler("sysDataSendRequest", "onSysDataSendRequest")
registerAnonymousEventHandler("gmcp.room", "onGmcpRoomData")

function onListAreasCommand()
    display(getAreaTable())
end

function onSetAreaCommand(area_name)
    laly.log:debug("Area name: "..area_name)
end

local trigger = tempRegexTrigger("^lareas$", "onListAreasCommand()")
enableTrigger(trigger)

trigger = tempRegexTrigger("^larea (\\w+)$", "onSetAreaCommand(matches[2])")
enableTrigger(trigger)