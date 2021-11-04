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


local name = "EL_Adr";
local options = {};
local widget = {};
--local config = {};
local encoder = nil;
local menuState = {};
local errorCode = 0;

local lastRun = 0;

__stopWmSw2 = false; -- stop sending out

local function load()
  local basedir = "/EDGELUA/LIB/";
  if not __libI then
--      print("LOAD_I");
    __libI = loadScript(basedir .. "libI.lua")();
    if not __libI then
      errorCode = 1;
    end
  end
  if not __libD then
--      print("LOAD_D");
    __libD = loadScript(basedir .. "libD.lua")();
    if not __libD then
      errorCode = 2;
    end
  end
  if not __libP then
--      print("LOAD_P");
    __libP = loadScript(basedir .. "libP.lua")();
    if not __libP then
      errorCode = 3;
    end
  end
end

local function create(zone, options)
  widget.zone = zone;
  widget.options = options;

  load();
  load = nil;
  
  if (errorCode > 0) then
    return widget;
  end

  __libI.initWidget(widget);
  collectgarbage();

  if not(__WmSw2Config) then
    local config = __libI.loadConfig();
    if not(config) then
      errorCode = 4;
      return widget;
    end
    __WmSw2Config = __libI.initConfig(config);
  end 
  collectgarbage();

  local menu = __libI.loadMenu();
  if not(menu) then
    errorCode = 5;
    return widget;
  end

  local unused;
  unused, unused, encoder = __libP.getEncoder(__WmSw2Config);
  unused = nil;

  __libI = nil; -- free memory

  collectgarbage();

  return widget;
end

local function update(widget, options)
  widget.options = options;
end

local function background(widget)
  if (errorCode == 0) then
    if ((getTime() - lastRun) > 100) then
      __stopWmSw2 = false;
      menuState[1] = 0; -- deselected state
    end
  end
end

local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    __stopWmSw2 = true;
    lastRun = getTime();
    __libD.displayAddressConfig(__WmSw2Config, widget, encoder, paramScaler, menuState, event, touch);
    background();
  else
    lcd.drawText(widget.x, widget.y, "Error: " .. errorCode, DBLSIZE);
  end
end

return { 
  name=name,
  options=options,
  create=create,
  update=update,
  refresh=refresh,
  background=background
};

