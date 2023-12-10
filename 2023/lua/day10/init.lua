local M = {}

local lib = require 'lib'
local inspect = require 'inspect'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    local animal_pos = {}
    local grid = lib.defaultable({})
    local row = 1
    for line in input:gmatch("(.-)\n") do
        if line == nil or line == "" then goto continue end

        for i = 1, #line do
            local char = line:sub(i, i)

            table.insert(grid[row], char)

            if char == 'S' then
                animal_pos = {row, i}
            end
        end

        -- TODO STUFF HERE

        row = row + 1
        ::continue::
    end

    print(inspect(grid))

    local path = {}
    local current_pos = animal_pos
    local done = false
    local dir = {1, 0}
    while not done do
        local pipe = grid[current_pos[1]][current_pos[2]]
        print(inspect(current_pos), inspect(pipe))

        if pipe == '|' then
            current_pos = {current_pos[1], current_pos[2] + 1 * dir[2]}
            dir = {0, dir[2]}
        elseif pipe == '-' then
            current_pos = {current_pos[1], current_pos[2] + 1 * dir[2]}
            dir = {dir[1], 0}
        elseif pipe == 'L' then
            current_pos = {current_pos[1] + 1 * dir[1], current_pos[2] + 1 * dir[2]}
            dir = {dir[2], dir[1]}
        elseif pipe == 'J' then
            current_pos = {current_pos[1] + 1 * dir[1], current_pos[2]}
            dir = {dir[2], -dir[1]}
        elseif pipe == '7' then
            current_pos = {current_pos[1], current_pos[2] + 1 * dir[2]}
            dir = {dir[2], dir[1]}
        elseif pipe == 'F' then
            current_pos = {current_pos[1], current_pos[2] + 1 * dir[2]}
            dir = {, -dir[1]}
        end
    end

    -- print(inspect(grid))
    print(inspect(animal_pos))

    return {part_1, part_2}
end

return M
