--#include "../../global.h"

local function run(event)
  lcd.clear();
  local x = 20;
  local y = 20;

  lcd.drawText(x, y, "Press ENTER", MIDSIZE);

  if (event == EVT_VIRTUAL_ENTER) then
    return 1;
  else
    return 0;
  end
end

return {
  run = run
};
