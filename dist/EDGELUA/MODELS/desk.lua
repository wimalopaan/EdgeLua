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

local menu = {
  title = "Pult Demo",
  saveValues = false,
  {
    title = "Lichter",
    {"Ausgang1 a", states = {"aus", "ein", "---"}, state = 1, switch = "ls1", fn = 1, module = 1, lsmode = 1}, -- Entry "---" not selectable
    {"Ausgang1 b", states = {"aus", "---", "ein"}, state = 1, switch = "ls2", fn = 1, module = 1, lsmode = 2}, -- Entry "---" not selectable
    {"Ausgang2", states = {"aus", "ein 1", "ein 2"}, state = 1, switch = "ls3", fn = 2, module = 1, lsmode = 1},
    {"Ausgang3", states = {"aus", "ein 1", "ein 2"}, state = 1, switch = "ls4", fn = 3, module = 1, lsmode = 2},
  },
}
local map = {
  {module = 1, type = 1, description = "Modul vorne"},
};
return menu, map;
