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
        print("TRACE: " , "loadFile", baseDir .. filename );
        content = loadScript(baseDir .. filename);
    end
    if not(content) then
        if (#model.getInfo().name > 0) then
            filename = model.getInfo().name .. ".lua";
            print("TRACE: " , "loadFile", baseDir .. filename );
            content = loadScript(baseDir .. filename);
        end
    end
    if not(content) then
        if (LCD_W <= 128) then
            filename = "tiny.lua";
            print("TRACE: " , "loadFile", baseDir .. filename );
            content = loadScript(baseDir .. filename);
        elseif (LCD_W <= 212) then
            filename = "medium.lua";
            print("TRACE: " , "loadFile", baseDir .. filename );
            content = loadScript(baseDir .. filename);
        else
            filename = "large.lua";
            print("TRACE: " , "loadFile", baseDir .. filename );
            content = loadScript(baseDir .. filename);
        end
    end
    if not(content) then
        filename = "default.lua";
        print("TRACE: " , "loadFile", baseDir .. filename );
        content = loadScript(baseDir .. filename);
    end
    return content, filename;
end

local function loadConfig()
    local baseDir = "/EDGELUA" .. "/RADIO/";
    local cfg = loadFile(baseDir);
    print("TRACE: " , "loadConfig", cfg );
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
-- print("TRACE: " , "loadFile", baseDir .. filename );
-- content = loadScript(baseDir .. filename);
-- end
-- if not content then
-- if (LCD_W <= 128) then
-- filename = "tiny.lua";
-- print("TRACE: " , "loadFile", baseDir .. filename );
-- content = loadScript(baseDir .. filename);
-- elseif (LCD_W <= 212) then
-- filename = "medium.lua";
-- print("TRACE: " , "loadFile", baseDir .. filename );
-- content = loadScript(baseDir .. filename);
-- else
-- filename = "large.lua";
-- print("TRACE: " , "loadFile", baseDir .. filename );
-- content = loadScript(baseDir .. filename);
-- end
-- end
-- if not content then
-- filename = "default.lua";
-- print("TRACE: " , "loadFile", baseDir .. filename );
-- content = loadScript(baseDir .. filename);
-- end
-- return content, filename;
-- end

-- local function loadConfig()
-- local baseDir = "/EDGELUA" .. "/RADIO/";
-- local cfg = loadFile(baseDir);
-- print("TRACE: " , "loadConfig", cfg );
-- if (cfg) then
-- return cfg();
-- end
-- return nil;
-- end

local function initBackendBus(config)
  print("TRACE: " , "initBackendBus" );
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
    print("TRACE: " , "export: gv:", data[4], data[3], #data[3] );
  end

  return data;
end

local function initBackendSPort(config)
  local data = {};
  return data;
end

local function initBackendTipTip(config)
  print("TRACE: " , "initBackendTipTip" );
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
    print("TRACE: " , "initBackendTipTip values:", config.backends.tiptip.values, #config.backends.tiptip.values );
    data[4] = config.backends.tiptip.values;
  else
    data[4] = {0, 100, -100};
  end

  print("TRACE: " , "initBackendTipTip VALUES: ", data[2], data[1] );

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

        print("TRACE: " , "loadRemote", filename, rcfg );

        for li, remote in ipairs(rcfg) do
            local fi = getFieldInfo(remote[1]);
            if (fi) then
                remote[6] = fi.id;
                print("TRACE: " , "remote: ", remote[1], fi, fi.id );
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
