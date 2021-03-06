-- utility functions for use with Glade UI definitions
local gtk = require "lgui"

local glade = {}
local mt = {}

local function __newindex(this, name, value)
    print("Connecting", this, name, "to", value)
    this:connect(name:gsub("_", "-"), value, this)
end
    
function mt:__index(name)
    local widget = self.xml:getWidget(name) or self.xml:getWidget( (name:gsub('(.)([A-Z])', "%1 %2")) )
    
    if not widget then return nil end
    
    getmetatable(widget).__newindex = __newindex

    return widget
end

function gtk.loadGlade(...)
    local xml = gtk.Glade.new(...)
    if not xml then return end
    return setmetatable({ xml = xml }, mt)
end

return glade

