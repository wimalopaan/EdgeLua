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

local errorCode = 0;

__WmSw2Config = nil;
__stopWmSw2 = 0;
__WmSw2ForeignInput = 0;
__WmSw2Warning1 = nil;
__WmSw2Warning2 = nil;

local function load()
  local basedir = "/EDGELUA" .. "/LIB/";
  if not __libI then
    local chunk = loadScript(basedir .. "libI.lua");
    if (chunk) then
      __libI = chunk();
    end
    if not __libI then
      errorCode = 1;
    end
  end
  collectgarbage();
  if not __libD then
    local chunk = loadScript(basedir .. "libD.lua");
    if (chunk) then
      __libD = chunk();
    end
    if not __libD then
      errorCode = 2;
    end
  end
  collectgarbage();
  if not __libP then
    local chunk = loadScript(basedir .. "libP.lua");
    if (chunk) then
      __libP = chunk();
    end
    if not __libP then
      errorCode = 3;
    end
  end
  collectgarbage();
end

local function loadLibA()
  local basedir = "/EDGELUA" .. "/LIB/";
  if not __libA then
                            ;
    local chunk = loadScript(basedir .. "libA.lua");
    if (chunk) then
      __libA = chunk();
    end
    if not __libA then
      errorCode = 3.1;
    end
  end
  collectgarbage();
end

local function loadLibU()
  local basedir = "/EDGELUA" .. "/LIB/";
  if not __libU then
                            ;
    local chunk = loadScript(basedir .. "libU.lua");
    if (chunk) then
      __libU = chunk();
    end
    if not __libU then
      errorCode = 3.2;
    end
  end
  collectgarbage();
end

local widget = {};
local menuState = {};
local paramEncoder = nil;
local paramScaler = nil;

local lastRun = 0;

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
        __WmSw2Config = __libI.initConfig(config, true); --todo
      end
      collectgarbage();

      local unused = nil;
      unused, paramScaler, paramEncoder = __libP.getEncoder(__WmSw2Config);
      unused = nil;

      __libI = nil; -- free memory

      collectgarbage();
end

local function run_telemetry(event)
    lcd.clear();
    if (errorCode == 0) then
        __stopWmSw2 = bit32.bor(__stopWmSw2, 2);
        lastRun = getTime();
        lcd.drawScreenTitle("Learn address", 1, 1);
        __libD.displayAddressConfig(__WmSw2Config, widget, paramEncoder, paramScaler, menuState, event, touch);
    else
      lcd.drawText(0, 0, "Error: " .. errorCode, DBLSIZE);
    end
  end

local function background_telemetry()
    if (errorCode == 0) then
      if ((getTime() - lastRun) > 100) then
        __stopWmSw2 = bit32.band(__stopWmSw2, bit32.bnot(2));
        menuState[1] = 0; -- deselected state
      end
    end
end

return {
    init = init_telemetry,
    run = run_telemetry,
    background = background_telemetry,
}
