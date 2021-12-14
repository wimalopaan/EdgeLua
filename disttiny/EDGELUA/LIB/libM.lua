
local function loadFile(baseDir)
    local content = nil;
    local filename = nil;
    if (#model.getInfo().name > 0) then
      filename = model.getInfo().name .. ".lua";
                                            ;
      content = loadScript(baseDir .. filename);
    end
    if not content then
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
  return data;
end

local function initConfigMixer(config)
                            ;
    local cfg = {};
    cfg[2] = {};

    cfg[2][1] = initBackendBus(config);
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
