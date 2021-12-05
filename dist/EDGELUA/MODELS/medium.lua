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

-- Default menu for medium radios

local gstates1 = {"aus", "ein", "blk1", "blk2"};
local gstates2 = {"aus", "e1", "e2"};
local gstates3 = {"Pos1", "Pos2", "Pos3", "Pos4", "Pos5"};

local menu = {
    title = "Model1",
    saveValues = true,
    { -- template for digital multiswitch RC-MultiSwitch-D @ Address(1)
        title = "Deck 1",
        {"M1A", states = gstates1, state = 1, switch = "sa", fn = 1, module = 1},
        {"M1B", states = gstates1, state = 1, switch = "sb", fn = 2, module = 1},
        {"M1C", states = gstates1, state = 1, switch = nil, fn = 3, module = 1},
        {"M1D", states = gstates1, state = 1, switch = "se", virtual = { {fn = 7, module = 1} } },
        {"M1E", states = gstates1, state = 1, switch = "input1", fn = 5, module = 1},
        {"M1F", states = gstates1, state = 1, switch = "input2", fn = 6, module = 1},
        {"M1G", states = gstates1, state = 1, switch = nil, fn = 7, module = 1},
        {"M1H", states = gstates1, state = 1, switch = nil, fn = 8, module = 1},
    },
    { -- template for export function (via global variable) and virtual functions
        {"Winde", states = gstates1, state = 1, switch = "sa", fn = 1, module = 8, export = 0}, --export
        {"Anker", states = gstates1, state = 1, switch = "sb", fn = 2, module = 8, export = 1},
        {"Licht1", states = gstates1, state = 1, switch = nil, fn = 5, module = 8},
        {"Licht2", states = gstates1, state = 1, switch = nil, fn = 6, module = 8},
        {"L-Alle", states = gstates1, state = 1, switch = "sg", fn = 0, module = 0, virtual = {{fn = 5, module = 8}, {fn = 6, module = 8}, {fn = 1, module = 2}} }, -- virtual
    },
    { -- template for digital multiswitch RC-MultiSwitch-D @ Address(1)
        {"Licht3", states = gstates1, state = 1, switch = "sc", fn = 1, module = 2},
        {"M2B", states = gstates1, state = 1, switch = "sd", fn = 2, module = 2},
        {"M2C", states = gstates1, state = 1, switch = nil, fn = 3, module = 2},
        {"M2D", states = gstates1, state = 1, switch = "se", fn = 4, module = 2},
        {"M2E", states = gstates1, state = 1, switch = nil, fn = 5, module = 2},
        {"M2F", states = gstates1, state = 1, switch = nil, fn = 6, module = 2},
        {"M2G", states = gstates1, state = 1, switch = nil, fn = 7, module = 2},
        {"M2H", states = gstates1, state = 1, switch = nil, fn = 8, module = 2},
    },
}

local exportValues = {0, -50, 50, 100}; -- values for states

local map = {
   {module = 1, type = 1},
   {module = 2, type = 2},
   {module = 8, type = 3},
};

return menu, map, exportValues;
