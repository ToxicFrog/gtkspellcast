function server.event.say(sock, evt)
    local game = server.game
    for client in pairs(game.clients) do
        ui.debug("[server] sending say-event to %s", tostring(client))
        event.send(client, evt)
    end
end

