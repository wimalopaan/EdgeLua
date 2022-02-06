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

local function init()
end

local function gather(basedir, names)
  for filename in dir(basedir) do
    if (string.find(filename, ".lua$")) then
      names[#names + 1] = basedir .. "/" .. filename;
      print(basedir .. "/" .. filename);
    end
  end
end

local function compile(filename)
  local chunk = loadScript(filename);
  if (chunk) then
    lcd.drawText(0, 40, "  ok", TEXT_COLOR);
  else
    lcd.drawText(0, 40, "fail", TEXT_COLOR);
  end
  chunk = nil;
  collectgarbage();
end

local lastTime = 0;
local state = 0;
local iterator = 1;
local fileIter = 1;
local filenames = {};

local dirs = {

  "/EDGELUA/ANIMS",

  "/EDGELUA/COMMON",
  "/EDGELUA/LIB",
  "/EDGELUA/MODELS",
  "/EDGELUA/RADIO",
  "/SCRIPTS/TELEMETRY",

  "/WIDGETS/ELUAAD",
  "/WIDGETS/ELUAAN",
  "/WIDGETS/ELUACO",
  "/WIDGETS/ELUASW",
  "/WIDGETS/ELUAWI",
  "/WIDGETS/ELUAIC",
  "/WIDGETS/ELUATS",

};

local function run()
-- lcd.clear();
  lcd.drawText(0, 0, "Compiling ..." .. "2.51", TEXT_COLOR);
  local t = getTime();
  local dir = nil;
  if ((t - lastTime) > 50) then
    lastTime = t;
    if (state == 0) then
      if (iterator <= #dirs) then
        local d = dirs[iterator];
        lcd.clear();
        filenames = {};
        gather(d, filenames);
        lcd.drawText(0, 10, "D: " .. d, TEXT_COLOR);
        lcd.drawText(0, 20, "n: " .. #filenames, TEXT_COLOR);
        fileIter = 1;
        state = 1;
      else
        state = 3;
      end
      return 0;
    elseif (state == 1) then
      if (fileIter <= #filenames) then
        local filename = filenames[fileIter];
        -- lcd.clear();
        lcd.drawText(0, 30, "C: " .. filename, TEXT_COLOR);
        compile(filename);
        fileIter = fileIter + 1;
      else
        iterator = iterator + 1;
        state = 0;
      end
      return 0;
    elseif (state == 3) then
      return 1;
    end
  else
    return 0;
  end
  return 1;
end

return {
  init = init,
  run = run
};
