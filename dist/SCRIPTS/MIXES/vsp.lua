---
-- EdgeLUA - EdgeTx / OpenTx Extensions
-- Copyright (C) 2024 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
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
   {"Eing 1", SOURCE},
   {"Eing 2", SOURCE},
   {"Gew 1->2", VALUE, -100, 100, 0},
   {"Gew 2->1", VALUE, -100, 100, 0},
-- {"VSP", VALUE, 1, 2, 1}
};
local output = {
 "S1",
 "S2"
};
local function run(a, b, wa, wb)
   local ab = math.abs(a);
   local bb = math.abs(b);
   local as = a + ((bb * wb) / 100);
   local asb = math.abs(as);
   local bs = b + ((ab * wa) / 100);
   local bsb = math.abs(bs);
   local rmax = 0;
   local Amax = 1024;
   local Bmax = 1024;
   if (as >= 0) then
      if (bs >= 0) then
  if (asb >= bsb) then
     if (wb > 0) then
        Amax = 1024 + (1024 * wb) / 100;
     end
     Bmax = (bsb * Amax) / asb;
  else
     if (wa > 0) then
        Bmax = 1024 + (1024 * wa) / 100;
     end
     Amax = (asb * Bmax) / bsb;
  end
      else
  if (asb >= bsb) then
     if (wb > 0) then
        Amax = 1024 + (1024 * wb) / 100;
     end
     Bmax = (bsb * Amax) / asb;
  else
     if (wa < 0) then
        Bmax = 1024 + (-1024 * wa) / 100;
     end
     Amax = (asb * Bmax) / bsb;
  end
      end
   else
      if (bs >= 0) then
  if (asb >= bsb) then
     if (wb < 0) then
        Amax = 1024 + (-1024 * wb) / 100;
     end
     Bmax = (bsb * Amax) / asb;
  else
     if (wa > 0) then
        Bmax = 1024 + (1024 * wa) / 100;
     end
     Amax = (asb * Bmax) / bsb;
  end
      else
  if (asb >= bsb) then
     if (wb < 0) then
        Amax = 1024 + (-1024 * wb) / 100;
     end
     Bmax = (bsb * Amax) / asb;
  else
     if (wa < 0) then
        Bmax = 1024 + (-1024 * wa) / 100;
     end
     Amax = (asb * Bmax) / bsb;
  end
      end
   end
   rmax = math.sqrt(Amax * Amax + Bmax * Bmax);
   local Vsp1 = (as * 1024) / rmax;
   local Vsp2 = (bs * 1024) / rmax;
   return Vsp1, Vsp2;
end
return {
 input = input,
 run = run,
 output = output
};
