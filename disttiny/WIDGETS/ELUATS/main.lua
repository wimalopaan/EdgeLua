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

local name = "EL_Test";
local options = {
  {"Test", STRING}
};

local function create(zone, options)
  load();
  loadLibU();
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
    __WmSw2Config = __libI.initConfig(config, true);
  end
  collectgarbage();

  __libI = nil; -- free memory

  collectgarbage();

  if (CHAR_TRIM) and (getSwitchIndex) then
    local t5u = getSwitchIndex(CHAR_TRIM .. "5u");
                    ;
  else
                                    ;
  end

  if (getPhysicalSwitches) then
    local sws = getPhysicalSwitches();
                                        ;
    for i, sw in ipairs(sws) do
                                                   ;
    end
  end

  return widget;
end

local function update(widget, options)
  widget[11] = options;
end

local function background(widget)
  if (errorCode == 0) then
  end
end

local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    __libU.displayDebug(widget);

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