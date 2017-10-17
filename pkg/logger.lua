laly.log.COLORS = {
    debug = "dark_orchid",
    info = "light_slate_grey",
    warn = "orange",
    error = "firebrick",
}

laly.log.LEVELS = {
    debug = 0,
    info = 1,
    warn = 2,
    error = 3
}

laly.log_level = 1 -- info

function laly.log:debug(msg)
    if laly.log_level >= laly.log.LEVELS.debug then
        laly.log:print("debug", msg)
    end
end

function laly.log:info(msg)
    if laly.log_level >= laly.log.LEVELS.info then
        laly.log:print("info", msg)
    end
end

function laly.log:warn(msg)
    if laly.log_level >= laly.log.LEVELS.warn then
        laly.log:print("warn", msg)
    end
end

function laly.log:error(msg)
    if laly.log_level >= laly.log.LEVELS.error then
        laly.log:print("error", msg)
    end
end

function laly.log:print(level, msg)
    if not table.contains(laly.log.COLORS, level) then level = "info" end
    local color = laly.log.COLORS[level]
    cecho("\n<dark_slate_grey>[<white>::<"..color..">("..level.."): <light_grey>"..msg.."<white>::<dark_slate_grey>]\n")
end