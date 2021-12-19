local util   = require 'utility'
local client = require 'client'

-- function OnSetText(uri, text)
--     local diffs = {}

--     for pos in text:gmatch '()#' do
--         if pos == 1 or text:sub(pos - 1, pos - 1):match '[\r\n]' then
--             diffs[#diffs+1] = {
--                 start = pos,
--                 finish = pos,
--                 text = '//'
--             }
--         end
--     end

--     return diffs
-- end

function OnSetText(uri, text)
    local diffs = {}

--    log.debug("TTT:", text);

    local p1, p2, token = string.find(text, "()%s*#(%a+)()");
    if (p1 == 1) then
        diffs[#diffs+1] = {
            start  = p1,
            finish = p2 - 1,
            text   = "//" .. token,
        }
    end

     for startp, token, endp in string.gmatch(text, "[\n\r]+%s*()#(%a+)()") do
        diffs[#diffs+1] = {
            start  = startp,
            finish = endp - 1,
            text   = "//" .. token,
        }
     end

    --  for i, d in ipairs(diffs) do
    --     log.debug("diff:", d.start, d.finish, d.text);
    --  end

     return diffs;
end
