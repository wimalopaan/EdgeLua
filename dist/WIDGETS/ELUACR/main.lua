
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

local name = "EL_crsf";
local options = {};
local function initWidgetColor(zone, options)
    local widget = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    widget[1] = zone.x;
    widget[2] = zone.y;
    widget[3] = zone.w;
    widget[4] = zone.h;
    widget[10] = zone;
    widget[11] = options;
      local w, h = lcd.sizeText("A", SMLSIZE);
      widget[5] = h - 1;
      widget[8] = h;
      widget[9] = h * 3 / 2;
      w, h = lcd.sizeText("A", MIDSIZE);
      widget[6] = h;
      widget[7] = h;
    return widget;
  end
local function create(zone, options)
  local widget = initWidgetColor(zone, options);
  widget.sendDataLastTime = getTime();
  return widget;
end
local function update(widget, options)
  widget[11] = options;
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
    local payloadOut = { CRSF_ADDRESS_BETAFLIGHT, CRSF_ADDRESS_TRANSMITTER, 0x05, t};
    crossfireTelemetryPush(CRSF_FRAMETYPE_CMD, payloadOut);
  end
end
local function background(widget)
    sendData(widget);
end
local function refresh(widget, event, touch)
    sendData(widget);
    lcd.drawText(widget[1], widget[2], "CRSF: ", DBLSIZE);
    local finfo = getFieldInfo("s1");
    local v = getValue("s1");
    lcd.drawText(20,100,"value = " .. v);
    if (finfo) then
        lcd.drawText(20,20,"id = " .. finfo.id)
        lcd.drawText(20,40,"name = " .. finfo.name)
        lcd.drawText(20,60,"desc = " .. finfo.desc)
        if (finfo.unit) then
            lcd.drawText(20,80,"unit = " .. (finfo.unit))
        end
    else
        lcd.drawText(20,20,"No info for " .. CHAR_POT .. "S1")
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
