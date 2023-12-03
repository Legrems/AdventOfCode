local M = {}

local lib = require 'lib'
local inspect = require 'inspect'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    for line in input:gmatch("(.-)\n") do
        if line == nil or line == "" then goto continue end

        -- TODO STUFF HERE

        ::continue::
    end

    return {part_1, part_2}
end

return M
