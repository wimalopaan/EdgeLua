--#include "../../global.h"

local function run(event)
  lcd.clear();
  local x = 20;
  local y = 20;

  lcd.drawText(x, y, "Press ENTER", MIDSIZE);

  if (event == EVT_VIRTUAL_ENTER) then
    for ch = 0,63 do
      local lines = model.getMixesCount(ch);
      for line = 0, lines do
        print("ch:" .. ch .. " l:" .. line);
        local m = model.getMix(ch, line);
        if (m) then
          model.deleteMix(ch, line);
          model.insertMix(ch, line, m);
        end
      end
    end
    return 1;
  else
    return 0;
  end
end

return {
  run = run
};
