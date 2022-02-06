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

local gstates1 = {"aus", "ein 1", "ein 2"};

local menu = {
  title = "Simple",
  saveValues = false,
  {
    title = "Lichter",
    {"Led1", states = gstates1, state = 1, switch = nil, fn = 1, module = 1},
    {"Led2", states = gstates1, state = 1, switch = nil, fn = 2, module = 1},
    {"Led3", states = gstates1, state = 1, switch = nil, fn = 3, module = 1},
    {"Led4", states = gstates1, state = 1, switch = nil, fn = 4, module = 1},
    {"Led5", states = gstates1, state = 1, switch = nil, fn = 5, module = 1},
    {"Led6", states = gstates1, state = 1, switch = nil, fn = 6, module = 1},
    {"Led7", states = gstates1, state = 1, switch = nil, fn = 7, module = 1},
    {"Led8", states = gstates1, state = 1, switch = nil, fn = 8, module = 1},
  },
}

local map = {
  {module = 1, type = 1, description = "Das Modul mit dem roten Aufkleber"},
};

return menu, map;
