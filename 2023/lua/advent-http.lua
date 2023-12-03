local M = {}
local http_request = require 'http.request'
local lib = require 'lib'
local posix = require 'posix'

local session = lib.read_file(".aocsession")


function M.get_input_for_day(day)

    local request = http_request.new_from_uri('https://adventofcode.com/2023/day/' .. day .. '/input')
    request.headers:append('cookie', 'session=' .. session)

    local headers, stream = request:go()
    local body = assert(stream:get_body_as_string())

    if headers:get ":status" ~= "200" then
        print('Error while fetching the input, status code: ' .. headers:get ':status')
        error(body)
    end

    return body
end

function M.create_day(day, start_browser)
    print('Creating folder from template for day ' .. day)

    if posix.stat("day" .. day, "type") == 'directory' then
        print('Folder for day ' .. day .. ' already exist, skipping template copy...')
    else
        os.execute("cp -r template/ day" .. day .. '/')
    end

    local input_day = M.get_input_for_day(day)

    lib.write_file("day" .. day .. "/input.txt", input_day)

    if start_browser then
        os.execute('firefox "https://adventofcode.com/2023/day/' .. day .. '"')
    end
end

function M.fetch_leaderboard()
    local request = http_request.new_from_uri('https://adventofcode.com/2023/leaderboard/private/view/250642.json')
    request.headers:append('cookie', 'session=' .. session)

    local headers, stream = request:go()
    local body = assert(stream:get_body_as_string())

    if headers:get ":status" ~= "200" then
        print('Error while fetching private leaderboard')
    end

    print('Writing in leaderboard.json...')
    lib.write_file("leaderboard.json", body)
end

return M
