--
-- WM OTXE - OpenTX Extensions 
-- Copyright (C) 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
-- To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ 
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
-- IMPORTANT
-- Please note that the above license also covers the transfer protocol used and the encoding scheme and 
-- all further principals of tranferring state and other information.

local name = "WmS2C";
local options = {};
local widget = {};
local menuState = {1, 1, 1, 0, 0}; -- row, col, page
local buttonState = {0, 0, 0, 0, 0, 0};
--local config = {};
local menu = {};
local headers = {};
local queue = nil;
local fsmState = {};
local encoder = nil;
local paramEncoder = nil;
local paramScaler = nil;
local configFSM = nil;
local errorCode = 0;
local help = {};

local lastRun = 0;

__stopWmSw2 = false; -- stop WMSW2 sending out

local function load()
  if not __libI then
    --      print("LOAD_I");
    __libI = loadScript("/SCRIPTS/WM/libI.lua")();
    if not __libI then errorCode = 1; end
  end
  if not __libD then
    --      print("LOAD_D");
    __libD = loadScript("/SCRIPTS/WM/libD.lua")();
    if not __libD then errorCode = 2; end
  end
  if not __libP then
    --      print("LOAD_P");
    __libP = loadScript("/SCRIPTS/WM/libP.lua")();
    if not __libP then errorCode = 3; end
  end
end

local function create(zone, options)
  widget.zone = zone;
  widget.options = options;

  load();

  if (errorCode > 0) then 
    return widget; 
  end
 
  __libI.initWidget(widget);
  collectgarbage();

  if not(__WmSw2Config) then
    local config = __libI.loadConfig();
    if not (config) then
      errorCode = 4;
      return widget;
    end
    __WmSw2Config = __libI.initConfig(config);
  end 
  collectgarbage();

  local map = nil;
  local modInfos = nil;
  local filename = {};
  local exportValues = nil;
  menu, exportValues, filename, map, modInfos = __libI.loadMenu();
  exportValues = nil;

  if not (menu) then
    errorCode = 5;
    return widget;
  end

  encoder, paramScaler, paramEncoder = __libP.getEncoder(__WmSw2Config);
  unused = nil;
  configFSM = __libP.getConfigFSM(__WmSw2Config);

  headers, menu, help = __libI.initParamMenu(__WmSw2Config, menu, map, modInfos, filename)

  __libI.initConfigFSM(fsmState);

  __libI = nil; -- free memory

  queue = __libP.Class.Queue.new();

  collectgarbage();
  print("gc6: ", collectgarbage("count"));

  return widget;
end

local function update(widget, options) widget.options = options; end

local function background(widget)
  if (errorCode == 0) then
    if ((getTime() - lastRun) > 100) then __stopWmSw2 = false; end
  end
end

local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    __stopWmSw2 = true;
    lastRun = getTime();
    __libD.processEvents(__WmSw2Config, menu, menuState, event, queue, __libD.selectParamItem);
    __libD.processTouch(menu, menuState, event, touch);
    __libD.processButtons(__WmSw2Config, menu, menuState, buttonState, queue, __libD.selectParamItem);
    local pvalue = __libD.displayParamMenu(__WmSw2Config, widget, menu, headers, menuState, paramScaler, event, help);
    configFSM(__WmSw2Config, menu, headers, menuState, queue, fsmState, encoder, paramEncoder, pvalue);
  else
    lcd.drawText(widget.x, widget.y, "Error: " .. errorCode, DBLSIZE);
  end
end
 
return {
  name = name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
};
