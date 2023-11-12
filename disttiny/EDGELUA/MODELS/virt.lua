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
local gstates1 = {"aus", "ein", "blink 1", "blink 2"};
local menu = {
  title = "Virtual Demo",
  {
    title = "Kollektion1",
    {"L1", states = gstates1, state = 1, switch = "sa", fn = 1, module = 1},
    {"L2", states = gstates1, state = 1, switch = "sb", fn = 2, module = 1},
    {"L12", states = gstates1, state = 1, switch = nil, virtual = { {fn = 1, module = 1}, {fn = 2, module = 1} } },
    {"L123", states = gstates1, state = 1, switch = nil, virtual = { {fn = 1, module = 1}, {fn = 2, module = 1}, {fn = 1, module = 2} } },
    {"L3", states = gstates1, state = 1, switch = nil, fn = 1, module = 2},
    {"L4", states = gstates1, state = 1, switch = nil, fn = 2, module = 2},
  },
}
local map = {
  {module = 1, type = 1, description = "Das Modul mit dem roten Aufkleber"},
  {module = 2, type = 2, description = "Im Ruderhaus"},
};
return menu, map;
