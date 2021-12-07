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

local output = {
   "module1",
   "module2",
   "module3",
   "module4",
   "module5"
};

local errorCode = 0;
local gvar = 0;
local values = {};

local function initConfig()
   if not(__WmSw2Config) then
      local basedir = "/EDGELUA" .. "/LIB/";
      if not __libI then
        __libI = loadScript(basedir .. "libI.lua")();
        if not __libI then
          errorCode = 1;
        else
         local config = __libI.loadConfig();
         if not(config) then
            errorCode = 4;
            return;
         end
         __WmSw2Config = __libI.initConfig(config, false); -- not modify
         collectgarbage();
        end
      end
   end

   local bendcfg = __WmSw2Config[20][3];
   gvar = bendcfg[3];
   values = bendcfg[4];
   print("TRACE: " , "vmap: gvar: ", gvar, values );

end

if (LCD_W <= 212) then
   __Sw2MixerValue = 0;
end

local lastValue = 0;

local function demux(value)
   if (value ~= lastValue) then
                                  ;
      lastValue = value;
   end

    local chValue = math.min(value % 10, #values);
    value = math.floor(value / 10);

    local chValues = {0, 0, 0, 0, 0};
    local channel = math.min(value % 10, #chValues);

    chValues[channel] = values[chValue] * 10.24;

                                                                                       ;

    return chValues[1], chValues[2], chValues[3], chValues[4], chValues[5];
end

local function transportGlobalLua()
   return demux(__Sw2MixerValue);
end

local function transportGV()
   return demux(model.getGlobalVariable(gvar, 0));
end

local function transportShm()
   return demux(getShmVar(1));
end

if (LCD_W <= 212) then
   print("TRACE: " , "vmap: use transportGlobalLua" );
   return {
       init = initConfig,
       output = output,
       run = transportGlobalLua
   };
else
   if (getShmVar) then
      print("TRACE: " , "vmap: use transportShm" );
      return {
        init = initConfig,
        output = output,
        run = transportShm
      };
   else
      print("TRACE: " , "vmap: use transportGV" );
      return {
         init = initConfig,
         output = output,
         run = transportGV
      };
   end
end
