local M = {}

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    local digits = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
    for line in input:gmatch("(.-)\n") do
        if line == nil or line == "" then goto continue end
        local w = line

        local numbers = w:gsub("[A-z]", "")
        local value = tonumber(numbers:sub(1, 1) .. numbers:sub(-1, -1))

        part_1 = part_1 + value

        for i in pairs(digits) do
            w = w:gsub(digits[i], digits[i]:sub(1, 1) .. i .. digits[i]:sub(-1, -1))
        end

        numbers = w:gsub("[A-z]", "")
        value = tonumber(numbers:sub(1, 1) .. numbers:sub(-1, -1))
        part_2 = part_2 + value

        if debug then
            print(line, w, numbers, value)
        end

        ::continue::
    end

    return {part_1, part_2}
end

return M
