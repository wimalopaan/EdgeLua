--[[
-- EdgeLUA - EdgeTx / OpenTx Extensions
-- Copyright (C) 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
-- To view a copy of this license, visit http:
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
-- IMPORTANT
-- Please note that the above license also covers the transfer protocol used and the encoding scheme and
-- all further principals of tranferring state and other information.
--]]

-- Default Menu for tiny radios
--{ global
local gstates1 = {"aus", "ein", "bl1", "bl2"}; --<> Beschriftung
local gstates2 = {"stp", "auf", "ab", "NA"}; --<> Die Beschriftung kann aber auch individuell in jeder Zeile erfolgen
local gstates3 = {"P1", "P2", "P3", "P4"};
--}
--{ menu
local menu = {
    title = "Model2", --<> Der Name: ggf. auch der Name zum Abspeichern der Parameterwerte
    saveValues = true,
    { -- template for digital multiswitch RC-MultiSwitch-D @ Address(1) Aä
        title = "Deck 1/1",
        {"M1A", states = gstates1, state = 1, switch = "sa", fn = 1, module = 1}, --<> Hier ist der Schalter `sa` zugeordnet
        {"M1B", states = gstates1, state = 1, switch = "sb", fn = 2, module = 1},
        {"M1C", states = gstates1, state = 1, switch = nil, fn = 3, module = 1},
        {"M1D", states = gstates1, state = 1, switch = "se", virtual = { {fn = 7, module = 1} } }, --<> Eine _virtuelle_ Schaltfunktion besteht aus _mindestens_ einer physischen Schaltfunktion
        {"M1E", states = gstates1, state = 1, switch = nil, fn = 5, module = 1},
        {"M1F", states = gstates1, state = 1, switch = "ls1", fn = 6, module = 1, lsmode = 1}, --<> Logische Schalter beginnen mit dem Präfix `ls`
    },
    {
        title = "Deck 1/2",
        {"M1G", states = gstates1, state = 1, switch = nil, fn = 7, module = 1},
        {"M1H", states = gstates1, state = 1, switch = nil, fn = 8, module = 1},
    },
    { -- template for export function (via global variable) and virtual functions
        {"Wnd", states = gstates2, state = 1, switch = "sa", fn = 1, module = 8, export = 1}, --
        {"Ank", states = gstates2, state = 1, switch = "sb", fn = 2, module = 8, export = 2}, --
        {"Li1", states = gstates1, state = 1, switch = nil, fn = 5, module = 8},
        {"Li2", states = gstates1, state = 1, switch = nil, fn = 6, module = 8},
        {"LAll", states = gstates1, state = 1, switch = "sg", fn = 0, module = 0, virtual = {{fn = 5, module = 8}, {fn = 6, module = 8}, {fn = 1, module = 2}} }, --<> _Virtuelle_ Schaltfunktion mit mehreren _physichen_ Funktionen und dem Schalter `sg`
    },
    { -- template for digital multiswitch RC-MultiSwitch-D @ Address(1)
        {"Li3", states = gstates1, state = 1, switch = "sc", fn = 1, module = 2},
        {"M2B", states = gstates3, state = 1, switch = "sd", fn = 2, module = 2},
        {"M2C", states = gstates3, state = 1, switch = nil, fn = 3, module = 2},
        {"M2D", states = gstates3, state = 1, switch = "se", fn = 4, module = 2},
        {"M2E", states = gstates1, state = 1, switch = nil, fn = 5, module = 2},
        {"M2F", states = gstates1, state = 1, switch = nil, fn = 6, module = 2},
    },
    {
        {"M2G", states = gstates1, state = 1, switch = nil, fn = 7, module = 2},
        {"M2H", states = gstates1, state = 1, switch = nil, fn = 8, module = 2},
    }
}
--}
--{ export
-- deprecated
--local exportValues = {0, -50, 50, 100}; --<> Diese Werte werden den Zuständen 1, 2, 3, 4 zugeordnet
--}
--{ map
local map = {
   {module = 1, type = 1, description = "Rumpf links"},
   {module = 2, type = 2, description = "Deckshaus"},
   {module = 8, type = 3},
};
--}
return menu, map, exportValues;
