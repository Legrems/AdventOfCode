# AdventOfCode

## 2023
Written in LUA (https://www.lua.org/)

### Installation for Arch
```bash
trizen -S lua luarocks

sudo luarocks install luasocket
sudo luarocks install http
sudo luarocks install luaposix
sudo luarocks install inspect
sudo luarocks install tablua
sudo luarocks install lua-cjson
```

### Set the AOC session
`lua adventofcode.lua set-session <SESSION-COOKIE>`

### Usage
Go inside the 2023/lua folder, then:
`lua adventofcode.lua day X <show|run> <--debug> <--file> <input filepath>`

### Start the next day of the AOC
`lua adventofcode.lua start <daynumber> -b`

This will open the browser on the correct page, creating a new folder from the template, as well as downloading the input, as long as you've set the correct session with `set-session` before.

### Leaderboard
#### Show Part 1 / Part 2 separate
`lua adventofcode.lua day <day> rank`

#### Show Part 1 + 2 summary, with ordering
`lua adventofcode.lua day <day> rank --summary`

#### Fetch the leaderboard status (don't do it too often >15 minutes aoc says)
`lua adventofcode.lua rank --fetch`
