local M = {}

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    for line in input:gmatch("(.-)\n") do
        if line == nil or line == "" then goto continue end

        local gameid = tonumber(line:split(":")[1]:split(" ")[2])
        line = line:split(":")[2]

        local possible = true
        local min_counts = {green=0, red=0, blue=0}

        for _, v in pairs(line:split(";")) do
            local counts = {green=0, red=0, blue=0}

            for _, rev in pairs(v:split(", ")) do
                rev = rev:gsub("^ ", "")

                local col = rev:split(" ")[2]
                counts[col] = counts[col] + tonumber(rev:split(" ")[1])
            end

            for i, j in pairs(counts) do
                min_counts[i] = math.max(min_counts[i], j)
            end

            if not (counts['red'] <= 12 and counts['green'] <= 13 and counts['blue'] <= 14) then
                possible = false
            end

            if debug then
                print(counts['red'], counts['green'], counts['blue'])
            end
        end

        if debug then
            print(gameid, possible)
        end

        if possible then
            part_1 = part_1 + gameid
        end

        part_2 = part_2 + min_counts['red'] * min_counts['green'] * min_counts['blue']

        ::continue::
    end

    return {part_1, part_2}
end

return M
