--
-- EdgeLUA - EdgeTx / OpenTx Extensions 
-- Copyright (C) 2021 Wilhelm Meier <wilhelm.wm.meier@googlemail.com>
--
-- This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
-- To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ 
-- or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

-- IMPORTANT
-- Please note that the above license also covers the transfer protocol used and the encoding scheme and 
-- all further principals of tranferring state and other information.


local animation1 = {
  name = "Loop 1",
  length = 20, -- total loop length [s]
  switches = {
    {fn = 1, module = 1,
      transitions = {
        {at = 4, state = 3}, -- at: [s]
        {at = 10, state = 1},
      }
    },
    {fn = 2, module = 1,
      transitions = {
        {at = 1.5, state = 2}, -- at: [s]
        {at = 3, state = 1},
      }
    },
    {fn = 5, module = 1,
      sequence = {
        {duration = 3, state = 1}, -- duration: [s]
        {duration = 4, state = 2},
        {duration = 3.5, state = 3},
        {duration = 2.1, state = 2},
        {duration = 1, state = 1},
      }
    },
  },
  outputs = {
  },
  inputs = {
  }
};

local animation2 = {
  name = "Loop 2",
  length = 10, -- total loop length [s]
  switches = {
    {fn = 2, module = 1,
      transitions = {
        {at = 1, state = 2}, -- at: [s]
        {at = 3, state = 1},
      }
    },
    {fn = 5, module = 1,
      sequence = {
        {duration = 2, state = 1}, -- duration: [s]
        {duration = 2, state = 2},
      }
    },
  },
  outputs = {
  },
  inputs = {
  }
};

local animation3 = {
  name = "Single 1",
  length = 0, -- no looping
  switches = {
    {fn = 2, module = 1,
      transitions = {
        {at = 1, state = 2}, -- at: [s]
        {at = 3, state = 1},
      }
    },
    {fn = 5, module = 1,
      sequence = {
        {duration = 2, state = 1}, -- duration: [s]
        {duration = 2, state = 2},
      }
    },
  },
  outputs = {
  },
  inputs = {
  }
};

local animation4 = {
  name = "Single 2",
  length = 0, -- no looping
  switches = {
    {fn = 2, module = 1,
      transitions = {
        {at = 1, state = 2}, -- at: [s]
        {at = 3, state = 1},
      }
    },
    {fn = 5, module = 1,
      sequence = {
        {duration = 2, state = 1}, -- duration: [s]
        {duration = 2, state = 2},
      }
    },
  },
  outputs = {
  },
  inputs = {
  }
};

return {animation1, animation2, animation3};

