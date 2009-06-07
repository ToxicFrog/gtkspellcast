-- this is the entry point for the client module

-- basic flow of control:
--  initialized with game information
--  connect to server
--  wait for events and dispatch them

client = { event = {} }

require "client.eventcore"
require "client.eventsay"

function client.send(evt)
    if not client.game then
        return ui.info("[client] no game joined")
    end
    return event.send(client.game.sock, evt)
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
    client.game = {
        host = game.host;
        port = game.port;
        name = game.name or config.name;
        gender = game.gender or config.gender;
        sock = sock;
    }
    
    event.register(sock, client.dispatch)

    client.send {
        event = "join";
        name = game.name;
        gender = game.gender;
    }
end

