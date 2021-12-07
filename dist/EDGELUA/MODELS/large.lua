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
local gstates2 = {"stop", "ab", "auf", "Not aus"};
local gstates3 = {"Pos 1", "Pos 2", "Pos 3", "Pos 4"};

local menu = {
  title = "Model3",
  saveValues = true,
  { -- template for digital multiswitch RC-MultiSwitch-D @ Address(1)
    title = "Deck 1",
    -- backend = 1, -- todo
    {"M1A", states = gstates1, state = 1, switch = "sa", fn = 1, module = 1},
    {"M1B", states = gstates1, state = 1, switch = "sb", fn = 2, module = 1},
    {"M1C", states = gstates1, state = 1, switch = "input1", fn = 3, module = 1},
    {"M1D", states = gstates1, state = 1, switch = "se", virtual = { {fn = 7, module = 1} } },
    {"M1E", states = gstates1, state = 1, switch = nil, fn = 5, module = 1},
    {"M1F", states = gstates1, state = 1, switch = "ls1", fn = 6, module = 1, lsmode = 1},
    {"M1G", states = gstates1, state = 1, switch = "ls2", fn = 7, module = 1, lsmode = 2},
    {"M1H", states = gstates1, state = 1, switch = nil, fn = 8, module = 1},
  },
  { -- template for export function (via global variable) and virtual functions
    title = "Winden",
    -- backend = 1, -- todo
    {"Winde", states = {"stop", "los", "fest", "Not aus"}, state = 1, switch = "sa", fn = 1, module = 8, export = 0}, -- export state via global variable (number) (s.a. exportValues)
    {"Anker", states = gstates2, state = 1, switch = "sb", fn = 2, module = 8, export = 1},
    {"Licht1", states = gstates1, state = 1, switch = nil, fn = 5, module = 8},
    {"Licht2", states = gstates1, state = 1, switch = nil, fn = 6, module = 8},
    {"L-Alle", states = gstates1, state = 1, switch = "sg", fn = 0, module = 0, virtual = {{fn = 5, module = 8}, {fn = 6, module = 8}, {fn = 1, module = 2}} }, -- virtual
  },
  {
    title = "Sonstiges",
    -- backend = 1, -- todo
    {"Licht3", states = gstates1, state = 1, switch = "sc", fn = 1, module = 2},
    {"M2B", states = gstates3, state = 1, switch = "sd", fn = 2, module = 2},
    {"M2C", states = gstates3, state = 1, switch = nil, fn = 3, module = 2},
    {"M2D", states = gstates3, state = 1, switch = "se", fn = 4, module = 2},
    {"M3A", states = gstates3, state = 1, switch = nil, fn = 1, module = 3},
    {"M3B", states = gstates1, state = 1, switch = nil, fn = 2, module = 3},
    {"M3C", states = gstates1, state = 1, switch = nil, fn = 3, module = 3},
    {"M2H", states = gstates1, state = 1, switch = "ls3", fn = 8, module = 2},
  },
}

-- to be replaced
local exportValues = {0, -50, 50, 100}; -- values for states

--[[ in radios-settings
local export = {
  [1] = {gv = 1, values = {0, -50, 50, 100}},
  [2] = {gv = 2, values = {-100, 0, 100}},
  [3] = {gv = 2, values = {-75, -25, 25, 75}},
};
--]]

local map = {
  {module = 1, type = 1, description = "Das Modul mit dem roten Aufkleber"},
  {module = 2, type = 2, description = "Im Ruderhaus"},
  {module = 8, type = 3},
};

return menu, map, exportValues;
