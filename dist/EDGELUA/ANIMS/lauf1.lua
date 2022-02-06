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

local animation1 = {
    name = "Loop 1",
    length = 14, -- total loop length [s]
    switches = {
      {fn = 1, module = 1,
        transitions = {
          {at = 5, state = 2}, -- at: [s]
          {at = 6, state = 1},
        }
      },
      {fn = 2, module = 1,
        transitions = {
          {at = 6, state = 2}, -- at: [s]
          {at = 7, state = 1},
        }
      },
      {fn = 3, module = 1,
        transitions = {
          {at = 7, state = 2}, -- at: [s]
          {at = 8, state = 1},
        }
      },
      {fn = 4, module = 1,
        transitions = {
          {at = 8, state = 2}, -- at: [s]
          {at = 9, state = 1},
        }
      },
      {fn = 5, module = 1,
        transitions = {
          {at = 9, state = 2}, -- at: [s]
          {at = 10, state = 1},
        }
      },
      {fn = 6, module = 1,
        transitions = {
          {at = 11, state = 2}, -- at: [s]
          {at = 12, state = 1},
        }
      },
    },
    outputs = {
    },
    inputs = {
    }
  };

  local animation2 = {
    name = "Single 1",
    length = 0, -- no looping
    switches = {
      {fn = 1, module = 1,
        sequence = {
          {duration = 5, state = 1}, -- duration: [s]
          {duration = 5, state = 2},
        }
      },
      {fn = 2, module = 1,
        sequence = {
          {duration = 6, state = 1}, -- duration: [s]
          {duration = 4, state = 2},
        }
      },
      {fn = 3, module = 1,
        sequence = {
          {duration = 7, state = 1}, -- duration: [s]
          {duration = 3, state = 2},
        }
      },
      {fn = 4, module = 1,
        sequence = {
          {duration = 8, state = 1}, -- duration: [s]
          {duration = 2, state = 2},
        }
      },
      {fn = 5, module = 1,
        sequence = {
          {duration = 9, state = 1}, -- duration: [s]
          {duration = 1, state = 2},
        }
      },
    },
    outputs = {
    },
    inputs = {
    }
  };

  return {animation1, animation2};
