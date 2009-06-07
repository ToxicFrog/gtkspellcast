local gtk = require "lgui"
local win = gtk.loadGlade("ui/gtk/spellcast.glade")

--------------------------------------------------------------------------------
-- "Join Game" menu entry
--------------------------------------------------------------------------------

win.JoinGameGender:set("active", 0)

function win.MainMenuJoinGame:activate()
    win.JoinGame:showAll()
end

function win.JoinGameOK:clicked()
    -- perform connect
    local iter = gtk.TreeIter.new()
    win.JoinGameGender:getActiveIter(iter)
    local game = {
        host = win.JoinGameHost:get "text";
        port = win.JoinGamePort:get "value";
        name = win.JoinGameName:get "text";
        --gender = gtk.TreeModel.get(win.JoinGameGender, iter, 0);
        gender = win.JoinGameGender:getActiveText();
    }
    for k,v in pairs(game) do print(k,v) end
    
    if #game.host == 0 or #game.name == 0 then
        ui.message("[ui] You must enter a hostname and player name")
        return
    end
    ui.message("[ui] join game: %s:%d %s %s", game.host, game.port, game.name, game.gender)
    
    win.JoinGame:hideAll()
    client.join(game)
end

function win.JoinGameCancel:clicked()
    win.JoinGame:hideAll()
end

--------------------------------------------------------------------------------
-- "Host Game" menu entry
--------------------------------------------------------------------------------

function win.MainMenuHostGame:activate()
    win.HostGame:showAll()
end

function win.HostGameOK:clicked()
    local game = {
        port = win.HostGamePort:get "value";
        maxplayers = win.HostGameMaxPlayers:get "value";
    }
    ui.message("[ui] host game: %d %d", game.port, game.maxplayers)
    
    win.HostGame:hideAll()
    server.host(game)
end

function win.HostGameCancel:clicked()
    win.HostGame:hideAll()
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
    client.send { event = "say", text = text }
    
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

