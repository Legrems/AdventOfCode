local M = {}

---@param a number
---@param b number
---@param c number
---@param d number
---@return table
---@return table
function M.xrange(a, b, c, d)
    -- print('Xrange', a, b, c, d)
    if a < c and d < b then
        return {c, d}, {{a, c - 1}, {d + 1, b}}
    elseif a < c and c <= b then
        return {c, b}, {{a, c - 1}}
    elseif a <= d and d < b then
        return {a, d}, {{d + 1, b}}
    elseif c <= a and b <= d then
        return {a, b}, {{}}
    else
        return {}, {{a, b}}
    end
end

function M.workon_range(range, map)
    local mapping = {}
    local unprocessed = {range}
    if #range == 0 then
        return {}
    end

    -- print("====== WORKON =======")

    for _, value in pairs(map) do

        local unprocessed_new = {}

        for _, np in pairs(unprocessed) do
            -- print('Range', inspect(range))
            -- print('Map', inspect(value))
            -- print('Np', inspect(np))
            local mapped, extras = M.xrange(np[1], np[2], value[1], value[1] + value[3] - 1)
            local ecart = value[2] - value[1]
            -- print(inspect(mapped))
            -- print(inspect(extras))

            for _, e in pairs(extras) do
                if #e > 0 then
                    -- print('U ' .. e[1], e[2])
                    table.insert(unprocessed_new, e)
                end
            end
            if #mapped > 0 then
                -- print('M ' .. mapped[1], mapped[2], '=>', mapped[1] + ecart, mapped[2] + ecart)
                table.insert(mapping, {mapped[1] + ecart, mapped[2] + ecart})
            end
        end

        unprocessed = unprocessed_new
    end

    -- print('Range', inspect(range))
    -- print('Mapping', inspect(mapping))
    -- print('Unproc', inspect(unprocessed))
    -- print('---')

    for _, r in pairs(unprocessed) do
        table.insert(mapping, r)
    end
    return mapping
end

return M
