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

local name = "EL_Ico";

local bmpUpSmall = nil;
local bmpDownSmall = nil;
local bmpLeftSmall = nil;
local bmpRightSmall = nil;
local bmpPauseSmall = nil;
local bmpPreviousSmall = nil;
local bmpNextSmall = nil;

local bmpExpandSmall = nil;

local bmpUpLarge = nil;
local bmpDownLarge = nil;
local bmpLeftLarge = nil;
local bmpRightLarge = nil;
local bmpPauseLarge = nil;
local bmpPreviousLarge = nil;
local bmpNextLarge = nil;

local fields = {};
local bmpSmall = {};
local bmpLarge = {};

local options = {
  { "Name", STRING}, -- display name
  { "Adresse", VALUE, 1, 1, 8},
  { "Funktion", VALUE, 1, 1, 8},
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
    __WmSw2Config = __libI.initConfig(config, true);
  end
  collectgarbage();

  bmpUpSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/up.png");
  bmpDownSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/down.png");
  bmpLeftSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/left.png");
  bmpRightSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/right.png");
  bmpPreviousSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/previous.png");
  bmpNextSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/next.png");
  bmpPauseSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/round.png");
  bmpExpandSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/expand.png");

  bmpUpLarge = Bitmap.open("/EDGELUA" .. "/ICONS/72px/up.png");
  bmpDownLarge = Bitmap.open("/EDGELUA" .. "/ICONS/72px/down.png");
  bmpLeftLarge = Bitmap.open("/EDGELUA" .. "/ICONS/72px/left.png");
  bmpRightLarge = Bitmap.open("/EDGELUA" .. "/ICONS/72px/right.png");
  bmpPreviousLarge = Bitmap.open("/EDGELUA" .. "/ICONS/72px/previous.png");
  bmpNextLarge = Bitmap.open("/EDGELUA" .. "/ICONS/72px/next.png");
  bmpPauseLarge = Bitmap.open("/EDGELUA" .. "/ICONS/72px/round.png");

  bmpSmall[1] = bmpDownSmall;
  bmpSmall[2] = bmpPauseSmall;
  bmpSmall[3] = bmpUpSmall;

  bmpLarge[1] = bmpDownLarge;
  bmpLarge[2] = bmpPauseLarge;
  bmpLarge[3] = bmpUpLarge;

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

local function updateDimensions(field, event)
  if (event) then -- fullscreen
    field.x = math.max(0, field.cx - 36);
    field.y = math.max(0, field.cy - 36);
    field.w = 72;
    field.h = 72;
  else
    field.x = math.max(0, field.cx - 24);
    field.y = math.max(0, field.cy - 24);
    field.w = 48;
    field.h = 48;
  end
end

local function getField(widget, number, event)
  local field = {};
  field.cx = widget[1] + (2 * (number - 1) + 1) * widget[3] / 6;
  field.cy = (widget[2] + widget[4]) / 2;
  updateDimensions(field, event);
  return field;
end

local function updateFields(widget, event)
  fields[1] = getField(widget, 1, event);
  fields[2] = getField(widget, 2, event);
  fields[3] = getField(widget, 3, event);
end

local function displayFields(widget, bmps)
  for i, bmp in ipairs(bmps) do
    if (bmp) then
      local sizex, sizey = Bitmap.getSize(bmp);
      if (sizex > 0) then
        lcd.drawBitmap(bmp, fields[i].x, fields[i].y);
      end
    end
  end
end

local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    if (widget[3] <= (LCD_W / 2)) then

      if (bmpExpandSmall) then
        lcd.drawBitmap(bmpExpandSmall, widget[1], widget[2]);
      end
      lcd.drawText(widget[1] + 60, widget[2], widget[11].Name, MIDSIZE);
    else
      updateFields(widget, event);
      if (event) then
        displayFields(widget, bmpLarge);
      else
        displayFields(widget, bmpSmall);
      end
    end

-- displayButtons(fields);

    --[[

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
                                         ;
      elseif (covers(touch, leftBtn)) then
        buttonState = 2;
                                         ;
      elseif (covers(touch, rightBtn)) then
        buttonState = 3;
                                         ;
      elseif (covers(touch, stopBtn)) then
        buttonState = 4;
                                         ;
      end
      __WmSw2ForeignInput = buttonState + 10 * fn + 100 * module;
                                                  ;
    end
    --]]
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
