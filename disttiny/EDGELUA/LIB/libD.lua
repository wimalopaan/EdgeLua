--
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
end

local function updateWidgetDimensionsEdgeTx(widget, event)
  if (isFullScreen(event)) then
    widget[1] = 0;
    widget[2] = 0;
    widget[3] = LCD_W;
    widget[4] = LCD_H;
    widget[5]= widget[9];
  else
    widget[1] = widget[10].x;
    widget[2] = widget[10].y;
    widget[3] = widget[10].w;
    widget[4] = widget[10].h;
    widget[5]= widget[8];
  end
end

local function updateWidgetDimensionsOpenTx(widget, event)
end

local function displayFooter(widget, text)
  lcd.drawText(widget[1], widget[2] + widget[4] - widget[5], text, SMLSIZE + COLOR_THEME_PRIMARY3);
end

local function displayHeader(widget, text)
  lcd.drawText(widget[1] + widget[3] - 60, widget[2], text, SMLSIZE + COLOR_THEME_PRIMARY3);
end

local function displayInfo(widget, text)
  lcd.drawText(widget[1] + widget[3] - 60, widget[2] + widget[5], text, SMLSIZE + COLOR_THEME_PRIMARY3);
end

local function displayFooterNoTheme(widget, text)
  lcd.drawText(widget[1], widget[2] + widget[4] - widget[5], text, SMLSIZE);
end

local function displayHeaderNoTheme(widget, text)
  lcd.drawText(widget[1] + widget[3] - 60, widget[2], text, SMLSIZE);
end

local function displayInfoNoTheme(widget, text)
  lcd.drawText(widget[1] + widget[3] - 60, widget[2] + widget[5], text, SMLSIZE);
end

local function displayParamMenuBW(config, widget, pmenu, pheaders, state, paramScaler)
  local activePageIndex = state[3];
  local page = pmenu[activePageIndex];
  local header = pheaders[activePageIndex];
  lcd.clear()

  if (config[14] == 3) or (config[14] == 4) then
    lcd.drawText(widget[1], widget[2], "Not usable with backend: " .. config[14], MIDSIZE);
    return 0;
  end

  lcd.drawScreenTitle(header[1] .. "/" .. header[2], activePageIndex, #pheaders);

  local maxParamsPerLine = 1;
  for headerRow = 3, #header do -- Param header
    local hline = header[headerRow];
    if (#hline > maxParamsPerLine) then
      maxParamsPerLine = #hline;
    end
  end
  local fw = (widget[3] - config[2]) / maxParamsPerLine;

  for headerRow = 3, #header do
    local hline = header[headerRow];
    local x = widget[1];
    local y = widget[2] + widget[6] + (headerRow - 3) * widget[5];
    x = x + config[2];
    for col, item in ipairs(hline) do
      lcd.drawText(x, y, item[1], SMLSIZE);
      x = x + fw;
    end
  end

  local pvalue, percent = paramScaler(config);
  local x = widget[1];
  local y = widget[2] + widget[6];
  if ((state[4] > 0) and (state[5] > 0)) then
    lcd.drawText(x, y, pvalue .. "[" .. percent .. "%]", SMLSIZE + INVERS);
    local line = page[state[4]];
    line[2][state[5]] = pvalue;
  else
    lcd.drawText(x, y, pvalue .. "[" .. percent .. "%]", SMLSIZE);
  end

  for row, line in ipairs(page) do
    local x = widget[1];
    local y = widget[2] + widget[6] + (#header + row - 3) * widget[5];
    local label = line[1][1];

    if (row == state[1]) then
      lcd.drawText(x, y, label, SMLSIZE + INVERS);
    else
      lcd.drawText(x, y, label, SMLSIZE);
    end

    x = x + config[2];
    for col, pv in ipairs(line[2]) do
      if ((row == state[4]) and (col == state[5])) then
        lcd.drawText(x, y, pv, SMLSIZE + INVERS);
      else
        if ((row == state[1]) and (col == state[2])) then
          lcd.drawText(x, y, pv, SMLSIZE + INVERS + BLINK);
        else
          lcd.drawText(x, y, pv, SMLSIZE);
        end
      end
      x = x + fw;
    end
  end
  return pvalue;
end
local function displayMenuBW(config, widget, menu, overlays, state, pagetitles)
  lcd.clear()
  local activePageIndex = state[3];
  local page = menu[activePageIndex];
  local overlay = overlays[activePageIndex];

                                                                  ;
  if (pagetitles[activePageIndex]) then
    lcd.drawScreenTitle(pagetitles[activePageIndex], activePageIndex, #menu);
  else
    lcd.drawScreenTitle(config[1], activePageIndex, #menu);
  end

  for row, item in ipairs(page) do
    local x = widget[1];
    local y = widget[2] + widget[6] + (row - 1) * widget[5];

    local label = item[1];
    if (item[7]) then
      label = label .. "#";
    end

    if (item[9]) then
      label = label .. "~";
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

    local fw = (widget[3] - config[2]) / #item[2];
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

local function setAndPushItem(queue, item, newState)
  local push = {[1] = item, [2] = item[3]};
  item[3] = newState;
  queue:push(push);
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
  setAndPushItem(queue, item, menuState[2]);
end

local function processEventsBWScroll(config, menu, menuState, event, queue, callback)
  if (event == EVT_VIRTUAL_ENTER) then
    callback(menu, menuState, queue);
  else

    if (event > 0) then
      menuDeselect(menuState);
    end
    if (event == EVT_VIRTUAL_INC) then -- same as EVT_VIRTUAL_NEXT
      prevCol(menu, menuState);
    elseif (event == EVT_VIRTUAL_DEC) then -- same as EVT_VIRTUAL_PREV
      nextCol(menu, menuState);
    elseif (event == 96) then
      prevRow(menu, menuState);
    elseif (event == 97) then
      nextRow(menu, menuState);
    end
  end
end

local function processEventsBWKeys(config, menu, menuState, event, queue, callback)
                                 ;
  if (event == EVT_VIRTUAL_ENTER) then
    callback(menu, menuState, queue);
  else

    if (event > 0) then
      menuDeselect(menuState);
    end
    if (event == EVT_VIRTUAL_INC) then
      prevRow(menu, menuState);
    elseif (event == EVT_VIRTUAL_DEC) then
      nextRow(menu, menuState);
    elseif (event == EVT_VIRTUAL_PREV) or (event == 101) then
      prevCol(menu, menuState);
    elseif (event == EVT_VIRTUAL_NEXT) or (event == 100) then
      nextCol(menu, menuState);
    end
  end
                                 ;
end
local function getSwitchValue(id, lsmode)
  local value = getValue(id);
  if (lsmode == 0) then
    if (value > 680) then
      return 2;
    elseif (value < -680) then
      return 3;
    else
      return 1;
    end
  elseif (lsmode == 1) then
    if (value < -680) then
      return 1;
    else
      return 2;
    end
  else
    if (value < -680) then
      return 1;
    else
      return 3;
    end
  end
end

local function processShortCuts(shortCuts, queue, switches)
                                      ;
  for i, sc in ipairs(shortCuts) do
    local v = getSwitchValue(sc[1], sc[3]);
    if not (v == switches[sc[1]][1]) then
      switches[sc[1]][1] = v;
      local item = sc[2];
      if not(item[3] == v) then
        setAndPushItem(queue, item, v);
                                                                     ;
      end
    end
  end
end

local function processOverlays(overlays, menuState, queue, switches)
                                     ;
  local activePageIndex = menuState[3];
  local overlay = overlays[activePageIndex];
  processShortCuts(overlay, queue, switches);
end

local function processTrimsSelect(config, buttonState, callback)
                                                                               ;
  if (config[13]) then
    local value = getValue(config[13]);
                                              ;
    if (value > buttonState[3]) then
                                            ;
      callback();
    end
    buttonState[3] = value;
  end
end

local function processTrimsPrevious(config, buttonState, callback)
  if (config[11]) then
    local value = getValue(config[11]);
    if (value > buttonState[1]) then
      callback();
    end
    buttonState[1] = value;
  end
end

local function processTrimsNext(config, buttonState, callback)
  if (config[12]) then
    local value = getValue(config[12]);
    if (value > buttonState[2]) then
      callback();
    end
    buttonState[2] = value;
  end
end

local function processTrims(config, menu, menuState, buttonState, queue, callback)
                        ;
  local prevCB = function()
    prevCol(menu, menuState);
    menuDeselect(menuState);
  end
  processTrimsPrevious(config, buttonState, prevCB);
  local nextCB = function()
    nextCol(menu, menuState);
    menuDeselect(menuState);
  end
  processTrimsNext(config, buttonState, nextCB);
  local selectCB = function()
                     ;
    callback(menu, menuState, queue);
  end
  processTrimsSelect(config, buttonState, selectCB);
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
    local item = page[menuState[1]];
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
        if (ms <= (-1024 + (2 * i + 1) * (2048 / 10))) then
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
        for col, rect in ipairs(item[8]) do
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

-- local function processForeignInput(config, foreignInput, menu, queue)
-- local state = foreignInput % 10;
-- foreignInput = math.floor(foreignInput / 10);
-- local fn = foreignInput % 10;
-- foreignInput = math.floor(foreignInput / 10);
-- local module = foreignInput % 10;

-- local item = findItem(menu, fn, module);
-- if (item) then
-- setAndPushItem(queue, item, state);
-- -- local push = {[1] = item, [2] = item[3]};
-- -- item[3] = state;
-- -- queue:push(push);
-- end
-- end

local function processForeignInputFromQueue(config, foreignQueue, menu, queue)
  if (foreignQueue:size() > 0) then
                                                              ;
    local fitem = foreignQueue:pop();
    if (fitem) then
      local item = findItem(menu, fitem[4], fitem[5]);
                                                                                          ;
      if (item) then
        setAndPushItem(queue, item, fitem[3]);
        -- local push = {[1] = item, [2] = item[3]};
        -- item[3] = state;
        -- queue:push(push);
      end
    end
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
                                        ;
    setAndPushItem(queue, item, state);
    -- local push = {[1] = item, [2] = item[3]};
    -- item[3] = state;
    -- queue:push(push);
  end
end

local function displayFmRssiWarningColor(config, widget, state)
  local fm = getFlightMode();
  if (fm == config[15]) then
                      ;
  end
end

local function displayAddressConfigBW(config, widget, encoder, pScaler, state, event)
  if (config[14] == 3) or (config[14] == 4) then
    lcd.drawText(widget[1], widget[2], "Not usable with backend: " .. config[14], MIDSIZE);
    return;
  end

  lcd.drawText(widget[1], widget[2] + widget[4] - widget[8], config[19], SMLSIZE);

  if (state[1] == 0) then

    lcd.drawText(widget[1], widget[2] + widget[5], "Attach only one device to the RX.", SMLSIZE);

    lcd.drawText(widget[1], widget[2] + 2 * widget[5], "Press [Enter] to start learning", MIDSIZE);

    if (event == EVT_VIRTUAL_ENTER) then
      state[1] = 1;
    end
  elseif (state[1] == 1) then
    local adr = pScaler(config) + 1;
    if (adr > 8) then
      adr = 8;
    end

    lcd.drawText(widget[1], widget[2] + widget[5], "Address: " .. adr, MIDSIZE + INVERS);

    lcd.drawText(widget[1], widget[2] + 2 * widget[9], "Watch for the device to respond.", SMLSIZE);

    lcd.drawText(widget[1], widget[2] + 3 * widget[9], "Switch on RX and device", MIDSIZE);

    local bendcfg = config[20][1];
                            ;
    encoder(bendcfg[2], 14, adr); -- learn code

    if (event == EVT_VIRTUAL_ENTER) then
      state[1] = 0;
    end
  else
  end
end
local function processEventsBW()
end

if (EVT_VIRTUAL_INC == EVT_VIRTUAL_NEXT) then
  processEventsBW = processEventsBWScroll;
else
  processEventsBW = processEventsBWKeys;
end

if (LCD_W <= 128) then
  displayMenuColor = nil;
  displayMenuColorNoTheme = nil;
  displayParamMenuColor = nil;
  displayParamMenuColorNoTheme = nil;
  displayAddressConfigColor = nil;
  displayAddressConfigColorNoTheme = nil;
   processEventsColor = nil;
  return {
    displayMenu = displayMenuBW,
    displayParamMenu = displayParamMenuBW,
    processEvents = processEventsBW,
    processShortCuts = processShortCuts,
    processOverlays = processOverlays,
    selectItem = selectItem,
    selectParamItem = selectParamItem,
    -- processForeignInput = processForeignInput,
    processForeignInputFromQueue = processForeignInputFromQueue,
    displayAddressConfig = displayAddressConfigBW,
  };
elseif (LCD_W <= 212) then
  displayMenuColor = nil;
  displayMenuColorNoTheme = nil;
  displayParamMenuColor = nil;
  displayParamMenuColorNoTheme = nil;
  displayAddressConfigColor = nil;
  displayAddressConfigColorNoTheme = nil;
  processEventsColor = nil;
  return {
    displayMenu = displayMenuBW,
    displayParamMenu = displayParamMenuBW,
    processEvents = processEventsBW,
    processShortCuts = processShortCuts,
    processOverlays = processOverlays,
    selectItem = selectItem,
    selectParamItem = selectParamItem,
    -- processForeignInput = processForeignInput,
    processForeignInputFromQueue = processForeignInputFromQueue,
    displayAddressConfig = displayAddressConfigBW,
  };
else
  if (isEdgeTx()) then
    return {
      isFullScreen = isFullScreen,
      updateWidgetDimensions = updateWidgetDimensionsEdgeTx,
      displayParamMenu = displayParamMenuColor,
      displayMenu = displayMenuColor,
      processEvents = processEventsColor,
      processShortCuts = processShortCuts,
      processOverlays = processOverlays,
      processTouch = processTouch,
      processButtons = processButtons,
      selectItem = selectItem,
      selectParamItem = selectParamItem,
      -- processForeignInput = processForeignInput,
      processForeignInputFromQueue = processForeignInputFromQueue,
      processRemoteInput = processRemoteInput,
      displayAddressConfig = displayAddressConfigColor,
      displayFmRssiWarning = displayFmRssiWarningColor,
    };
  else
    return {
      isFullScreen = isFullScreen,
      updateWidgetDimensions = updateWidgetDimensionsOpenTx,
      displayParamMenu = displayParamMenuColorNoTheme,
      displayMenu = displayMenuColorNoTheme,
      processEvents = processEventsColor,
      processShortCuts = processShortCuts,
      processOverlays = processOverlays,
      processTouch = processTouch,
      processButtons = processButtons,
      selectItem = selectItem,
      selectParamItem = selectParamItem,
      -- processForeignInput = processForeignInput,
      processForeignInputFromQueue = processForeignInputFromQueue,
      processRemoteInput = processRemoteInput,
      displayAddressConfig = displayAddressConfigColorNoTheme,
      displayFmRssiWarning = displayFmRssiWarningColor,
    };
  end
end
