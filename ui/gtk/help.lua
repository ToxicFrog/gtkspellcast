-- all stuff related to the help dialogs

local gtk,glade,aux = ui.ctx.gtk, ui.ctx.glade, ui.ctx.aux

ui.help = {}

local function help_close(self)
	gtk.widget_hide_all(self.handle)
end

-- load each of the different help panes
for _,dialog in ipairs { "About", "Rules", "Manual", "Spellbook" } do
	-- glade_load_autoconnect returns a table containing, among other things,
	-- id => widget and handle => widget kvpairs
	-- we store the former in ui.help, and the latter in ui.widgets, which is 
	-- the master index of widgets indexed by handle
	local t = aux.glade_load_autoconnect("ui/gtk/help.glade", dialog)
	for k,v in pairs(t) do
		if k ~= "xml" and k ~= "src" then
			ui.help[k] = v
			print(k,v)
			if type(k) == "number" then
				ui.widgets[k] = v
			end
		end
	end
	
	-- install the signal handlers for delete-event and response
	for _,signal in ipairs { "delete_event", "response" } do
		t[dialog][signal] = help_close
	end
	
	-- install the signal handler for the menu item
	ui.widgets["HelpMenu"..t[dialog].id].activate = function(self)
		gtk.widget_show_all(t[dialog].handle)
	end
end

-- install the spellbook
local spellbook = require "ui.gtk.spellbook"

for _,category in ipairs(spellbook) do
	print("CAT", category.name)
	
	local wcat = aux.glade_load_autoconnect("ui/gtk/help.glade", "Category")
	gtk.label_set_text(wcat.CategoryName.handle, category.name)
	gtk.box_pack_start(ui.help.CategoryList.handle, wcat.Category.handle, false, true, 0)
	
	for _,spell in ipairs(category) do
		print("SPELL", spell.name, spell.gest)
		local wspel = aux.glade_load_autoconnect("ui/gtk/help.glade", "Spell")
		gtk.label_set_text(wspel.SpellName.handle, spell.name)
		
		local gest = gtk.label_new("   [ "..spell.gest.." ]")
		gtk.box_pack_end(wspel.SpellGestures.handle, gest, true, true, 0)
		
		gtk.text_buffer_insert_at_cursor(
			gtk.text_view_get_buffer(wspel.SpellDescription.handle),
			spell.desc, #spell.desc)
		gtk.box_pack_start(wcat.SpellList.handle, wspel.Spell.handle, false, true, 0)
	end
end

