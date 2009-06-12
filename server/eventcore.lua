server.event = event.dispatcher()

function server.mkdispatcher(sock)
    local game = server.game
    return function(evt)
        evt.sock = sock
        return server.event(evt)
    end
end

function server.event.pre(evt)
    local game = server.game
    local sock = evt.sock
    ui.debug("[server] event: %s", evt.event)

    if game.clients[sock].observer == nil and evt.event ~= "join" then
        -- the client has connected but hasn't joined yet
        -- we don't allow this
        server.killclient(sock, "must join before sending other messages")
        return true
    end

    -- observers aren't allowed to do anything
    if game.clients[sock].observer then
        return true
    end
    
    evt.who = game.clients[evt.sock].name
end
    
function server.event.default(evt)
    ui.debug("[server] %s >> %s", evt.sock:getpeername(), evt.event)
end

function server.event.iofail(evt)
    local sock = evt.sock
    local game = server.game
    local player = game.clients[sock]
    ui.info("[server] %s disconnected: %s", player.name, evt.why)
    game.clients[sock] = nil
    
    if player.observer == false then
        -- they were a proper, connected player
        -- FIXME need better code to handle this once the rules engine starts!
        -- broadcast disconnect message to all players
        server.sendto_all { event = "quit", why = evt.why }
        game.players[name] = nil
        game.nrof_players = game.nrof_players - 1
    end
end

