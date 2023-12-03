local M = {}

local lib = require 'lib'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    local schematic = input:split("\n")
    local invalidmap = {'.', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
    local validmap = {'*'}
    local gears = {}
    for linei, line in pairs(schematic) do
        if line == nil or line == "" then goto continue end

        local prev_line = schematic[linei - 1]
        local next_line = schematic[linei + 1]

        if debug then
            print(prev_line)
            print(line)
            print(next_line)
        end

        for startpos, k, endpos in line:pgmatch('(%d+)') do

            local invalid = true

            for lini = linei - 1, linei + 1 do
                if lini <= 0 then goto skip end
                if gears[lini] == nil then
                    gears[lini] = {}
                end

                for pos = startpos - 1, endpos do
                    if gears[lini][pos] == nil then
                        gears[lini][pos] = {}
                    end

                    local char = schematic[lini]:sub(pos, pos)
                    if char ~= '' and not table.contains(invalidmap, char) then
                        invalid = false
                    end

                    if char ~= '' and table.contains(validmap, char) then
                        if debug then
                            print('Found gear', linei, lini, k, startpos, endpos, char)
                            print('Inserting gear in', lini)
                        end

                        table.insert(gears[lini][pos], k)
                    end
                end

                ::skip::
            end

            if not invalid then
                if debug then
                    print(k, startpos, endpos)
                end
                part_1 = part_1 + k
            end
        end

        ::continue::
    end

    for i, _ in pairs(gears) do
        for j, _ in pairs(gears[i]) do
            if #gears[i][j] == 2 then
                if debug then
                    print('Gears for', i, j, ' : ', gears[i][j][1], gears[i][j][2])
                end
                part_2 = part_2 + gears[i][j][1] * gears[i][j][2]
            end
        end
    end

    return {part_1, part_2}
end

return M
