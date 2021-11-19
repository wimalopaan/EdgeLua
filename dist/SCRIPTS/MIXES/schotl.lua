--
-- WM OTXE - OpenTX Extensions
-- Copyright (C) 2020, 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
-- To view a copy of this license, visit http:
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
       
       
       
       
local input = {
   {"Eing A1", SOURCE},
   {"Eing B1", SOURCE},
   {"Eing A2", SOURCE},
   {"Eing B2", SOURCE},
   {"Deadband", VALUE, 1, 100, 10}, -- absolute value
   {"Timeout ms", VALUE, 1, 300, 100} -- milli secs
};
local output = {
   "Pow 1",
 "Dir 1",
 "Pow 2",
 "Dir 2",
 "State1",
 "State2"
};
local lastDirs = {
   {0, 0},
   {0, 0}
};
local nextRunTime = 0;
local function saveLastDir(index, value, timeout)
   if (getTime() > nextRunTime) then
      nextRunTime = getTime() + timeout;
      lastDirs[index][1] = lastDirs[index][2];
      lastDirs[index][2] = value;
   end
end
local function run(a1, b1, a2, b2, deadband, to)
   local state1 = 0;
   local state2 = 0;
   local timeout = to / 10;
-- local SchottelPow1 = math.sqrt(a1 * a1 + b1 * b1) / 1.41421;
   local SchottelPow1 = math.sqrt(a1 * a1 + b1 * b1);
   local SchottelDir1 = 0;
   local min1 = math.min(math.abs(a1), math.abs(b1));
   local max1 = math.sqrt(min1 * min1 + 1024 * 1024) / 1024;
   local min2 = math.min(math.abs(a2), math.abs(b2));
   local max2 = math.sqrt(min2 * min2 + 1024 * 1024) / 1024;
   ;
   if (SchottelPow1 > deadband) then
      SchottelDir1 = math.atan2(b1, a1) * 1024 / math.pi;
      saveLastDir(1, SchottelDir1, timeout);
      state1 = 1;
   else
      SchottelDir1 = lastDirs[1][1];
      state1 = 0;
   end
-- local SchottelPow2 = math.sqrt(a2 * a2 + b2 * b2) / 1.41421;
   local SchottelPow2 = math.sqrt(a2 * a2 + b2 * b2);
   local SchottelDir2 = 0;
   if (SchottelPow2 > deadband) then
      SchottelDir2 = math.atan2(b2, a2) * 1024 / math.pi;
      saveLastDir(2, SchottelDir2, timeout);
      state2 = 1;
   else
      SchottelDir2 = lastDirs[2][1];
      state2 = 0;
   end
   return
   (SchottelPow1 / max1), SchottelDir1,
   (SchottelPow2 / max2), SchottelDir2,
   state1, state2;
end
return {
   input = input,
   run = run,
   output = output
}
