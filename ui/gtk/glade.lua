-- utility functions for use with Glade UI definitions
local gtk = require "lgui"

local glade = {}
local mt = {}

function mt:__index(name)
    local widget = self.xml:getWidget(name) or self.xml:getWidget(name:gsub('(.)([A-Z])', "%1 %2"))
    
    if not widget then return nil end
    
    local function __index(this, name)
        local f = widget[name]
        if f then
            this[name] = function(_, ...)
                return f(widget, ...)
            end
        else
            this[name] = false
        end
        return this[name]
    end
    
    local function __newindex(this, name, value)
        widget:connect(name:gsub("_", "-"), value)
    end
    
    return setmetatable( {}, { __index = __index, __newindex = __newindex } )
end

function gtk.loadGlade(...)
    local xml = gtk.Glade.new(...)
    return setmetatable({ xml = xml }, mt)
end

return glade

