local M = {}

local lib = require 'lib'
local daylib = require 'lib.day5'
local inspect = require 'inspect'

function M.day(input, debug)
    local part_1 = 0
    local part_2 = 0

    local seeds = {}
    local max_seed = 0

    local seedmap = lib.defaultable({})

    for seed in input:split("\n")[1]:gmatch("(%d+)") do
        table.insert(seeds, tonumber(seed))
        max_seed = math.max(max_seed, tonumber(seed))
    end

    for itype, type in pairs(input:split("\n\n")) do
        local loc = type:find("seeds")
        if loc ~= nil and loc > 0 then goto skip end

        local header = type:split("map:")[1]
        local loc1 = header:split("-")[1]
        local loc2 = header:split("-")[3]

        if debug then
            print(loc1, loc2)
        end

        for i, sline in pairs(type:split("\n")) do
            if i == 1 then goto skip1 end

            local dstart = tonumber(sline:split(" ")[1])
            local sstart = tonumber(sline:split(" ")[2])
            local rangel = tonumber(sline:split(" ")[3])

            if dstart ~= nil and sstart ~= nil and rangel ~= nil then
                table.insert(seedmap[itype], {dstart, sstart, rangel})

                if debug then
                    print(dstart, sstart, rangel)
                end
            end

            ::skip1::
        end

        ::skip::
    end

    part_1 = seeds[1]
    table.insert(seeds, 82)
    for iseed, seed in pairs(seeds) do

        if debug then
            print('P1 Seed', iseed, seed)
        end

        local loc = 0
        local v = seed
        for i, _ in pairs(seedmap) do
            for _, value in pairs(seedmap[i]) do
                if value[2] <= v and v < value[2] + value[3] then
                    v = value[1] + (v - value[2])
                    break
                end
            end

            if debug then
                print('vfor', iseed, v)
            end
            loc = v
        end

        part_1 = math.min(part_1, loc)
    end

    part_2 = seeds[1]

    local seed = seeds[1]
    local rangemap = lib.defaultable({})
    local pseedmap = lib.defaultable({})

    for iseed, length in pairs(seeds) do
        if iseed % 2 > 0 then
            seed = length
            goto plzkillme
        end

        table.insert(rangemap[1], {seed, seed + length - 1})

        ::plzkillme::
    end

    if debug then
        print(inspect(rangemap))
        print(inspect(seedmap))
        print(inspect(pseedmap))
    end

    for i, map in pairs(seedmap) do
        for _, range in pairs(map) do
            table.insert(pseedmap[i], {range[2], range[1], range[3]})
        end
    end

    local ranges = rangemap[1]
    for i, local_seedmap in pairs(pseedmap) do

        if debug then
            print(i .. ' ----------')
            print('Rangemap', inspect(ranges))
            print('Seedmap', inspect(local_seedmap))
        end

        local ranges_new = {}
        for irange, range in pairs(ranges) do
            local work = daylib.workon_range(range, local_seedmap)

            if debug then
                print('N Range', irange)
                print('Range', inspect(range))
                print('Mapped', inspect(work))
            end

            for _, m in pairs(work) do
                table.insert(ranges_new, m)
            end
        end

        ranges = ranges_new

        -- break
    end

    if debug then
        print(inspect(ranges))
    end

    part_2 = ranges[1][1]
    for _, r in pairs(ranges) do
        part_2 = math.min(part_2, r[1])
    end
    -- print("=============")
    -- print("=============")
    -- print("=============")
    --
    -- local tt = { { 77, 90 }, { 14, 15 }, { 55, 65 } }
    -- local sp = { { 49, 53, 8 }, { 0, 11, 42 }, { 42, 0, 7 }, { 57, 7, 4 } }
    -- -- (0-1)=>(2-3) AND (3-5)=>(10-12)
    --
    -- for _, t in pairs(tt) do
    --     print('--------')
    --     local k = daylib.workon_range(t, sp)
    --     print(inspect(t), '=>', inspect(k))
    -- end

    return {part_1, part_2}
end

return M
