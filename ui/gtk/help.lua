-- all stuff related to the help dialogs
local gtk = require "lgui"
local glade = require "ui.gtk.glade"
local cb = glade.callbacks()

ui.help = {}

local function hider(win)
    return function() win:hideAll() end
end

for _,dialog in ipairs { "About", "Rules", "Manual", "Spellbook" } do
    ui.help[dialog] = glade.widgets(gtk.Glade.new("ui/gtk/help.glade", dialog))
    local win = ui.help[dialog][dialog]
    
    win:connect("delete-event", hider(win))
    win:connect("response", hider(win))

    ui.win["HelpMenu"..dialog]:connect("activate", function(self)
        print(dialog)
        ui.help[dialog][dialog]:showAll()
    end)
end

