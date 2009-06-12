client.event = event.dispatcher()

function client.event.default(evt)
    ui.debug("[client] event: %s", evt.event)
end

function client.event.post(evt)
    return ui.event(evt)
end

function client.event.iofail(evt)
    ui.info("[client] connection lost: %s", evt.why)
    game = nil
end
