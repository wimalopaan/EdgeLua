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
local function loadLibR()
  if not __libR then
    __libR = loadLib("libR.lua");
    if not __libR then
      errorCode = 3.3;
    end
  end
  collectgarbage();
end
local function loadLibApp()
  if not __libApp then
    __libApp = loadLib("libApp.lua");
    if not __libApp then
      errorCode = 3.4;
    end
  end
  collectgarbage();
end

local name = "EL_Adr";
local options = {};
local paramEncoder = nil;
local paramScaler = nil;
local menuState = {};
local buttonState = {0, 0, 0, 0, 0, 0};
local bmpExpandSmall = nil;
local lastRun = 0;
local function create(zone, options)
  load();
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
    __WmSw2Config = __libI.initConfig(config, true);
  end
  collectgarbage();
  local menu = __libI.loadMenu();
  if not(menu) then
    errorCode = 5;
    return widget;
  end
  local unused;
  unused, paramScaler, paramEncoder = __libP.getEncoder(__WmSw2Config);
  unused = nil;
  __libI = nil; -- free memory
  collectgarbage();
  bmpExpandSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/expand.png");
  return widget;
end
local function update(widget, options)
  widget[11] = options;
end
local function background(widget)
  if (errorCode == 0) then
    if ((getTime() - lastRun) > 100) then
      if not(__stopWmSw2) then
        __stopWmSw2 = 0;
      end
      __stopWmSw2 = bit32.band(__stopWmSw2, bit32.bnot(2));
      menuState[1] = 0; -- deselected state
    end
  end
end
local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    if not(__stopWmSw2) then
      __stopWmSw2 = 0;
    end
  __stopWmSw2 = bit32.bor(__stopWmSw2, 2);
    lastRun = getTime();
    __libD.displayAddressConfig(__WmSw2Config, widget, paramEncoder, paramScaler, menuState, event, touch, buttonState, bmpExpandSmall);
    background();
  else
    lcd.drawText(widget[1], widget[2], "Error: " .. errorCode, DBLSIZE);
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
