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
      print("TRACE: " , "LOAD_A", basedir );
    __libA = loadScript(basedir .. "libA.lua")();
    if not __libA then
      errorCode = 3.1;
    end
  end
end

local function loadLibU()
  local basedir = "/EDGELUA" .. "/LIB/";
  if not __libU then
      print("TRACE: " , "LOAD_U", basedir );
    __libU = loadScript(basedir .. "libU.lua")();
    if not __libU then
      errorCode = 3.2;
    end
  end
end

local name = "EL_Wch";

local options = {
  { "Name", STRING}, -- display name
  { "Adresse", VALUE, 1, 1, 8},
  { "Funktion", VALUE, 1, 1, 8},
  { "Zustand", SOURCE, 8}, -- telemetry state variable
};

local buttonState = 1; -- state 1 := off

local function create(zone, options)
  load();
  loadLibU();

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
    __WmSw2Config = __libI.initConfig(config);
  end
  collectgarbage();

  return widget;
end

local function update(widget, options)
  widget[11] = options;
end

local function background(widget)
end

local function makeButton(f, border)
  return {x = f.x + border, y = f.y + border, w = f.w - (2 * border), h = f.h - (2 * border), state = 0};
end

local function covers(touch, btn)
  if ((touch.x >= btn.x) and (touch.x <= (btn.x + btn.w)) and (touch.y >= btn.y) and (touch.y <= (btn.y + btn.h))) then
    return true;
  end
  return false;
end

local function buttonText(button, text)
  lcd.drawText(button.x + 16, button.y + button.h/2 - 8, text, SML);
end

local function buttonBorder(button)
  lcd.drawRectangle(button.x, button.y, button.w, button.h, DOTTED + LIGHTGREY);
end

local function buttonBorderState(button)
  lcd.drawRectangle(button.x, button.y, button.w, button.h, RED, 4);
end

local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then

    local border = 2;
    local iw = (widget[3] / 6);
    local ih = widget[4];
    if (ih > iw) then
      ih = iw;
    end

    local f1 = {x = widget[1], y = widget[2], w = iw / 2, h = ih};
    if (event) then
      f1.y = (widget[2] + widget[4]) / 2 - ih / 2;
    end
    local f2 = {x = f1.x + f1.w, y = f1.y, w = iw, h = ih};
    local f3 = {x = f2.x + f2.w, y = f1.y, w = iw, h = ih};
    local f4 = {x = f3.x + f3.w, y = f1.y, w = iw, h = ih};
    local f5 = {x = f4.x + f4.w, y = f1.y, w = iw / 2, h = ih};
    local f6 = {x = f5.x + f5.w, y = f1.y, w = iw, h = ih};
    local f7 = {x = f6.x + f6.w, y = f1.y, w = iw, h = ih};

    local holdBtn = makeButton(f3, border);
    local leftBtn = makeButton(f2, border);
    local rightBtn = makeButton(f4, border);
    local stopBtn = makeButton(f7, border);

    lcd.drawFilledRectangle(holdBtn.x, holdBtn.y, holdBtn.w, holdBtn.h, GREEN);
    lcd.drawFilledCircle(stopBtn.x + stopBtn.w/2, stopBtn.y + stopBtn.h/2, stopBtn.h/2 - border, RED);
    lcd.drawFilledTriangle(leftBtn.x + border, leftBtn.y + leftBtn.h/2,
      leftBtn.x + leftBtn.w - border, leftBtn.y + border,
      leftBtn.x + leftBtn.w - border, leftBtn.y + leftBtn.h - border, ORANGE);
    lcd.drawFilledTriangle(rightBtn.x + rightBtn.w - border, rightBtn.y + rightBtn.h/2,
      rightBtn.x + border, rightBtn.y + border,
      rightBtn.x + border, rightBtn.y + rightBtn.h - border, ORANGE);

    lcd.drawFilledRectangle(f1.x + border, f1.y + border, f1.w - (2 * border), f1.h - (2 * border), YELLOW);
    lcd.drawFilledRectangle(f5.x + border, f5.y + border, f5.w - (2 * border), f5.h - (2 * border), YELLOW);
    lcd.drawText(f6.x + border, f6.y + f6.h / 2 - 16, __libU.optionString(widget[11].Name));

    buttonText(holdBtn, "Halt");
    buttonText(leftBtn, "Links");
    buttonText(rightBtn, "Rechts");
    buttonText(stopBtn, "Frei");

    buttonBorder(holdBtn);
    buttonBorder(leftBtn);
    buttonBorder(rightBtn);

    local state = getValue(widget[11].Zustand);

    if (state == 40) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Halt");
      buttonBorderState(holdBtn);
    elseif (state == 41) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Rechts");
      buttonBorderState(rightBtn);
    elseif (state == 42) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Links");
      buttonBorderState(leftBtn);
    elseif (state == 43) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Blockiert");
      lcd.drawFilledRectangle(f5.x + border, f5.y + border, f5.w - (2 * border), f5.h - (2 * border), BLINK + RED);
      lcd.drawFilledRectangle(f1.x + border, f1.y + border, f1.w - (2 * border), f1.h - (2 * border), BLINK + RED);
    elseif (state == 44) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Ende rechts");
      lcd.drawFilledRectangle(f5.x + border, f5.y + border, f5.w - (2 * border), f5.h - (2 * border), RED);
    elseif (state == 45) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Ende links");
      lcd.drawFilledRectangle(f1.x + border, f1.y + border, f1.w - (2 * border), f1.h - (2 * border), RED);
    elseif (state == 46) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Frei");
      lcd.drawRectangle(f7.x + border, f7.y + border, f7.w - (2 * border), f7.h - (2 * border), ORANGE, 4);
    elseif (state == 50) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Fehler");
    elseif (state >= 10) and (state < 20) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Start");
    elseif (state >= 20) and (state < 40) then
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Kalibrierung");
    else
      lcd.drawText(f6.x + border, f6.y + f6.h - 16, "Ungueltig");
    end

    if (event == EVT_TOUCH_TAP) then
      local fn = widget[11].Funktion;
      local module = widget[11].Adresse;
      if (covers(touch, holdBtn)) then
        buttonState = 1;
        print("TRACE: " , "buttonState", buttonState );
      elseif (covers(touch, leftBtn)) then
        buttonState = 2;
        print("TRACE: " , "buttonState", buttonState );
      elseif (covers(touch, rightBtn)) then
        buttonState = 3;
        print("TRACE: " , "buttonState", buttonState );
      elseif (covers(touch, stopBtn)) then
        buttonState = 4;
        print("TRACE: " , "buttonState", buttonState );
      end
      __WmSw2ForeignInput = buttonState + 10 * fn + 100 * module;
      print("TRACE: " , "buttonState FI", __WmSw2ForeignInput );
    end

  else
    lcd.drawText(widget[1], widget[2], "Error: " .. errorCode, DBLSIZE);
  end

end

return {
  name = name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
};
