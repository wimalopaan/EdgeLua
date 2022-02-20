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
    {1, 2},
};

local threshes = {
    {-33, 33},
    {0},
};

return {
    {source = "trn", number = 1, thr = threshes[1], map = maps[1], fn = 1, module = 1}, -- trainer input 1 with threshes[1], maps[1] for switch
    {source = "trn", number = 2, thr = threshes[1], ls = {10, 11, 12} },
    {source = "trn", number = 3, thr = threshes[2], ls = {13, 14} },

    {"sumdv3", channel = 13, ls = {20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30} }, -- all eleven switches
    {"sumdv3", channel = 14, ls = {32} }, -- first switch only
    {"sumdv3", channel = 15, sw = {{fn = 4, module = 1, state = 2}, {fn = 5, module = 1, state = 2} } }, -- first and second
    {"sumdv3", channel = 16, ls = {34, 35} },

};
