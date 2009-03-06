local gtk = require "lgui"
local glade = require "ui.gtk.glade"
local win = glade.widgets("ui/gtk/spellcast.glade")
local cb = glade.callbacks()

function cb.MainMenuJoinGame:activate()
	ui.message("Join Game selected")
end

function cb.MainMenuHostGame:activate()
	ui.message("Host Game selected")
end

function cb.SubmitButton:toggled()
	ui.message("Submit button toggled, status is: "..tostring(self:get "active"))
end

function cb.SpellListButton:clicked()
	ui.message("Spell list button clicked")
    ui.spell_list:showAll()
end

function cb.TextEntry:activate()
    local text = self:get "text"
    ui.message("Text entry: "..text)
    
    self:set("text", "")

    if not text:match "^>" then return end
    
    local f,err = loadstring(text:sub(5,-1))
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

function cb.MainWindow:delete_event()
    os.exit(0)
end

function cb.MainMenuExitGame:activate()
    os.exit(0)
end

glade.autoconnect(win, cb)

return win

