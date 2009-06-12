-- this is the entry point for the server module

-- basic flow of control:
--  initialized with game information
--  create listen socket
--  register timer callback to accept incoming connections

server = {}

require "server.eventcore"
require "server.eventsay"
require "server.eventjoin"

local function acceptor(sock)
    local game = server.game
    local client = sock:accept()
    
    if client then
        ui.info("[server] client connected: %s", client:getpeername())
        game.clients[client] = { name = "<<"..client:getpeername()..">>"; sock = client; }
        game.nrof_clients = game.nrof_clients +1
        
        event.register(client, server.mkdispatcher(client))
    end
end

function server.host(game)
    if server.game then
        ui.info("[server] game already running")
        return
    end
    
    local sock,err = socket.bind('*', game.port)
    if not sock then
        ui.info("[server] couldn't start server: %s", err)
        return nil,err
    end
    
    server.game = {
        port = game.port;
        sock = sock;
        clients = {};
        players = {};
        nrof_clients = 0;
        nrof_players = 0;
    }

    ui.info("[server] hosting on port %d", game.port)
    sock:settimeout(0)
    
    event.register(function() return acceptor(sock) end)
end

function server.shutdown()
    ui.info("[server] shutting down")
    event.unregister(acceptor)
    sock:close()
    
    for client in pairs(game.clients) do
        server.killclient(client, "server shutdown")
    end
    
    game = nil
end

function server.killclient(client, why)
    local game = server.game
    event.send(client, {
        event = "quit";
        why = why;
    })
    event.shutdown(client)
    
    game.clients[client] = nil
    game.nrof_clients = game.nrof_clients - 1
end

