-- craftinfo.lua
addon.name      = 'craftinfo';
addon.author    = 'Joesomsom';
addon.version   = '1.0';
addon.desc      = 'Tries to retrieve craft info.';
addon.link      = 'N/A atm';

require 'common'
require 'socket.http'
local json = require 'json'

ashita.events.register('command', 'command_cb', function(cmd, nType)
  if cmd:lower():startswith('/craftinfo ') then
    local item = cmd:sub(12)
    local url = 'https://bg-wiki.com/api.php?action=query&titles='
      .. ashita.ffxi.encode_uri(item)
      .. '&prop=extracts&format=json&exintro=1'
    local body, code = http.request(url)
    if code == 200 then
      local js = json.decode(body)
      local pages = js.query.pages
      for _, page in pairs(pages) do
        ashita.chat.output(page.extract or 'No info found.')
      end
    else
      ashita.chat.output('HTTP error: ' .. tostring(code))
    end
    return true
  end
  return false
end)
