laly = laly or {}

laly.path = laly.path or {}
laly.path.aliases = laly.path.alieases or {}

local function create_aliases()
    local id
    local defs = {
        ["start path"] = {
            help = [[

            ]],
            pattern = [[^path new$]],
            command = [[laly.path.start()]],
        },
        ["stop path"] = {
            help = [[

            ]],
            pattern = [[^path end$]],
            command = [[laly.path.stop()]],
        },
        ["map path"] = {
            help = [[

            ]],
            pattern = [[^path map$]],
            command = [[laly.path.map()]],
        },
        ["insert command"] = {
            help = [[

            ]],
            pattern = [[]],
            command = [[laly.path.insert(matches[2], matches[3])]]
        },
    }
end

