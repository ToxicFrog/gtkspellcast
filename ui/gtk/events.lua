-- events to worry about:
-- join quit say observe

require "ui.gtk.lc"

ui.event = event.dispatcher()

function ui.event.pre(evt)
    ui.message("[ui] event: %s", evt.event)
end

function ui.event.default(evt)
    ui.message("[ui] unhandled event: %s", evt.event)
end

for _,key in ipairs { "say", "join", "leave", "quit", "observe" } do
    ui.event[key] = ui.lc.message
end
