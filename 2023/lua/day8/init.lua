local M = {}

local lib = require 'lib'
local inspect = require 'inspect'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 1

    local path = input:split("\n\n")[1]

    local network = {}
    for line in input:split("\n\n")[2]:gmatch("(.-)\n") do
        if line == nil or line == "" then goto continue end

        local t = {}
        for i in line:gmatch("([A-Z][A-Z][A-Z])") do
            table.insert(t, i)
        end
        assert(#t, 3)

        network[t[1]] = {t[2], t[3]}

        ::continue::
    end

    if debug then
        print(inspect(network))
    end

    -- Part 1 --
    local pos = 'AAA'
    while pos ~= 'ZZZ' do
        local j = (part_1 + 1)  % #path

        if debug then
            print(pos, part_1, j, #path, path:sub(j, j), inspect(network[pos]))
        end

        if path:sub(j, j) == 'L' then
            pos = network[pos][1]
        else
            pos = network[pos][2]
        end

        part_1 = part_1 + 1
    end

    -- Part 2 --
    for start, _ in pairs(network) do
        if not start:endswith('A') then goto skip end

        pos = start
        local i = 0

        while not pos:endswith('Z') do
            local j = (i + 1) % #path
            if path:sub(j, j) == 'L' then
                pos = network[pos][1]
            else
                pos = network[pos][2]
            end

            i = i + 1
        end

        if debug then
            print(start, i)
        end

        part_2 = math.lcm(part_2, i)

        ::skip::
    end

    return {part_1, math.floor(part_2)}
end

return M
