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

local gstates1 = {"aus", "ein1", "ein2"};
local menu = {
  title = "DA Demo 1-6",
  saveValues = true,
  {
    title = "Analog 1",
    {"M1A", states = gstates1, state = 1, switch = "sa", fn = 1, module = 1},
    {"M2A", states = gstates1, state = 1, switch = "sb", fn = 1, module = 2},
    {"M3A", states = gstates1, state = 1, switch = "sc", fn = 1, module = 3},
    {"M4A", states = gstates1, state = 1, switch = "sd", fn = 1, module = 4},
    {"M5A", states = gstates1, state = 1, switch = "se", fn = 1, module = 5},
    {"M6A", states = gstates1, state = 1, switch = "sf", fn = 1, module = 6, lsmode = 1},
  },
}
-- deprecated
-- local exportValues = {0, -50, 50, 100}; -- values for states
local map = {
  {module = 1, type = 2, description = "Graupner 2-16K"},
  {module = 2, type = 2, description = "Graupner 2-16K"},
  {module = 3, type = 2, description = "Robbe"},
  {module = 4, type = 2, description = "CP"},
  {module = 5, type = 2, description = "Lothar Löwer"},
  {module = 6, type = 2, description = "unknown"},
};
return menu, map, exportValues;
