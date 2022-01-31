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

local function loadLib(filename)
                             ;
  local basedir = "/EDGELUA" .. "/LIB/";
  local chunk = loadScript(basedir .. filename);
  local lib = nil;
  if (chunk) then
                                     ;
    lib = chunk();
  end
  collectgarbage();
  return lib;
end

local errorCode = 0;

-- __stopWmSw2 = 0;
-- __WmSw2Config = nil;
-- __WmSw2ForeignInput = 0;
-- __WmSw2Warning1 = nil;
-- __WmSw2Warning2 = nil;

local function loadLibI()
  if not __libI then
    __libI = loadLib("libI.lua");
    if not __libI then
      errorCode = 1;
    end
  end
end

local function loadLibM()
  if not __libM then
    __libM = loadLib("libM.lua");
    if not __libM then
      errorCode = 1;
    end
  end
end

local function loadLibD()
  if not __libD then
    __libD = loadLib("libD.lua");
    if not __libD then
      errorCode = 2;
    end
  end
end

local function loadLibP()
  if not __libP then
    __libP = loadLib("libP.lua");
    if not __libP then
      errorCode = 3;
    end
  end
  collectgarbage();
end

local function load()
  loadLibI();
  loadLibD();
  loadLibP();
end

local function loadLibA()
  if not __libA then
    __libA = loadLib("libA.lua");
    if not __libA then
      errorCode = 3.1;
    end
  end
  collectgarbage();
end

local function loadLibU()
  if not __libU then
    __libU = loadLib("libU.lua");
    if not __libU then
      errorCode = 3.2;
    end
  end
  collectgarbage();
end

local widget = {};
local menuState = {1, 1, 1, 0, 0}; -- row, col, page
local menu = {};
local shortCuts = {};
local overlays = {};
local pagetitles = {};
local switches = {};
local queue = nil;
local autoResets = {};
local fsmState = {};
local switchFSM = {};
local encoder = nil;
local rssiState = {};
local exportValues = {0, -50, 50, 100}; -- percent
local lastForeignInput = 0;

local function run_telemetry(event)

    if (errorCode == 0) then
      __libD.processEvents(__WmSw2Config, menu, menuState, event, queue, __libD.selectItem);
-- __libD.processOverlays(overlays, menuState, queue, switches);
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
    __WmSw2Config = __libI.initConfig(config, true); -- modify model
  end

  collectgarbage();

  if not(__WmSw2Config) then
    errorCode = 4.1;
    return;
  end

  local filename = {};
  local map = {};
  local modules = {};
  menu, exportValues, filename, map, modules = __libI.loadMenu(); -- todo: remove exportvalues
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

  menu, shortCuts, overlays, pagetitles, switches = __libI.initMenu(menu)
  collectgarbage();

  __libI.initFSM(fsmState);

  __libI = nil; -- free memory

  queue = __libP.Class.Queue.new();

  collectgarbage();
                                         ;
end

local function background_telemetry()
  if (errorCode == 0) then
    __libD.processShortCuts(shortCuts, queue, switches);
    __libD.processOverlays(overlays, menuState, queue, switches);
    if (__WmSw2ForeignInput) and (lastForeignInput ~= __WmSw2ForeignInput) then
      __libD.processForeignInput(__WmSw2Config, __WmSw2ForeignInput, menu, queue);
      lastForeignInput = __WmSw2ForeignInput;
    end
                                                  ;
    if (__stopWmSw2) and (__stopWmSw2 == 0) then
      switchFSM(__WmSw2Config, menu, queue, fsmState, encoder, exportValues, autoResets);
    end
    __libP.rssiState(__WmSw2Config, rssiState);
                                                                   ;
  end
end

return {
  run = run_telemetry,
  init = init_telemetry,
  background = background_telemetry
}
