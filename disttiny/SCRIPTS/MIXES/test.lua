---
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
  print("TRACE: " , "loadLib:", filename );
  local basedir = "/EDGELUA" .. "/LIB/";
  local chunk = loadScript(basedir .. filename);
  local lib = nil;
  if (chunk) then
    print("TRACE: " , "loadLib chunk:", filename );
    lib = chunk();
  end
  collectgarbage();
  return lib;
end

local errorCode = 0;
-- __WmMixerConfig = nil;
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
    {"Input1", SOURCE},
    {"Input2", SOURCE},
    {"Input3", SOURCE},
    {"Input4", SOURCE},
    {"V1", VALUE, 0, 100, 10},
    {"V2", VALUE, 0, 100, 2}
 };
local output = {
    "Incremental",
    "I2",
    "I3",
    "I4",
    "I5",
    "I6",
};
local function run(s1, s2, s3, s4, v1, v2)
    return s1, (s1 + s2), (s1 + s2 + s3), (s1 + s2 + s3 + s4), v1, v2;
end
return {
    input = input,
    output = output,
    run = run
};
