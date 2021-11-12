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
local menuState = {1, 1, 1, 0, 0}; -- row, col, page
local menu = {};
local shortCuts = {};
local overlays = {};
local pagetitles = {};
local queue = nil;
local fsmState = {};
local switchFSM = {};
local encoder = nil;
local rssiState = {};
local exportValues = {0, -50, 50, 100}; -- percent
local errorCode = 0;
__stopWmSw2 = false; -- stop sending out
local function run_telemetry(event)
    if (errorCode == 0) then
      __libD.processEvents(__WmSw2Config, menu, menuState, event, queue, __libD.selectItem);
      __libD.processOverlays(overlays, menuState, queue);
      __libD.displayMenu(__WmSw2Config, widget, menu, overlays, menuState, pagetitles);
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
  if not(__WmSw2Config) then
    errorCode = 4.1;
    return;
  end
  local filename = {};
  local map = {};
  local modules = {};
  menu, exportValues, filename, map, modules = __libI.loadMenu();
  filename = nil;
  map = nil;
  modules = nil;
  collectgarbage();
  encoder = __libP.getEncoder(__WmSw2Config);
  switchFSM = __libP.getSwitchFSM(__WmSw2Config);
  if not(menu) then
    errorCode = 5;
    return;
  end
  menu, shortCuts, overlays, pagetitles = __libI.initMenu(menu)
  collectgarbage();
  __libI.initFSM(fsmState);
  __libI = nil; -- free memory
  queue = __libP.Class.Queue.new();
  collectgarbage();
  print("TRACE: ", "gc6: ", collectgarbage("count") );
end
local function background_telemetry()
  if (errorCode == 0) then
    __libD.processShortCuts(shortCuts, queue);
    if not(__stopWmSw2) then
      switchFSM(__WmSw2Config, menu, queue, fsmState, encoder, exportValues);
    end
    __libP.rssiState(__WmSw2Config, rssiState);
  end
end
return {run=run_telemetry, init=init_telemetry, background=background_telemetry}
