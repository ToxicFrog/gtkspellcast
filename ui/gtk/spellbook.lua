local gtk = require "lgui"

local sb_list
local sb_setup_detailed,sb_setup_byfirst,sb_setup_bylast,sb_setup_byname

function hider(widget)
    return function() return widget:hideAll() end
end

function ui.load_spellbook(sb)
	sb_list = gtk.loadGlade("ui/gtk/help.glade", "Spell List Window")
	ui.spell_list = sb_list.SpellListWindow
	sb_setup_detailed(sb)
	sb_setup_byfirst(sb)
	sb_setup_bylast(sb)
	sb_setup_byname(sb)

    ui.spell_list:connect("response", hider(ui.spell_list))
    ui.spell_list:connect("delete-event", hider(ui.spell_list))
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
			cat_box = gtk.loadGlade("ui/gtk/help.glade", "Category")
            cat_box.CategoryName:set("label", cat)
            ui.help.Spellbook.CategoryList:packStart(false, true, 0, cat_box.Category)
		end
		
		local spell_box = gtk.loadGlade("ui/gtk/help.glade", "Spell")
		local gestures = gtk.Label.new("   [ "..spell.gestures.." ]")
		
        spell_box.SpellName:set("label", spell.name)
        spell_box.SpellGestures:packEnd(true, true, 0, gestures)
        spell_box.SpellDescription:get "buffer":set("text", spell.description)
        cat_box.SpellList:packStart(false, true, 0, spell_box.Spell)
	end
end

function sb_build_table(sb, t)
    local height = math.ceil(#sb/2)

    t:resize(height, 2)

	for i=1,#sb do
		local spell = sb[i]
		local spellgui = gtk.loadGlade("ui/gtk/help.glade", "Spell List Entry")
		
		spellgui.Gestures:packStart(false, false, 0, gtk.Label.new(spell.gestures))
        spellgui.Name:set("label", spell.name)
		
        local row = (i-1) % height
        local col = math.floor((i-1)/height)
		t:attach(spellgui.SpellListEntry, col, col+1, row, row+1, 5, 5, 0, 0)
	end
    
end

function sb_setup_byfirst(sb)
	table.sort(sb, function(lhs, rhs) return lhs.gestures < rhs.gestures end)
    sb_build_table(sb, sb_list.ByFirst)
end

function sb_setup_bylast(sb)
	print "SB by last gesture"
	table.sort(sb, function(lhs, rhs) return lhs.gestures:reverse() < rhs.gestures:reverse() end)
    sb_build_table(sb, sb_list.ByLast)
end

function sb_setup_byname(sb)
	print "SB by name"
	table.sort(sb, function(lhs, rhs) return lhs.name < rhs.name end)
    sb_build_table(sb, sb_list.ByName)
end

