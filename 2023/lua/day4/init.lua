local M = {}

local lib = require 'lib'
local inspect = require 'inspect'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    local multi = {}
    for i, _ in pairs(input:split("\n")) do
        multi[i] = 1
    end

    for gameid, line in pairs(input:split("\n")) do
        if line == nil or line == "" then goto continue end

        local winning = {}
        for k in line:split(":")[2]:split("|")[1]:gmatch("(%d+)") do
            table.insert(winning, k)
        end

        local numbers = {}
        local counts = 0
        local have = {}
        for k in line:split(":")[2]:split("|")[2]:gmatch("(%d+)") do
            table.insert(numbers, tonumber(k))
            if table.contains(winning, k) then
                table.insert(have, k)
                counts = counts + 1
            end
        end
        local points = 2 ^ (counts - 1)

        if counts > 0 then
            part_1 = part_1 + points
        end

        local m = multi[gameid]
        for k = gameid, math.min(gameid + #have, #input:split("\n") - 1) do
            multi[k] = multi[k] + m
        end

        part_2 = part_2 + m

        ::continue::
    end

    return {part_1, part_2}
end

return M
