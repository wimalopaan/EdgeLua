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

local function isDigit(v)
  return (v >= string.byte("0")) and (v <= string.byte("9"));
end

local function isLetter(v)
  return (v >= string.byte("A") and (v <= string.byte("Z"))) or (v >= string.byte("a") and (v <= string.byte("z")));
end

local function nthChar(n, v)
  local c = bit32.extract(v, n * 8, 8);
  if (isDigit(c) or isLetter(c)) then
    return string.char(c);
  end
  return nil;
end

local function optionString(option)
  local s = "";
  if (option) then
    for i = 0,3 do
      local c = nthChar(i, option);
      if (c) then
        s = s .. c;
      else
        return s;
      end;
    end
    end
  return s
end

-- local function serialize(table, filename)
-- if type(table) == "table" then
-- io.write("{\n")
-- for k,v in pairs(o) do
-- io.write("  ", k, " = ")
-- serialize(v)
-- io.write(",\n")
-- end
-- io.write("}\n")
-- else
-- error("cannot serialize a " .. type(o))
-- end
-- end
local debugText = {};

local function initDebugTextBW()
  debugText[7] = "Vers:";
  debugText[4] = "GFLS:";
  debugText[3] = "SwId:";
  debugText[1] = "Rad:";
  debugText[5] = "Shm:";
  debugText[6] = "SSw:";
  debugText[2] = "TrSw:";
  debugText[8] = "VSto:";
  debugText[9] = "FNam:";
  debugText[10] = "SOpt:";
  debugText[11] = "Func:";
end

local function initDebugTextColor()
  debugText[7] = "Version:";
  debugText[4] = "SwitchID LS:";
  debugText[3] = "GetSwitchId:";
  debugText[1] = "Radio:";
  debugText[5] = "SharedMem:";
  debugText[6] = "SetStickySw:";
  debugText[2] = "TrimSwitch:";
  debugText[8] = "ValueStorage:";
  debugText[9] = "ModelFileName:";
  debugText[10] = "StringOption:";
  debugText[11] = "FunctionNames:";
end

local function displayDebugBW(widget)
  local y = widget[2];
  local x1 = widget[1];
  local x2 = x1 + widget[3] / 4;
  local x3 = x1 + widget[3] / 2;
  local x4 = x1 + 3 * widget[3] / 4;

      lcd.drawText(x1, y, debugText[7] .. "2.49", SMLSIZE);

  y = y + widget[8];
  lcd.drawText(x1, y, debugText[1] , SMLSIZE);
  local ver, radio, maj, minor, rev, osname = getVersion();
  if (osname) then
      lcd.drawText(x2, y, "ETx " .. radio .. " " .. maj .. "." .. minor .. "." .. rev, SMLSIZE);
  else
      lcd.drawText(x2, y, "OTx " .. radio .. " " .. maj .. "." .. minor .. "." .. rev, SMLSIZE);
  end
  y = y + widget[8];
  lcd.drawText(x1, y, debugText[8], SMLSIZE);

      lcd.drawText(x2, y, "n", SMLSIZE);

  y = y + widget[8];
  lcd.drawText(x1, y, debugText[2], SMLSIZE);
      lcd.drawText(x2, y, "-", SMLSIZE);

  y = y + widget[8];
  lcd.drawText(x1, y, debugText[3], SMLSIZE);

      if (getSwitchIndex) then -- getSwitchName(), getSwitchValue(), getPhysicalSwitches(), SWITCH_COUNT
          lcd.drawText(x2, y, "y", SMLSIZE);
      else
          lcd.drawText(x2, y, "n", SMLSIZE);
      end

  y = y + widget[8];
  lcd.drawText(x1, y, debugText[4], SMLSIZE);
  local id = getFieldInfo("sl1");
  if (id) then
      lcd.drawText(x2, y, "y", SMLSIZE);
  else
      lcd.drawText(x2, y, "n", SMLSIZE);
  end

  y = widget[2];
  y = y + widget[8];
  y = y + widget[8];

  lcd.drawText(x3, y, debugText[5], SMLSIZE);

  if (getShmVar) and (setShmVar) then
      lcd.drawText(x4, y, "y", SMLSIZE);
  else
      lcd.drawText(x4, y, "n", SMLSIZE);
  end

  y = y + widget[8];
  lcd.drawText(x3, y, debugText[6], SMLSIZE);

  if (setStickySwitch) then -- getLogicalSwitchValue()
      lcd.drawText(x4, y, "y", SMLSIZE);
  else
      lcd.drawText(x4, y, "n", SMLSIZE);
  end

  y = y + widget[8];
  lcd.drawText(x3, y, debugText[9], SMLSIZE);

  if (model.getInfo().filename) then
      lcd.drawText(x4, y, "y", SMLSIZE);
  else
      lcd.drawText(x4, y, "n", SMLSIZE);
  end

  y = y + widget[8];
  lcd.drawText(x3, y, debugText[10], SMLSIZE);

  if (widget[11]) then
    local opt = widget[11].Test;
    if (type(opt) == "string") then
      lcd.drawText(x4, y, "y: " .. opt, SMLSIZE);
    else
      lcd.drawText(x4, y, "n", SMLSIZE);
    end
  else
    lcd.drawText(x4, y, "na", SMLSIZE);
  end

  y = y + widget[8];
  lcd.drawText(x3, y, debugText[11], SMLSIZE);

  if (LS_FUNC_VEQUAL) then
      lcd.drawText(x4, y, "y", SMLSIZE);
  else
      lcd.drawText(x4, y, "n", SMLSIZE);
  end

end

local function displayDebugColor(widget)
  displayDebugBW(widget);
end

if (LCD_W <= 128) then
  initDebugTextBW();
  return {
    saveValues = saveValues,
    initValues = initValues,
    displayDebug = displayDebugBW,
    optionString = optionString,
  };
elseif (LCD_W <= 212) then
  initDebugTextBW();
  return {
    saveValues = saveValues,
    initValues = initValues,
    displayDebug = displayDebugBW,
    optionString = optionString,
  };
else
  initDebugTextColor();
  return {
    saveValues = saveValues,
    initValues = initValues,
    displayDebug = displayDebugColor,
    optionString = optionString,
  };
end
