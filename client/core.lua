-- this is the entry point for the client module

-- basic flow of control:
--  initialized with game information
--  connect to server
--  wait for events and dispatch them

client = {}
client.event = {}

function client.event.default(evt)
    ui.debug("[client] << %s", evt.event)
end

function client.event.say(evt)
    --lc.message { event = "say", subject = evt.who, object = evt.text }
    ui.debug("client say-event processing")
    if evt.who == client.game.name then
        ui.message('You say, "%s"', evt.text)
    else
        ui.message('%s says, "%s"', evt.who, evt.text)
    end
end

local function dispatch(evt)
    ui.debug("[client] event: %s", evt.event)
    
    for k,v in pairs(evt) do
        ui.debug("[client][event] %s = %s", tostring(k), tostring(v))
    end
    
    local fname = evt.event:gsub('%W', '_')
    local f = client.event[fname] or client.events.default
    f(evt)
end

-- join a game in progress
-- fields in gameinfo struct:
-- host port name gender
function client.join(game)
    ui.info("[client] connecting to %s:%d", game.host, game.port)
    local sock,err = socket.connect(game.host, game.port)
    
    if not sock then
        ui.info("[client] connection failed: %s", err)
        return nil,err
    end
    ui.info("[client] connected")
    game.sock = sock
    client.game = game
    
    event.register(sock, dispatch)

    client.send {
        event = "join";
        name = game.name;
        gender = game.gender;
    }
end

function client.send(evt)
    if not client.game then
        return ui.info("[client] no game joined")
    end
    return event.send(client.game.sock, evt)
end
