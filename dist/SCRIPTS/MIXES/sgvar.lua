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
   "sw_var",
   "transp",
   "raw"
};
if (LCD_W <= 212) then
   __Sw2MixerValue = 0;
end
local function transportGlobalLua()
   return __Sw2MixerValue
   , 0, 0
   ;
end
local function transportGV()
   return model.getGlobalVariable(gvar, 0)
   , 1, model.getGlobalVariable((gvar + 1), 0)
   ;
end
local function transportShm()
   return getShmVar(1)
   , 2, 0
   ;
end
if (LCD_W <= 212) then
   print("TRACE: ", "sgvar: use transportGlobalLua" );
   return {
      output = output,
      run = transportGlobalLua
   };
else
   if (getShmVar) then
      print("TRACE: ", "sgvar: use transportShm" );
      return {
         output = output,
         run = transportShm
      };
   else
      print("TRACE: ", "sgvar: use transportGV" );
      return {
         init = initGV,
         output = output,
         run = transportGV
      };
   end
end
