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

-- exporting switch states needs mixer script vmap to be setup too

local gstates1 = {"aus", "ein", "blink 1", "blink 2"};

local menu = {
  title = "Export Demo",
  saveValues = false,
  {
    title = "Kollektion1",
    {"M1A", states = gstates1, state = 1, switch = "sa", fn = 1, module = 1, export = 1}, -- export values set 1 (see config under /EDGELUA/RADIO)
    {"M2A", states = gstates1, state = 1, switch = nil, fn = 1, module = 2, export = 3}, -- export values set 3
  },
}

local map = {
  {module = 1, type = 1, description = "Das Modul mit dem roten Aufkleber"},
};

return menu, map;
