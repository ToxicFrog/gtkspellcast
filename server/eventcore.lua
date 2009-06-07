function server.mkdispatcher(sock)
    local game = server.game
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

function server.event.default(sock, evt)
    ui.debug("[server] %s >> %s", sock:getpeername(), evt.event)
end

function server.event.iofail(sock, evt)
    local game = server.game
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

