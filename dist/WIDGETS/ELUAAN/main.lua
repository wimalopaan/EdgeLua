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

local function loadLibA()
  local basedir = "/EDGELUA" .. "/LIB/";
  if not __libA then
                              ;
    __libA = loadScript(basedir .. "libA.lua")();
    if not __libA then
      errorCode = 3.1;
    end
  end
end

local function loadLibU()
  local basedir = "/EDGELUA" .. "/LIB/";
  if not __libU then
                              ;
    __libU = loadScript(basedir .. "libU.lua")();
    if not __libU then
      errorCode = 3.2;
    end
  end
end

local name = "EL_Ani";
local options = {};
local animations = nil;
local fsmState = {};
local currentAnimation = nil;

local function create(zone, options)
  load();
  loadLibA();
  collectgarbage();

             ;

  if (errorCode > 0) then
    return {};
  end

             ;
  local widget = __libI.initWidget(zone, options);
  collectgarbage();

             ;

  if not(__WmSw2Config) then
    local config = __libI.loadConfig();
    if not(config) then
      errorCode = 4;
      return widget;
    end
    __WmSw2Config = __libI.initConfig(config, true);
  end
  collectgarbage();

             ;

  animations = __libA.loadAnimations(__WmSw2Config);

             ;

  if not(animations) then
    errorCode = 5;
    return widget;
  end

  animations = __libA.initAnimations(animations);

             ;

  if not(animations) then
    errorCode = 6;
    return widget;
  end

  __libA.initAnimationFSM(fsmState);

             ;

  __libI = nil; -- free memory

  collectgarbage();

  return widget;
end

local function update(widget, options)
  widget[11] = options;
end

local function background(widget)
  if (errorCode == 0) then
    if (__stopWmSw2 == 0) then
      currentAnimation = __libA.runAnimation(currentAnimation, fsmState);
    end
  end
end

local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    currentAnimation = __libA.chooseAnimation(__WmSw2Config, widget, animations, fsmState, event, touch);
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
