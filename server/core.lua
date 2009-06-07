-- this is the entry point for the server module

-- basic flow of control:
--  initialized with game information
--  create listen socket
--  register timer callback to accept incoming connections

server = { event = {} }

local game

function server.event.default(sock, evt)
    ui.debug("[server] %s >> %s", sock:getpeername(), evt.event)
end

function server.event.iofail(sock, evt)
    local name = game.clients[sock].name
    ui.info("[server] %s disconnected: %s", name, evt.reason)
    
    if game.clients[sock].gender then
        -- they were a proper, cnnected player
        -- FIXME need better code to handle this once the rules engine starts!
        -- broadcast disconnect message to all players
        game.players[name] = nil
        game.nrofplayers = game.nrofplayers - 1
    end
    game.clients[sock] = nil
end

function server.event.join(sock, evt)
    if game.players[evt.name] then
        return server.killclient(sock, "name already in use")
    end
    
    local player = game.clients[sock]
    player.name = evt.name
    player.gender = evt.gender

    game.players[player.name] = player
    game.clients[sock] = player
    game.nrofplayers = game.nrofplayers+1
    
    ui.info("[server] Player joined: %s", player.name)
end

function server.event.say(sock, evt)
    for client in pairs(game.clients) do
        ui.debug("[server] sending say-event to %s", tostring(client))
        event.send(client, evt)
    end
end

local function mkdispatcher(sock)
    return function(evt)
        ui.debug("[server] event: %s", evt.event)
        
        if not game.clients[sock].gender and evt.event ~= "join" then
            -- the client has connected but hasn't joined yet
            -- we don't allow this
            server.killclient(sock, "must join before sending other messages")
            return
        else
            evt.who = game.clients[sock].name
        end
        
        local fname = evt.event:gsub('%W', '_')
        local f = server.event[fname] or server.event.default
        print(f, sock, evt)
        f(sock, evt)
    end
end

local function acceptor(sock)
    local client = sock:accept()
    
    if client then
        ui.info("[server] client connected: %s", client:getpeername())
        game.clients[client] = { name = "<<"..client:getpeername()..">>"; sock = client; }
        
        event.register(client, mkdispatcher(client))
    end
end

function server.host(_game)
    if game then
        ui.info("[server] game already running")
        return
    end
    
    local sock,err = socket.bind('*', _game.port)
    if not sock then
        ui.info("[server] couldn't start server: %s", err)
        return nil,err
    end
    
    game = _game
    game.sock = sock
    game.nrofplayers = 0
    game.clients = {}
    game.players = {}

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

