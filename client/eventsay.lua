function client.event.say(evt)
    local game = server.game
    --lc.message { event = "say", subject = evt.who, object = evt.text }
    ui.debug("client say-event processing")
    if evt.who == game.name then
        ui.message('You say, "%s"', evt.text)
    else
        ui.message('%s says, "%s"', evt.who, evt.text)
    end
end

