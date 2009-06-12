local gtk = require "lgui"
local win = gtk.loadGlade("ui/gtk/spellcast.glade")

--------------------------------------------------------------------------------
-- "Join Game" menu entry
--------------------------------------------------------------------------------

function win.MainMenuJoinGame:activate()
    win.JoinGameName:set("text", config.default_name)
    win.JoinGameGender:set("active", config.default_gender_index)
    win.HostGame:hideAll()
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
        gender = win.JoinGameGender:getActiveText();
        observe = win.JoinGameObserve:get "active";
    }
    for k,v in pairs(game) do print(k,v) end
    
    if #game.host == 0 or #game.name == 0 then
        ui.info("[ui] You must enter a hostname and player name")
        return
    end
    
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
    win.HostGameName:set("text", config.default_name)
    win.HostGameGender:set("active", config.default_gender_index)
    win.JoinGame:hideAll()
    win.HostGame:showAll()
end

function win.HostGameOK:clicked()
    local game = {
        port = win.HostGamePort:get "value";
        maxplayers = win.HostGameMaxPlayers:get "value";
    }
    
    local result = server.host(game)
    if result then
        client.join {
            host = "localhost";
            port = game.port;
            name = win.HostGameName:get "text";
            gender = win.HostGameGender:getActiveText();
        }
        win.HostGame:hideAll()
    end
end

function win.HostGameCancel:clicked()
    win.HostGame:hideAll()
end

--------------------------------------------------------------------------------
-- "Disconnect" entry
--------------------------------------------------------------------------------

function win.MainMenuDisconnect:activate()
    if not client.game then
        ui.message("Not connected.")
        return
    end
    client.disconnect "disconnect by user"
end

--------------------------------------------------------------------------------
-- "Options" menu
--------------------------------------------------------------------------------

win.ConfigSaveLogs:set("active", config.gtk.save_logs)
win.ConfigTurnSep:set("active", config.gtk.turn_separator)

function win.ConfigPlayerSetup:activate()
    win.ConfigName:set("text", config.default_name)
    win.ConfigGender:set("active", config.default_gender_index)
    win.PlayerSetup:showAll()
end

function win.ConfigApply:clicked()
    config.default_name = win.ConfigName:get "text"
    config.default_gender = win.ConfigGender:getActiveText();
    config.default_gender_index = win.ConfigGender:get "active"
    commit_config()
    win.PlayerSetup:hideAll()
end

function win.ConfigCancel:clicked()
    win.PlayerSetup:hideAll()
end

function win.ConfigSaveLogs:toggled()
    config.gtk.save_logs = win.ConfigSaveLogs:get "active"
    commit_config()
end

function win.ConfigTurnSep:toggled()
    config.gtk.turn_separator = win.ConfigTurnSep:get "active"
    commit_config()
end

--------------------------------------------------------------------------------
-- General UI widgets
--------------------------------------------------------------------------------

function win.SubmitButton:toggled()
    local state = self:get "active"

    if ui.questions then
        assert(state)
        ui.dispatch_questions()
        ui.clear_questions()
        self:set("active", false)
        return
    end

    -- FIXME dispatch gestures here
    
    self:set("text", state and "Cancel" or "End Turn")
end

function win.SpellListButton:clicked()
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

