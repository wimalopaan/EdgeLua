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
    {"shm0", VALUE, 1, 16, 10}, -- absolute value
    {"shm1", VALUE, 1, 16, 11}, -- absolute value
    {"shm2", VALUE, 1, 16, 12}, -- absolute value
    {"shm3", VALUE, 1, 16, 13}, -- absolute value
    {"shm4", VALUE, 1, 16, 14}, -- absolute value
 };
 local output = {
   "shm0",
   "shm1",
   "shm2",
   "shm3",
   "shm4"
};
local function transportShm(s0, s1, s2, s3, s4)
   local indizes = {s0, s1, s2, s3, s4};
   local values = {0, 0, 0, 0, 0};
   for i, index in ipairs(indizes) do
      if (index >= 1) and (index <= 16) then
         values[i] = getShmVar(index);
                                               ;
      end
   end
   return values[1], values[2], values[3], values[4], values[5];
end
return {
    output = output,
    input = input,
    run = transportShm
};
