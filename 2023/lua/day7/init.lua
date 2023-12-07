local M = {}

local lib = require 'lib'
local daylib = require 'lib.day7'
local inspect = require 'inspect'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    local ranking = {}
    local ranking2 = {}

    for line in input:gmatch("(.-)\n") do
        if line == nil or line == "" then goto continue end

        local hand = line:split(" ")[1]
        local bid = tonumber(line:split(" ")[2])

        table.insert(ranking, {daylib.count(hand), hand, bid})
        table.insert(ranking2, {daylib.count2(hand), hand, bid})

        ::continue::
    end

    table.sort(ranking, daylib.order)
    table.sort(ranking2, daylib.order)

    for i, hand in pairs(ranking) do
        -- print(i, inspect(hand), i * hand[3])
        part_1 = part_1 + i * hand[3]
    end

    for i, hand in pairs(ranking2) do
        print(i, inspect(hand), i * hand[3])
        part_2 = part_2 + i * hand[3]
    end

    return {part_1, part_2}
end

return M
