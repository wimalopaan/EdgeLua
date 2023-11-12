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
    name = "Effekte",
    icon = "expand.png",
    layout = {rows = 2, cols = 2},
    buttons = {
        {name = "Licht1", ls = 1},
        {name = "Licht2", ls = 2},
        {name = "Sound1", ls = 3},
        {name = "Sound2", ls = 4},
    }
};
