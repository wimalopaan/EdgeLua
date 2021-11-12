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
       
       
       
       
local function serialize(table, filename)
    if type(table) == "table" then
        io.write("{\n")
        for k,v in pairs(o) do
          io.write("  ", k, " = ")
          serialize(v)
          io.write(",\n")
        end
        io.write("}\n")
      else
        error("cannot serialize a " .. type(o))
      end
end
return {
    serialize = serialize,
}
