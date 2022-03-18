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

local function loadLib(filename)
                             ;
  local basedir = "/EDGELUA" .. "/LIB/";
  local chunk = loadScript(basedir .. filename);
  local lib = nil;
  if (chunk) then
                                     ;
    lib = chunk();
  end
  collectgarbage();
  return lib;
end

local errorCode = 0;

-- __stopWmSw2 = 0;
-- __WmSw2Config = nil;
-- __WmSw2ForeignInput = 0;
-- __WmSw2Warning1 = nil;
-- __WmSw2Warning2 = nil;

local function loadLibI()
  if not __libI then
    __libI = loadLib("libI.lua");
    if not __libI then
      errorCode = 1;
    end
  end
end

local function loadLibM()
  if not __libM then
    __libM = loadLib("libM.lua");
    if not __libM then
      errorCode = 1;
    end
  end
end

local function loadLibD()
  if not __libD then
    __libD = loadLib("libD.lua");
    if not __libD then
      errorCode = 2;
    end
  end
end

local function loadLibP()
  if not __libP then
    __libP = loadLib("libP.lua");
    if not __libP then
      errorCode = 3;
    end
  end
  collectgarbage();
end

local function load()
  loadLibI();
  loadLibD();
  loadLibP();
end

local function loadLibA()
  if not __libA then
    __libA = loadLib("libA.lua");
    if not __libA then
      errorCode = 3.1;
    end
  end
  collectgarbage();
end

local function loadLibU()
  if not __libU then
    __libU = loadLib("libU.lua");
    if not __libU then
      errorCode = 3.2;
    end
  end
  collectgarbage();
end

local function loadLibR()
  if not __libR then
    __libR = loadLib("libR.lua");
    if not __libR then
      errorCode = 3.3;
    end
  end
  collectgarbage();
end

local function loadLibApp()
  if not __libApp then
    __libApp = loadLib("libApp.lua");
    if not __libApp then
      errorCode = 3.4;
    end
  end
  collectgarbage();
end

local name = "EL_App";
local options = {
    { "Offset", VALUE, 0, 0, 49},
    { "Value1", SOURCE, 1},
    { "Value2", SOURCE, 2},
    { "Value3", SOURCE, 3},
    { "Value4", SOURCE, 4},
    { "Value5", SOURCE, 5},
};
local app = {};
local lasttime = 0;

local function create(zone, options)
  load();
  loadLibApp();
  collectgarbage();

  if (errorCode > 0) then
    return {};
  end

  local widget = __libI.initWidget(zone, options);
  collectgarbage();

  app = __libApp.init();

  if not(app) then
    errorCode = 6;
    return widget;
  end

  __libI = nil; -- free memory

  collectgarbage();

  setSerialBaudrate(9600);

  return widget;
end

local function update(widget, options)
  widget[11] = options;
end

local function send(widget)
    local t = getTime();
    if ((t - lasttime) > 33) then
        lasttime = t;
        local off = widget[11].Offset;
        local v1 = getValue(widget[11].Value1);
        serialWrite("$v" .. off .. ":" .. v1 .. "\n");
        off = off + 1;
        local v2 = getValue(widget[11].Value2);
        serialWrite("$v" .. off .. ":" .. v2 .. "\n");
        off = off + 1;
        local v3 = getValue(widget[11].Value3);
        serialWrite("$v" .. off .. ":" .. v3 .. "\n");
        off = off + 1;
        local v4 = getValue(widget[11].Value4);
        serialWrite("$v" .. off .. ":" .. v4 .. "\n");
        off = off + 1;
        local v5 = getValue(widget[11].Value5);
        serialWrite("$v" .. off .. ":" .. v5 .. "\n");
    end
end

local state = 1;

local function parse(b)
    if (state == 1) then
    elseif (state == 1) then
    else
    end
end

local function receive(widget)
    local msg = serialRead();
    for i=1, #msg do
        parse(msg:byte(i, i));
    end
end

local function background(widget)
  if (errorCode == 0) then
    send();
    receive();
  end
end

local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    background();
  else
    lcd.drawText(widget[1], widget[2], "Error: " .. errorCode, DBLSIZE);
  end
end

return {
  name=name,
  options=options,
  create=create,
  update=update,
  refresh=refresh,
  background=background
};
