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

gtks = require "gtk-server"
ctx = gtks.library()
gtk,glade = ctx.gtk, ctx.glade

gtk.init()
widgets = ctx.aux.glade_load_autoconnect("/home/ben/Desktop/Spellcast/ui/spellcast3.glade")

buf = gtk.text_view_get_buffer(widgets.TextDisplay.handle)
gtk.widget_show_all(widgets.MainWindow.handle)

function widgets.MainWindow:delete_event()
	print("Exiting")
	os.exit(0)
end

function widgets.MainMenuExitGame:activate()
	print("Exiting")
	os.exit(0)
end

function widgets.HelpMenuAbout:activate()
	-- widgets.AboutDialog:show_all()
	gtk.widget_show_all(widgets.AboutDialog.handle)
end

function widgets.HelpMenuRules:activate()
	-- widgets.AboutDialog:show_all()
	gtk.widget_show_all(widgets.RulesDialog.handle)
end

function widgets.AboutDialog:delete_event()
	-- widgets.AboutDialog:hide_all()
	gtk.widget_hide_all(widgets.AboutDialog.handle)
end
widgets.AboutDialog.response = widgets.AboutDialog.delete_event

while true do
	local evt = gtk.server_callback("wait")
	gtk.text_buffer_insert_at_cursor(buf, "\n"..evt, #evt+1)
	
	local handle,signal = string.split(evt, '/')
	handle = tonumber(handle)
	signal = signal:gsub('-', '_')
	
	if widgets[handle][signal] then
		widgets[handle][signal](string.split(evt, '/'))
	else
		print("Warning: unhandled event: "..evt)
	end
end
print "done"

--[[
xml = glade.xml_new("/home/ben/Desktop/spellcast3.glade", nil, nil)
win = glade.xml_get_widget(xml, "Main Window")
gtk.widget_show_all(win)

function widget(name)
	return function(signals)
		local wh = glade.xml_get_widget(xml, name)
		for _,signal in ipairs(signals) do
			gtk.server_connect(wh, signal, name.."/"..wh.."/"..signal)
		end
		return wh
	end
end

widget "Submit Button" { "clicked" }
widget "Spell List Button" { "clicked", "pressed", "released" }
widget "Text Entry" { "activate" }
widget "Main Window" { "delete-event" }
widget "Main Menu Join Game" { "activate" }
widget "Main Menu Host Game" { "activate" }
widget "Main Menu Exit Game" { "activate" }
widget "Help Menu Game Rules" { "activate" }
widget "Help Menu Manual" { "activate" }
widget "Help Menu Spellbook" { "activate" }
widget "Help Menu About" { "activate" }

chat = glade.xml_get_widget(xml, "Text Display")
buf = gtk.text_view_get_buffer(chat)

while true do
	local evt = gtk.server_callback("wait")
	gtk.text_buffer_insert_at_cursor(buf, "\n"..evt, #evt+1)
	if evt:match("Main Window") or evt:match("Main Menu Exit Game") then
		break
	end
end
print "done"
--]]
