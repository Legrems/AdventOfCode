local M = {}

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

---@param element type
---@return boolean does the table contains this
function table:contains(element)
    for _, v in pairs(self) do
        if v == element then
            return true
        end
    end
    return false
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

return M
