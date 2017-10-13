function stripRoomName(room_name)
    local new_name = string.gsub(room_name, "@%a", "")
    lamp.log:debug("Cleaned room name: "..new_name)
    return new_name
end

function lamp.map:createRoom()
    local room_id = gmcp.room.info.num
    local is_created = false
    local found_zone, zone_id = lamp.map:isKnownZone(gmcp.room.info.zone)
    local room_name = stripRoomName(gmcp.room.info.name)

    if not found_zone then
        lamp.log:error("Can't create room in an unknown zone")
        return
    end

    lamp.log:debug("Attempting to create room for "..room_id)
    if room_id == -1 then
        lamp.log:error("Unable to create room - no room id given by mud")
        return
    end

    is_created = addRoom(room_id)
    setRoomName(room_id, room_name)
    setRoomArea(room_id, zone_id)

    local terrain_id = lamp.map.terrain[gmcp.room.info.terrain]
    if terrain_id then
        lamp.log:debug("Setting terrain as "..terrain_id)
        setRoomEnv(room_id, terrain_id)
    end

    if not lamp.map.prev_room then
        if gmcp.room.info.coord.cont == 1 then
            setRoomCoordinates(room_id, gmcp.room.info.coord.x, gmcp.room.info.coord.y*-1, 0)
        else
            setRoomCoordinates(room_id, 0, 0, 0)
        end
        lamp.map.prev_room = room_id
        lamp.log:debug("Created first map room for id "..room_id)
    else
        lamp.map.prev_room = lamp.map.curr_room
        lamp.log:debug("Attempting to find coords for new room...")
        local x, y, z = lamp.map:getNewCoords(lamp.command)
        local rooms_at_location = getRoomsByPosition(zone_id, x, y, z)
        if table.size(rooms_at_location) > 0 then
            lamp.log:debug("Found colliding rooms... Moving")
            lamp.map:moveCollidingRooms(zone_id, x, y, z)
        end
        lamp.log:debug("New coords set to: "..x.." "..y.." "..z)
        setRoomCoordinates(room_id, x, y, z)
    end
    
    lamp.map.curr_room = room_id
    lamp.map:connectExits(gmcp.room)
    lamp.map:connectSpecialExits()
    centerview(room_id)

    if not is_created then 
        lamp.log:error("Failed to create new room")
    else 
        lamp.log:debug("Created new room") 
    end
end

function lamp.map:getNewCoords(command)
    if not command then
        lamp.log:error("No command has been sent - can't find new coords")
        return
    end

    if gmcp.room.info.coord.cont == 1 then
        lamp.log:debug("Continent room: hardcoding coords")
        return tonumber(gmcp.room.info.coord.x), tonumber(gmcp.room.info.coord.y)*-1, 0
    end    

    if gmcp.room.info.zone ~= lamp.map.prev_zone_name then
        lamp.log:debug("Changed zone, centering map at 0, 0, 0")
        return 0, 0, 0
    end

    if lamp.map:isCardinalExit(command) then
        local direction_travelled = lamp.map:getShortExit(command)
        lamp.log:debug("Last command was a cardinal exit")
        local prev_room_x, prev_room_y, prev_room_z = getRoomCoordinates(lamp.map.prev_room)
        if direction_travelled == "n" then
            return prev_room_x, prev_room_y + 2, prev_room_z
        elseif direction_travelled == "s" then
            return prev_room_x, prev_room_y - 2, prev_room_z
        elseif direction_travelled == "e" then
            return prev_room_x + 2, prev_room_y, prev_room_z
        elseif direction_travelled == "w" then
            return prev_room_x - 2, prev_room_y, prev_room_z
        elseif direction_travelled == "ne" then
            return prev_room_x + 2, prev_room_y + 2, prev_room_z
        elseif direction_travelled == "nw" then
            return prev_room_x - 2, prev_room_y + 2, prev_room_z
        elseif direction_travelled == "se" then
            return prev_room_x + 2, prev_room_y - 2, prev_room_z
        elseif direction_travelled == "sw" then
            return prev_room_x - 2, prev_room_y - 2, prev_room_z
        elseif direction_travelled == "u" then
            return prev_room_x, prev_room_y, prev_room_z + 2
        elseif direction_travelled == "d" then
            return prev_room_x, prev_room_y, prev_room_z - 2
        else
            return prev_room_x, prev_room_y, prev_room_z
        end
    end
end

function lamp.map:moveCollidingRooms(zone_id, cur_x, cur_y, cur_z)
    local x_axis_pos = {"e"}
    local x_asis_neg = {"w"}
    local y_axis_pos = {"n", "nw", "ne"}
    local y_axis_neg = {"s", "sw", "se"}
    local z_axis_pos = {"u"}
    local z_axis_neg = {"d"}
    
    local rooms = getAreaRooms(zone_id)
    local dir = lamp.map:getShortExit(lamp.command)
    if table.contains(y_axis_pos, dir) then
        for name, id in pairs(rooms) do
            local x, y, z = getRoomCoordinates(id)
            if y >= cur_y then
                setRoomCoordinates(id, x, y + 2, z)
            end
        end
    elseif table.contains(y_axis_neg, dir) then
        for name, id in pairs(rooms) do
            local x, y, z = getRoomCoordinates(id)
            if y <= cur_y then
                setRoomCoordinates(id, x, y - 2, z)
            end
        end
    elseif table.contains(x_axis_pos, dir) then
        for name, id in pairs(rooms) do
            local x, y, z = getRoomCoordinates(id)
            if x >= cur_x then
                setRoomCoordinates(id, x + 2, y, z)
            end
        end
    elseif table.contains(x_axis_neg, dir) then
        lamp.log:debug("Shifting rooms lower in x")
        for name, id in pairs(rooms) do
            local x, y, z = getRoomCoordinates(id)
            if x <= cur_x then
                setRoomCoordinates(id, x - 2, y, z)
            end
        end
    elseif table.contains(z_axis_pos, dir) then
        for name, id in pairs(rooms) do
            local x, y, z = getRoomCoordinates(id)
            if z >= cur_z then
                setRoomCoordinates(id, x, y, z + 2)
            end
        end
    elseif table.contains(z_axis_neg, dir) then
        for name, id in pairs(rooms) do
            local x, y, z = getRoomCoordinates(id)
            if z <= cur_z then
                setRoomCoordinates(id, x, y, z - 2)
            end
        end
    end
end