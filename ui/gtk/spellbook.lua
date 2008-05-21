local gtk,glade,aux = ui.ctx.gtk, ui.ctx.glade, ui.ctx.aux
local sb_setup_detailed,sb_setup_byfirst,sb_setup_bylast,sb_setup_byname

function ui.load_spellbook(sb)
	sb_setup_detailed(sb)
	sb_setup_byfirst(sb)
	sb_setup_bylast(sb)
	sb_setup_byname(sb)
end

-- set up the sorted-by-category detailed spellbook
function sb_setup_detailed(sb)
	-- sort by name in category
	table.sort(sb, function(lhs, rhs)
		if lhs.category < rhs.category then return true end
		if lhs.category == rhs.category and lhs.name < rhs.name then return true end
		return false
	end)
	
	local cat,cat_box
	for _,spell in ipairs(sb) do
		if spell.category ~= cat then
			cat = spell.category
			cat_box = aux.glade_load_autoconnect("ui/gtk/help.glade", "Category")
			gtk.label_set_text(cat_box.CategoryName.handle, cat)
			gtk.box_pack_start(ui.help.CategoryList.handle, cat_box.Category.handle, false, true, 0)
		end
		
		local spell_box = aux.glade_load_autoconnect("ui/gtk/help.glade", "Spell")
		local gestures = gtk.label_new("   [ "..spell.gestures.." ]")
		
		gtk.label_set_text(spell_box.SpellName.handle, spell.name)
		gtk.box_pack_end(spell_box.SpellGestures.handle, gestures, true, true, 0)
		gtk.text_buffer_insert_at_cursor(
			gtk.text_view_get_buffer(spell_box.SpellDescription.handle),
			spell.description, #spell.description)
		gtk.box_pack_start(cat_box.SpellList.handle, spell_box.Spell.handle, false, true, 0)
	end
end

function sb_setup_byfirst(sb)
	print "SB by first gesture"
end

function sb_setup_bylast(sb)
	print "SB by last gesture"
end

function sb_setup_byname(sb)
	print "SB by name"
end
