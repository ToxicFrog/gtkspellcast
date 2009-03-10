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

local gtk = require "lgui"
require "ui.gtk.glade"

ui = {}

ui.win = require "ui.gtk.mainwindow"
require "ui.gtk.questions"
require "ui.gtk.help"
require "ui.gtk.spellbook"

function ui.message(text)
    local iter = gtk.TextIter.new()
    local buf = ui.win.TextDisplay:get "buffer":cast(gtk.TextBuffer)
    buf:getEndIter(iter)
    buf:insert(iter, "\n"..text)
end

config.gtk = config.gtk or { layout = "new" }
--require ("ui.gtk.layout."..config.gtk.layout)

ui.add_question {
    question = "What spell do you want to cast (with the left hand)?";
    answers = { "Shield", "Counterspell" };
}
ui.show_questions()
ui.add_question {
    question = "foo"
    ;answers = { "bar", "baz" }
}
ui.show_questions()
ui.clear_questions()
ui.show_questions()

ui.win.MainWindow:showAll()

function ui.mainloop()
    return gtk.main()
end

