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

local output = {
   "mod1",
   "mod2",
   "mod3",
   "mod4",
   "mod5"
};
local chValues = {0, 0, 0, 0, 0}; -- outputs
local gvar = 0;
local backend = 0;
local bendcfg = nil;
local values = nil; -- tiptip
local exportValues = nil; -- bus
local function initConfig()
   print("TRACE: " , "vmap: init: ", __WmMixerConfig );
   if not(__WmMixerConfig) then
      if not __libM then
        loadLibM();
        print("TRACE: " , "vmap: libM: ", __libM );
        if __libM then
         local config = __libM.loadConfig();
         print("TRACE: " , "vmap: config: ", config );
         if not(config) then
            errorCode = 4;
            return;
         end
         __WmMixerConfig = __libM.initConfig(config); -- not modify model
         print("TRACE: " , "vmap initConfig", __WmMixerConfig );
         collectgarbage();
        end
      end
   end
   backend = __WmMixerConfig[1];
   bendcfg = __WmMixerConfig[2][backend];
   if (backend == 1) then
      gvar = bendcfg[4];
      exportValues = bendcfg[3];
      print("TRACE: " , "vmap: bus: gvar: ", gvar, exportValues );
   end
   if (backend == 3) then
      gvar = bendcfg[3];
      values = bendcfg[4];
      print("TRACE: " , "vmap: tiptip: gvar: ", gvar, values );
   end
end
if (LCD_W <= 212) then
   __Sw2MixerValueVmap = 0;
end
local function demuxBendBus(value)
-- local chValues = {0, 0, 0, 0, 0};
   if (exportValues) then
      local state = value % 10; -- (1000 * <export>) + (100 * <function>) + (10 * <module>) + <valueIndex>
      value = math.floor(value / 10);
      local module = value % 10;
      value = math.floor(value / 10);
      local fn = value % 10;
      value = math.floor(value / 10);
      local export = value % 10;
      export = math.min(export, #exportValues);
      local evalues = exportValues[export];
      state = math.min(state, #evalues);
      if (module > 0) and (state > 0) then
         chValues[module] = evalues[state] * 10.24;
                                                                                        ;
      end
   end
   return chValues[1], chValues[2], chValues[3], chValues[4], chValues[5];
end
local function demuxBendTipTip(value)
-- local chValues = {0, 0, 0, 0, 0};
   if (values) then
      local state = math.min(value % 10, #values); -- (1000 * <export>) + (100 * <function>) + (10 * <module>) + <valueIndex>
      value = math.floor(value / 10);
      local module = math.min(value % 10, #chValues);
                                            ;
      if (module > 0) and (state > 0) then
         chValues[module] = values[state] * 10.24;
                                                                                        ;
      end
   end
   return chValues[1], chValues[2], chValues[3], chValues[4], chValues[5];
end
local lastValue = 0; -- only for debug
local function demux(value)
   if (value ~= lastValue) then
                                  ;
      lastValue = value;
   end
   if (backend == 1) then
      return demuxBendBus(value);
   elseif (backend == 3) then
      return demuxBendTipTip(value);
   end
   return chValues[1], chValues[2], chValues[3], chValues[4], chValues[5];
end
local function transportGlobalLua()
   return demux(__Sw2MixerValueVmap);
end
local function transportGV()
   return demux(model.getGlobalVariable(gvar, 0));
end
local function transportShm()
   return demux(getShmVar(2));
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
