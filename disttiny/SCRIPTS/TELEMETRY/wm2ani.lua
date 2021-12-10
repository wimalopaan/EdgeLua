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
local animations = nil;
local fsmState = {};
local currentAnimation = nil;

local function init_telemetry()
    load();
    loadLibA();
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

      animations = __libA.loadAnimations(__WmSw2Config);

      if not(animations) then
        errorCode = 5;
        return;
      end

      animations = __libA.initAnimations(animations);

      if not(animations) then
        errorCode = 6;
        return;
      end

      __libA.initAnimationFSM(fsmState);

      __libI = nil; -- free memory
      collectgarbage();
end

local function run_telemetry(event)
    lcd.clear();
    if (errorCode == 0) then
      lcd.drawScreenTitle("Animations", 1, 1);
      currentAnimation = __libA.chooseAnimation(__WmSw2Config, widget, animations, fsmState, event);
    else
      lcd.drawText(0, 0, "Error: " .. errorCode, DBLSIZE);
    end
  end

local function run_background()
  if (errorCode == 0) then

    if (__stopWmSw2 == 0) then
      currentAnimation = __libA.runAnimation(currentAnimation, fsmState);
    end
  end
end

return {
    init = init_telemetry,
    run = run_telemetry,
    background = run_background
}