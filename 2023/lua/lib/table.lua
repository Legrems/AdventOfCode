local Table = {}
local tablua = require 'tablua'
local inspect = require 'inspect'

Table.__index = Table
function Table:new(o)
    local t = {}
    setmetatable(t, Table)

    t.table = {}
    t.headers = o
    t.formats = {}
    t.default_format = Table.default
    t.skips = {}

    return t
end

function Table:pretty_print()
    local t = {}

    for _, v in pairs(self.table) do
        local out = {}
        for j, _ in pairs(self.headers) do
            if self.formats[j] == nil then
                table.insert(out, self.default_format(v[j]))
            else
                table.insert(out, self.formats[j](v[j]))
            end
        end

        table.insert(t, out)
    end

    local tab = tablua(t)
    tab:add_line(self.headers, 1)

    print(tab)
end

function Table:sortby(field)
    local hn
    local reverse = field:sub(1, 1) == '-'
    if reverse then field = field:sub(2, #field) end

    for i, header in pairs(self.headers) do
        if header:upper() == field:upper() then
            hn = i
        end
    end
    if not hn then return end

    table.sort(self.table, function(a, b)
        if type(a[hn]) ~= type(b[hn]) then return false end
        if reverse then return a[hn] < b[hn] end
        return a[hn] > b[hn]
    end)
end

function Table:filterby(value)
    self.prefilter_table = self.table

    self.table = {}
    for _, arr in pairs(self.prefilter_table) do
        for _, v in pairs(arr) do
            if type(v) == "number" then
                v = tostring(v)
            end
            if type(v) ~= "string" then goto continue end

            if v:upper():find(value:upper()) then
                table.insert(self.table, arr)
                break
            end

            ::continue::
        end
    end
end

function Table:insert(value)
    table.insert(self.table, value)
end

function Table:inspect()
    print("===== Inspect =====")
    print('Table', inspect(self.table))
    print('Formats', inspect(self.formats))
    print('Headers', inspect(self.headers))
    print("===== END Inspect =====")
end

function Table.default(a)
    return a
end

return Table
