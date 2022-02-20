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

local function loadFile(baseDir, baseName)
    local content = nil;
    local filename = nil;
    if (baseName) then
        filename = baseName .. ".lua";
                                              ;
        content = loadScript(baseDir .. filename);
    end
    if not(content) then
        if (#model.getInfo().name > 0) then
            filename = model.getInfo().name .. ".lua";
                                                  ;
            content = loadScript(baseDir .. filename);
        end
    end
    if not(content) then
        if (LCD_W <= 128) then
            filename = "tiny.lua";
                                                  ;
            content = loadScript(baseDir .. filename);
        elseif (LCD_W <= 212) then
            filename = "medium.lua";
                                                  ;
            content = loadScript(baseDir .. filename);
        else
            filename = "large.lua";
                                                  ;
            content = loadScript(baseDir .. filename);
        end
    end
    if not(content) then
        filename = "default.lua";
                                              ;
        content = loadScript(baseDir .. filename);
    end
    return content, filename;
end

local function loadConfig()
    local baseDir = "/EDGELUA" .. "/RADIO/";
    local cfg = loadFile(baseDir);
                            ;
    if (cfg) then
        return cfg();
    end
    return nil;
end

-- local function loadFile(baseDir)
-- local content = nil;
-- local filename = nil;
-- if (#model.getInfo().name > 0) then
-- filename = model.getInfo().name .. ".lua";
-- ;
-- content = loadScript(baseDir .. filename);
-- end
-- if not content then
-- if (LCD_W <= 128) then
-- filename = "tiny.lua";
-- ;
-- content = loadScript(baseDir .. filename);
-- elseif (LCD_W <= 212) then
-- filename = "medium.lua";
-- ;
-- content = loadScript(baseDir .. filename);
-- else
-- filename = "large.lua";
-- ;
-- content = loadScript(baseDir .. filename);
-- end
-- end
-- if not content then
-- filename = "default.lua";
-- ;
-- content = loadScript(baseDir .. filename);
-- end
-- return content, filename;
-- end

-- local function loadConfig()
-- local baseDir = "/EDGELUA" .. "/RADIO/";
-- local cfg = loadFile(baseDir);
-- ;
-- if (cfg) then
-- return cfg();
-- end
-- return nil;
-- end

local function initBackendBus(config)
                         ;
  local data = {};
  if (config.backends.bus.stateTimeout) then
    data[1] = config.backends.bus.stateTimeout;
  else
    data[1] = 20;
  end
  if (config.backends.bus.mixerGlobalVariable >= 1) then
    data[2] = config.backends.bus.mixerGlobalVariable;
  else
    data[2] = 5;
  end

  if (config.export) then
    data[4] = config.export.mixerGlobalVariable;
    data[3] = config.export.values;
                                                                                                                             ;
  end

  return data;
end

local function initBackendSPort(config)
  local data = {};
  return data;
end

local function initBackendTipTip(config)
                            ;
  local data = {};
  if (config.backends.tiptip.shortTimeout) then
    data[1] = config.backends.tiptip.shortTimeout;
  else
    data[1] = 30;
  end
  if (config.backends.tiptip.longTimeout) then
    data[2] = config.backends.tiptip.longTimeout;
  else
    data[2] = 90;
  end
  if (config.backends.tiptip.mixerGlobalVariable) then
    data[3] = config.backends.tiptip.mixerGlobalVariable;
  else
    data[3] = 7;
  end
  if (config.backends.tiptip.values) then
                                                                                                     ;
    data[4] = config.backends.tiptip.values;
  else
    data[4] = {0, 100, -100};
  end

                                                                                                    ;

  return data;
end

local function initBackendSolExpert(config)
  local data = {};
  return data;
end

local function initRemotes()
    if not LS_FUNC_STICKY then
                                        ;
        LS_FUNC_STICKY = 18;
      end

    local baseDir = "/EDGELUA" .. "/RADIO/REMOTE/";
    local remotes, filename = loadFile(baseDir);

    local cremotes = {};
    if (remotes) then
        local rcfg = remotes();

                                           ;

        for li, remote in ipairs(rcfg) do
            if (remote.source == "trn") then
                if (remote.number) then
                    local name = remote.source .. remote.number;
                    local fi = getFieldInfo(name);
                    if (fi) then
                        local cr = {};
                        cr[1] = name;
                        cr[7] = fi.id;
                        if (remote.thr) then
                            cr[3] = remote.thr;
                            if (remote.map) then
                                cr[2] = 1;
                                cr[4] = remote.map;
                                cr[5] = remote.fn;
                                cr[6] = remote.module;
                                cr[9] = 1;
                                                                                           ;
                                cremotes[#cremotes + 1] = cr;
                            elseif (remote.ls) then
                                cr[2] = 2;
                                cr[8] = remote.ls;
                                                                                           ;
                                cremotes[#cremotes + 1] = cr;
                                for li, l in ipairs(cr[8]) do
                                                            ;
                                    local ls = model.getLogicalSwitch(l - 1);
                                    if (ls) then
                                      if (ls.func == 0) then
                                                                       ;
                                        model.setLogicalSwitch(l - 1, {func = LS_FUNC_STICKY});
                                      end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if (remote.source == "sumdv3") then

            end

        end
    end
    return cremotes;
end

local function setLS(sws, index)
    local lsNumber = sws[index];
    if (lsNumber) then
        for si, sw in ipairs(sws) do
            if (sw == lsNumber) then
                local v = getLogicalSwitchValue(sw - 1);
                                                      ;
                if not (v) then
                    setStickySwitch(sw - 1, true);
                                             ;
                end
            else
                setStickySwitch(sw - 1, false);
            end
        end
    end
end

local function getThreshIndex(thrs, value)
    for iv, thr in ipairs(thrs) do
        if (value < thr) then
            return iv;
        else
            if (value >= thr) and (iv == #thrs) then
                return (iv + 1);
            end
        end
    end
    return 0;
end

local function processLogicalSwitch(remote)
    local value = getValue(remote[7]) / 10.24;
    local lsIndex = getThreshIndex(remote[3], value);
                                                                 ;
    setLS(remote[8],lsIndex);
end

local function processQueuedSwitch(remote, queue)
    local value = getValue(remote[7]) / 10.24;
    local lsIndex = getThreshIndex(remote[3], value);

    local state = remote[4][lsIndex];
    if (remote[9] ~= state) then
        local item = {};
        item[4] = remote[5];
        item[5] = remote[6];
        item[3] = state;
        queue:push(item);
        remote[9] = state;
    end
end

local function processRemotes(remotes, queue)
    for ir, remote in ipairs(remotes) do
        if (remote[2] == 2) then
            processLogicalSwitch(remote);
        elseif (remote[2] == 1) then
            processQueuedSwitch(remote, queue);
        elseif (remote[2] == 3) then
        end
    end
end

local function displayRemotes(remotes, widget, event, touch)
    lcd.drawText(widget[1], widget[2], "Remotes", MIDSIZE);
end

return {
    initRemotes = initRemotes,
    processRemotes = processRemotes,
    displayRemotes = displayRemotes,
};
