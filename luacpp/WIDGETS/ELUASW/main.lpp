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


local name = "EL_Gui";
local options = {};
local widget = {};
local menuState = {1, 1, 1, 0, 0}; -- row, col, page
local buttonState = {0, 0, 0, 0, 0, 0};
--local config = {};
local menu = {};
local shortCuts = {};
local overlays = {};
local queue = nil;
local fsmState = {};
local switchFSM = nil;
local encoder = nil;
local exportValues = {0, -50, 50, 100}; -- percent
local rssiState = {};
local errorCode = 0;

__WmSw2Config = nil;
__stopWmSw2 = false; -- stop sending out
__WmSw2ForeignInput = 0;
__WmSw2Warning1 = nil;
__WmSw2Warning2 = nil;

local lastForeignInput = 0;
local remoteInput = {0, 0, 0, 0};

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
  collectgarbage();
  
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

  local filename = {};
  local map = {};
  local modules = {};
  menu, exportValues, filename, map, modules = __libI.loadMenu();
  map = nil;
  modules = nil;

  if not(menu) then
    errorCode = 5;
    return widget;
  end

  encoder = __libP.getEncoder(__WmSw2Config);
  switchFSM = __libP.getSwitchFSM(__WmSw2Config);

  menu, shortCuts, overlays = __libI.initMenu(__WmSw2Config, menu, filename)      
  __libI.initFSM(fsmState);

  __libI = nil; -- free memory

  queue = __libP.Class.Queue.new();

  collectgarbage();

  return widget;
end

local function update(widget, options)
  widget.options = options;
end

local function background(widget)
  if (errorCode == 0) then
    __libD.processShortCuts(shortCuts, queue);
    __libD.processRemoteInput(__WmSw2Config, menu, queue, remoteInput);
    if (lastForeignInput ~= __WmSw2ForeignInput) then
      __libD.processForeignInput(__WmSw2Config, __WmSw2ForeignInput, menu, queue);
      lastForeignInput = __WmSw2ForeignInput;
    end
    if not(__stopWmSw2) then
      switchFSM(__WmSw2Config, menu, queue, fsmState, encoder, exportValues);
    end

    __libP.rssiState(__WmSw2Config, rssiState);

  end
end

local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    __libD.processEvents(__WmSw2Config, menu, menuState, event, queue, __libD.selectItem);
    __libD.processTouch(menu, menuState, event, touch);
    __libD.processButtons(__WmSw2Config, menu, menuState, buttonState, queue, __libD.selectItem);
    __libD.processOverlays(overlays, menuState, queue);
    __libD.displayMenu(__WmSw2Config, widget, menu, overlays, menuState, event, remoteInput, __WmSw2Warning1, __WmSw2Warning2);

    __libD.displayFmRssiWarning(__WmSw2Config, widget, rssiState);

    background();
  else
    lcd.drawText(widget.x, widget.y, "Error: " .. errorCode, DBLSIZE);
  end
end

return { name=name,
  options=options,
  create=create,
  update=update,
  refresh=refresh,
  background=background
};

