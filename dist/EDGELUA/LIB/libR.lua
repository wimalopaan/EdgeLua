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
    local baseDir = "/EDGELUA" .. "/RADIO/REMOTE/";
    local remotes, filename = loadFile(baseDir);

    if (remotes) then
        local rcfg = remotes();

                                           ;

        for li, remote in ipairs(rcfg) do
            local fi = getFieldInfo(remote[1]);
            if (fi) then
                remote[6] = fi.id;
                                                                    ;
            end
        end
        return rcfg;
    end

    return nil;
end

local function processRemotes()
end

return {
    initRemotes = initRemotes,
    processRemotes = processRemotes,
};
