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

local function sort(table, key) -- sort up
  for i = 1, (#table - 1) do
    if (table[i][key] > table[i + 1][key]) then
      local tmp = table[i];
      table[i] = table[i + 1];
      table[i + 1] = tmp;
      i = 1;
    end
  end
end

local function sortDown(table, key)
    for i = 1, (#table - 1) do
      if (table[i][key] < table[i + 1][key]) then
        local tmp = table[i];
        table[i] = table[i + 1];
        table[i + 1] = tmp;
        i = 1;
      end
    end
  end

local function isEdgeTx()
  local ver, radio, maj, minor, rev, osname = getVersion();
  return osname ~= nil;
end

local function loadAnimations(config)
  local basedir = "/EDGELUA" .. "/ANIMS/";
  local anims = {};
  if (#model.getInfo().name > 0) then
    local filename = model.getInfo().name .. ".lua";
    local chunk = loadScript(basedir .. filename);
    if (chunk) then
      anims = chunk();
    end
  end
  if not(anims) or (#anims == 0) then
    local filename = "default.lua";
    local chunk = loadScript(basedir .. filename);
    if (chunk) then
      anims = chunk();
    end
  end
  return anims;
end

local function initAnimations(anims)
  local canims = {};
  for ia, anim in ipairs(anims) do
    local canim = {};
    canim[1] = anim.name;

    if not(anim.length) or (anim.length == 0) then
      canim[2] = 0;
    else
      canim[2] = math.floor(anim.length * 100);
    end

                                                                ;

    local trans = {};
    if (anim.switches) then
      local allTransitions = {};
      for si, s in ipairs(anim.switches) do
        if (s.transitions) then
          for it, t in ipairs(s.transitions) do
            trans = {};
            trans[1] = s.fn;
            trans[2] = s.module;
            trans[3] = t.state;
            trans[4] = math.floor(t.at * 100);
            trans[5] = false;
            allTransitions[#allTransitions + 1] = trans;
          end
        elseif (s.sequence) then
          local t = 0;
          for it, d in ipairs(s.sequence) do
            trans = {};
            trans[1] = s.fn;
            trans[2] = s.module;
            trans[3] = d.state;
            trans[4] = t;
            trans[5] = false;
            allTransitions[#allTransitions + 1] = trans;
            t = t + math.floor(d.duration * 100);
          end
        end
      end
      sort(allTransitions, 4);
      canim[3] = allTransitions;

      -- for ci, tr in ipairs(canim[3]) do
      -- ;
      -- end
      canims[#canims + 1] = canim;
    end
  end
                                      ;
  return canims;
end

local function setItem(fn, module, state, queue)
                                      ;
  __WmSw2ForeignInput = module * 100 + fn * 10 + state;
  local item= {};
  item[4] = fn;
  item[5] = module;
  item[3] = state;
  queue:push(item);
end

local function clearAnim(anim)
  for i, tr in ipairs(anim[3]) do
    tr[5] = false;
  end
end

local function runAnimation(anim, state, queue)
  if not(anim) then
    return;
  end
  local t = getTime();
  local wasLastTransition = false;

  if (state[2] == 0) then -- state: init
    __WmSw2Warning1 = "Animation";
    __WmSw2Warning2 = anim[1];
                                                                               ;
    state[2] = 1;
    state[3] = t; -- start of anim
    state[4] = t; -- last seq point
    clearAnim(anim);
  elseif (state[2] == 1) then -- state: run
    local diffTime = t - state[3];
    __WmSw2Warning1 = "Animation [" .. math.floor(diffTime / 100) .. "/" .. math.floor(anim[2] / 100) .. "]";
    for it, tr in ipairs(anim[3]) do
      local fn = tr[1];
      local module = tr[2];
      if not(tr[5]) and (diffTime >= tr[4]) then
        tr[5] = true;
        setItem(fn, module, tr[3], queue);
                                                                ;
        if (it == #anim[3]) then
          wasLastTransition = true;
        end
      end
    end
    state[1] = t;
    if (anim[2] > 0) and ((t - state[3]) >= anim[2]) then
      state[3] = t; -- restart
      state[4] = t;
                      ;
      clearAnim(anim);
    end
    if (anim[2] == 0) and (wasLastTransition) then
                   ;
      state[2] = 0;
      state[5] = 0;
      __WmSw2Warning1 = nil;
      __WmSw2Warning2 = nil;
      return nil;
    end
  end
  return anim;
end

local function resetState(state)
  local t = getTime();
  state[1] = t; -- timepoint for statemachine
  state[2] = 0; -- state of statemachine
  state[3] = t; -- start time of anim
  state[4] = t; -- last sequencepoint start time
end

local function initAnimationFSM(state)
  resetState(state);
  state[5] = 0; -- active anim [1...4]
  state[8] = 0; -- selection
  state[8] = 1;
end

local function drawButtons(anims, rects, state)
  for i, rect in ipairs(rects) do
    if (state[5] == i) then
      lcd.drawFilledRectangle(rect.xmin, rect.ymin, rect.xmax - rect.xmin + 1, rect.ymax - rect.ymin + 1, COLOR_THEME_ACTIVE);
    else
      if (state[8] == i) then
        lcd.drawFilledRectangle(rect.xmin, rect.ymin, rect.xmax - rect.xmin + 1, rect.ymax - rect.ymin + 1, COLOR_THEME_FOCUS);
        lcd.drawRectangle(rect.xmin, rect.ymin, rect.xmax - rect.xmin + 1, rect.ymax - rect.ymin + 1, COLOR_THEME_PRIMARY1);
      else
        lcd.drawFilledRectangle(rect.xmin, rect.ymin, rect.xmax - rect.xmin + 1, rect.ymax - rect.ymin + 1, COLOR_THEME_SECONDARY2);
      end
    end
    lcd.drawText(rect.xmin + 5, rect.ymin + 5, anims[i][1], COLOR_THEME_PRIMARY1);
  end
end

local function covers(touch, item)
  if ((touch.x >= item.xmin) and (touch.x <= item.xmax)
    and (touch.y >= item.ymin) and (touch.y <= item.ymax)) then
    return true;
  end
  return false;
end

local function processKeyEvents(anims, state, event)
  if (event == EVT_VIRTUAL_ENTER) then
                                                                       ;
    if (state[8] == state[5]) then
      state[5] = 0;
      return 0;
    end
    if (state[8]) and (state[8] <= #anims) then
      state[5] = state[8] ;
    end
  end
  if (event == EVT_VIRTUAL_INC) then
                 ;
    if (state[8] >= #anims) then
      state[8] = 1;
    else
      state[8] = state[8] + 1;
    end
  end
  if (event == EVT_VIRTUAL_DEC) then
                 ;
    if (state[8] <= 1) then
      state[8] = #anims;
    else
      state[8] = state[8] - 1;
    end
  end
end

local function processEvents(anims, rects, state, event, touch)
  if (event == EVT_TOUCH_TAP) then
    for bi, rect in ipairs(rects) do
      if (touch) and (covers(touch, rect)) then
        state[8] = bi;
        break;
      end
    end
  end
  processKeyEvents(anims, state, event);
end

local function chooseAnimationBW(config, widget, anims, state, event)
                               ;
  if not(anims) or (#anims == 0) then
    return;
  end

  processKeyEvents(anims, state, event);

  for i, anim in ipairs(anims) do
    local x1 = widget[1] + 10;
    local x2 = widget[1] + 30;
    local y = widget[2] + i * widget[8];
    if (i == state[5]) then
      if (i == state[8]) then
        lcd.drawText(x1, y, "[x]", SMLSIZE + INVERS);
      else
        lcd.drawText(x1, y, "[x]", SMLSIZE);
      end
      lcd.drawText(x2, y, anim[1], SMLSIZE);
    else
      if (i == state[8]) then
        lcd.drawText(x1, y, "[ ]", SMLSIZE + INVERS);
      else
        lcd.drawText(x1, y, "[ ]", SMLSIZE);
      end
    end
    lcd.drawText(x2, y, anim[1], SMLSIZE);
  end
                               ;
  if (state[5] > 0) then
    return anims[state[5]];
  end
  return nil;
end

local function chooseAnimationNoTheme(config, widget, anims, state, event, touch)
                                    ;
  if not(anims) or (#anims == 0) then
    return;
  end

  processKeyEvents(anims, state, event);

  for i, anim in ipairs(anims) do
    local x1 = widget[1] + 10;
    local x2 = widget[1] + 30;
    local y = widget[2] + i * 2 * widget[8];
    if (i == state[5]) then
      if (i == state[8]) then
        lcd.drawText(x1, y, "[x]", SMLSIZE + INVERS);
      else
        lcd.drawText(x1, y, "[x]", SMLSIZE);
      end
      lcd.drawText(x2, y, anim[1], SMLSIZE);
    else
      if (i == state[8]) then
        lcd.drawText(x1, y, "[ ]", SMLSIZE + INVERS);
      else
        lcd.drawText(x1, y, "[ ]", SMLSIZE);
      end
    end
    lcd.drawText(x2, y, anim[1], SMLSIZE);
  end
  if (state[5] > 0) then
    return anims[state[5]];
  end
  return nil;
end

local function chooseAnimation(config, widget, anims, state, event, touch, png)
  lcd.clear();
  local rects = {};
  local bh = 1.5 * widget[9];
  local border_h = 40;
  local bw = widget[3] - 2 * border_h;;
  local vs = 5;

                                                                       ;

  if (widget[3] <= (LCD_W / 2)) then
    if (png) then
      lcd.drawBitmap(png, widget[1], widget[2]);
    end
    lcd.drawText(widget[1] + 60, widget[2], "Animationen", MIDSIZE);
    return;
  end

  if not(anims) then
    return;
  end
  if (#anims == 0) then
    lcd.drawText(widget[1], widget[2] + widget[4] / 2 - widget[9], "No animations", DBLSIZE);
  elseif (#anims == 1) then
    local rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 - bh / 2, ymax = widget[2] + widget[4] / 2 + bh / 2};
    rects[1] = rect;
  elseif (#anims == 2) then
    local rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 - bh - vs, ymax = widget[2] + widget[4] / 2 - vs};
    rects[1] = rect;
    rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 + vs, ymax = widget[2] + widget[4] / 2 + bh + vs};
    rects[2] = rect;
  elseif (#anims == 3) then
    local rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 - bh / 2, ymax = widget[2] + widget[4] / 2 + bh / 2};
    rects[1] = rect;
    rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 - 3 * bh / 2 - vs, ymax = widget[2] + widget[4] / 2 - bh / 2 - vs};
    rects[2] = rect;
    rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 + bh / 2 + vs, ymax = widget[2] + widget[4] / 2 + 3 * bh / 2 + vs};
    rects[3] = rect;
  elseif (#anims >= 4) then
    local rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 - 2 * bh - 3 * vs / 2, ymax = widget[2] + widget[4] / 2 - bh - 3 * vs / 2};
    rects[1] = rect;
    rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 - bh - vs / 2, ymax = widget[2] + widget[4] / 2 - vs / 2};
    rects[2] = rect;
    rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 + vs / 2, ymax = widget[2] + widget[4] / 2 + bh + vs / 2};
    rects[3] = rect;
    rect = {xmin = widget[1] + border_h, xmax = widget[1] + bw,
      ymin = widget[2] + widget[4] / 2 + bh + 3 * vs / 2, ymax = widget[2] + widget[4] / 2 + 2 * bh + 3 * vs / 2};
    rects[4] = rect;
  end

  drawButtons(anims, rects, state);
  processEvents(anims, rects, state, event, touch);

  if (state[5] > 0) then
    return anims[state[5]];
  else
    __WmSw2Warning1 = nil;
    __WmSw2Warning2 = nil;
    return nil;
  end

end

if (LCD_W <= 128) then
  return {
    loadAnimations = loadAnimations,
    initAnimations = initAnimations,
    runAnimation = runAnimation,
    chooseAnimation = chooseAnimationBW,
    initAnimationFSM = initAnimationFSM,
  };
elseif (LCD_W <= 212) then
  return {
    loadAnimations = loadAnimations,
    initAnimations = initAnimations,
    runAnimation = runAnimation,
    chooseAnimation = chooseAnimationBW,
    initAnimationFSM = initAnimationFSM,
  };
else
  if (isEdgeTx()) then
    return {
      loadAnimations = loadAnimations,
      initAnimations = initAnimations,
      runAnimation = runAnimation,
      chooseAnimation = chooseAnimation,
      initAnimationFSM = initAnimationFSM,
    };
  else
    return {
      loadAnimations = loadAnimations,
      initAnimations = initAnimations,
      runAnimation = runAnimation,
      chooseAnimation = chooseAnimationNoTheme,
      initAnimationFSM = initAnimationFSM,
    };
  end
end
