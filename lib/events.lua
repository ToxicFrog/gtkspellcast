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

    local function val(tag, data)
        return unpack[tag](data:sub(2,-2))
    end
    
    local t = {}
    for kvp in s:gmatch("%b"..SO..SI) do
        local iter = kvp:gmatch('(['..DC1..DC2..DC3..DC4..'])(%b'..STX..ETX..')')
        
        t[val(iter())] = val(iter())
    end
    
    return t
end

local function sendevt(sock, evt)
    local buf = serialize(evt)
    sock:send(tostring(#buf)..'\n'..buf)
end

local function recvevt(sock)
    local size = tonumber(sock:receive('*l'))
    if not size then return nil end
    
    local buf = sock:receive(size)
    return deserialize(buf)
end

local sockets = {}
local timers = {}
local writebufs = {}

local readlist,writelist

local function mkreadlist()
    readlist = {}
    for sock in pairs(sockets) do
        table.insert(readlist, sock)
    end
end

local function mkwritelist()
    writelist = {}
    for sock,buf in pairs(writebufs) do
        if #buf > 0 then
            table.insert(writelist, sock)
        end
    end
end

event = {}--{ serialize = serialize, deserialize = deserialize }

function event.send(sock, evt)
    table.insert(writebufs[sock], evt)
    if #writebufs[sock] == 1 then
        mkwritelist()
    end
end

function event.register(sock, fn)
    if not fn then
        timers[sock] = true
    else
        sockets[sock] = fn
        writebufs[sock] = {}
        mkreadlist()
    end
end

function event.unregister(sock)
    timers[sock] = nil
    sockets[sock] = nil
    writebufs[sock] = nil
    mkreadlist()
    mkwritelist()
end

function event.mainloop()
    while true do
        -- the lists are automatically kept updated by the register and send functions
        -- select on the lists
        rready,wready = socket.select(readlist, writelist, 0.1)
        
        -- send any pending messages
        for _,sock in ipairs(wready) do
            print("pending", sock, writebufs[sock][1])
            local evt = table.remove(writebufs[sock], 1)
            if #writebufs[sock] == 0 then
                mkwritelist()
            end
            sendevt(sock, evt)
        end
        
        -- dispatch any pending events
        for _,sock in ipairs(rready) do
            local evt = recvevt(sock)
            if evt then
                sockets[sock](evt)
            end
        end
        
        -- process any registered timers
         for f in pairs(timers) do
            f()
        end
   end
end

