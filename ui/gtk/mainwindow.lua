local gtk = require "lgui"
local win = gtk.loadGlade("ui/gtk/spellcast.glade")

function win.MainMenuJoinGame:activate()
	ui.message("Join Game selected")
end

function win.MainMenuHostGame:activate()
	ui.message("Host Game selected")
end

function win.SubmitButton:toggled()
	ui.message("Submit button toggled, status is: "..tostring(self:get "active"))
end

function win.SpellListButton:clicked()
	ui.message("Spell list button clicked")
    ui.spell_list:showAll()
end

function win.TextEntry:activate()
    local text = self:get "text"
    ui.message("Text entry: "..text)
    
    self:set("text", "")

    if not text:match "^>" then return end
    
    local f,err = loadstring(text:sub(2,-1))
    if f then
        local r,err = pcall(f)
        if not r then
            ui.message("Error: "..tostring(err))
        else
            ui.message(tostring(err))
        end
    else
        ui.message("Invalid code: "..tostring(err))
    end
end

function win.MainWindow:delete_event()
    os.exit(0)
end

function win.MainMenuExitGame:activate()
    os.exit(0)
end

return win

