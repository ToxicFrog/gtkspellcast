function server.event.join(evt)
    local game = server.game
    local sock = evt.sock
    
    local player = game.clients[sock]
    player.name = evt.name
    player.gender = evt.gender
    player.observer = not not evt.observe

    if player.observer then
        return
    end
    
    if game.players[evt.name] then
        return server.killclient(sock, "name already in use")
    end
    
    game.players[player.name] = player
    game.nrof_players = game.nrof_players + 1
    
    ui.info("[server] Player joined: %s", player.name)
    server.sendto_all { event = "join", who = player.name }
end

function server.event.quit(evt)
    local game = server.game
    server.killplayer(game.clients[evt.sock], evt.why)
    server.killclient(evt.sock)
end

function server.killplayer(player, why)
    local game = server.game
    
    if not player.observer then
        game.players[player.name] = nil
        game.nrof_players = game.nrof_players
        server.sendto_all { event = "quit", who = player.name, why = why }
    end
end
