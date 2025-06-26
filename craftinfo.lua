-- craftinfo.lua
addon.name      = 'craftinfo';
addon.author    = 'Joesomsom';
addon.version   = '1.0';
addon.desc      = 'Tries to retrieve craft info.';
addon.link      = 'N/A atm';

-- NOTE: This addon uses https://github.com/msva/lua-htmlparser library;
--       So, you must either install it in the addons/libs or directly
--       under this folder (such as craftinfo).

require 'common'
local http = require 'socket.http'
-- local json = require 'json'
local chat = require('chat');

local craftinfo = T{
  item          = '           ',  -- The item/receipe to lookup.
  total_recipes = 0,              -- Current Recipe Count
  recipes = {}
};

local function parse_bg_synth_info(body, item)
  first, last = string.find(body, item);
  local htmlparser = require("htmlparser");
  local root = htmlparser.parse(body);
  local elements = root:select(".item-info-body");
  for i,e in ipairs(elements) do
	  local matz = e("li::marker > a:not(.selflink)")
    local wholeMatzString = "";
    for _, mat in ipairs(matz) do
      wholeMatzString = wholeMatzString .. mat:getcontent() .. ", ";
    end
    local cleanedupMatzStr = string.gsub(wholeMatzString, ", $", '')
    if cleanedupMatzStr ~= "" then
      craftinfo.total_recipes = craftinfo.total_recipes + 1;
      craftinfo.recipes[craftinfo.total_recipes] = cleanedupMatzStr;
    end
  end
end

local function cleanup_craftinfo()
  craftinfo.total_recipes = 0;
  craftinfo.recipes = {};
end

local function print_recipe_table()
  for i,r in ipairs(craftinfo.recipes) do
    print("Recipe#"..i..": "..craftinfo.recipes[i]);
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
  if (#args == 2) then
    craftinfo.item = args[2];
  end
  local item_ = craftinfo.item:gsub("%s+", "_");
  -- print(item_);
  local url = 'https://bg-wiki.com/ffxi/' .. item_;
  local body, code = http.request(url)
  if code == 200 then
    -- print("200 info found");
    parse_bg_synth_info(body, craftinfo.item);
    print_recipe_table();
    cleanup_craftinfo();
    return true
  else
    ashita.chat.output('HTTP error: ' .. tostring(code))
  end
  return false
end)
