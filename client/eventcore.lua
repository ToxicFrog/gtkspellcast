function client.dispatch(evt)
    ui.debug("[client] event: %s", evt.event)
    
    for k,v in pairs(evt) do
        ui.debug("[client][event] %s = %s", tostring(k), tostring(v))
    end
    
    local fname = evt.event:gsub('%W', '_')
    local f = client.event[fname] or client.events.default
    f(evt)
end

function client.event.default(evt)
    ui.debug("[client] << %s", evt.event)
end

function client.event.iofail(evt)
    ui.info("[client] connection lost: %s", evt.reason)
    game = nil
end


