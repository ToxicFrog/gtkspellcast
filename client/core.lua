-- this is the entry point for the client module

-- basic flow of control:
--  initialized with game information
--  connect to server
--  wait for events and dispatch them

client = {}
client.events = {}

local function dispatch(evt)
    ui.message("[client] event: %s", evt.event)
    do return end
    
    local fname = event.event:gsub('%W', '_')
    local f = client.events[fname] or client.events.default
    f(event)
end

-- join a game in progress
-- fields in gameinfo struct:
-- host port name gender
function client.join(game)
    ui.message("[client] connecting to %s:%d", game.host, game.port)
    local sock,err = socket.connect(game.host, game.port)
    
    if not sock then
        ui.message("[client] connection failed: %s", err)
        return nil,err
    end
    ui.message("[client] connected")
    
    event.register(sock, dispatch)
    game.sock = sock
    client.game = game
end

function client.send(evt)
    if not client.game then
        return ui.message("[client] no game joined")
    end
    return event.send(client.game.sock, evt)
end
