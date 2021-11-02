--
-- EdgeLUA - EdgeTx / OpenTx Extensions 
-- Copyright (C) 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
-- To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ 
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

-- IMPORTANT
-- Please note that the above license also covers the transfer protocol used and the encoding scheme and 
-- all further principals of tranferring state and other information.

local function init() 
end

local function compile(basedir)
  for filename in dir(basedir) do
    lcd.drawText(30, 10, filename, TEXT_COLOR);
    local chunk = loadScript(basedir .. "/" ..filename);
    if (chunk) then
      lcd.drawText(0, 10, "ok", TEXT_COLOR);
    else
      lcd.drawText(0, 10, "fail", TEXT_COLOR);
    end 
    chunk = nil;
    collectgarbage();
  end
end 

local lastTime = 0;
local state = 0;

local function run() 
  local t = getTime();
  local baseDir = "/EDGELUA/";
  local dir = nil;
  if ((t - lastTime) > 50) then
    lastTime = t;
    if (state == 0) then
      dir = baseDir .. "ANIMS";
      compile(dir);
      state = 1;
      return 0;
    elseif (state == 1) then  
      dir = baseDir .. "COMMON";
      compile(dir);
      state = 2;
      return 0;
    elseif (state == 2) then  
      dir = baseDir .. "LIB";
      compile(dir);
      state = 3;
      return 0;
    elseif (state == 3) then  
      dir = baseDir .. "MODELS";
      compile(dir);
      state = 4;
      return 0;
    elseif (state == 4) then  
      dir = baseDir .. "RADIO";
      compile(dir);
      state = 5;
      return 0;
    end 
  else
    return 0;
  end 
  return 1;
end


return {
  init = init, 
  run = run
};