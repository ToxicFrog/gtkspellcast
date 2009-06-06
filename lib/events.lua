local DC1,DC2,DC3,DC4,STX,ETX,SO,SI
    = string.char(0x11, 0x12, 0x13, 0x14, 0x02, 0x03, 0x0E, 0x0F)
      :match(('(.)'):rep(8))

local function serialize(t)
    local pack = {}
    function pack.string(val)
        return DC1..STX..val:gsub(STX, '_')..ETX
    end
    function pack.number(val)
        return DC2..STX..tostring(val)..ETX
    end
    function pack.boolean(val)
        return DC3..STX..tostring(val)..ETX
    end
    function pack.table(val)
        return DC4..STX..serialize(val)..ETX
    end
    function pack.other() return "" end

    local s = ""
    for k,v in pairs(t) do
        local tk,tv = type(k),type(v)
        s = s..SO..(pack[tk] or pack.other)(k)
            ..(pack[tv] or pack.other)(v)..SI
    end
    return s
end

local function deserialize(s)
    local unpack = {}
    unpack[DC1] = function(s) return s end
    unpack[DC2] = function(s) return tonumber(s) end
    unpack[DC3] = function(s) return s == "true" end
    unpack[DC4] = function(s) return deserialize(s) end

    local t = {}
    for kvp in s:gmatch("%b"..SO..SI) do
        local iter = kvp:gmatch('(['..DC1..DC2..DC3..DC4..'])(%b'..STX..ETX')')
        
        t[unpack(iter())] = unpack(iter())
        local k,kvp = val(kvp)
        local v = val(kvp)
        t[k] = v
    end
    
    return t
end

event = {}

function event.send(sock, evt)
    local buf = serialize(evt)
    sock:send(tostring(#buf)..'\n'..buf)
end

function event.recv(sock)
    local size = tonumber(sock:receive('*l'))
    if not size then return nil end
    
    return deserialize(sock:receive(size))
end

local sockets = {}
local timers = {}

function event.register(sock, fn)
    if not fn then
        timers[sock] = true
    else
        table.insert(sockets, sock)
        sockets[sock] = fn
    end
end

function event.mainloop()
    local ready
    while true do
        -- process all sockets with pending messages on them
        ready = socket.select(sockets, nil, 0.1)
        for _,sock in ipairs(ready) do
            sockets[sock](sock)
        end
        
        -- process all local update functions
        for f in pairs(timers) do
            f()
        end
    end
end

