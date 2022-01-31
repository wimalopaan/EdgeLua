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
local config = nil;
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

local function inside(touch, area)
                                                                                       ;
  if ((touch.x >= area.x) and (touch.x < (area.x + area.w)) and (touch.y >= area.y) and (touch.y <= (area.y + area.h))) then
    return true;
  end
  return false;
end

local function displaySliderVertical(slider, widget, event, touch)
  lcd.drawFilledRectangle(slider.x, slider.y, slider.w, slider.h, lcd.RGB(slider.data.color));
  lcd.drawRectangle(slider.x, slider.y, slider.w, slider.h, COLOR_THEME_PRIMARY2);
  lcd.drawText(slider.x, slider.y - 1.1 * widget[8], slider.data.name, COLOR_THEME_PRIMARY1);

  local value = -1 * getShmVar(slider.data.shm);
  local position = slider.h * (value / 1024 + 1) / 2 + slider.y;

  lcd.drawFilledRectangle(slider.x, position - 5, slider.w, 10, COLOR_THEME_PRIMARY1);

  if (event == EVT_TOUCH_SLIDE) then
    if (inside(touch, slider)) then
      local d = (touch.y - slider.y) / slider.h;
      local v = -1 * (d - 0.5) * 2048;
                                            ;
      setShmVar(slider.data.shm, v);
      return 1;
    end
  elseif (event == EVT_TOUCH_TAP) then
    if (touch.tapCount == 2) then
      if (inside(touch, slider)) then
        setShmVar(slider.data.shm, 0);
        return 2;
      end
    end
  end
  return 0;
end

local function displayAllSlider(config, widget, event, touch)
                              ;

  if (config.layout == "V") then
    if (#config.slider > 0) then
      local width = widget[3] / ( 2 * #config.slider + 1);
      local yborder = widget[4] * 0.1;
      local height = widget[4] - 2 * yborder;

      local y = yborder;

      for si, sl in ipairs(config.slider) do
        local slider = {
           x = (2 * (si - 1) + 1 ) * width;
           y = yborder;
           w = width;
           h = height;
           data = sl;
        };
        displaySliderVertical(slider, widget, event, touch);
      end
    end
  end
  if (config.layout == "H") then

  end
  return 0;
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
  if (errorCode == 0) and (config) then
    if (widget[3] <= (LCD_W / 2)) then
      if (iconWidget) then
        lcd.drawBitmap(iconWidget, widget[1], widget[2] + widget[4] / 2 - 24);
      end
      lcd.drawText(widget[1] + 60, widget[2] + widget[4] / 2 - widget[9], config.name, MIDSIZE);
    else
      local error = displayAllSlider(config, widget, event, touch);
      if (error > 0) then
        lcd.drawText(widget[1], widget[2], "Error: " .. error, DBLSIZE);
      end
    end
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
