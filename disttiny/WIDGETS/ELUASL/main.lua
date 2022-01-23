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

local function loadFile(baseDir, baseName)
    local content = nil;
    local filename = nil;
    if (baseName) then
        filename = baseName .. ".lua";
                                              ;
        content = loadScript(baseDir .. filename);
    end
    if not(content) then
        if (#model.getInfo().name > 0) then
            filename = model.getInfo().name .. ".lua";
                                                  ;
            content = loadScript(baseDir .. filename);
        end
    end
    if not(content) then
        if (LCD_W <= 128) then
            filename = "tiny.lua";
                                                  ;
            content = loadScript(baseDir .. filename);
        elseif (LCD_W <= 212) then
            filename = "medium.lua";
                                                  ;
            content = loadScript(baseDir .. filename);
        else
            filename = "large.lua";
                                                  ;
            content = loadScript(baseDir .. filename);
        end
    end
    if not(content) then
        filename = "default.lua";
                                              ;
        content = loadScript(baseDir .. filename);
    end
    return content, filename;
end

local function loadConfig()
    local baseDir = "/EDGELUA" .. "/RADIO/";
    local cfg = loadFile(baseDir);
                            ;
    if (cfg) then
        return cfg();
    end
    return nil;
end

local name = "EL_Sli";
local options = {
  { "Name", STRING}
};

local options = {};
local iconWidget = nil;

local iconTable = {}; -- hash table for icon bitmaps, only hash based access

local function loadIcon(filename)
  if (iconTable[filename]) then
                                      ;
    return iconTable[filename], true;
  end
  local icon = Bitmap.open(filename);
  local ok = true;
  if (icon) then
    local w, h = Bitmap.getSize(icon);
    if (w == 0) then
                                        ;
      ok = false;
    else
                                       ;
      iconTable[filename] = icon;
    end
  end
  return icon, ok;
end

local function create(zone, options)
  load();
  collectgarbage();

  if (errorCode > 0) then
    return {};
  end

  local widget = __libI.initWidget(zone, options);
  collectgarbage();

  __libI = nil; -- free memory

  collectgarbage();

  local name = options.Name;
  if (name) then

    if not (type(name) == "string") then
                                  ;
      name = __libU.optionString(name);
    end

  end

  config = loadFile("/EDGELUA" .. "/RADIO/SLIDER/", name);
  if (config) then
    config = config();

    if not (config.name) then
      config.name = "unnamed";
    end

  end

  if (errorCode > 0) then
    return {};
  end

  iconWidget = loadIcon("/EDGELUA" .. "/ICONS/48px/" .. "expand.png");

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
