local M = {}

function M.run(times, distances)
    local tt = 1
    for i, time in pairs(times) do
        local w = 0
        for j = 0, time - 1 do
            print(j..' * ('..time..' - '..j..') > '..distances[i], '=>', (j * (time - j)) .. ' > ' .. distances[i])
            if j * (time - j) > distances[i] then
                w = w + 1
            end
        end
        tt = tt * w
    end
    return tt
end

return M
