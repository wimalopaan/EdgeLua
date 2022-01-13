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

local function loadFile(baseDir)
    local content = nil;
    local filename = nil;
    if (#model.getInfo().name > 0) then
    filename = model.getInfo().name .. ".lua";
                                          ;
    content = loadScript(baseDir .. filename);
    end
    if not content then
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
    if not content then
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

local name = "EL_But";
local options = {};
local config = nil;

local initFailed = -1;
local lastTime = 0;

local bmpExpandSmall = nil;
local bmpRoundSmall = nil;
local bmpRoundLarge = nil;

local function insertSRFFs(config)
  if not (config.buttons) then
    return 1;
  end

  for i, b in ipairs(config.buttons) do
    if (b.ls > 0) then
      local lsNumber = b.ls - 1;
                                          ;
      local ls = model.getLogicalSwitch(lsNumber);
      if (ls) then
        if (ls.func == 0) then
                                              ;
          model.setLogicalSwitch(lsNumber, {func = LS_FUNC_STICKY});
          setStickySwitch(lsNumber, false);
        elseif (ls.func == LS_FUNC_STICKY) then
                                             ;
          if (setStickySwitch(lsNumber, false)) then
            if (initFailed < 0) then
              initFailed = i;
            end
          end
        else
                                                ;
          return 2;
        end
      end
    end
  end
  return 0;
end

local function create(zone, options)
  load();
  if (errorCode > 0) then
    return {};
  end

  loadLibU();
  if (errorCode > 0) then
    return {};
  end

  config = loadFile("/EDGELUA" .. "/MODELS/LSBUT/");
  if (config) then
    config = config();

    if not (config.name) then
      config.name = "unnamed";
    end

  end

  if (errorCode > 0) then
    return {};
  end

  local r = insertSRFFs(config);
  if (r > 0) then
    errorCode = 10 + r;
  end

  local widget = __libI.initWidget(zone, options);
  collectgarbage();

  bmpExpandSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/expand.png");
  bmpRoundSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/round.png");
  bmpRoundLarge = Bitmap.open("/EDGELUA" .. "/ICONS/72px/round.png");

  if (bmpExpandSmall) then
    local w, h = Bitmap.getSize(bmpExpandSmall);
    if (w == 0) then
                              ;
      errorCode = 20;
    end
  end
  if (bmpRoundLarge) then
    local w, h = Bitmap.getSize(bmpRoundLarge);
    if (w == 0) then
                              ;
      errorCode = 21;
    end
  end
  if (bmpRoundSmall) then
    local w, h = Bitmap.getSize(bmpRoundSmall);
    if (w == 0) then
                              ;
      errorCode = 22;
    end
  end

  __libI = nil;
  collectgarbage();

  return widget;
end

local function update(widget, options)
  widget[11] = options;
end

local function background(widget)
  if (errorCode == 0) then
                       ;
    if (initFailed >= 0) then
      local t = getTime();
      if ((t - lastTime) > 20) then
        lastTime = t;
        for i, b in ipairs(config.buttons) do
          if ((i >= initFailed) and (b.ls > 0)) then
            local lsNumber = b.ls - 1;
                                             ;
            if (setStickySwitch(lsNumber, false)) then
              initFailed = i;
              return;
            end
          end
        end
        initFailed = -1;
        end
    end
  end
end

local function covers(touch, item)
  if ((touch.x >= item.xmin) and (touch.x <= item.xmax)
    and (touch.y >= item.ymin) and (touch.y <= item.ymax)) then
    return true;
  end
  return false;
end

local function displayButtons(config, widget, event, touch)
  if not (config.layout) then
    return 1;
  end
  if not (config.buttons) then
    return 2;
  end
  if ((config.layout.rows * config.layout.cols) > #config.buttons) then
    return 3;
  end

  local fw = widget[3] / config.layout.cols;
  local fh = widget[4] / config.layout.rows;
  local border = 6;
  local bw = fw - 2 * border;
  local bh = fh - 2 * border;
  local rects = {};
  local idx = 1;
  for row = 1, config.layout.rows, 1 do
    local y = widget[2] + (row - 1) * fh + border;
    for col = 1, config.layout.cols, 1 do
      local x = widget[1] + (col - 1) * fw + border;
      local lsNumber = config.buttons[idx].ls - 1;
      lcd.drawFilledRectangle(x, y, bw, bh, COLOR_THEME_SECONDARY1);
      if (getLogicalSwitchValue(lsNumber)) then
        lcd.drawRectangle(x, y, bw, bh, COLOR_THEME_WARNING, border);
      else
        lcd.drawRectangle(x, y, bw, bh, COLOR_THEME_PRIMARY2);
      end

      if (#config.buttons <= 4) then
        lcd.drawBitmap(bmpRoundLarge, x + fw / 2 - 36, y + fh / 2 - 36);
        if (config.buttons[idx].name) then
          lcd.drawText(x + 2 * border, y + 2 * border, config.buttons[idx].name, MIDSIZE + COLOR_THEME_PRIMARY1);
        end
      else
        lcd.drawBitmap(bmpRoundSmall, x + fw / 2 - 24, y + fh / 2 - 24);
        if (config.buttons[idx].name) then
          lcd.drawText(x + 2 * border, y + 2 * border, config.buttons[idx].name, SMLSIZE + COLOR_THEME_PRIMARY1);
        end
      end

      local rect = {xmin = x, xmax = x + bw, ymin = y, ymax = y + bh};
      rects[idx] = rect;
      idx = idx + 1;
    end
  end

  if ((touch) and (event == EVT_TOUCH_TAP)) then
    for i, rect in ipairs(rects) do
      if (covers(touch, rect)) then
                                                ;
        local lsNumber = config.buttons[i].ls - 1;
        if (getLogicalSwitchValue(lsNumber)) then
          setStickySwitch(config.buttons[i].ls - 1, false);
        else
          setStickySwitch(config.buttons[i].ls - 1, true);
        end
      end
    end
  end

  return 0;
end

local function refresh(widget, event, touch)
  background(widget);
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) and (config) then
    if (widget[3] <= (LCD_W / 2)) then
      if (bmpExpandSmall) then
        lcd.drawBitmap(bmpExpandSmall, widget[1], widget[2] + widget[4] / 2 - 24);
      end
      lcd.drawText(widget[1] + 60, widget[2] + widget[4] / 2 - widget[9], config.name, MIDSIZE);
    else
      local error = displayButtons(config, widget, event, touch);
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