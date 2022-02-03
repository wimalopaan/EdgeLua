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

-- Default menu for large radios w/ color lcd

local gstates1 = {"aus", "ein", "blink 1", "blink 2"};

local menu = {
  title = "Autoreset Demo",
  saveValues = false,
  {
    title = "Kollektion",
    {"ScheinW1", states = gstates1, state = 1, switch = nil, fn = 1, module = 1, autoreset = 30}, -- 300ms
    {"ScheinW2", states = gstates1, state = 1, switch = nil, fn = 2, module = 1, autoreset = 100}, -- 1000ms = 1s
    {"ScheinW3", states = gstates1, state = 1, switch = "sf", fn = 3, module = 2, autoreset = 50}, -- 500ms
  },
}

local map = {
  {module = 1, type = 1, description = "Das Modul mit dem roten Aufkleber"},
};

return menu, map;
