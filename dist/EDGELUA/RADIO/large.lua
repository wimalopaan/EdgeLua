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
  removeTrimsFromFlightModes = {
    { mode = 0, trims = {5, 6} }, -- default
    { mode = 1, trims = {5, 6} }, -- safeMode
  },
  navigation = {
    --[[
      see test widget
    ]]
    next = "t5d", -- maybe jsx, jsy on x12s with curve
    previous = "t5u",
    select = "t6u",
    scrollUpDn = "ls", -- direct navigating
    scrollLR = "rs",
    pageSwitch = "6pos",
    -- pageSwitch = "ext1",
    fallbackIds = { -- switch IDs, if determining via above strings does not work
      next = 69, -- "t5d"
      previous = 70, -- "t5u"
      select = 72, -- "t6u"
    }
   },
  parameterDial = "s1",
  -- remote = "trn16"; -- getting switch encoding from radio-desk-controller
  stateTimeout = 10, -- unit: 10ms
  module = 0, -- RF Module
  mixerGlobalVariable = 6,
  backend = 1, -- 1: sbus/ibus; 2: s.port/f.port (tbd); 3: tiptip (maybe)
  safeMode = {
    flightMode = 1,
    name = "Safe-Mode",
    excludeMixesBeginnWith = "sw", -- mixer line beginning with "sw.*" are not included for deactivation by flightmode
    timeOut = 10, -- [s], after this time safeMode will be disabled, going to normal mode
    linkDropoutMax = 20, --[s], after this time without link switch to safeMode again (e.g. turning off the rx).
  };
};
