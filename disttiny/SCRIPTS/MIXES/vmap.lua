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
   "mod1",
   "mod2",
   "mod3",
   "mod4",
   "mod5"
};

local gvar = 0;
local values = nil;

local function initConfig()
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

   if (backend == 1) then

   end
   if (backend == 3) then
      gvar = bendcfg[3];
      values = bendcfg[4];
                                         ;
   end
end

if (LCD_W <= 212) then
   __Sw2MixerValue = 0;
end

local lastValue = 0;

local function demux(value)
   local chValues = {0, 0, 0, 0, 0};
   if (value ~= lastValue) then
                                  ;
      lastValue = value;
   end
   if (values) then
      local chValue = math.min(value % 10, #values); -- 10 * <channel> + <valueIndex>
      value = math.floor(value / 10);

      local channel = math.min(value % 10, #chValues);

                                                      ;

      if (channel > 0) and (chValue > 0) then
         chValues[channel] = values[chValue] * 10.24;
                                                                                            ;
      end

   end
   return chValues[1], chValues[2], chValues[3], chValues[4], chValues[5];
end

local function transportGlobalLua()
   return demux(__Sw2MixerValue);
end

local function transportGV()
   return demux(model.getGlobalVariable(gvar, 0));
end

local function transportShm()
   return demux(getShmVar(2));
end

if (LCD_W <= 212) then
                                        ;
   return {
       init = initConfig,
       output = output,
       run = transportGlobalLua
   };
else
   if (getShmVar) then
                                     ;
      return {
        init = initConfig,
        output = output,
        run = transportShm
      };
   else
                                    ;
      return {
         init = initConfig,
         output = output,
         run = transportGV
      };
   end
end
