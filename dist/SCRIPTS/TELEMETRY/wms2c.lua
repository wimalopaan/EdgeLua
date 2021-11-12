--
-- EdgeLUA - EdgeTx / OpenTx Extensions
-- Copyright (C) 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
-- To view a copy of this license, visit http:
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
-- IMPORTANT
-- Please note that the above license also covers the transfer protocol used and the encoding scheme and
-- all further principals of tranferring state and other information.
       
       
       
       
       
       
local function load()
  local basedir = "/EDGELUA" .. "/LIB/";
  if not __libI then
    __libI = loadScript(basedir .. "libI.lua")();
    if not __libI then
      errorCode = 1;
    end
  end
  if not __libD then
    __libD = loadScript(basedir .. "libD.lua")();
    if not __libD then
      errorCode = 2;
    end
  end
  if not __libP then
    __libP = loadScript(basedir .. "libP.lua")();
    if not __libP then
      errorCode = 3;
    end
  end
end
local widget = {};
local menuState = {1, 1, 1, 0, 0}; -- row, col, page, selrow, selcol
--local config = {};
local menu = {};
local headers = {};
local queue = nil;
local fsmState = {};
local configFSM = nil;
local encoder = nil;
local paramScaler = nil;
local paramEncoder = nil;
local errorCode = 0;
local lastRun = 0;
__stopWmSw2 = false; -- stop sending out
--__WmSw2Config = nil;
local function run_telemetry(event)
  if (errorCode == 0) then
    lcd.clear();
    __stopWmSw2 = true;
    lastRun = getTime();
    __libD.processEvents(__WmSw2Config, menu, menuState, event, queue, __libD.selectParamItem);
    local pvalue = __libD.displayParamMenu(__WmSw2Config, widget, menu, headers, menuState, paramScaler);
    configFSM(__WmSw2Config, menu, headers, menuState, queue, fsmState, encoder, paramEncoder, pvalue);
  else
    lcd.clear();
    lcd.drawText(0, 0, "Error: " .. errorCode, DBLSIZE);
  end
end
local function init_telemetry()
  load();
  collectgarbage();
  if (errorCode > 0) then
    return;
  end
  widget = __libI.initWidget();
  collectgarbage();
  if not(__WmSw2Config) then
    local config = __libI.loadConfig();
    if not(config) then
      errorCode = 4;
      return;
    end
    __WmSw2Config = __libI.initConfig(config);
  end
  collectgarbage();
  local map = nil;
  local modInfos = nil;
  local exportValues = nil;
  local filename = nil;
  menu, exportValues, filename, map, modInfos = __libI.loadMenu();
  exportValues = nil;
  filename = nil;
  collectgarbage();
  encoder, paramScaler, paramEncoder = __libP.getEncoder(__WmSw2Config);
  configFSM = __libP.getConfigFSM(__WmSw2Config);
  collectgarbage();
  if not(menu) then
    errorCode = 5;
    return;
  end
  headers, menu = __libI.initParamMenu(__WmSw2Config, menu, map, modInfos)
  map = nil;
  modInfos = nil;
  collectgarbage();
  __libI.initConfigFSM(fsmState);
  __libI = nil; -- free memory
  queue = __libP.Class.Queue.new();
  collectgarbage();
-- print("gc6: ", collectgarbage("count"));
end
local function background_telemetry()
  if (errorCode == 0) then
    if ((getTime() - lastRun) > 100) then
      __stopWmSw2 = false;
    end
  end
end
return {run=run_telemetry, init=init_telemetry, background=background_telemetry}
