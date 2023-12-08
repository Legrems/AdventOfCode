local M = {}

local inspect = require 'inspect'

---@param path string
---@return string? content
function M.read_file(path)
    local file = io.open(path, 'rb')
    if not file then return nil end
    local content = file:read 'a'
    file:close()
    return content
end

function M.write_file(path, content)
    local file = io.open(path, 'w')
    if not file then return nil end
    file:write(content)
    file:close()
end

---@param self string
---@param sep string
---@param n? number
---@param regexp? string
---@return string[] record
function string:split(sep, n, regexp)
    assert(sep ~= '')
    assert(n == nil or n >= 1)

    local record = {}

    if self:len() > 0 then
        local plain = not regexp
        n = n or -1

        local field, start = 1, 1
        local first, last = self:find(sep, start, plain)

        while first and n ~= 0 do
            record[field] = self:sub(start, first - 1)
            field = field + 1
            start = last + 1
            first, last = self:find(sep, start, plain)
            n = n - 1
        end

        record[field] = self:sub(start)
    end

    return record
end

---@param self string
---@param pattern string
---@return function matchs
function string:pgmatch(pattern)
    -- Return start pos, number, end pos equivalent for gmatch
    return self:gmatch("()" .. pattern .. "()")
end

---@param element any
---@return boolean does the table contains this
function table:contains(element)
    for _, v in pairs(self) do
        if v == element then
            return true
        end
    end
    return false
end


---@param self table
---@param f function
---@return table newtable
function table:map(f)
    local n = {}
    for _, v in pairs(self) do
        table.insert(n, f(v))
    end
    return n
end

---@param default any or function
---@return table 'defaultdict' like table
function M.defaultable(default)
    local T = {}
    local metatable = {
        __index = function(t, key)
            if not rawget(t, key) then
                if type(default) == 'function' then
                    rawset(t, key, default(key))
                else
                    local f = function(_)
                        return M.deepcopy(default)
                    end
                    rawset(t, key, f(key))
                end
            end
            return rawget(t, key)
        end
    }
    return setmetatable(T, metatable)
end

---@param object table 
---@param seen? table
---@results object deepcopied table
function M.deepcopy(object, seen)
    -- Keep track of the copied object
    seen = seen or {}
    if object == nil then return nil end
    if seen[object] then return seen[object] end

    local out
    if type(object) == 'table' then
        out = {}
        seen[object] = out

        for k, v in next, object, nil do
            out[M.deepcopy(k, seen)] = M.deepcopy(v, seen)
        end
        setmetatable(out, M.deepcopy(getmetatable(object), seen))
    else -- number, string, boolean, etc
        out = object
    end
    return out
end


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

function M.day5_workon_range(range, map)
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

---@param t1 table First object to compare
---@param t2 table Second object to compare
function table.equals(t1, t2)
    for i, v1 in pairs(t1) do
        for j, v2 in pairs(t2) do
            if i == j then
                if v1 ~= v2 then
                    return false
                end
            end
        end
    end
    return true
end

function table.indexof(t1, value)
    for i, v1 in pairs(t1) do
        if v1 == value then
            return i
        end
    end
    return -1
end

function math.gcd( m, n )
    while n ~= 0 do
        local q = m
        m = n
        n = q % n
    end
    return m
end

function math.lcm( m, n )
    return ( m ~= 0 and n ~= 0 ) and m * n / math.gcd( m, n ) or 0
end

---@param str string
---@param self string
---@return boolean
function string:startswith(str)
    local f = self:find(str)
    if f == nil then return false end
    return f == 1
end


---@param str string
---@param self string
---@return boolean
function string:endswith(str)
    -- More efficiant than:
    -- return self:reverse():startswith(str:reverse())
    local f = self:find(str, -1)
    if f == nil then return false end
    return f == (#self - #str + 1)
end

return M
