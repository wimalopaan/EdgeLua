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
       
       
       
       
local Class = {};
function Class.new(prototype)
  local o = {};
  setmetatable(o, prototype);
  prototype.__index = prototype;
  return o;
end
local Queue = {first = 0, last = -1};
function Queue:new()
  return Class.new(Queue);
end
function Queue:push (item)
  self.last = self.last + 1;
  self[self.last] = item;
end
function Queue:pop()
  local item = self[self.first];
  self[self.first] = nil;
  self.first = self.first + 1;
  return item;
end
function Queue:size()
  return self.last - self.first + 1;
end
Class.Queue = Queue;
local function nextItem(menu, state)
  local page = menu[state[3]];
  if (state[4] == #page) then
    state[4] = 1;
    if (state[3] == #menu) then
      state[3] = 1;
    else
      state[3] = state[3] + 1;
    end
  else
    state[4] = state[4] + 1;
  end
end
local function setSwitchOn(lsNumber)
  local max = getFieldInfo("max");
  if (max) then
    local maxId = max.id;
    local ls = model.getLogicalSwitch(lsNumber);
    ls.func = 3;
    model.setLogicalSwitch(lsNumber, ls);
  end
end
local function setSwitchOff(lsNumber)
  local max = getFieldInfo("max");
  if (max) then
    local maxId = max.id;
    local ls = model.getLogicalSwitch(lsNumber);
    ls.func = 1;
    model.setLogicalSwitch(lsNumber, ls);
  end
end
local function rssiState(cfg, state)
  if (cfg[18]) then
    local t = getTime();
    if not(state[1]) then
      state[1] = 0;
      state[2] = t;
      setSwitchOff(cfg[18]);
    end
    if (state[1] == 0) then -- safeMode
      if (getRSSI() > 10) then
        print("TRACE: ", "safemode: on" );
        state[1] = 1;
        state[2] = t;
      end
    elseif (state[1] == 1) then -- wait rssi
      if (getRSSI() < 10) then
        print("TRACE: ", "safemode: wait up: down" );
        state[2] = t;
        state[1] = 0;
      end
      if ((t - state[2]) > cfg[16]) then
        setSwitchOn(cfg[18]);
        print("TRACE: ", "safemode: wait up: up" );
        state[2] = t;
        state[1] = 2;
      end
    elseif (state[1] == 2) then -- normal
      if (getRSSI() < 10) then
        print("TRACE: ", "safemode normal: down" );
        state[2] = t;
        state[1] = 3;
      end
    elseif (state[1] == 3) then -- wait normal
      if (getRSSI() > 10) then
        print("TRACE: ", "safemode: wait down: up" );
        state[2] = t;
        state[1] = 2;
      end
      if ((t - state[2]) > cfg[17]) then
        setSwitchOff(cfg[18]);
        print("TRACE: ", "safemode: wait down: down" );
        state[2] = t;
        state[1] = 0;
      end
    end
  end
end
local function transportToMixer(gv, value)
end
local function sportConfigFSM()
end
local function sbusConfigFSM(config, menu, headers, menuState, queue, state, encoder, paramEncoder, pValue)
  local t = getTime();
  if ((t - state[1]) > config[3]) then
    if (state[2] == 0) then
      if (queue:size() > 0) then
        state[3] = queue:pop(); -- line
        print("TRACE: ", "cFSM: ", state[2], state[3][1][1] );
        state[2] = 1;
        state[1] = t;
        paramEncoder(config[10], 31, 31); -- bcast off (handles sbus correct)
      end
    elseif (state[2] == 1) then -- broadcast off
      print("TRACE: ", "cFSM: ", state[2] );
      if ((t - state[1]) > 50) then
        state[2] = 2;
        state[1] = t;
-- local item = {[3] = 2, [4] = state[3][1][2], [5] = state[3][1][3]};
        local item = {
          [3] = 2, -- state = on
          [4] = state[3][1][2],
          [5] = state[3][1][3]
        }
        encoder(config[10], item); -- set laston in module
      end
    elseif (state[2] == 2) then -- select item
      print("TRACE: ", "cFSM: ", state[2] );
      if ((t - state[1]) > 50) then
        state[2] = 3;
        state[1] = t;
      end
    elseif (state[2] == 3) then -- send pvalue
      if (menuState[4] == 0) and (menuState[5] == 0) then
        state[2] = 4;
        state[1] = t;
      else
        local item = state[3][1];
        local values = state[3][2];
        local col = menuState[5];
        local value = values[col];
        local itemLine = state[3][3];
        local pageHeaders = headers[ menuState[3] ];
        local header = pageHeaders[itemLine + 3 - 1];
        local paramNumber = header[col][2];
        print("TRACE: ", "cFSM: ", state[2], "P:", paramNumber, "V:", value, header );
        paramEncoder(config[10], paramNumber, value);
      end
    elseif (state[2] == 4) then -- end
      print("TRACE: ", "cFSM: ", state[2] );
      state[2] = 0;
      state[1] = t;
    end
  end
end
local function sportSwitchFSM()
end
local function tiptipSwitchFSM()
end
local function sbusSwitchFSM(config, menu, queue, state, encoder, exportValues)
  local t = getTime();
  if ((t - state[1]) > config[3]) then
    local item = nil;
    if (queue:size() > 0) then
      item = queue:pop();
    else
      local page = menu[state[3]];
      item = page[state[4]];
      if (item[7]) then -- virtuals are not cyclic pushed
        item = nil;
      end
      nextItem(menu, state);
    end
    if (item) then
      if (item[7]) then
        for i, virt in ipairs(item[7]) do
          virt[3] = item[3];
          queue:push(virt);
        end
      else
        encoder(config[10], item);
        if (item[6]) then -- export
          local expValue = exportValues[ item[3] ] * 1024 / 100;
          model.setGlobalVariable(item[6], 0, expValue);
        end
      end
      state[1] = t;
    end
  end
end
local function transportGV(gv, value)
  model.setGlobalVariable(gv, 0, value);
  ;
end
local function transportShm(gv, value)
  setShmVar(1, value)
  ;
end
local function transportGlobalLua(gv, value)
  __Sw2MixerValue = value;
  ;
end
local function scaleXJT(sbusValue)
  local b = bit32.extract(sbusValue, 4);
  if (sbusValue >= 0) then
    return ((sbusValue * 1024) / 1638 + 0.5);
  else
    if (b == 0) then
      return ((sbusValue * 1024) / 1638 - 0.5);
    else
      return ((sbusValue * 1024) / 1638 + 0.5);
    end
  end
end
local function scaleIBus(ibusValue)
  if (ibusValue >= 0) then
    return (ibusValue + 1);
  else
    return ibusValue;
  end
end
local function scaleSBus(sbusValue)
  if (sbusValue >= 0) then
    return ((sbusValue * 1024) / 1638 + 1.5);
  else
    return ((sbusValue * 1024) / 1638 + 0.5);
  end
end
local function setXJT(gv, sbusValue)
  local v = math.modf(scaleXJT(sbusValue));
   transportToMixer(gv, sbusValue);
-- transportToMixer(gv + 1, v);
end
local function setIBus(gv, ibusValue)
  local v = math.modf(scaleIBus(ibusValue));
  transportToMixer(gv, v);
end
local function setSBus(gv, sbusValue)
  local v = math.modf(scaleSBus(sbusValue));
  transportToMixer(gv, v);
end
local function parameterToValueSBus(paramNumber, paramValue)
  if (paramNumber >= 0) and (paramNumber <= 15) then
    if (paramValue >= 0) then
      if (paramValue > 15) then
        paramValue = 15;
      end
      return (512 + paramNumber * 32 + 2 * paramValue) * 2 - 1024;
    end
  end
  return 0;
end
local function parameterToValueIBus(paramNumber, paramValue)
  if (paramNumber >= 0) and (paramNumber <= 15) then
    if (paramValue >= 0) then
      if (paramValue > 31) then
        paramValue = 31;
      end
      return (512 + paramNumber * 32 + paramValue) * 2 - 1024;
    end
  end
  return 0;
end
local function encodeParamXJT(gv, paramNumber, paramValue)
  local sbusValue = parameterToValueSBus(paramNumber, paramValue);
  setXJT(gv, sbusValue);
end
local function encodeParamIBus(gv, paramNumber, paramValue)
  local ibusValue = parameterToValueIBus(paramNumber, paramValue);
  setIBus(gv, ibusValue);
end
local function encodeParamSBus(gv, paramNumber, paramValue)
  local sbusValue = parameterToValueSBus(paramNumber, paramValue);
  setSBus(gv, sbusValue);
end
local function encodeFunctionSBus(item)
  local state = item[3];
  local fn = item[4];;
  local module = item[5];
  return (64 * (module - 1) + 8 * (fn - 1) + 2 * (state - 1)) * 2 - 1024;
end
local function encodeFunctionIBus(item)
  local state = item[3];
  local fn = item[4];
  local module = item[5];
  return (64 * (module - 1) + 8 * (fn - 1) + (state - 1)) * 2 - 1024;
end
local function encodeXJT(gv, item)
  local sbusValue = encodeFunctionSBus(item);
  setXJT(gv, sbusValue);
end
local function encodeSBus(gv, item)
  local sbusValue = encodeFunctionSBus(item);
  setSBus(gv, sbusValue);
end
local function encodeIBus(gv, item)
  local ibusValue = encodeFunctionIBus(item);
  setIBus(gv, ibusValue);
end
local function percentOf(v)
  return math.floor((v + 1024) / 20.48);
end
local function parameterValueIbus(config)
  local v = getValue(config[6]);
  local s = ((v + 1024) * 32) / 2048;
  if (s > 31) then
    s = 31;
  elseif (s < 0) then
    s = 0;
  end
  return math.floor(s), percentOf(v);
end
-- use half the range
local function parameterValueSbus(config)
  local v = getValue(config[6]);
  local s = ((v + 1024) * 16) / 2048;
  if (s > 15) then
    s = 15;
  elseif (s < 0) then
    s = 0;
  end
  return math.floor(s), percentOf(v);
end
local function encodeSPort(gv, item)
end
local function encodeTipTip(gv, item)
end
local function getEncoder(cfg)
  if not(cfg[14]) or (cfg[14] <= 1) then
    local type = cfg[9];
    if (type == 0) then
      return encodeXJT, parameterValueSbus, encodeParamXJT;
    elseif (type == 1) then
      return encodeIBus, parameterValueIbus, encodeParamIBus;
    elseif (type == 2) then
      return encodeSBus, parameterValueSbus, encodeParamSBus;
    end
    return encodeSBus, parameterValueSbus, encodeParamSBus;
  else
    if (cfg[14] == 2) then
      return encodeSPort, parameterValueSPort, encodeParamSPort;
    elseif (cfg[14] == 3) then
      return encodeTipTip;
    end
  end
end
local function getConfigFSM(cfg)
  if (cfg[14] <= 1) then
    return sbusConfigFSM;
  elseif (cfg[14] == 2) then
    return sportConfigFSM;
  else
    return function() end;
  end
end
local function getSwitchFSM(cfg)
  if (cfg[14] <= 1) then
    return sbusSwitchFSM;
  elseif (cfg[14] == 2) then
    return sportSwitchFSM;
  else
    return tiptipSwitchFSM;
  end
end
if (LCD_W <= 212) then -- BW radio
  print("TRACE: ", "libP: use transportGlobalLua" );
  __Sw2MixerValue = 0;
  transportToMixer = transportGlobalLua;
  return {
    Class = Class,
    getSwitchFSM = getSwitchFSM,
    getConfigFSM = getConfigFSM,
    getEncoder = getEncoder,
    rssiState = rssiState,
  };
else -- color radio
  if (getShmVar) then
    print("TRACE: ", "libP: use transportShm" );
    transportToMixer = transportShm;
  else
    print("TRACE: ", "libP: use transportGV" );
    transportToMixer = transportGV;
  end
  return {
    Class = Class,
    getSwitchFSM = getSwitchFSM,
    getConfigFSM = getConfigFSM,
    getEncoder = getEncoder,
    rssiState = rssiState,
  };
end
