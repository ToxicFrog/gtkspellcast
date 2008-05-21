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

local gtks = require "gtk-server"

ui = {}
ui.ctx = gtks.library()
local gtk,glade,aux = ui.ctx.gtk, ui.ctx.glade, ui.ctx.aux

config.gtk = config.gtk or { layout = "new" }

gtk.init()
ui.widgets = aux.glade_load_autoconnect("ui/gtk/spellcast.glade", "Main Window")	

require "ui.gtk.help"
require ("ui.gtk.layout."..config.gtk.layout)

gtk.widget_show_all(ui.widgets.MainWindow.handle)

do
	local buf = gtk.text_view_get_buffer(ui.widgets.TextDisplay.handle)
	function ui.message(text)
		gtk.text_buffer_insert_at_cursor(buf, "\n"..text, #text+1)
	end
end

function ui.widgets.MainMenuJoinGame:activate()
	ui.message("Join Game selected")
end

function ui.widgets.MainMenuHostGame:activate()
	ui.message("Host Game selected")
end

function ui.widgets.SubmitButton:toggled()
	ui.message("Submit button toggled, status is: "..gtk.toggle_button_get_active(self.handle))
end

function ui.widgets.TextEntry:activate()
	local text = gtk.entry_get_text(self.handle)
	ui.message("Text entry activated, text is: "..text)
	
	local f = loadstring(text)
	if f then
		local r, err = pcall(f)
		if not r then
			ui.message("Error: "..err)
		end
	end
		
	gtk.entry_set_text(self.handle, "")
end

function ui.widgets.SpellListButton:clicked()
	ui.message("Spell list button clicked")
end

function ui.widgets.MainWindow:delete_event()
	print("Exiting")
	os.exit(0)
end

function ui.widgets.MainMenuExitGame:activate()
	print("Exiting")
	os.exit(0)
end

function ui.mainloop()
	while true do
		local evt = gtk.server_callback("wait")
		--ui.message(evt)

		local handle,signal = string.split(evt, '/')
		handle = tonumber(handle)
		signal = signal:gsub('-', '_')

		if ui.widgets[handle][signal] then
			ui.widgets[handle][signal](ui.widgets[handle])
		else
			ui.message("Warning: unhandled event: "..evt)
		end
	end
end
