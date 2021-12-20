--
-- WM OTXE - OpenTX Extensions
-- Copyright (C) 2020 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
-- To view a copy of this license, visit http:
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

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

__WmMixerConfig = nil;

local function loadLibM()
  if not __libM then
    __libM = loadLib("libM.lua");
    if not __libM then
      errorCode = 1;
    end
  end
end

local function clamp(value)
  return math.max(math.min(value, 1024), -1024);
end

local input = {
   {"Input", SOURCE},
   {"Reset", SOURCE},
   {"Scale", VALUE, 0, 100, 10},
   {"Deadb", VALUE, 0, 100, 2}
};

local output = {
   "Incremental"
};

local value = 0;

local function run(input, reset, scale, deadband)
   if (reset > 0) then
      value = 0;
   else
      if (math.abs(input) >= (deadband * 10.24)) then
         local i = (input * scale) / 10240;
         value = clamp(value + i);
      end
   end
   return value;
end

return {
   input = input,
   output = output,
   run = run
};
