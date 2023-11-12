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

local output = {
   "sw_var",
};
local gvar = 0;
local function initGV()
                                          ;
   if not(__WmMixerConfig) then
      if not __libM then
        loadLibM();
                                     ;
        if __libM then
         local config = __libM.loadConfig();
                                        ;
         if not(config) then
            errorCode = 4;
            return;
         end
         __WmMixerConfig = __libM.initConfig(config); -- not modify model
                                                  ;
         collectgarbage();
        end
      end
   end
   local backend = __WmMixerConfig[1];
   local bendcfg = __WmMixerConfig[2][backend];
   gvar = bendcfg[2];
                               ;
end
if (LCD_W <= 212) then
   __Sw2MixerValue = 0;
end
local function transportGlobalLua()
   return __Sw2MixerValue;
end
local function transportGV()
                                           ;
   return model.getGlobalVariable(gvar, 0);
end
local function transportShm()
   return getShmVar(1);
end
if (LCD_W <= 212) then
                                         ;
   return {
      output = output,
      run = transportGlobalLua
   };
else
   if (getShmVar) then
                                      ;
      return {
         output = output,
         run = transportShm
      };
   else
                                     ;
      return {
         init = initGV,
         output = output,
         run = transportGV
      };
   end
end
