function server.event.join(sock, evt)
    local game = server.game
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

