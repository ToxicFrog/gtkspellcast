-- all stuff related to the help dialogs
local gtk = require "lgui"

ui.help = {}

local function hider(win)
    return function() win:hideAll() end
end

for _,dialog in ipairs { "About", "Rules", "Manual", "Spellbook" } do
    ui.help[dialog] = gtk.loadGlade("ui/gtk/help.glade", dialog)
    local win = ui.help[dialog][dialog]
    
    win.delete_event = hider(win)
    win.response = hider(win)

    ui.win["HelpMenu"..dialog].activate = function(self)
        ui.help[dialog][dialog]:showAll()
    end
end

