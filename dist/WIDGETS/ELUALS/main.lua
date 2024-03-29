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
local name = "EL_But";
local options = {
  { "Name", STRING},
  { "Reset", VALUE, 0, 0, 1},
};
-- shared between all instances
local iconTable = {}; -- hash table for icon bitmaps, only hash based access
-- local ccfg = nil;
-- local initFailed = -1;
-- local lastTime = 0;
-- local exclusiveGroups = {};
-- local iconWidget = nil;
-- local iconDefaultSmall = nil;
-- local iconDefaultLarge = nil;
local function insertSRFFs(widget, config)
  if not (config.buttons) then
    return 1;
  end
  local instanceData = widget[12];
  if not LS_FUNC_STICKY then
                     ;
    LS_FUNC_STICKY = 18;
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
            if (instanceData[2] < 0) then
              instanceData[2] = i;
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
local function makeGroups(config)
  local groups = {};
  for i, b in ipairs(config.buttons) do
    if (b.ls > 0) then
      if (b.exgroup) and (b.exgroup > 0) then
        if not (groups[b.exgroup]) then
          groups[b.exgroup] = {};
        end
        groups[b.exgroup][#groups[b.exgroup] + 1] = b.ls;
                                              ;
      end
    end
  end
  return groups;
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
  local name = options.Name;
  if (name) then
                         ;
    if not (type(name) == "string") then
                               ;
      name = __libU.optionString(name);
    end
  end
                                 ;
  local cfg = loadFile("/EDGELUA" .. "/MODELS/LSBUT/", name);
  local ccfg = {};
  if (cfg) then
    ccfg = cfg();
    if not (ccfg.name) then
      ccfg.name = "unnamed";
    end
  end
                           ;
  if (errorCode > 0) then
    return {};
  end
  local widget = __libI.initWidget(zone, options);
  local instanceData = {};
  widget[12] = instanceData;
  instanceData[1] = ccfg;
  instanceData[3] = 0;
  if (options.Reset == 0) then
    instanceData[2] = -1; -- no following explicit reset
  end
  local r = insertSRFFs(widget, ccfg);
  if (r > 0) then
    errorCode = 10 + r;
  end
  local exclusiveGroups = makeGroups(ccfg);
  collectgarbage();
  instanceData[4] = exclusiveGroups;
  instanceData[5] = loadIcon("/EDGELUA" .. "/ICONS/48px/" .. "expand.png");
  instanceData[6] = loadIcon("/EDGELUA" .. "/ICONS/48px/" .. "round.png");
  instanceData[7] = loadIcon("/EDGELUA" .. "/ICONS/72px/" .. "round.png");
  __libI = nil;
  collectgarbage();
  return widget;
end
local function update(widget, options)
  widget[11] = options;
end
local function background(widget)
  local instanceData = widget[12];
  if (errorCode == 0) then
                       ;
    if (instanceData[2] >= 0) then
      local t = getTime();
      if ((t - instanceData[3]) > 20) then
        instanceData[3] = t;
        for i, b in ipairs(instanceData[1].buttons) do
          if ((i >= instanceData[2]) and (b.ls > 0)) then
            local lsNumber = b.ls - 1;
                                             ;
            if (setStickySwitch(lsNumber, false)) then
              instanceData[2] = i;
              return;
            end
          end
        end
        instanceData[2] = -1;
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
  -- if ((config.layout.rows * config.layout.cols) > #config.buttons) then
  -- return 3;
  -- end
  local iconDefaultLarge = widget[12][7];
  local iconDefaultSmall = widget[12][6];
  local exclusiveGroups = widget[12][4];
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
      if (config.buttons[idx]) then
        local lsNumber = config.buttons[idx].ls - 1;
        lcd.drawFilledRectangle(x, y, bw, bh, COLOR_THEME_SECONDARY1);
        if (getLogicalSwitchValue(lsNumber)) then
          lcd.drawRectangle(x, y, bw, bh, COLOR_THEME_WARNING, border);
        else
          lcd.drawRectangle(x, y, bw, bh, COLOR_THEME_PRIMARY2);
        end
        if (#config.buttons <= 4) then
          if (config.buttons[idx].iconData) then
            lcd.drawBitmap(config.buttons[idx].iconData, x + fw / 2 - 36, y + fh / 2 - 36);
          else
            if (config.buttons[idx].icon) then
              if not(config.buttons[idx].icon == 0) then
                local icon, ok = loadIcon("/EDGELUA" .. "/ICONS/72px/" .. config.buttons[idx].icon);
                if (ok) then
                  config.buttons[idx].iconData = icon;
                end
              end
            else
              lcd.drawBitmap(iconDefaultLarge, x + fw / 2 - 36, y + fh / 2 - 36);
            end
          end
          if (config.buttons[idx].name) then
            lcd.drawText(x + 2 * border, y + 2 * border, config.buttons[idx].name, MIDSIZE + COLOR_THEME_PRIMARY1);
          end
        else
          if (config.buttons[idx].iconData) then
            lcd.drawBitmap(config.buttons[idx].iconData, x + fw / 2 - 24, y + fh / 2 - 24);
          else
            if (config.buttons[idx].icon) then
              local icon, ok = loadIcon("/EDGELUA" .. "/ICONS/48px/" .. config.buttons[idx].icon);
              if (ok) then
                config.buttons[idx].iconData = icon;
              end
            else
              lcd.drawBitmap(iconDefaultSmall, x + fw / 2 - 24, y + fh / 2 - 24);
            end
          end
          if (config.buttons[idx].name) then
            lcd.drawText(x + 2 * border, y + 2 * border, config.buttons[idx].name, SMLSIZE + COLOR_THEME_PRIMARY1);
          end
        end
      else
        lcd.drawFilledRectangle(x, y, bw, bh, COLOR_THEME_SECONDARY2);
      end
      local rect = {xmin = x, xmax = x + bw, ymin = y, ymax = y + bh};
      rects[idx] = rect;
    idx = idx + 1;
    end
  end
  if ((touch) and (event == EVT_TOUCH_TAP)) then
    for i, rect in ipairs(rects) do
      if (config.buttons[i]) then
        if (covers(touch, rect)) then
                                                  ;
          local lsNumber = config.buttons[i].ls - 1;
          if (getLogicalSwitchValue(lsNumber)) then
            setStickySwitch(config.buttons[i].ls - 1, false);
          else
            if (config.buttons[i].exgroup) and (exclusiveGroups[config.buttons[i].exgroup]) then
              for exgi, exls in ipairs(exclusiveGroups[config.buttons[i].exgroup]) do
                if (config.buttons[i].ls ~= exls) then
                  setStickySwitch(exls - 1, false);
                end
              end
            end
            setStickySwitch(config.buttons[i].ls - 1, true);
          end
        end
      end
    end
  end
  return 0;
end
local function refresh(widget, event, touch)
  local instanceData = widget[12];
  local ccfg = instanceData[1];
  local iconWidget = instanceData[5];
  background(widget);
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) and (ccfg) then
    -- ;
    if (widget[3] <= (LCD_W / 2)) or (widget[4] <= (LCD_H / 2)) then
      if (iconWidget) then
        lcd.drawBitmap(iconWidget, widget[1], widget[2] + widget[4] / 2 - 24);
      end
      lcd.drawText(widget[1] + 60, widget[2] + widget[4] / 2 - widget[9], ccfg.name, MIDSIZE);
    else
      local error = displayButtons(ccfg, widget, event, touch);
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
