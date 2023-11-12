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

local function sort(table, key) -- sort up
  for i = 1, (#table - 1) do
    if (table[i][key] > table[i + 1][key]) then
      local tmp = table[i];
      table[i] = table[i + 1];
      table[i + 1] = tmp;
      i = 1;
    end
  end
end
local function sortDown(table, key)
    for i = 1, (#table - 1) do
      if (table[i][key] < table[i + 1][key]) then
        local tmp = table[i];
        table[i] = table[i + 1];
        table[i + 1] = tmp;
        i = 1;
      end
    end
  end

