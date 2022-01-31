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
      table[i] = transition[i + 1];
      table[i + 1] = tmp;
      i = 1;
    end
  end
end

local function sortDown(table, key)
    for i = 1, (#table - 1) do
      if (table[i][key] < table[i + 1][key]) then
        local tmp = table[i];
        table[i] = transition[i + 1];
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

    if (anim.switches) then
      local swt = {};
      local sws = {};
      for si, s in ipairs(anim.switches) do
        if (s.transitions) then
          local sw = {};
          sw[1] = s.fn;
          sw[2] = s.module;
          local transitions = {};
          for it, t in ipairs(s.transitions) do
            transitions[it] = {math.floor(t.at * 100), t.state, 0};
          end
          sort(transitions, 1);
          sw[3] = transitions;
          if (#transitions > 1) then
            swt[#swt + 1] = sw;
          end
        elseif (s.sequence) then
          local sw = {};
          sw[1] = s.fn;
          sw[2] = s.module;
          local durations = {};
          for is, s in ipairs(s.sequence) do
            durations[is] = {math.floor(s.duration * 100), s.state, 0};
          end
          sw[3] = durations;
          if (#durations > 1) then
            sws[#sws + 1] = sw;
          end
        end
      end
      canim[3] = swt;
      canim[4] = sws;
    end
    if (canim[1]) and (canim[2])
          and (canim[3] or canim[4]) then
      canims[#canims + 1] = canim;
    end
  end
                                      ;
  return canims;
end

local function setItem(fn, module, state)
                                      ;
  __WmSw2ForeignInput = module * 100 + fn * 10 + state;
end

local function clearAnim(anim)
  for i, swt in ipairs(anim[3]) do
    for it, transition in ipairs(swt[3]) do
      transition[3] = 0;
    end
  end
  for i, sws in ipairs(anim[4]) do
    for is, seqpoint in ipairs(sws[3]) do
      seqpoint[3] = 0;
    end
  end
end

local function runAnimation(anim, state)
  if not(anim) then
    return;
  end
  local t = getTime();

  if (state[2] == 0) then -- state: init
    __WmSw2Warning1 = "Animation";
    __WmSw2Warning2 = anim[1];
                                                                                                           ;
    state[2] = 1;
    state[3] = t; -- start of anim
    state[4] = t; -- last seq point
    state[7] = 0; -- last trans or seq reached
    clearAnim(anim);
  elseif (state[2] == 1) then -- state: run
    if ((t - state[1]) >= 10) then
      local diffTime = t - state[3];
      __WmSw2Warning1 = "Animation [" .. math.floor(diffTime / 100) .. "/" .. math.floor(anim[2] / 100) .. "]";
      for i, swt in ipairs(anim[3]) do
        local fn = swt[1];
        local module = swt[2];
        for it, transition in ipairs(swt[3]) do
          if (transition[3] == 0) and (diffTime >= transition[1]) then
            transition[3] = 1;
            setItem(fn, module, transition[2]);
            if (it == #swt[3]) then
                             ;
              state[7] = state[7] + 1;
            end
            break;
          end
        end
      end
      diffTime = t - state[4];
      for i, sws in ipairs(anim[4]) do
        local fn = sws[1];
        local module = sws[2];
        for it, seqpoint in ipairs(sws[3]) do
          if (seqpoint[3] == 0) and (diffTime >= seqpoint[1]) then
            seqpoint[3] = 1;
            state[4] = t;
            setItem(fn, module, seqpoint[2]);
            if (it == #sws[3]) then
                             ;
              state[7] = state[7] + 1;
            end
            break;
          end
        end
      end
      state[1] = t;
    end
    if (anim[2] > 0) and ((t - state[3]) >= anim[2]) then
      state[3] = t; -- restart
      state[4] = t;
                      ;
      clearAnim(anim);
    end
    if (anim[2] == 0) and (state[7] >= 2) then
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
  state[7] = 0;
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
