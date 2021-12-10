--
-- WM OTXE - OpenTX Extensions
-- Copyright (C) 2020, 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
-- To view a copy of this license, visit http:
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

local input = {
   {"Eing A", SOURCE}
};

local output = {
   "a", "b", "diff", "gv"
};

local errorCode = 0;
local gvar = 0;

local function initGV()
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
         __WmSw2Config = __libI.initConfig(config);
         collectgarbage();
        end
      end
   end

   local bendcfg = __WmSw2Config[20][1];
   gvar = bendcfg[2];

-- gvar = __WmSw2Config[CFG_MixerGlobalVariable];
 end

local function run(a)
    local b = model.getGlobalVariable((gvar + 1), 0);

    return a, b, (a - b) * 100, gvar;
end

return {
    init = initGV,
    input = input,
    run = run,
    output = output
}
