ui.lc = { strings = {}, functions = {} }
local lc = ui.lc

local function message(key)
    return function(text)
        lc.strings[key] = text
    end
end

function lc.process(str, env)
    local function dofn(str)
        str = lc.process(str, env)
        local fn
        
        local name = str:match('^[^:]+')
        if not lc.functions[name] then
            return env[name] or "<<error/"..name..">>"
        end
        
        local argv = {}
        for arg in str:sub(#name+2):gmatch('[^,]+') do
            table.insert(argv, arg)
        end
        
        return lc.functions[name](env, unpack(argv))
    end

    return (str:gsub('%$([%w:,$]+)', dofn)
        :gsub('%$(%b())', function(s) return dofn(s:sub(2,-2)) end))
end

function lc.message(evt)
    local key = evt.event
    if client.game.name == evt.who then
        key = "you "..key
    end
    
    if lc.strings[key] then
        ui.message(lc.process(lc.strings[key], evt))
    end
end

message "say"           '$who says, "$text"'
message "you say"       'You say, "$text"'
message "join"          '$who has joined the game.'
message "you join"      'You have joined the game as $who.'
message "you observe"   'You have joined the game as an observer.'
message "quit"          '$who has disconnected: $why'
message "you quit"      'You have been disconnected: $why'
