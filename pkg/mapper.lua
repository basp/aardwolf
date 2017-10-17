laly.commands = laly.commands or {}

laly.commands.get_areas = {
  pattern = "^lareas$",
  alias = nil,
}

function laly.commands.get_areas:exec()
  display(getAreaTable())
end

laly.commands.set_coords = {
  
}

laly.commands.get_coords = {

}

laly.commands.set_exit = {

}

laly.commands.get_exits = {

}

laly.commands.get_stubs = {

}

laly.commands.auto_exits = {
  
}

laly.commands.auto_coords = {

}

laly.commands.delete_area = {

}

laly.commands.delete_exits = {

}

--[[
function laly.commands:list_areas()
  display(getAreaTable())
end

function laly.commands:set_coords()
  local x = matches[2]
  local y = matches[3]
  local z = matches[4]
  local room_id = tonumber(gmcp.room.info.num)
  setRoomCoordinates(room_id, x, y, z)
  centerview(room_id)
  laly.log:debug("Room coordinates for room "..room_id.." set to "..x.." "..y.." "..z)
end

function laly.commands:get_coords()
end

function laly.commands:set_exit()
end

tempAlias("^lareas$", "laly.commands:list_areas()")
tempAlias("^lcoords (-?\\d+) (-?\\d+) (-?\\d+)$", "laly.commands:set_coords()")
]]--