lamp.CARDINAL_EXITS_LONG = {
    "north",
    "south",
    "east",
    "west",
    "northeast",
    "northwest",
    "southeast",
    "soutwest",
    "up",
    "down"
}

lamp.CARDINAL_EXITS_SHORT = {
    "n",
    "s",
    "e",
    "w",
    "ne",
    "nw",
    "se",
    "sw",
    "u",
    "d"
}

lamp.CARDINAL_EXITS_SHRINK = {
    north = "n",
    south = "s",
    east = "e",
    west = "w",
    northeast = "ne",
    northwest = "nw",
    southeast = "se",
    southwest = "sw",
    down = "d",
    up = "u"
}

lamp.CARDINAL_EXITS_EXPAND = {
    n = "north",
    s = "south",
    e = "east",
    w = "west",
    ne = "northeast",
    nw = "northwest",
    se = "southeast",
    sw = "southwest",
    d = "down",
    u = "up"
}

function lamp.map:getExitNum(dir)
    if not lamp.map:isCardinalExit(dir) then
        lamp.log:error("Can't get an exit number for a non-cardinal direction ("..dir..")")
        return
    end
    local exit = lamp.map:getShortExit(dir)
    for k, v in pairs(lamp.CARDINAL_EXITS_SHORT) do
        if exit == v then
            return k
        end
    end
    lamp.log:error("Unable to find exit number for direction "..exit)
end

function lamp.map:isCardinalExit(command)
    return table.contains(lamp.CARDINAL_EXITS_LONG, command) or table.contains(lamp.CARDINAL_EXITS_SHORT, command)
end

function lamp.map:getShortExit(command)
    if table.contains(lamp.CARDINAL_EXITS_SHORT, command) then
        return command
    elseif table.contains(lamp.CARDINAL_EXITS_LONG, command) then
        return lamp.CARDINAL_EXITS_SHRINK[command]
    end
end

function lamp.map:connectExits(room_data)
    local exits = room_data.info.exits
    local room_id = room_data.info.num

    for direction, room in pairs(exits) do
        local dir_num = lamp.map:getExitNum(direction)
        if roomExists(room) then
            lamp.log:debug("The room exists, connecting stubs")
            setExitStub(room_id, dir_num, true)
            connectExitStub(room_id, dir_num)
            local stubs = getExitStubs(room_id)
        else
            lamp.log:debug("Unexplored exit, creating stub")
            lamp.log:debug("Setting stub in direction "..dir_num)
            setExitStub(room_id, dir_num, true)
        end
    end
    lamp.log:debug("Leaving connectExits")
end

function lamp.map:connectSpecialExits()
    if not lamp.map:isCardinalExit(lamp.command)
        and lamp.command ~= "l"
        and lamp.command ~= "look"
        and lamp.command ~= "recall" then
        lamp.log:debug("Saw special exit command ("..lamp.command.."), linking to previous room")
        local special_exits = getSpecialExits(gmcp.room.info.num)
        if not table.contains(special_exits, lamp.command) then
            addSpecialExit(lamp.map.prev_room, gmcp.room.info.num, lamp.command)
        end
    end
end
--]]