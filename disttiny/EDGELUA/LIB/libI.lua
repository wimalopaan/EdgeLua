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

local function isEdgeTx()
  local ver, radio, maj, minor, rev, osname = getVersion();
  return osname ~= nil;
end

local function initWidgetBW()
  local widget = {0, 0, 0, 0, 0, 0, 0};
  widget[1] = 0;
  widget[2] = 0;
  widget[3] = LCD_W;
  widget[4] = LCD_H;
  widget[5] = 8;
  widget[8] = 8;
  widget[9] = 16;
  widget[6] = 8;
  widget[7] = 16;
  return widget;
end
local function getLogicalSwitchFor(id)
  local max = getFieldInfo("max");
  if not(max) then return -1; end

  local maxId = max.id;
  for lsNumber = 63, 0, -1 do
    local ls = model.getLogicalSwitch(lsNumber);
    if (ls) then

      if (LS_FUNC_VPOS) then
        if (ls.func == LS_FUNC_VPOS) and (ls.v1 == maxId) and (ls.v2 == 0) and (ls["and"] == id) then
          return lsNumber;
        end
      else
        if (ls.func == 3) and (ls.v1 == maxId) and (ls.v2 == 0) and (ls["and"] == id) then
          return lsNumber;
        end
      end

    end
  end
  return -1;
end

local function getFirstFreeLogicalSwitch()
  for lsNumber = 63, 0, -1 do
    local ls = model.getLogicalSwitch(lsNumber);
    if (ls) and (ls.func == 0) then
      return lsNumber;
    end
  end
  return -1;
end

local function insertLogicalSwitchFor(id)
                                     ;

  if (type(id) == "string") then
    if (getSwitchIndex) then
      local swid = getSwitchIndex(CHAR_TRIM .. id);
      if (swid) then
                                                                ;
        id = swid;
      else
        return -1;
      end
    else
      return -1;
    end
  end
  local max = getFieldInfo("max");
  if (max) then
    local maxId = max.id;
    if (id) then
      local lsNumber = getLogicalSwitchFor(id);
      if (lsNumber < 0) then
        lsNumber = getFirstFreeLogicalSwitch();
        if (lsNumber >= 0) then

          if (LS_FUNC_VPOS) then
            model.setLogicalSwitch(lsNumber, {func = LS_FUNC_VPOS, v1 = maxId, v2 = 0, ["and"] = id});
          else
            model.setLogicalSwitch(lsNumber, {func = 3, v1 = maxId, v2 = 0, ["and"] = id});
          end

        end
      end
      if (lsNumber >= 0) then
        local lsf = getFieldInfo("ls" .. (lsNumber + 1));
        if (lsf) then

          return lsf.id;
        end
      end
    end
  end
  return -1;
end

local function insertSettableSwitch(number)
                               ;
  local max = getFieldInfo("max");
  if (max) then
    local maxId = max.id;

    for n = 63, 0, -1 do
      local ls = model.getLogicalSwitch(n);

      if (LS_FUNC_VEQUAL) then
        if ((ls.func == LS_FUNC_VEQUAL) or (ls.func == LS_FUNC_VPOS)) and (ls.v1 == maxId) and (ls.v2 == number) then
          return n;
        end
      else
        if ((ls.func == 1) or (ls.func == 3)) and (ls.v1 == maxId) and (ls.v2 == number) then
          return n;
        end
      end

    end
    local lsNumber = getFirstFreeLogicalSwitch();
    if (lsNumber >= 0) then

      if (LS_FUNC_VEQUAL) then
        model.setLogicalSwitch(lsNumber, {func = LS_FUNC_VEQUAL, v1 = maxId, v2 = number}); -- func: 1: a == 0, 3: a > x
      else
        model.setLogicalSwitch(lsNumber, {func = 1, v1 = maxId, v2 = number}); -- func: 1: a == 0, 3: a > x
      end

      return lsNumber;
    end
  end
  return -1;
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
-- return content, filename;
-- end

local function loadMenu()
  local baseDir = "/EDGELUA" .. "/MODELS/";
  local menu, filename = loadFile(baseDir);
                                    ;
  if (menu) then
    local modchunk = loadScript("/EDGELUA" .. "/COMMON/swmods.lua");
    if (modchunk) then
      local modules = modchunk();
      if (modules) then
        local m, map, exportValues = menu(); -- todo: remove exportvalues
        return m, exportValues, filename, map, modules;
      end
    end
  end
  return nil;
end

-- local function loadConfig()
-- local baseDir = "/EDGELUA" .. "/RADIO/";
-- local cfg = loadFile(baseDir);
-- ;
-- if (cfg) then
-- return cfg();
-- end
-- return nil;
-- end

--[[

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
--]]

local function initConfigBW(config, modifyModel)
                       ;
  local cfg = {};
  cfg[20] = {};

  cfg[20][1] = initBackendBus(config);
  if (config.title) then
    cfg[1] = config.title;
  else
    cfg[1] = "WmSw";
  end
  if (config.firstColumnWidth) then
    cfg[2] = config.firstColumnWidth;
  else
    cfg[2] = 40;
  end

  if (config.parameterDial) then
    local info = getFieldInfo(config.parameterDial);
    if (info) then
      cfg[6] = info.id;
    end
  end

  local module = model.getModule(config.module or 0);

  if not(module) or (module.Type == 0) then
    module = model.getModule(1);
  end

  if (module) then
    local type = module.Type;
    local proto = module.protocol;
    local subproto = module.subProtocol;
    if (type == 2) then -- xjt
      cfg[9] = 0; -- xjt
    elseif (type == 6) then -- mpm
      if (proto == 28) then -- AFHDS2A
        cfg[9] = 1; -- ibus
      else
        cfg[9] = 2; -- sbus
      end
    else
      cfg[9] = 2; --sbus
    end
  else
    cfg[9] = 2; --sbus
  end

  local footer = "Vers: " .. "2.16";
  if (cfg[9] == 0) then
    footer = footer .. " Mod: xjt";
  elseif (cfg[9] == 1) then
    footer = footer .. " Mod: ibus";
  else
    footer = footer .. " Mod: sbus";
  end
  if (config.title) then
    footer = footer .. " Conf: " .. config.title;
  end
  cfg[19] = footer;

  if (config.backend >= 1) and (config.backend <= 4) then
    cfg[14] = config.backend;
  else
    cfg[14] = 1;
  end

-- model.deleteMixes();

  if (modifyModel) and (config.safeMode) then
    if (config.safeMode.flightMode > 0) then
      if (config.safeMode.timeOut > 0) and (config.safeMode.linkDropoutMax > 0) then
        local fmLsNumber = insertSettableSwitch(1);
        if (fmLsNumber >= 0) then

          for ch = 0,63 do
            local lines = model.getMixesCount(ch);
            for line = 0, lines do
              local m = model.getMix(ch, line);
              if (m) then
                if not(string.find(m.name, config.safeMode.excludeMixesBeginnWith)) then
                  local mask = bit32.lshift(1, config.safeMode.flightMode);
                  m.flightModes = bit32.bor(m.flightModes, mask);
                  model.deleteMix(ch, line);
                  model.insertMix(ch, line, m);
                end
              end
            end
          end
          local fm = model.getFlightMode(config.safeMode.flightMode);
          if (fm) then
            local ls = nil;

              if (getSwitchIndex) then
                ls = {};
                ls.id = getSwitchIndex("L" .. (fmLsNumber + 1));
                                                           ;
              end

            if (ls) then
                                            ;
              if (config.safeMode.name) then
                fm.name = config.safeMode.name;
              else
                fm.name = "SafeMode";
              end
              fm.switch = -ls.id; -- inverted
              model.setFlightMode(config.safeMode.flightMode, fm);
            else
                                     ;
              if (config.safeMode.name) then
                fm.name = config.safeMode.name;
              else
                fm.name = "SafeMode";
              end
              fm.switch = -136; -- inverted LS63
              model.setFlightMode(config.safeMode.flightMode, fm);
            end
          end
          cfg[15] = config.safeMode.flightMode;
          cfg[16] = config.safeMode.timeOut * 100;
          cfg[17] = config.safeMode.linkDropoutMax * 100;
          cfg[18] = fmLsNumber;
                                                                  ;
        end
      end
    end
  end

  return cfg;
end
local function findItem(cmenu, fn, module) -- compressed-menu
  for ip, page in ipairs(cmenu) do
    for i, item in ipairs(page) do
      if (item[4]) and (item[5]) and (item[4] == fn) and (item[5] == module) then
        return item;
      end
    end
  end
  return nil;
end

local function findModuleInfo(module, map, modInfos)
  for imap, entry in ipairs(map) do
    if (entry.module == module) then
      for imod, modInfo in ipairs(modInfos) do
        if (entry.type == modInfo.type) then
          if (entry.description) then
            modInfo.help = entry.description;
          end
          --[[
          if (entry.saveparams) then
            modInfo.save = true;
          end
          --]]
          return modInfo;
        end
      end
    end
  end
  return nil;
end

local function getModules(map)
  local modules = {};
  for i, mod in ipairs(map) do
    modules[i] = mod.module;
  end
  return modules;
end

local function moduleItems(menu)
  local mi = {};
  for ip, page in ipairs(menu) do
    for ii, item in ipairs(page) do
      if (item.module) and (item.fn) and (item.module > 0) and (item.fn > 0) then
        if not(mi[item.module]) then
          mi[item.module] = {};
        end
        mi[item.module][#mi[item.module] + 1] = item;
      end
    end
  end
  return mi;
end

local function initParamMenu(cfg, menu, map, modInfos, mode)
  if not(menu) or not(map) or not(modInfos) then
    return;
  end

  local cmenu = {};
  local headers = {};
  local help = {};

  local valuesFileName = nil;
  local miTable = moduleItems(menu);

  for _, imodule in ipairs(getModules(map)) do
    local items = miTable[imodule];
    if (#items > 0) then
      local modInfo = findModuleInfo(imodule, map, modInfos); -- full module info table
      if (modInfo) then
        local header = {nil, nil, nil}; -- header[1] = title, header[2] = moduleNumber
        header[1] = modInfo.description;
        header[2] = imodule;
        header[3] = nil;
        for l, hline in ipairs(modInfo.moduleParams) do -- header[3...] = {{shortName, pId}, ...}
          local line = {};
          for ip, param in ipairs(hline) do
            if (mode) then
              line[ip] = {param[1], param[3]}; -- long label
            else
              line[ip] = {param[2], param[3]}; -- short label
            end
          end
          header[(l - 1) + 3] = line;
        end

        local page = {};
        local citem = {nil, nil, nil}; -- {name, fn, module}, Dummy Eintrag um ein lastOn im Modul auszulösen
        citem[1] = "Module";
        citem[2] = 1;
        citem[3] = imodule;
        for itemLineNumber = 1, #modInfo.moduleParams do
          local line = {nil, nil, nil}; -- {citem, {v0, v1, v2, ...}, itemLine}
          local values = {};
          for valueNumber = 1, #modInfo.moduleParams[itemLineNumber] do
            values[valueNumber] = 0;
          end
          line[1] = citem;
          line[2] = values;
          line[3] = itemLineNumber;
          page[#page + 1] = line;
        end
        headers[#headers + 1] = header;
        cmenu[#cmenu + 1] = page;
        if (mode) and (modInfo.help) then
          help[#cmenu] = modInfo.help;
        end

        header = {nil, nil, nil}; -- header[1] = title, header[2] = moduleNumber
        header[1] = modInfo.description;
        header[2] = imodule;
        header[3] = nil;
        for l, hline in ipairs(modInfo.functionParams) do -- header[3...] = {{shortName, pId}, ...}
          local line = {};
          for ip, param in ipairs(hline) do
            if (mode) then
              line[ip] = {param[1], param[3]}; -- long label
            else
              line[ip] = {param[2], param[3]}; -- short label
            end
          end
          header[(l - 1) + 3] = line;
        end

        local maxItemLines = 8 - #header; -- possible lines usable for function-parameters
        local itemsPerPage = math.floor(maxItemLines / #modInfo.functionParams);
        local pages = math.ceil(#items / itemsPerPage); -- needed for this module

        local itemNumber = 1;
        for p = 1, pages do
          local page = {};
          for inlineNumber = 1, itemsPerPage do
            local item = items[itemNumber];
            if (item) then
              local citem = {nil, nil, nil}; -- {name, fn, module}
              citem[1] = item[1];
              citem[2] = itemNumber;
              citem[3] = imodule;
              for itemLineNumber = 1, #modInfo.functionParams do
                local line = {nil, nil, nil}; -- {citem, {v0, v1, v2, ...}, itemLine}
                local values = {};

                for valueNumber = 1, #modInfo.functionParams[itemLineNumber] do
                  values[valueNumber] = 0;
                end
                line[1] = citem;
                line[2] = values;
                line[3] = itemLineNumber;
                page[#page + 1] = line;
              end
            else
              break;
            end
            itemNumber = itemNumber + 1;
          end
          cmenu[#cmenu + 1] = page;
          headers[#headers + 1] = header;
          if (mode) and (modInfo.help) then
            help[#cmenu] = modInfo.help;
          end
        end
      end
    end
  end
                                                     ;
  return headers, cmenu, help, valuesFileName;
end

local function initParamMenuBW(cfg, menu, map, modInfos)
  return initParamMenu(cfg, menu, map, modInfos, false);
end
local function initMenuBW(menu)
  if not menu then
    return;
  end

  local cmenu = {};
  local shortCuts = {};
  local overlays = {};
  local pagetitles = {};

  for i, p in ipairs(menu) do
    overlays[i] = {};
  end
  local switchUse = {};

  local switchId = nil;
  local lsmode = 0;
  for i, p in ipairs(menu) do
    if (p.title) then
      pagetitles[i] = p.title;
    end
    cmenu[i] = {};
    for k, item in ipairs(p) do
      switchId = nil;
      lsmode = 0;
      if (item.switch) then
        local s = getFieldInfo(item.switch);
        if (s) then
          switchId = s.id;
        end
        if (string.find(item.switch, "ls")) then
          lsmode = item.lsmode;
        end
      end
      -- all components mus be set
      -- todo: remove nil
      local citem = {item[1], item.states, item.state, item.fn, item.module, nil, nil, nil};
      -- validity check
      if (citem[1]) and
      (citem[2]) and
      (
        ((citem[4]) and (citem[5]) and (citem[4] > 0) and (citem[5] > 0)) or
        ((citem[7]) and (#citem[7] > 0))
        ) then
        cmenu[i][k] = citem;
        if (switchId) then
          citem[1] = citem[1] .. "/" .. item.switch;
          local use = {citem, lsmode};
          if not switchUse[switchId] then
            switchUse[switchId] = {use};
          else
            local sc = #switchUse[switchId];
            switchUse[switchId][sc + 1] = use;
          end
        end
      end
    end
  end
  for switchid, uses in pairs(switchUse) do
    if (#uses > 1) then
      for iu, use in ipairs(uses) do
        local swItem = use[1];
        local lsmode = use[2];
        for ip, page in ipairs(cmenu) do
          for i, item in ipairs(page) do
            if (item == swItem) then
              overlays[ip][#overlays[ip] + 1] = {switchid, item, lsmode};
            end
          end
        end
      end
    else
      local item = uses[1][1];
      local lsmode = uses[1][2];
      shortCuts[#shortCuts + 1] = {switchid, item, lsmode};
    end
  end
  menu = nil;
  switchUse = nil;
  collectgarbage();
  return cmenu, shortCuts, overlays, pagetitles;
end
local function initFSM(state)
  if not(state[1]) then
    state[1] = getTime();
    state[2] = 0;
    state[3] = 1;
    state[4] = 1;
    return;
  end
end

local function initConfigFSM(state)
  if not(state[1]) then
    state[1] = getTime();
    state[2] = 0;
    state[3] = 0; -- nil
    return;
  end
end

if (LCD_W <= 128) then
  initMenuColor = nil;
  initParamMenuColor = nil;
  initConfigColor = nil;
  return {
    loadConfig = loadConfig,
    loadMenu = loadMenu,
    initWidget = initWidgetBW,
    initMenu = initMenuBW,
    initParamMenu = initParamMenuBW,
    initConfig = initConfigBW,
    initFSM = initFSM,
    initConfigFSM = initConfigFSM,
  };
elseif (LCD_W <= 212) then
  initMenuColor = nil;
  initParamMenuColor = nil;
  initConfigColor = nil;
  return {
    loadConfig = loadConfig,
    loadMenu = loadMenu,
    initWidget = initWidgetBW,
    initMenu = initMenuBW,
    initParamMenu = initParamMenuBW,
    initConfig = initConfigBW,
    initFSM = initFSM,
    initConfigFSM = initConfigFSM,
  };
else
  return {
    loadConfig = loadConfig,
    loadMenu = loadMenu,
    initWidget = initWidgetColor,
    initMenu = initMenuColor,
    initParamMenu = initParamMenuColor,
    initConfig = initConfigColor,
    initFSM = initFSM,
    initConfigFSM = initConfigFSM,
  };
end
