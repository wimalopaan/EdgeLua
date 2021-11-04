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


-- List of Modul-Types

local modules = {
  {
    type = 1,
    description = "RC-Multiswitch-D",
    moduleParams = {
      {{"Test Outputs", "Tst", 8}},
    };
    functionParams = {
      {{"Reset", "Res", 0}, {"Pwm", "Pwm", 1}, {"Blink1 I", "B1i", 2}, {"Blink1 D", "B1d", 3}}, -- line1
      {{"Blink2 I", "B2i", 4}, {"Blink2 D", "B2d", 5}, {"PassThr", "PT", 6}} -- line2
    }
  },
  {
    type = 2,
    description = "RC-MultiAdapter-DA",
    moduleParams = {
      {{"TimeMpx", "TMpx", 7}, {"Impuls-L", "Imp", 8}, {"SyncImpuls-L", "Syn", 9}},
    };
    functionParams = {
      {{"Reset", "Res", 0}, {"PassThru", "PT", 6}}, -- line1
    }
  },
  {
    type = 3,
    description = "RC-Quad-D",
    moduleParams = {
      {{"SensorId", "SId", 7}},
    };
    functionParams = {
      {{"Reset", "Res", 0}, {"Ramp", "Rmp", 1}, {"Pwm FW", "PwF", 2}, {"Off FW", "OFw", 3}}, -- line1
      {{"Pwm BW", "PwB", 4}, {"Off BW", "OBw", 5}, {"PassThru", "PT", 6}, {"StromK", "Ck", 10}} -- line2
    }
  },
  {
    type = 4,
    description = "RC-ServoSwitch-D",
    moduleParams = {
      {{"TimeMpx", "TMpx", 7}, {"TMod", "TMod", 8}, {"OutpTim", "OTim", 9}},
    };
    functionParams = {
      {{"Reset", "Res", 0}, {"Speed", "Sp", 1}, {"Pos 1", "P1", 2}, {"Pos 2", "P2", 3}}, -- line1
      {{"Pos 3", "P3", 4}, {"Pos 4", "P4", 5}, {"Mode/PassT", "MPT", 6}} -- line2
    }
  },
  {
    type = 5,
    description = "RC-Led-D",
    moduleParams = {
      {{"TimeMpx", "TMpx", 7}, {"TMod", "TMod", 8}, {"OutpTim", "OTim", 9}},
    };
    functionParams = {
      {{"Reset", "Res", 0}, {"Speed", "Sp", 1}, {"Pos 1", "P1", 2}, {"Pos 2", "P2", 3}}, -- line1
      {{"Pos 3", "P3", 4}, {"Pos 4", "P4", 5}, {"Mode/PassT", "MPT", 6}} -- line2
    }
  }
};

return modules;
