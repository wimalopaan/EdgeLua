--
-- EdgeLUA - EdgeTx / OpenTx Extensions
-- Copyright (C) 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
-- To view a copy of this license, visit http:
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

-- IMPORTANT
-- Please note that the above license also covers the transfer protocol used and the encoding scheme and
-- all further principals of tranferring state and other information.

return {
  title = "TX16s",

  firstColumnWidth = 110,

parameterDial = "s1",

module = 0;

--[[ deprecated
mixerGlobalVariable = 6;
stateTimeout = 10;
--]]

backend = 1; -- 1: sbus/ibus; 2: s.port/f.port (tbd); 3: tiptip (maybe); 4: solexpert (tbd)

removeTrimsFromFlightModes = {
    { mode = 0, trims = {5, 6} }, -- default
    { mode = 1, trims = {5, 6} }, -- safeMode
  },

  navigation = {

    next = "5d", -- maybe jsx, jsy on x12s with curve
    previous = "5u",
    select = "6u",

    scrollUpDn = "ls", -- direct navigating
    scrollLR = "rs",
    pageSwitch = "6pos",
    -- pageSwitch = "ext1",

    fallbackIds = { -- switch IDs, if determining via above strings does not work (OpenTx)
      next = 69, -- "5d"
      previous = 70, -- "5u"
      select = 72, -- "6u"
    },

   },

backends = {
    bus = {
      stateTimeout = 10, -- unit: 10ms
      mixerGlobalVariable = 6, -- only if SHM is not supported (OpenTx)
    },

    sport = {
      map = {
        {module = 1, id = 226},
        {module = 2, id = 256},
        {module = 3, id = 128},
      },
    },

    tiptip = {
      shortTimeout = 30, -- unit: 10ms
      longTimeout = 60, -- unit: 10ms
      mixerGlobalVariable = 6, -- mixer script vmap.lua maps modules 1-5 to script output, only if SHM is not supported
      values = {0, 100, -100},
    },

    solexpert = {
      shortTimeout = 50, -- unit: 10ms
      longTimeout = 90, -- unit: 10ms
      mixerGlobalVariable = 6, -- mixer script vmap.lua maps modules 1-5 to script output, only if SHM is not supported
      map = {
        {module = 1, values = {0, -75, -25, 25, 75}}, -- Selektor 8
        {module = 2, values = {0, -100, 100}},
        {module = 3, values = {0, -100, 100}},
      },
    },
  },

safeMode = {
    flightMode = 1,
    name = "Safe-Mode",
    excludeMixesBeginnWith = "sw", -- mixer line beginning with "sw.*" are not included for deactivation by flightmode
    timeOut = 10, -- [s], after this time safeMode will be disabled, going to normal mode
    linkDropoutMax = 20, --[s], after this time without link switch to safeMode again (e.g. turning off the rx).
  },

};
