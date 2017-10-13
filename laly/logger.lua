laly.log.COLORS = {
    debug = "dark_orchid",
    info = "light_slate_grey",
    warn = "orange",
    error = "firebrick",
}

function laly.log:debug(msg)
    laly.log:print("debug", msg)
end

function laly.log:info(msg)
    laly.log:print("info", msg)
end

function laly.log:warn(msg)
    laly.log:print("warn", msg)
end

function laly.log:error(msg)
    laly.log:print("error", msg)
end

function laly.log:print(level, msg)
    if not table.contains(laly.log.COLORS, level) then level = "info" end
    local color = laly.log.COLORS[level]
    local o = "<dark_slate_grey>[<white>::<"..color..">("..level.."): <light_grey>"..msg.."<white>::<dark_slate_grey>]\n"
    cecho(o)
end