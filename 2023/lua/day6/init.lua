local M = {}

local lib = require 'lib'
local daylib = require 'lib.day6'
local inspect = require 'inspect'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    local times = {}
    local distances = {}

    for i in input:split("\n")[1]:gmatch("(%d+)") do
        table.insert(times, tonumber(i))
    end

    for i in input:split("\n")[2]:gmatch("(%d+)") do
        table.insert(distances, tonumber(i))
    end

    part_1 = daylib.run(times, distances)

    local xtime = ''
    local xdistance = ''
    for _, t in pairs(times) do
        xtime = xtime .. tostring(t)
    end

    for _, d in pairs(distances) do
        xdistance = xdistance .. tostring(d)
    end
    -- part_2 = daylib.run({tonumber(xtime)}, {tonumber(xdistance)})

    return {part_1, part_2}
end

return M
