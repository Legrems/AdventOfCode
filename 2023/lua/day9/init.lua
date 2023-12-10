local M = {}

local lib = require 'lib'
local inspect = require 'inspect'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    for line in input:gmatch("(.-)\n") do
        if line == nil or line == "" then goto continue end

        local numbers = {}
        for n in line:gmatch("(-?%d+)") do
            table.insert(numbers, tonumber(n))
        end

        local crow = 1
        local done = false
        local diffs = lib.defaultable({})
        diffs[1] = numbers
        while not done do
            for i, t in pairs(diffs[crow]) do
                if i < #diffs[crow] then
                    local k = diffs[crow][i + 1] - t
                    -- print(i, t, k, inspect(diffs))
                    table.insert(diffs[crow + 1], k)
                end
            end

            done = true
            for _, k in pairs(diffs[crow + 1]) do
                if k ~= 0 then
                    done = false
                end
            end
            -- print(done, inspect(diffs[crow + 1]))
            crow = crow + 1
        end

        local function clast(tt, reverse)
            local l = 0
            for i, _ in pairs(tt) do
                local row = tt[#tt - i + 1]
                if debug then
                    print(l, inspect(row))
                end
                if reverse then
                    l = row[1] - l
                else
                    l = l + row[#row]
                end
            end

            if debug then
                print('final', l)
            end

            return l
        end

        part_1 = part_1 + clast(diffs, false)
        part_2 = part_2 + clast(diffs, true)

        ::continue::
    end

    return {part_1, part_2}
end

return M
