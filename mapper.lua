-- https://forums.mudlet.org/mudlet-mapper-f13/generic-mapping-script-t6105.html

laly = laly or {}

laly.map = laly.map or {}
laly.log = laly.log or {}

local exitmap = {
    n = "north",        ne = "northeast",   nw = "northwest",   e = "east",         
    w = "west",         s = "south",        se = "southeast",   sw = "southwest",   
    u = "up",           d = "down",         ["in"] = "in",      ["out"] = "out",
}

local short = {}
for k,v in pairs(exitmap) do short[v] = k end

local stubmap = {
    north = 1,          northeast = 2,      northwest = 3,      east = 4,           
    west = 5,           south = 6,          southeast = 7,      southwest = 8,      
    up = 9,             down = 10,          ["in"] = 11,        ["out"] = 12,
    [1] = "north",      [2] = "northeast",  [3] = "northwest",  [4] = "east",
    [5] = "west",       [6] = "south",      [7] = "southeast",  [8] = "southwest",
    [9] = "up",         [10] = "down",      [11] = "in",        [12] = "up",
}

local coordmap = {
    [1] = {0, 1, 0},    [2] = {1, 1, 0},    [3] = {-1, 1, 0},   [4] = {1, 0, 0},
    [5] = {-1, 0, 0},   [6] = {0, -1, 0},   [7] = {1, -1, 0},   [8] = {-1, -1, 0},
    [9] = {0, 0, 1},    [10] = {0, 0, -1},  [11] = {0, 0, 0},   [12] = {0, 0, 0},
}

local reverse_dirs = {
    north = "south",            south = "north",
    east = "west",              west = "east",
    northwest = "southeast",    southeast = "northwest",
    northeast = "southwest",    southwest = "northeast",
    up = "down",                down = "up",
    ["in"] = "out",             ["out"] = "in",
}

local function create_aliases()
    laly.aliases = laly.aliases or {}
    local id
    local tbl = {
        ["start mapping"] = {
            help = [[
            ]],
            pattern = [[]],
            command = [[laly.map.start_mapping(matches[2])]],
        },
        ["stop mapping"] = {
            help = [[
            ]],
            pattern = [[]],
            command = [[]],
        },
        ["save map"] = {
            help = [[
            ]],
            pattern = [[]],
            command = [[]],
        },
        ["load map"] = {
            help = [[
            ]],
            pattern = [[]],
            command = [[]],
        },
        ["import area"] = {
            help = [[
            ]],
            pattern = [[]],
            command = [[]],
        },
        ["export area"] = {
            help = [[
            ]],
            pattern = [[]],
            command = [[]],
        }
    }
end

local function capture_move_command(dir)
    dir = string.lower(dir)
end