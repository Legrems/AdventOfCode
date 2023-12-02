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
---@record string[] record
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

return M
