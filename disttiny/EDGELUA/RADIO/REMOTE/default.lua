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

local maps = {
    {2, 1, 3},
};

local threshes = {
    {-33, 33},
};

return {
    {"trn1", threshes[1], maps[1], fn = 1, module = 1},
    {"trn2", threshes[1], maps[1], fn = 2, module = 1},
};