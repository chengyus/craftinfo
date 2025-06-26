-- craftinfo.lua
addon.name      = 'craftinfo';
addon.author    = 'Joesomsom';
addon.version   = '1.0';
addon.desc      = 'Tries to retrieve craft info.';
addon.link      = 'N/A atm';

require 'common'
local http = require 'socket.http'
-- local json = require 'json'
local chat = require('chat');

local craftinfo = T{
  item    = '           ',  -- The item/receipe to lookup.
  recipes = {}
};

--local function encode_uri(str)
--  if not str then
--    return nil
--  end
--  str = string.gsub(str, "([^%w%.%-]+)", function (c)
--    return string.format("%%%02X", string.byte(c))
--  end)
--  return str
--end

local function parse_bg_synth_info(body, item)
  first, last = string.find(body, item);
  --print("item match first: "..first);
  --print("item match last: "..last);
  local htmlparser = require("htmlparser");
  local root = htmlparser.parse(body);
  local elements = root:select(".item-info-body");
  for _,e in ipairs(elements) do
	  --print(e.name)
	  local subs = e("li::marker > a:not(.selflink)")
	  for _,sub in ipairs(subs) do
		  print(sub:getcontent())
	  end
  end
end

ashita.events.register('command', 'command_cb', function(e)
  local args = e.command:args();
  local cmd, item;
  if (#args == 0 or not args[1] == '/craftinfo') then
    print(chat.header(addon.name):append(chat.message('[Error]: command incorrect.')));
    return;
  end
  cmd = e.command;
  --print(#args);
  --print("\n");
  --print(args[2]);
  if (#args == 2) then
    craftinfo.item = args[2];
    -- print(chat.header(addon.name):append(chat.message('[DEBUG]: item set to: ')):append(chat.success(craftinfo.item)));
  end
  local item_ = craftinfo.item:gsub("%s+", "_");
  -- print(item_);
  local url = 'https://bg-wiki.com/ffxi/' .. item_;
  local body, code = http.request(url)
  if code == 200 then
    -- print("200 info found");
    parse_bg_synth_info(body, craftinfo.item);
    return true
  else
    ashita.chat.output('HTTP error: ' .. tostring(code))
  end
  return false
end)
