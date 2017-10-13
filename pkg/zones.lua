function lamp.map:resetZone(zone_name)
    local zone_found, zone_id = lamp.map:isKnownZone(zone_name)
    if not zone_found then
        lamp.log:error("Zone not found - can't reset")
        return
    end

    local rooms = getAreaRooms(zone_id)
    if not rooms then
        lamp.log:info("No rooms to remove in "..zone_name)
        return
    end

    for room_name, room_id in pairs(rooms) do
        deleteRoom(room_id)
    end

    lamp.log:info("Removed all rooms from zone "..zone_name)
end

function lamp.map:isKnownZone(zone_name)
    local zones = getAreaTable()
    local zone_found = false
    local found_zone_id = nil

    for known_zone_name, zone_id in pairs(zones) do
        if known_zone_name == zone_name then
            zone_found = true
            found_zone_id = zone_id
            lamp.log:debug("Found zone as id "..zone_id)
            break
        end
    end

    return zone_found, found_zone_id
end

function lamp.map:createZone(new_zone_name)
    local new_zone_id = nil
    if not lamp.map:isKnownZone(new_zone_name) then
        new_zone_id = addAreaName(new_zone_name)
        lamp.log:debug("New zone "..new_zone_name.." created with id: "..new_zone_id)
    else
        lamp.log:debug("Zone already exists, not creating new zone")
    end
    return new_zone_id
end

function lamp.map:getZoneId(zone_name)
    local found, zone_id = lamp.map:isKnownZone(zone_name)
    if not found then
        zone_id = lamp.map:createZone(zone_name)
    end
    return zone_id
end

function lamp.map:setZone(zone_name)
    local zone_id = lamp.map:getZoneId(zone_name)
    if zone_id then
        lamp.map.curr_zone = zone_name
    else
        lamp.log:error("Failed to set zone")
    end
    lamp.log:debug("Current zone is now: "..lamp.map.curr_zone)
end