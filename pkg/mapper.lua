function laly.map:parseRoomData()
  local area_name = gmcp.room.info.zone
  if area_name ~= laly.map.curr_area then
    laly.map.prev_area = laly.map.curr_area
    laly.map.curr_area = area_name
    laly.log:debug("Changed area from "..laly.map.prev_area.." to "..laly.map.curr_area)
  end
end