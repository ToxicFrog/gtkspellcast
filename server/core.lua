-- this is the entry point for the server module

-- basic flow of control:
--  initialized with game information
--  create listen socket
--  register timer callback to accept incoming connections

server = { event = {} }

require "server.eventcore"
require "server.eventsay"
require "server.eventjoin"

local function acceptor(sock)
    local game = server.game
    local client = sock:accept()
    
    if client then
        ui.info("[server] client connected: %s", client:getpeername())
        game.clients[client] = { name = "<<"..client:getpeername()..">>"; sock = client; }
        
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
        nrofplayers = 0;
        clients = {};
        players = {};
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

function server.killclient(client, reason)
    local game = server.game
    event.send(client, {
        evt = "quit";
        reason = reason;
    })
    client:close()
    
    -- they were a connected player
    if game.clients[client] then
        -- FIXME need to swap in a replacement AI and whatnot
        -- probably a seperate unregister_player call or similar
        game.players[game.clients[client].name] = nil
    end
    game.clients[client] = nil
end

