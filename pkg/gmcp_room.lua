function lamp.map:parseGmcpRoom()
    local zone_name = gmcp.room.info.zone 

    -- Zone
    if lamp.map.curr_zone ~= zone_name then
        lamp.log:debug("Entered different zone")
        lamp.map:setZone(zone_name)
    end

    -- Continent
    if gmcp.room.info.coord.cont == 1 then
        lamp.log:debug("Continent room seen")
        local found_zone, zone_id = lamp.map:isKnownZone(zone_name)
    end

    -- Room
    lamp.map.seen_room = gmcp.room.info.num
    lamp.map.prev_room = lamp.map.curr_room

    if lamp.map.seen_room == -1 then
        lamp.log:debug("Can't find room based mud id - none given")
    elseif roomExists(lamp.map.seen_room) then
        if getRoomEnv(lamp.map.seen_room) == 999 then
            -- Temp room
        else
            lamp.log:debug("Found existing room - moving there")
            lamp.map.curr_room = lamp.map.seen_room
            lamp.map:connectSpecialExits()
            centerview(lamp.map.seen_room)
        end
    else
        lamp.log:debug("New room seen - creating...")
        lamp.map:createRoom()
    end
    lamp.map.prev_room_data = table.copy(gmcp.room)
    lamp.map.prev_zone_name = zone_name
end

function table.copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end