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

local bmpExpandSmall = nil;
local name = "EL_Test";
local options = {
  {"Test", STRING}
};
local function create(zone, options)
  load();
  loadLibU();
  collectgarbage();
  if (errorCode > 0) then
    return {};
  end
  local widget = __libI.initWidget(zone, options);
  collectgarbage();
  if not(__WmSw2Config) then
    local config = __libI.loadConfig();
    if not(config) then
      errorCode = 4;
      return widget;
    end
    __WmSw2Config = __libI.initConfig(config, true);
  end
  collectgarbage();
  __libI = nil; -- free memory
  collectgarbage();
  if (CHAR_TRIM) and (getSwitchIndex) then
    local t5u = getSwitchIndex(CHAR_TRIM .. "5u");
                    ;
  else
                                    ;
  end
  if (getPhysicalSwitches) then
    local sws = getPhysicalSwitches();
                                        ;
    for i, sw in ipairs(sws) do
                                                   ;
    end
  end
  bmpExpandSmall = Bitmap.open("/EDGELUA" .. "/ICONS/48px/expand.png");
  widget.sendDataLastTime = getTime();
  return widget;
end
local function update(widget, options)
  widget[11] = options;
end
local function background(widget)
  if (errorCode == 0) then
  end
end
CRSF_FRAMETYPE_DISPLAYPORT_CMD = 0x7D
CRSF_DISPLAYPORT_SUBCMD_UPDATE = 0x01
CRSF_DISPLAYPORT_SUBCMD_CLEAR = 0x02
CRSF_DISPLAYPORT_SUBCMD_OPEN = 0x03
CRSF_DISPLAYPORT_SUBCMD_CLOSE = 0x04
CRSF_DISPLAYPORT_SUBCMD_POLL = 0x05
CRSF_ADDRESS_BETAFLIGHT = 0xC8
CRSF_ADDRESS_TRANSMITTER = 0xEA
CRSF_FRAMETYPE_CMD = 0x32
CRSF_ADDRESS_CC = 0xA0
local function sendData(widget)
  local t = getTime();
  if ((t - widget.sendDataLastTime) > 10) then -- 100ms
    widget.sendDataLastTime = t;
                     ;
    local payloadOut = { CRSF_ADDRESS_CC, CRSF_ADDRESS_TRANSMITTER, 0x05, t};
    crossfireTelemetryPush(CRSF_FRAMETYPE_CMD, payloadOut);
  end
end
local function refresh(widget, event, touch)
  __libD.updateWidgetDimensions(widget, event);
  if (errorCode == 0) then
    if (widget[3] <= (LCD_W / 2)) then
      if (bmpExpandSmall) then
        lcd.drawBitmap(bmpExpandSmall, widget[1], widget[2]);
      end
      lcd.drawText(widget[1] + 60, widget[2], "Sys-Infos", MIDSIZE);
    else
      __libU.displayDebug(widget);
      sendData(widget);
    end
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
