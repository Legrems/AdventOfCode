local M = {}
-- local ordering = {'A', 'K', 'Q', 'J', 'T', 9, 8, 7, 6, 5, 4, 3, 2}
local ordering = "23456789TJQKA"
local orderingp2 = "J23456789T_QKA"
local inspect = require 'inspect'

local rank = {
    {1,1,1,1,1},
    {1,1,1,2},
    {1,2,2},
    {1,1,3},
    {2,3},
    {1,4},
    {5},
}

function M.count(hand)
    local out = {}
    print('Hand', hand)
    for k = 1, #ordering do
        local counter = {}
        -- local nhand = hand
        for i = 1, #ordering do
            local char = ordering:sub(i, i)
            local _, c = hand:gsub(char, "")
            if c > 0 then
                table.insert(counter, c)
            end
        end
        table.sort(counter)
        -- print('Counter', inspect(counter))
        for i, r in pairs(rank) do
            if table.equals(r, counter) then
                table.insert(out, i - 1)
                break
            end
        end
    end

    local h = {}
    -- table.insert(h, math.max(table.unpack(out)))
    for i = 1, #hand do
        local l, _ = string.find(ordering, hand:sub(i, i))
        table.insert(h, l)
    end
    -- table.sort(h, function(a, b) return b < a end)
    h = {math.max(table.unpack(out)), table.unpack(h)}
    print('H', inspect(h))
    return h
end

function M.count2(phand)
    local out = {}
    local hand = phand
    print('Hand', hand, phand)
    for k = 1, #orderingp2 do
        local counter = {}
        local nhand = hand:gsub('J', orderingp2:sub(k, k))
        for i = 1, #orderingp2 do
            local char = orderingp2:sub(i, i)
            local _, c = nhand:gsub(char, "")
            if c > 0 then
                table.insert(counter, c)
            end
        end
        table.sort(counter)
        -- print('Counter', inspect(counter))
        for i, r in pairs(rank) do
            if table.equals(r, counter) then
                table.insert(out, i - 1)
                break
            end
        end
    end

    local h = {}
    -- table.insert(h, math.max(table.unpack(out)))
    for i = 1, #phand do
        if phand:sub(i, i) == "J" then
            table.insert(h, 1)
        else
            local l, _ = string.find(orderingp2, phand:sub(i, i))
            table.insert(h, l)
        end
    end
    -- table.sort(h, function(a, b) return b < a end)
    h = {math.max(table.unpack(out)), table.unpack(h)}
    print('H', inspect(h))
    return h
end

function M.order(hand1, hand2)
    -- print(inspect(hand1), inspect(hand2))
    for i = 1, #hand1[1] do
        -- print(hand1[1][i], hand2[1][i])
        if hand1[1][i] > hand2[1][i] then
            return false
        elseif hand1[1][i] < hand2[1][i] then
            return true
        end
    end
    return false
end

return M
