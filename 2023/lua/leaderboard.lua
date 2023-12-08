local M = {}

local json = require 'cjson'
local tablua = require 'tablua'
local Table = require 'lib.table'
local lib = require 'lib'
local inspect = require 'inspect'

local function str_date(time)
    return os.date("%Y-%m-%d %H:%M:%S", time)
end

---@param day number
---@param summary boolean
---@return nil
function M.show_leaderboard_for_day(day, summary)
    local board = M.get_leaderboard()

    if summary then
        M.show_leaderboard_summary(board, day)
    else
        M.show_leaderboard_per_part(board, day)
    end
end

---@param board table
---@param day number
---@return nil
function M.show_leaderboard_summary(board, day)
    local ranking = {}
    local member_count = 0

    for _, member in pairs(board.members) do
        member_count = member_count + 1
        if member.completion_day_level == nil or member.completion_day_level[tostring(day)] == nil then goto skip end
        table.insert(ranking, {member, member.completion_day_level[tostring(day)]})

        ::skip::
    end

    table.sort(ranking, function(a, b)
        if b[2]["2"] == nil then
            if a[2]["2"] == nil then
                return a[2]["1"].get_star_ts < b[2]["1"].get_star_ts
            end

            return true
        end
        if a[2]["2"] == nil then
            return false
        end
        return a[2]["1"].get_star_ts + a[2]["2"].get_star_ts < b[2]["1"].get_star_ts + b[2]["2"].get_star_ts
    end)

    local print_table = {{'Username', 'P1 Time', 'P1 Diff', 'P2 Time', 'P2 Diff', '-> P1', 'P1 -> P2', 'Points'}}

    local first_ranking_p1 = ranking[1][2]["1"].get_star_ts
    local first_ranking_p2 = ranking[1][2]["2"].get_star_ts
    local now = os.date('*t', ranking[1][2]["1"].get_star_ts)
    local day_at_6 = os.time{year=now.year, month=now.month, day=now.day, hour=6}
    for i, member in pairs(ranking) do
        table.insert(print_table,
            {
                member[1].name,
                str_date(member[2]["1"].get_star_ts),
                string.format('%.0f (s)', member[2]["1"].get_star_ts - first_ranking_p1),
                member[2]["2"] ~= nil and str_date(member[2]["2"].get_star_ts) or "---",
                member[2]["2"] ~= nil and string.format('%.0f (s)', member[2]["2"].get_star_ts - first_ranking_p2) or "---",
                string.format('%.0f (min)', (member[2]["1"].get_star_ts - day_at_6) / 60),
                member[2]["2"] ~= nil and string.format('%.0f (s)', (member[2]["2"].get_star_ts - member[2]["1"].get_star_ts)) or "---",
                member_count - i + 1,
            }
        )
    end

    print(tablua(print_table))
end

---@param board table
---@param day number
---@return nil
function M.show_leaderboard_per_part(board, day)
    for _, part in pairs({"1", "2"}) do
        local ranking = {}
        local member_count = 0

        for _, member in pairs(board.members) do
            member_count = member_count + 1
            local day_completion = member.completion_day_level[tostring(day)]
            if day_completion == nil then goto skip end
            if day_completion[part] == nil then goto skip end

            table.insert(ranking, {member, day_completion[part], day_completion[part].get_star_ts})

            ::skip::
        end

        table.sort(ranking, function(a, b) return a[3] < b[3] end)

        local first_ranking = ranking[1][3]
        local print_table = {{'Username', 'Time', 'Diff', 'Points'}}
        for i, member in pairs(ranking) do
            ranking[i][3] = member[3] - first_ranking

            table.insert(print_table, {member[1].name, str_date(member[2].get_star_ts), string.format('%.0f seconds', member[3]), member_count - i + 1})

        end

        print('Part ' .. part)
        print(tablua(print_table))
    end
end

function M.show_local_leaderboard(filtering, sorting, days)
    local board = M.get_leaderboard()

    local tab = Table:new({"ID", "Name", "Stars", "Points"})

    tab.formats = {
        function (_) return string.format("%.0f", _) end,
        function (name) return type(name) == "string" and name:gsub('é', 'e') or 'ANONYMOUS' end,
        function (_) return string.format("%.0f", _) end,
        function (_) return string.format("%.0f", _) end,
    }

    for _, member in pairs(board.members) do
        tab:insert({member.id, member.name, member.stars, member.local_score})
    end

    if sorting then tab:sortby(sorting) end
    if filtering then tab:filterby(filtering) end
    tab:pretty_print()

    if not days then os.exit() end
    -- Per days --
    local ranges = days:split(",")
    local day = {{0, 0, "Who"}}
    local done = {}

    for _, r in pairs(ranges) do
        if r:find("-") then
            local start = r:split("-")[1]
            local pend = r:split("-")[2]

            for i = start, pend do
                if not table.contains(done, i) then
                    table.insert(done, i)
                    table.insert(day, {i, 1, string.format('%d-1', i)})
                    table.insert(day, {i, 2, string.format('%d-2', i)})
                end
            end
        else
            if not table.contains(done, tonumber(r)) then
                table.insert(done, r)
                table.insert(day, {tonumber(r), 1, r .. '-1'})
                table.insert(day, {tonumber(r), 2, r .. '-2'})
            end
        end
    end
    -- print(inspect(day))

    local tot = Table:new(table.map(day, function(e) return e[3] end))

    tot.formats = {
        function (member) return type(member.name) == "string" and member.name:gsub('é', 'e') or 'ANONYMOUS' end,
    }

    tot.default_format = function(e)
        if type(e.get_star_ts) == "number" then return str_date(e.get_star_ts) end
        return '-'
    end

    for _, member in pairs(board.members) do
        local memberarr = {member}
        for i, d in pairs(day) do
            if i == 1 then goto noop end
            local dday = string.format("%d", d[1])
            local part = string.format("%d", d[2])

            print(member.name, dday, part)
            local day_completion = member.completion_day_level[dday]
            if day_completion == nil then
                table.insert(memberarr, {})
                goto noop
            end
            local part_completion = day_completion[part]
            if part_completion == nil then
                table.insert(memberarr, {})
                goto noop
            end

            table.insert(memberarr, part_completion)

            ::noop::
        end
        tot:insert(memberarr)
        print(inspect(member))
    end

    table.sort(tot.table, function(a, b) return a[1].local_score > b[1].local_score end)

    tot:pretty_print()
end

---@return table
function M.get_leaderboard()
    local content = lib.read_file("leaderboard.json")

    return json.decode(content)
end

return M
