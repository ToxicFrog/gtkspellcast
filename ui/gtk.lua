--[[
	as a UI module, we need to expose a bunch of API functions:

		[ player related ]
		FIXME specify player structure
		
		ui.add_player(player)
	add a player status to the UI. FIXME may be removed and rolled into update_player

		ui.update_player(player)
	update a player's status.

		ui.remove_player(player)
	remove a player's status from the UI

		[ rules related ]
		FIXME specify spellbook structure
		
		ui.load_spellbook(sb)
	load the given spellbook and expose its contents to the use
	
		[ gameplay related ]
		
		ui.add_question(q)
		FIXME specify question structure
		
		change state?
		emit event?
		emit message?

		[ system related]
		
		ui.mainloop()
	run the UI main loop FIXME will be removed and replaced with a yielding coroutine
]]


-- events we need to worry about
-- menu: join game, host game, exit, edit options, manual, rules, spells, about
-- text entry
-- end turn (stateful!)
-- select answer (maybe?)
-- spell list: click, hold
-- gestures: click

--[[
widgets we need to talk to:
	- text box (update contents)
	- end turn button (change state, change label)
	- status line (change label)
	- question list (add/remove questions, show/hide list)
	- individual question entries (label and dropdown)

	- player info (encapsulated)
		* add/remove players and monsters
		* update monster hp and owner
		* update player hp/status/gestures/etc
		- player list
		- name, status flags, hitpoints, gesture lists, owned monsters
	
widgets we need to hear from:
	- end turn button (clicked)
	- spell list buttons (clicked, pressed, released)
	- text entry box (activate)
	- menu entries (activate)
		- join game
		- new game
		- exit
		- options
			- player list: classic
			- player list: divided
			- player list: new
			- gesture icon set: <type list>/<size list>
			- save logs
			- show turn dividers
		- manual
		- rules
		- spells
		- about
	- player gesture selection (???)

Notes:
	we don't need to hear from the answers. We just query them when "end
	questions" is pressed.
	The player list will be encapsulated. It needs to be able to recieve
	the gestures:
		add/remove/update player/monster
	and emit:
		select left/right gesture
]]

require "ui.gtk.glade"
local gtk = require "lgui"
local win = glade.widgets(gtk.Glade.new "ui/gtk/spellcast.glade")
local cb = setmetatable({}, { __index = function(self, name) self[name] = {} return self[name] end })

ui = {}

function ui.message(text)
    local iter = gtk.TextIter.new()
    local buf = win.TextDisplay:get "buffer":cast(gtk.TextBuffer)
    buf:getEndIter(iter)
    buf:insert(iter, "\n"..text)
--    gtk.Editable.insertAtCursor(win.TextBuffer, "\n"..text, #text+1)
end

config.gtk = config.gtk or { layout = "new" }
--require "ui.gtk.help"
--require ("ui.gtk.layout."..config.gtk.layout)

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
	gtk.widget_show_all(ui.spell_list.handle)
end

function cb.TextEntry:activate()
    local text = self:get "text"
    ui.message("Text entry: "..text)
    
    self:set("text", "")

    if not text:match "^lua>" then return end
    
    local f = loadstring(text:sub(5,-1))
    if f then
        local r,err = pcall(f)
        if not r then
            ui.message("Error: "..err)
        else
            ui.message(tostring(err))
        end
    end
end

function cb.MainWindow:delete_event()
    os.exit(0)
end

function cb.MainMenuExitGame:activate()
    os.exit(0)
end

glade.autoconnect(win, cb)
win.MainWindow:showAll()

function ui.mainloop()
    return gtk.main()
end

return ui

