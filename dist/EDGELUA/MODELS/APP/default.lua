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
  buttons = {
      {event = "b0", ls = 20},
      {event = "b1", ls = 21},
      {event = "b2", ls = 22},
      {event = "b3", ls = 23},
      {event = "b4", ls = 24},
      {event = "b5", ls = 25},
      {event = "b6", ls = 26},
      {event = "b7", ls = 27},
  },
  analogs = {
      {event = "v0", shm = 10},
      {event = "v1", shm = 11},
      {event = "v2", shm = 12},
      {event = "v3", shm = 13},
      {event = "v4", shm = 14},
      {event = "v5", shm = 15},
  }
};
