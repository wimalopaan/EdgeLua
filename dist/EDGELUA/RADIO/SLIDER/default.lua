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
  name = "Slider",
  icon = "expand.png",
  layout = "V", -- H: left2right, V: top2bottom
  slider = {
      {name = "Licht1", shm = 10, color = 0xff0000},
      {name = "Licht2", shm = 11, color = 0x00ff00},
      {name = "Licht3", shm = 12, color = 0x0000ff},
      {name = "Licht4", shm = 13, color = 0xff00ff},
  }
};
