function laly.log:debug(msg)
    cecho("\n<dark_slate_grey>[<white>::<dark_orchid>(debug):<light_grey> "..msg.." <white>::<dark_slate_grey>]\n")    
end

function laly.log:info(msg)
    cecho("\n<dark_slate_grey>[<white>::<light_slate_grey>(info):<light_grey> "..msg.." <white>::<dark_slate_grey>]\n")
end

function laly.log:error(msg)
    cecho("\n<dark_slate_grey>[<white>::<firebrick>(error):<light_grey> "..msg.." <white>::<dark_slate_grey>]\n")    
end