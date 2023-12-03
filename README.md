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
```

### Set the AOC session
`lua adventofcode.lua set-session <SESSION-COOKIE>`

### Usage
Go inside the 2023/lua folder, then:
`lua adventofcode.lua day X <show|run> <--debug> <--file> <input filepath>`

### Start the next day of the AOC
`lua adventofcode.lua start <daynumber> -b`

This will open the browser on the correct page, creating a new folder from the template, as well as downloading the input, as long as you've set the correct session with `set-session` before.
