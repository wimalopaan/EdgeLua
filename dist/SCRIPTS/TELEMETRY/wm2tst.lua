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

local widget = {};
local function init_telemetry()
    load();
    loadLibU();
    collectgarbage();
    if (errorCode > 0) then
       return;
    end
    if not(__WmSw2Config) then
        local config = __libI.loadConfig();
        if not(config) then
          errorCode = 4;
          return;
        end
        __WmSw2Config = __libI.initConfig(config, true);
    end
    collectgarbage();
    widget = __libI.initWidget();
    __libI = nil; -- free memory
    collectgarbage();
end
local function run_telemetry(event)
    lcd.clear();
    if (errorCode == 0) then
        lcd.clear();
       __libU.displayDebug(widget);
    else
      lcd.drawText(widget[1], widget[2], "Error: " .. errorCode, DBLSIZE);
    end
    return 0;
end
local function background_telemetry()
  if (errorCode == 0) then
  end
end
if (LCD_W <= 128) then
    return {
        init = init_telemetry,
        run = run_telemetry,
        background = background_telemetry,
    };
else
    return {
        init = init_telemetry,
        run = run_telemetry,
        background = background_telemetry,
    };
end
