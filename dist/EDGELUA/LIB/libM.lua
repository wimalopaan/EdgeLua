
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

local function initConfigMixer(config)
    print("TRACE: " , "initConfigMixer" );
    local cfg = {};
    cfg[2] = {};

    cfg[2][1] = initBackendBus(config);

    cfg[2][2] = initBackendSPort(config);

    cfg[2][3] = initBackendTipTip(config);

    cfg[2][4] = initBackendSolExpert(config);

    if (config.backend >= 1) and (config.backend <= 4) then
        cfg[1] = config.backend;
    else
        cfg[1] = 1;
    end

    return cfg;
end

return {
    loadConfig = loadConfig,
    initConfig = initConfigMixer,
};
