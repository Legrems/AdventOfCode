local M = {}

local json = require 'cjson'
local tablua = require 'tablua'
local lib = require 'lib'

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

    for _, member in pairs(board.members) do
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

    local print_table = {{'Username', 'P1 Time', 'P1 Diff', 'P2 Time', 'P2 Diff', '-> P1', 'P1 -> P2'}}

    local first_ranking_p1 = ranking[1][2]["1"].get_star_ts
    local first_ranking_p2 = ranking[1][2]["2"].get_star_ts
    local now = os.date('*t', ranking[1][2]["1"].get_star_ts)
    local day_at_6 = os.time{year=now.year, month=now.month, day=now.day, hour=6}
    for _, member in pairs(ranking) do
        table.insert(print_table,
            {
                member[1].name,
                str_date(member[2]["1"].get_star_ts),
                string.format('%.0f (s)', member[2]["1"].get_star_ts - first_ranking_p1),
                member[2]["2"] ~= nil and str_date(member[2]["2"].get_star_ts) or "---",
                member[2]["2"] ~= nil and string.format('%.0f (s)', member[2]["2"].get_star_ts - first_ranking_p2) or "---",
                string.format('%.0f (min)', (member[2]["1"].get_star_ts - day_at_6) / 60),
                member[2]["2"] ~= nil and string.format('%.0f (min)', (member[2]["2"].get_star_ts - member[2]["1"].get_star_ts) / 60) or "---",
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

        for _, member in pairs(board.members) do
            local day_completion = member.completion_day_level[tostring(day)]
            if day_completion == nil then goto skip end
            if day_completion[part] == nil then goto skip end

            table.insert(ranking, {member, day_completion[part], day_completion[part].get_star_ts})

            ::skip::
        end

        table.sort(ranking, function(a, b) return a[3] < b[3] end)

        local first_ranking = ranking[1][3]
        local print_table = {{'Username', 'Time', 'Diff'}}
        for i, member in pairs(ranking) do
            ranking[i][3] = member[3] - first_ranking

            table.insert(print_table, {member[1].name, str_date(member[2].get_star_ts), string.format('%.0f seconds', member[3])})

        end

        print('Part ' .. part)
        print(tablua(print_table))
    end
end

---@return table
function M.get_leaderboard()
    local content = lib.read_file("leaderboard.json")

    return json.decode(content)
end

return M
