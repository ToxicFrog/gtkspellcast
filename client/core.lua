-- this is the entry point for the client module

-- basic flow of control:
--  initialized with game information
--  connect to server
--  wait for events and dispatch them

client = {}
client.events = {}

local function dispatch(event)
    local fname = event.event:gsub('%W', '_')
    local f = client.events[fname] or client.events.default
    f(event)
end

-- join a game in progress
-- fields in gameinfo struct:
-- host port name gender
function client.join(game)
    local sock,err = socket.connect(game.host, game.port)
    
    if not sock then
        return sock,err
    end
    
    core.register(sock, dispatch)
end

