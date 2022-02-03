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
  print("TRACE: " , "loadLib:", filename );
  local basedir = "/EDGELUA" .. "/LIB/";
  local chunk = loadScript(basedir .. filename);
  local lib = nil;
  if (chunk) then
    print("TRACE: " , "loadLib chunk:", filename );
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

local name = "EL_Gui";
local options = {};
local menuState = {1, 1, 1, 0, 0}; -- row, col, page
local buttonState = {0, 0, 0, 0, 0, 0};
local menu = {};
local shortCuts = {};
local overlays = {};
local pagetitles = {};
local menudata = {};
local switches = {};
local queue = nil;
local autoResets = {};
local fsmState = {};
local switchFSM = nil;
local encoder = nil;
local exportValues = {0, -50, 50, 100}; -- percent
local rssiState = {};

local lastForeignInput = 0;
local remoteInput = {0, 0, 0, 0};

local function create(zone, options)
  load();
  collectgarbage();

  if (errorCode > 0) then
    return {};
  end

  local widget = __libI.initWidget(zone, options);
  collectgarbage();

  if not(__WmSw2Config) then
    local config = __libI.loadConfig();
    if not(config) then
      errorCode = 4;
      return widget;
    end
    __WmSw2Config = __libI.initConfig(config, true); -- modify model
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

  menu, shortCuts, overlays, pagetitles, menudata, switches = __libI.initMenu(__WmSw2Config, menu, filename);
  __libI.initFSM(fsmState);

  __libI = nil; -- free memory

  queue = __libP.Class.Queue.new();

  collectgarbage();

  return widget;
end

local function update(widget, options)
  widget[11] = options;
end

local function background(widget)
  if (errorCode == 0) then
    __libD.processShortCuts(shortCuts, queue, switches);
    __libD.processRemoteInput(__WmSw2Config, menu, queue, remoteInput);
    if (__WmSw2ForeignInput) and (lastForeignInput ~= __WmSw2ForeignInput) then
      print("TRACE: " , "foreignInput", __WmSw2ForeignInput );
      __libD.processForeignInput(__WmSw2Config, __WmSw2ForeignInput, menu, queue);
      lastForeignInput = __WmSw2ForeignInput;
    end
    if ((__stopWmSw2) and (__stopWmSw2 == 0)) or not (__stopWmSw2) then
      switchFSM(__WmSw2Config, menu, queue, fsmState, encoder, exportValues, autoResets);
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
    __libD.processOverlays(overlays, menuState, queue, switches);
    __libD.displayMenu(__WmSw2Config, widget, menu, overlays, menuState, event, remoteInput,
                       __WmSw2Warning1, __WmSw2Warning2, pagetitles, menudata, fsmState);

    __libD.displayFmRssiWarning(__WmSw2Config, widget, rssiState);

    background();
  else
    lcd.drawText(widget[1], widget[2], "Error: " .. errorCode, DBLSIZE);
  end
end

return { name=name,
  options=options,
  create=create,
  update=update,
  refresh=refresh,
  background=background
};
