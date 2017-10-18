-- https://forums.mudlet.org/mudlet-mapper-f13/generic-mapping-script-t6105.html

laly = laly or {}
laly.map = laly.map or {}

laly.LOG_LEVELS = {
    DEBUG = {
        level = 1,
        name = "debug",
        color = "dark_orchid",
    },
    INFO = {
        level = 2,
        name = "info",
        color = "light_slate_grey",
    },
    WARN = {
        level = 3,
        name = "warn",
        color = "orange",
    },
    ERROR = { 
        level = 4,
        name = "error",
        color = "firebrick",
    },
    FATAL = {
        level = 5,
        name = "fatal",
        color = "firebrick",
    }, 
}

function laly:log(level, msg)
    local name = level.name
    local color = level.color
    cecho("\n<dark_slate_grey>[ <"..color..">("..name.."): <reset>"..msg.." <dark_slate_grey>]\n")    
end

function laly:info(msg)
    laly:log(laly.LOG_LEVELS.INFO, msg)
end

function laly:debug(msg)
    laly:log(laly.LOG_LEVELS.DEBUG, msg)
end

function laly:warn(msg)
    laly:log(laly.LOG_LEVELS.WARN, msg)
end

function laly:error(msg)
    laly:log(laly.LOG_LEVELS.ERROR, msg)
end

function laly:fatal(msg)
    laly.log(laly.LOG_LEVELS.INFO, msg)
end

function laly.map:create_room()
    -- TODO
end

function laly.map:shift_room(direction)
    -- TODO
end

function laly.map:move_room(x, y, z)
    -- TODO
end

function laly.map:auto_map(things)
    if things == "exits" then
        auto_map_exits()
    elseif things == "pos" then
        auto_map_position()
    elseif things == "all" then
        auto_map_exits()
        auto_map_position()
    end
end

local prev_room_data = {}
local curr_room_data = {}
local last_command = {}

function laly.map:on_directed_move(direction)
end

function laly.map:on_random_move()
end

function laly.map:on_forced_move(direction)
end

function laly.map:on_room_data()
    if gmcp.room.info.num ~= curr_room_data.num then
        prev_room_data = curr_room_data
        curr_room_data = gmcp.room.info
    end
end

function lay.map:on_sys_data_send_request(_, command)
    last_command = command
end 

local function auto_map_exits()
    -- TODO
end

local function auto_map_position()
    -- TODO
end

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
    laly.map.aliases = laly.map.aliases or {}
    local id
    local tbl = {
        ["log"] = {
            help = [[
            Logs some output using the logging infrastructure, useful
            for testing out new logging formats and styles.
            ]],
            pattern = [[^log (debug|info|warn|error|fatal) (.+)$]],
            command = [[
            local level = matches[2]
            local msg = matches[3]
            laly:log(level, msg)
            ]]
        },
        ["create room"] = {
            help = [[
            Creates a new room if it doesn't exist already.
            ]],
            pattern = [[^map create$]],
            command = [[
            laly.map:create_room()
            ]],
        },
        ["shift room"] = {
            help = [[
            Shifts a room in one of the standard directions on the map.
            ]],
            pattern = [[^map shift (\w)$]],
            command = [[
            local direction = matches[2]
            laly.map:shift_room(direction)
            ]],
        },
        ["move room"] = {
            help = [[
            Moves a room to an absolute position on the map.
            ]],
            pattern = [[^map move (-?\d+) (-?\d+) (-?\d+)$]],
            command = [[
            local x = tonumber(matches[2])
            local y = tonumber(matches[3])
            local z = tonumber(matches[4])
            laly.map:move_room(x, y, z)
            ]],
        },
        ["auto map"] = {
            help = [[
            Auto map position, exits or both.
            ]],
            pattern = [[^map auto (pos|exits|all)$]],
            command = [[
            local things = matches[2]
            laly.map:auto_map(things)
            ]]
        },
        ["reset area"] = {
            help = [[
            Deletes the map of the current area and everything in it.
            ]],
            pattern = [[^map reset!$]],
            command = [[
            laly.map:delete_area()
            ]],
        },
    }
end

local function is_standard_direction(cmd)
    return table.contains(exitmap, cmd)
end

local function kill_event_handlers()
    laly.map.handlers = laly.map.handlers or {}
    for event, id in pairs(laly.map.handlers) do
        laly:debug("Killing existing <white>"..event.."<reset> handler")
        killAnonymousEventHandler(id) 
    end    
end

local function register_event_handlers()
    laly.map.handlers = laly.map.handlers or {}
    local defs = {
        onDirectedMove = [[laly.map:on_directed_move]],
        onRandomMove = [[laly.map:on_random_move]],
        onForcedMove = [[laly.map:on_forced_move]],
        ["sysDataSendRequest"] = [[laly.map:on_sys_data_send_request]],
        ["gmcp.room.info"] = [[laly.map:on_room_data]],
    }
    for event, command in pairs(defs) do 
        laly:debug("Registering new <white>"..event.."<reset> handler")
        laly.map.handlers[event] = registerAnonymousEventHandler(event, command)
    end
end

local function init()
    laly:debug("Killing existing handlers...")
    kill_event_handlers()
    
    laly:debug("Creating new handlers...")
    register_event_handlers()
end

laly:debug("Initializing...")
init()