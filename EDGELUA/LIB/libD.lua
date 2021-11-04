--
--
-- EdgeLUA - EdgeTx / OpenTx Extensions 
-- Copyright (C) 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
-- To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ 
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

-- IMPORTANT
-- Please note that the above license also covers the transfer protocol used and the encoding scheme and 
-- all further principals of tranferring state and other information.


local version = 1

local function isFullScreen(event)
  return not not event;
end

local function isEdgeTx()
  local ver, radio, maj, minor, rev, osname = getVersion();
  return osname ~= nil;
end

local function isColorLCD()
  return LCD_W >= 480;
end

local function updateWidgetDimensions(widget, event)
  if (isFullScreen(event)) then
    widget.x = 0;
    widget.y = 0;
    widget.w = LCD_W;
    widget.h = LCD_H;
    widget.fh = widget.fh_l;
  else
    widget.x = widget.zone.x;
    widget.y = widget.zone.y;
    widget.w = widget.zone.w;
    widget.h = widget.zone.h;
    widget.fh = widget.fh_s;
  end
end

local function displayFooter(widget, text)
  lcd.drawText(widget.x, widget.y + widget.h - widget.fh, text, SMLSIZE + COLOR_THEME_PRIMARY3);
end

local function displayHeader(widget, text)
  lcd.drawText(widget.x + widget.w - 60, widget.y, text, SMLSIZE + COLOR_THEME_PRIMARY3);
end

local function displayInfo(widget, text)
  lcd.drawText(widget.x + widget.w - 60, widget.y + widget.fh, text, SMLSIZE + COLOR_THEME_PRIMARY3);
end

local function displayFooterNoTheme(widget, text)
  lcd.drawText(widget.x, widget.y + widget.h - widget.fh, text, SMLSIZE);
end

local function displayHeaderNoTheme(widget, text)
  lcd.drawText(widget.x + widget.w - 60, widget.y, text, SMLSIZE);
end

local function displayInfoNoTheme(widget, text)
  lcd.drawText(widget.x + widget.w - 60, widget.y + widget.fh, text, SMLSIZE);
end

local function displayParamMenuBW(config, widget, pmenu, pheaders, state, paramScaler)
  local activePageIndex = state[3];
  local page = pmenu[activePageIndex];
  local header = pheaders[activePageIndex];
  lcd.clear()
  lcd.drawScreenTitle(header[1] .. "/" .. header[2], activePageIndex, #pheaders);

  local maxParamsPerLine = 1;
  for headerRow = 3, #header do -- Param header
    local hline = header[headerRow];
    if (#hline > maxParamsPerLine) then
      maxParamsPerLine = #hline;
    end
  end
  local fw = (widget.w - config[2]) / maxParamsPerLine;

  for headerRow = 3, #header do 
    local hline = header[headerRow];
    local x = widget.x;
    local y = widget.y + widget.y_offset + (headerRow - 3) * widget.fh;      
    x = x + config[2];
    for col, item in ipairs(hline) do
      lcd.drawText(x, y, item[1], SMLSIZE);
      x = x + fw;
    end      
  end

  local pvalue, percent = paramScaler(config);
  local x = widget.x;
  local y = widget.y + widget.y_offset;
  if ((state[4] > 0) and (state[5] > 0)) then
    lcd.drawText(x, y, pvalue .. "[" .. percent .. "%]", SMLSIZE + INVERS);
    local item = page[state[4]];
    item[2][state[5]] = pvalue;
  else
    lcd.drawText(x, y, pvalue .. "[" .. percent .. "%]", SMLSIZE);
  end

  for row, item in ipairs(page) do
    local x = widget.x;
    local y = widget.y + widget.y_offset + (#header + row - 3) * widget.fh;
    local label = item[1][1];

    if (row == state[1]) then
      lcd.drawText(x, y, label, SMLSIZE + INVERS);
    else
      lcd.drawText(x, y, label, SMLSIZE);
    end

    x = x + config[2];
    for col, st in ipairs(item[2]) do
      if ((row == state[4]) and (col == state[5])) then
        lcd.drawText(x, y, st, SMLSIZE + INVERS);
      else
        if ((row == state[1]) and (col == state[2])) then
          lcd.drawText(x, y, st, SMLSIZE + INVERS + BLINK);
        else
          lcd.drawText(x, y, st, SMLSIZE);
        end
      end
      x = x + fw;
    end
  end   
  return pvalue;
end

local function displayParamMenuColorNoTheme(config, widget, pmenu, pheaders, state, paramScaler, event, help)
  local activePageIndex = state[3];
  local page = pmenu[activePageIndex];
  local header = pheaders[activePageIndex];

  lcd.clear()
  lcd.drawText(widget.x, widget.y, header[1] .. " [" .. header[2] .."]", MIDSIZE);

  displayHeader(widget, "Page " .. activePageIndex .. "/" .. #pmenu);

  if (pmenu.footer) then
    displayFooter(widget, pmenu.footer);
  end

  local maxParamsPerLine = 1;
  for headerRow = 3, #header do -- Param header
    local hline = header[headerRow];
    if (#hline > maxParamsPerLine) then
      maxParamsPerLine = #hline;
    end
  end
  local fw = (widget.w - config[2]) / maxParamsPerLine;

  for headerRow = 3, #header do 
    local hline = header[headerRow];
    local x = widget.x;
    local y = widget.y + widget.y_offset + (headerRow - 3) * widget.fh;      
    x = x + config[2];
    for col, item in ipairs(hline) do
      lcd.drawText(x, y, item[1], SMLSIZE);
      x = x + fw;
    end      
  end

  if (help) then
    local htext = help[activePageIndex];
    if (htext) then
--      print("item:", htext, activePageIndex, #help);
      lcd.drawText(widget.x, widget.y + widget.h - 2 * widget.fh, "Hilfe: " .. htext, SMLSIZE);
    end 
  end 

  local pvalue, percent = paramScaler(config);
  local x = widget.x;
  local y = widget.y + widget.y_offset;
  if ((state[4] > 0) and (state[5] > 0)) then
    lcd.drawText(x, y, pvalue .. "[" .. percent .. "%]", SMLSIZE);
    local item = page[state[4]];
    item[2][state[5]] = pvalue;
  else
    lcd.drawText(x, y, pvalue .. "[" .. percent .. "%]", SMLSIZE);
  end

  for row, item in ipairs(page) do
    item.rects = {};
    local x = widget.x;
    local y = widget.y + widget.y_offset + (#header + row - 3) * widget.fh;
    local label = item[1][1];
    if (item[3] > 1) then
      label = "--" .. label;
    end
    if (row == state[1]) then
      lcd.drawText(x, y, label, SMLSIZE + INVERS);
    else
      lcd.drawText(x, y, label, SMLSIZE);
    end

    x = x + config[2];
    for col, st in ipairs(item[2]) do
      local rect = {xmin = x, ymin = y, xmax = x + fw, ymax = y + widget.fh};
      item.rects[col] = rect;

      if ((row == state[4]) and (col == state[5])) then
        lcd.drawText(x, y, st, SMLSIZE + INVERS);
--        if (event) then
--          lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1);
--        end
      else
        if ((row == state[1]) and (col == state[2])) then
          lcd.drawText(x, y, st, SMLSIZE + INVERS + BLINK);
--          if (event) then
--            lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1);
--          end
        else
          lcd.drawText(x, y, st, SMLSIZE);
--          if (event) then
--            lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1);
--          end
        end
      end
      x = x + fw;
    end
  end   
  return pvalue;
end


local function displayParamMenuColor(config, widget, pmenu, pheaders, state, paramScaler, event, help)
  local activePageIndex = state[3];
  local page = pmenu[activePageIndex];
  local header = pheaders[activePageIndex];

  lcd.clear()
  lcd.drawText(widget.x, widget.y, header[1] .. " [" .. header[2] .."]", MIDSIZE + COLOR_THEME_PRIMARY3);

  displayHeader(widget, "Page " .. activePageIndex .. "/" .. #pmenu);

  if (pmenu.footer) then
    displayFooter(widget, pmenu.footer);
  end

  local maxParamsPerLine = 1;
  for headerRow = 3, #header do -- Param header
    local hline = header[headerRow];
    if (#hline > maxParamsPerLine) then
      maxParamsPerLine = #hline;
    end
  end
  local fw = (widget.w - config[2]) / maxParamsPerLine;

  for headerRow = 3, #header do 
    local hline = header[headerRow];
    local x = widget.x;
    local y = widget.y + widget.y_offset + (headerRow - 3) * widget.fh;      
    x = x + config[2];
    for col, item in ipairs(hline) do
      lcd.drawText(x, y, item[1], SMLSIZE);
      x = x + fw;
    end      
  end

  if (help) then
    local htext = help[activePageIndex];
    if (htext) then
--      print("item:", htext, activePageIndex, #help);
      lcd.drawText(widget.x, widget.y + widget.h - 2 * widget.fh, "Hilfe: " .. htext, SMLSIZE + COLOR_THEME_PRIMARY1);
    end 
  end 

  local pvalue, percent = paramScaler(config);
  local x = widget.x;
  local y = widget.y + widget.y_offset;
  if ((state[4] > 0) and (state[5] > 0)) then
    lcd.drawText(x, y, pvalue .. "[" .. percent .. "%]", SMLSIZE + COLOR_THEME_WARNING);
    local item = page[state[4]];
    item[2][state[5]] = pvalue;
  else
    lcd.drawText(x, y, pvalue .. "[" .. percent .. "%]", SMLSIZE + COLOR_THEME_PRIMARY3);
  end

  for row, item in ipairs(page) do
    item.rects = {};
    local x = widget.x;
    local y = widget.y + widget.y_offset + (#header + row - 3) * widget.fh;
    local label = item[1][1];
    if (item[3] > 1) then
      label = "--" .. label;
    end
    if (row == state[1]) then
      lcd.drawText(x, y, label, SMLSIZE + INVERS + COLOR_THEME_SECONDARY2, COLOR_THEME_PRIMARY2);
    else
      lcd.drawText(x, y, label, SMLSIZE + COLOR_THEME_PRIMARY1);
    end

    x = x + config[2];
    for col, st in ipairs(item[2]) do
      local rect = {xmin = x, ymin = y, xmax = x + fw, ymax = y + widget.fh};
      item.rects[col] = rect;

      if ((row == state[4]) and (col == state[5])) then
        lcd.drawText(x, y, st, SMLSIZE + INVERS + COLOR_THEME_SECONDARY2, COLOR_THEME_PRIMARY2);
        if (event) then
          lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1, COLOR_THEME_ACTIVE);
        end
      else
        if ((row == state[1]) and (col == state[2])) then
          lcd.drawText(x, y, st, SMLSIZE + INVERS + BLINK + COLOR_THEME_SECONDARY2, COLOR_THEME_PRIMARY2);
          if (event) then
            lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1, COLOR_THEME_FOCUS);
          end
        else
          lcd.drawText(x, y, st, SMLSIZE+ COLOR_THEME_PRIMARY1);
          if (event) then
            lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1, COLOR_THEME_PRIMARY3);
          end
        end
      end
      x = x + fw;
    end
  end   
  return pvalue;
end


local function displayMenuBW(config, widget, menu, overlays, state)
  lcd.clear()
  local activePageIndex = state[3];
  local page = menu[activePageIndex];
  local overlay = overlays[activePageIndex];

  lcd.drawScreenTitle(config[1], activePageIndex, #menu);

  for row, item in ipairs(page) do
    local x = widget.x;
    local y = widget.y + widget.y_offset + (row - 1) * widget.fh;

    local label = item[1];
    if (item[7]) then
      label = label .. "#";
    end

    for io, o in ipairs(overlay) do
      if (o[2] == item) then
        label = label .. "*";
      end
    end

    if (row == state[1]) then
      lcd.drawText(x, y, label, SMLSIZE + INVERS);
    else
      lcd.drawText(x, y, label, SMLSIZE);
    end

    local fw = (widget.w - config[2]) / #item[2];
    x = x + config[2];

    for col, st in ipairs(item[2]) do
      if (col == item[3]) then
        lcd.drawText(x, y, st, SMLSIZE + INVERS);
      else 
        if (state[2] == col) and (row == state[1]) then
          lcd.drawText(x, y, st, SMLSIZE + INVERS + BLINK);
        else
          lcd.drawText(x, y, st);
        end
      end
      x = x + fw;
    end
  end
end

local function displayMenuColor(config, widget, menu, overlays, state, event, remote, warning1, warning2)
  lcd.clear()

  if (warning1) then
    local ww1, wh1 = lcd.sizeText(warning1, DBLSIZE);
    lcd.drawText(widget.x + widget.w / 2 - ww1 / 2, widget.y + widget.h / 2 - wh1,
      warning1, DBLSIZE + COLOR_THEME_WARNING);
    if (warning2) then
      local ww2, wh2 = lcd.sizeText(warning2, XXLSIZE);
      lcd.drawText(widget.x + widget.w / 2 - ww2 / 2, widget.y + widget.h / 2,
        warning2, XXLSIZE + COLOR_THEME_WARNING);
    end
  end

  local activePageIndex = state[3];
  local page = menu[activePageIndex];
  local overlay = overlays[activePageIndex];

  if (page.title) then
    lcd.drawText(widget.x, widget.y, page.title, MIDSIZE + COLOR_THEME_PRIMARY3);
  else
    if (menu.title) then
      lcd.drawText(widget.x, widget.y, menu.title, MIDSIZE + COLOR_THEME_PRIMARY3);
    end
  end

  displayHeader(widget, "Page" .. activePageIndex .. "/" .. #menu);

  if (menu.footer) then
    displayFooter(widget, menu.footer);
  end

  if (config[8]) then
    lcd.drawText(widget.x + widget.w - 70, widget.y + widget.h - widget.fh,
      "r[" .. remote[2] .. "," .. remote[3] .. "," .. remote[4] .. "]:" .. remote[1],
      SMLSIZE + COLOR_THEME_PRIMARY3);
  end

  for row, item in ipairs(page) do
    item.rects = {};
    local x = widget.x;
    local y = widget.y + widget.y_offset + (row - 1) * widget.fh;

    local label = item[1];
    if (item[7]) then
      label = label .. "#";
    end

    for io, o in ipairs(overlay) do
      if (o[2] == item) then
        label = label .. "*";
      end
    end

    if (row == state[1]) then
      lcd.drawText(x, y, label, SMLSIZE + INVERS + COLOR_THEME_SECONDARY2, COLOR_THEME_PRIMARY2);
    else
      lcd.drawText(x, y, label, SMLSIZE + COLOR_THEME_PRIMARY1);
    end

    local fw = (widget.w - config[2]) / #item[2];
    x = x + config[2];

    for col, st in ipairs(item[2]) do
      local rect = {xmin = x, ymin = y, xmax = x + fw, ymax = y + widget.fh};
      item.rects[col] = rect;
      if (col == item[3]) then -- active
        lcd.drawText(x, y, st, SMLSIZE + INVERS + COLOR_THEME_SECONDARY2, COLOR_THEME_PRIMARY2);
        if (event) then
          lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1, COLOR_THEME_ACTIVE);
        end
      else 
        if (state[2] == col) and (row == state[1]) then -- focus
          lcd.drawText(x, y, st, SMLSIZE + INVERS + BLINK + COLOR_THEME_SECONDARY2, COLOR_THEME_PRIMARY2);
          if (event) then
            lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1, COLOR_THEME_FOCUS);
          end
        else -- 
          lcd.drawText(x, y, st, SMLSIZE + COLOR_THEME_PRIMARY1);
          if (event) then
            lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1, COLOR_THEME_PRIMARY3);
          end
        end
      end
      x = x + fw;
    end
  end
end

local function displayMenuColorNoTheme(config, widget, menu, overlays, state, event, remote, warning1, warning2)
  lcd.clear()

  if (warning) then
    local ww, wh = lcd.sizeText(warning, DBLSIZE);
    lcd.drawText(widget.x + widget.w / 2 - ww / 2, widget.y + widget.h / 2 - wh / 2,
      warning, XXLSIZE);
  end

  local activePageIndex = state[3];
  local page = menu[activePageIndex];
  local overlay = overlays[activePageIndex];

  if (page.title) then
    lcd.drawText(widget.x, widget.y, page.title, MIDSIZE);
  else
    if (menu.title) then
      lcd.drawText(widget.x, widget.y, menu.title, MIDSIZE);
    end
  end

  displayHeaderNoTheme(widget, activePageIndex .. "/" .. #menu);

  if (menu.footer) then
    displayFooterNoTheme(widget, menu.footer);
  end

  for row, item in ipairs(page) do
    item.rects = {};
    local x = widget.x;
    local y = widget.y + widget.y_offset + (row - 1) * widget.fh;

    local label = item[1];
    if (item[7]) then
      label = label .. "#";
    end

    for io, o in ipairs(overlay) do
      if (o[2] == item) then
        label = label .. "*";
      end
    end

    if (row == state[1]) then
      lcd.drawText(x, y, label, SMLSIZE + INVERS);
    else
      lcd.drawText(x, y, label, SMLSIZE);
    end

    local fw = (widget.w - config[2]) / #item[2];
    x = x + config[2];

    for col, st in ipairs(item[2]) do
      local rect = {xmin = x, ymin = y, xmax = x + fw, ymax = y + widget.fh};
      item.rects[col] = rect;
      if (col == item[3]) then -- active
        lcd.drawText(x, y, st, SMLSIZE + INVERS);
--        if (event) then
--          lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1);
--        end
      else 
        if (state[2] == col) and (row == state[1]) then -- focus
          lcd.drawText(x, y, st, SMLSIZE + INVERS + BLINK);
--          if (event) then
--            lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1);
--          end
        else -- 
          lcd.drawText(x, y, st);
--          if (event) then
--            lcd.drawRectangle(x - 1, y - 1, fw - 1, widget.fh - 1);
--          end
        end
      end
      x = x + fw;
    end
  end
end

local function prevPage(menu, menuState)
  if (menuState[3] == 1) then
    menuState[3] = #menu;
  else
    menuState[3] = menuState[3] - 1;
  end
end

local function nextPage(menu, menuState)
  if (menuState[3] == #menu) then
    menuState[3] = 1;
  else
    menuState[3] = menuState[3] + 1;
  end
end

local function prevRow(menu, menuState)
  if (menuState[1] == 1) then
    prevPage(menu, menuState);
    menuState[1] = #menu[menuState[3]];
  else
    menuState[1] = menuState[1] - 1;
  end
end

local function nextRow(menu, menuState)
  if (menuState[1] == #menu[menuState[3]]) then
    nextPage(menu, menuState);
    menuState[1] = 1;
  else
    menuState[1] = menuState[1] + 1; 
  end
end

local function prevCol(menu, menuState)
  if (menuState[2] == 1) then
    prevRow(menu, menuState);
    menuState[2] = #menu[menuState[3]][menuState[1]][2];
  else
    menuState[2] = menuState[2] - 1;
  end
end

local function nextCol(menu, menuState)
  if (menuState[2] == #menu[menuState[3]][menuState[1]][2]) then
    nextRow(menu, menuState);
    menuState[2] = 1;
  else
    menuState[2] = menuState[2] + 1;
  end
end

local function menuDeselect(menuState)
  menuState[4] = 0;
  menuState[5] = 0;
end

local function makeSelection(menuState)
  menuState[4] = menuState[1]; -- selection
  menuState[5] = menuState[2];
end

local function selectParamItem(menu, menuState, queue)
  makeSelection(menuState);
  local page = menu[menuState[3]];
  local pitem = page[menuState[1]];
  local item = pitem;
  queue:push(item);
end

local function selectItem(menu, menuState, queue)
  makeSelection(menuState);
  local page = menu[menuState[3]];
  local item = page[menuState[1]];
  item[3] = menuState[2];
  queue:push(item);
end

local function processEventsBW(config, menu, menuState, event, queue, callback)
  if (event == EVT_VIRTUAL_ENTER) then
    callback(menu, menuState, queue);
  else
    if (event > 0) then
      menuDeselect(menuState);
    end
    if (event == EVT_VIRTUAL_INC) then
      prevCol(menu, menuState);
    elseif (event == EVT_VIRTUAL_DEC) then
      nextCol(menu, menuState);
    elseif (event == EVT_VIRTUAL_PREV) or (event == 101) then
      prevCol(menu, menuState);
    elseif (event == EVT_VIRTUAL_NEXT) or (event == 100) then
      nextCol(menu, menuState);
    end
  end
end

local function processEventsColor(config, menu, menuState, event, queue, callback)
  if (event == EVT_VIRTUAL_ENTER) then
    callback(menu, menuState, queue);
  else
    if (event) and (event > 0) then
      menuDeselect(menuState);
    end
    if (event == EVT_VIRTUAL_INC) then
      prevCol(menu, menuState);
    elseif (event == EVT_VIRTUAL_DEC) then
      nextCol(menu, menuState);
    elseif (event == EVT_VIRTUAL_PREV) or (event == 101) then
      prevCol(menu, menuState);
    elseif (event == EVT_VIRTUAL_NEXT) or (event == 100) then
      nextCol(menu, menuState);
    elseif (event == 0x601) then
      nextCol(menu, menuState);
    elseif (event == 0x600) then
      prevCol(menu, menuState);
    elseif (event == 0x605) then
      nextRow(menu, menuState);
    elseif (event == 0x604) then
      prevRow(menu, menuState);
    elseif (event == 0x801) then
      nextPage(menu, menuState);
    elseif (event == 0x800) then
      prevPage(menu, menuState);
    end
  end
end

local function getSwitchValue(id, lsmode)
  local value = getValue(id);
  if (lsmode == 0) then
    if (value == 0) then
      return 1;
    elseif (value > 0) then
      return 2;
    else
      return 3;
    end
  elseif (lsmode == 1) then
    if (value < 0) then
      return 1;
    else
      return 2;
    end
  else
    if (value < 0) then
      return 1;
    else
      return 3;
    end
  end
end

local function processShortCuts(shortCuts, queue)
  for i, sc in ipairs(shortCuts) do
    local v = getSwitchValue(sc[1], sc[3]);
    if not (v == sc[4]) then
      sc[4] = v;
      sc[2][3] = v;
      queue:push(sc[2]);
    end
  end
end

local function processOverlays(overlays, menuState, queue)
  local activePageIndex = menuState[3];
  local overlay = overlays[activePageIndex];
  processShortCuts(overlay, queue);
end

local function processTrims(config, menu, menuState, buttonState, queue, callback)
  if (config[11]) then
    local value = getValue(config[11]);
    if (value > buttonState[1]) then
      prevCol(menu, menuState);
      menuDeselect(menuState);
    end
    buttonState[1] = value;
  end
  if (config[12]) then
    local value = getValue(config[12]);
    if (value > buttonState[2]) then
      nextCol(menu, menuState);
      menuDeselect(menuState);
    end
    buttonState[2] = value;
  end
  if (config[13]) then
    local value = getValue(config[13]);
    if (value > buttonState[3]) then
--	 print("cb", callback);
      callback(menu, menuState, queue);
    end
    buttonState[3] = value;
  end
end

local function processPots(config, menu, menuState, buttonState)
  if (config[4]) then
    local activePageIndex = menuState[3];
    local page = menu[activePageIndex];
    local value = getValue(config[4]) + 1024;
    local row = #page - math.floor(value * #page / 2049);
    if (row ~= buttonState[5]) then
      menuState[1] = row;
      buttonState[5] = row;
      menuDeselect(menuState);
    end
  end
  if (config[5]) then
    local activePageIndex = menuState[3];
    local page = menu[activePageIndex];
    local item = page[menuState[2]];
    local value = getValue(config[5]) + 1024;
    if (item) then
      local col = math.floor(value * #item[2] / 2049) + 1;
      if (col ~= buttonState[6]) then
        menuState[2] = col;
        buttonState[6] = col;
        menuDeselect(menuState);
      end
    end
  end
end

local function processMenuSwitch(config, menu, menuState, buttonState)
  if (config[7]) then
    local ms = getValue(config[7]);
    if (math.abs(ms - buttonState[4]) > 10) then
      local s = 1;
      for i = 0,5 do
        if (ms <= (-1024 + (2 * i  + 1) * (2048 / 6))) then
          s = i + 1;
          break;
        end
      end
      if (s <= #menu) then
        menuState[3] = s;
      end
      buttonState[4] = ms;
      menuDeselect(menuState);
    end
  end
end

local function processButtons(config, menu, menuState, buttonState, queue, callback)
  processTrims(config, menu, menuState, buttonState, queue, callback);
  processPots(config, menu, menuState, buttonState);
  processMenuSwitch(config, menu, menuState, buttonState);
end

local function covers(touch, item) 
  if ((touch.x >= item.xmin) and (touch.x <= item.xmax)
    and (touch.y >= item.ymin) and (touch.y <= item.ymax)) then
    return true;
  end
  return false;
end

local function processTouch(menu, menuState, event, touch)
  if (touch) then
    local activePageIndex = menuState[3];
    local page = menu[activePageIndex];
    if (event == EVT_TOUCH_TAP) then
      for row, item in ipairs(page) do
--	    print("rect", item.rects);
        for col, rect in ipairs(item.rects) do   
          if (covers(touch, rect)) then
            menuState[1] = row;
            menuState[2] = col;
          end
        end
      end
    end
    if (event == EVT_TOUCH_SLIDE) then
      if (touch.swipeLeft) then
        prevPage(menu, menuState);
      end
      if (touch.swipeRight) then
        nextPage(menu, menuState);
      end
    end
  end
end

local function findItem(cmenu, fn, module) -- compressed-menu
  for ip, page in ipairs(cmenu) do
    for i, item in ipairs(page) do
      if (item[4]) and (item[5]) and (item[4] == fn) and (item[5] == module) then
        return item;
      end
    end
  end
  return nil;
end

local function processForeignInput(config, foreignInput, menu, queue)
  local state = foreignInput % 10;
  foreignInput = math.floor(foreignInput / 10);
  local fn = foreignInput % 10
  foreignInput = math.floor(foreignInput / 10);
  local module = foreignInput % 10;;

  local item = findItem(menu, fn, module);
  if (item) then
--      print("foreign: ", module, fn, state);
    item[3] = state;
    queue:push(item);
  end
end

local function processRemoteInput(config, menu, queue, remoteState)
  if (not config[8]) then
    return;
  end

  local r = (getValue(config[8]) + 1024) / 2;

  if (r == remoteState[1]) then
    return;
  end
  remoteState[1] = r;

  local state = bit32.extract(r, 0, 3) + 1;
  local fn = bit32.extract(r, 3, 3) + 1;
  local module = bit32.extract(r, 6, 3) + 1;

  local item = findItem(menu, fn, module);
  if (item) then
    remoteState[2] = module;
    remoteState[3] = fn;
    remoteState[4] = state;
    print("remote: ", module, fn, state);
    item[3] = state;
    queue:push(item);
  end
end

local function displayFmRssiWarningColor(config, widget, state)
  local fm = getFlightMode();
  if (fm == config[15]) then
--    print("safemode");
  end   
end 

local function displayAddressConfigBW(config, widget, encoder, pScaler, state, event)
end

local function displayAddressConfigColor(config, widget, encoder, pScaler, state, event, touch)
  lcd.clear();

  local bh = 2 * widget.fh_l;
  local border_h = 20;
  local bw = widget.w - 2 * border_h;;

  local rect = {xmin = widget.x + border_h, xmax = widget.x + bw,
    ymin = widget.y + widget.h / 2 - bh / 2, ymax = widget.y + widget.h / 2 + bh / 2};

--   print("Adr: state: ", state[0]);
  if not(state[1]) or (state[1] == 0) then

    lcd.drawText(widget.x + border_h, widget.y + widget.fh_l, "Attach only one device to the RX.", SMLSIZE + COLOR_THEME_PRIMARY1);

    lcd.drawFilledRectangle(rect.xmin, rect.ymin, rect.xmax - rect.xmin + 1, rect.ymax - rect.ymin + 1, COLOR_THEME_FOCUS);
    lcd.drawText(rect.xmin + 5, rect.ymin + 5, "Press [Enter] to start learning", MIDSIZE + COLOR_THEME_PRIMARY1);
    if (event == EVT_VIRTUAL_ENTER) then
      state[1] = 1;
    end
  elseif (state[1] == 1) then    
    local adr = pScaler(config) + 1;
    if (adr > 8) then
      adr = 8;
    end 

    lcd.drawText(widget.x + border_h, widget.y + widget.fh_l, "Address: " .. adr, MIDSIZE + COLOR_THEME_WARNING);

    lcd.drawText(widget.x + border_h, widget.y + widget.h - widget.fh_l, "Watch for the device to respond.", SMLSIZE + COLOR_THEME_PRIMARY1);

    lcd.drawFilledRectangle(rect.xmin, rect.ymin, rect.xmax - rect.xmin + 1, rect.ymax - rect.ymin + 1, COLOR_THEME_ACTIVE);
    lcd.drawText(rect.xmin + 5, rect.ymin + 5, "Switch on RX and device", MIDSIZE + COLOR_THEME_PRIMARY2);

    encoder(config[10], 14, adr);

    if (event == EVT_VIRTUAL_ENTER) then
      state[1] = 0;
    end
  else
  end
end

local function displayAddressConfigColorNoTheme(config, widget, encoder, pScaler, state, event, touch)
end

if (LCD_W <= 128) then
  return {  
    displayMenu = displayMenuBW,
    displayParamMenu = displayParamMenuBW,
    processEvents = processEventsBW,
    processShortCuts = processShortCuts,
    processOverlays = processOverlays,
    selectItem = selectItem,
    selectParamItem = selectParamItem,
    displayAddressConfig = displayAddressConfigBW,
  };
elseif (LCD_W <= 212) then
  return { 
    displayMenu = displayMenuBW,
    displayParamMenu = displayParamMenuBW,
    processEvents = processEventsBW,
    processShortCuts = processShortCuts,
    processOverlays = processOverlays,
    selectItem = selectItem,
    selectParamItem = selectParamItem,
    displayAddressConfig = displayAddressConfigBW,
  };
else
  if (isEdgeTx()) then
    return { isFullScreen = isFullScreen,
      updateWidgetDimensions = updateWidgetDimensions,
      displayParamMenu = displayParamMenuColor,
      displayMenu = displayMenuColor,
      processEvents = processEventsColor,
      processShortCuts = processShortCuts,
      processOverlays = processOverlays,
      processTouch = processTouch,
      processButtons = processButtons,
      selectItem = selectItem,
      selectParamItem = selectParamItem,
      processForeignInput = processForeignInput,
      processRemoteInput = processRemoteInput,
      displayAddressConfig = displayAddressConfigColor,
      displayFmRssiWarning = displayFmRssiWarningColor,
    };
  else
    return { isFullScreen = isFullScreen,
      updateWidgetDimensions = updateWidgetDimensions,
      displayParamMenu = displayParamMenuColorNoTheme,
      displayMenu = displayMenuColorNoTheme,
      processEvents = processEventsColor,
      processShortCuts = processShortCuts,
      processOverlays = processOverlays,
      processTouch = processTouch,
      processButtons = processButtons,
      selectItem = selectItem,
      selectParamItem = selectParamItem,
      processForeignInput = processForeignInput,
      processRemoteInput = processRemoteInput,
      displayAddressConfig = displayAddressConfigColorNoTheme,
    };
  end
end

