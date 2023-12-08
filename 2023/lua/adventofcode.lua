local params = {...}

local socket = require 'socket'
local advent_http = require 'advent-http'
local lib = require 'lib'
local leaderboard = require 'leaderboard'

if params[3] == 'rank' then
    local day = tonumber(params[2]) or 1
    local summary = params[4] == '--summary' or false
    local all = params[4] == '--all' or false

    local sorting, filtering, days
    for _, param in pairs(params) do
        if param:find('--sort=') then
            sorting = param:gsub('--sort=', '')
        elseif param:find('--filter=') then
            filtering = param:gsub('--filter=', '')
        elseif param:find('--days=') then
            days = param:gsub('--days=', '')
        end
    end

    if all then
        leaderboard.show_local_leaderboard(filtering, sorting, days)
    else
        leaderboard.show_leaderboard_for_day(day, summary)
    end

    os.exit()
end

if params[1] == "set-session" then
    lib.write_file(".aocsession", io.read("*l"))
end

if params[1] == "rank" and params[2] == "--fetch" then
    advent_http.fetch_leaderboard()
    os.exit()
end

if #params < 2 then
    print('Invalid argument count, exiting...')
    os.exit()
end

local next_is_file = false
local filepath = "day" .. params[2] .. "/input.txt"
local debug = false
local start_browser = false
for _, param in pairs(params) do
    if param == "--debug" then
        debug = true
    end
    if param == '-b' then
        start_browser = true
    end
    if next_is_file then
        filepath = param
    end
    if param == "--file" then
        next_is_file = true
    end
end

if params[1] == 'start' then
    local day = tonumber(params[2])
    advent_http.create_day(day, start_browser)
    os.exit()
end

local input_day = lib.read_file(filepath)

if input_day == nil then
    print("No valid input, skipping...")
    os.exit()
end

if params[3] == 'show' then
    if params[4] ~= nil then
        print('Showing line number ' .. params[4])
        local index = 1
        for line in input_day:gmatch("(.-)\n") do
            if index == tonumber(params[4]) then
                print(index, line)
                break
            end
            index = index + 1
        end
    else
        print(input_day)
    end
    os.exit()
end

if params[3] == 'rank' then
    local day = tonumber(params[2]) or 1
    local summary = params[4] == "--summary" or false
    leaderboard.show_leaderboard_for_day(day, summary)
    os.exit()
end

if params[3] == 'run' then
    local module_day = require("day" .. params[2])
    local start_time = socket.gettime()
    for k, v in pairs(module_day.day(input_day, debug)) do
        print('Part ' .. k .. ' : ' .. v)
    end
    local end_time = socket.gettime()

    print(('Elapsed time (ms): %.2f'):format((end_time - start_time) * 1000))
end
