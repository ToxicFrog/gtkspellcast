function server.event.say(evt)
    server.sendto_all { event = "say", who = evt.who, text = evt.text }
end

function server.sendto_all(evt)
    for client in pairs(server.game.clients) do
        print(client, evt)
        event.send(client, evt)
    end
end
