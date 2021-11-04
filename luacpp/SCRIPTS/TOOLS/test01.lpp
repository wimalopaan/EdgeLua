

local function init()
end 

local function run()
  local t5u = getFieldInfo("t5u");

  if (t5u) then
    print("t5u:", t5u.id, getValue(t5u.id));
  end 

  local sl1 = getFieldInfo("sl1");
  if (sl1) then
    print("sl1:", sl1.id, getValue(sl1.id));
  end 
  local sl64 = getFieldInfo("sl64");
  if (sl64) then
    print("sl64:", sl64.id, getValue(sl64.id));
  end 

  local ls1 = getFieldInfo("ls1");
  if (ls1) then
    print("ls1:", ls1.id, getValue(ls1.id));
  end 

  local ls64 = getFieldInfo("ls64");
  if (ls64) then
    print("ls64:", ls64.id, getValue(ls64.id));
  end 

  local ls = model.getLogicalSwitch(50);
  if (ls) then
    print("LS:", ls.func, ls["and"])
  end

  return 1;
end 

return {
  init = init,
  run = run
}