-- utility functions for use with Glade UI definitions
local gtk = require "lgui"

local glade = {}
local mt = {}

function mt:__index(name)
    return self.xml:getWidget(name) or self.xml:getWidget((name:gsub('(.)([A-Z])', "%1 %2")))
end

function glade.widgets(gladexml, ...)
    if type(gladexml) == "string" then
        return glade.widgets(gtk.Glade.new(gladexml, ...))
    end
    return setmetatable({ xml = gladexml }, mt)
end

function glade.callbacks()
  return setmetatable({}, { __index = function(self, name) self[name] = {} return self[name] end })
end

function glade.autoconnect(widgets, callbacks)
    for name,handlers in pairs(callbacks) do
        local widget = assert(widgets[name], "Couldn't find widget named "..name)
        for event,handler in pairs(handlers) do
            widget:connect(event:gsub("_", "-"), function(this, ...) return handler(widget, ...) end)
        end
    end
end

return glade

