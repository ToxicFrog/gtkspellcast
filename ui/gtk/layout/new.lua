-- code for the new-style player list
-- we need to load the list from the glade file and map it into the top level window
-- we also need to expose an API which permits the core to update player information

-- this needs to export functions for modifying the player info, but that can wait
-- until later

local gtk,glade,aux = ui.ctx.gtk, ui.ctx.glade, ui.ctx.aux

local playerlist = aux.glade_load_autoconnect("ui/gtk/layout/new.glade", "Players")
local players = {}

gtk.box_pack_end(ui.widgets.InsertPlayerListHere.handle, playerlist.Players.handle, false, true, 0)

-- add a new player to the player list
-- this is responsible for setting up whatever internal structures the UI needs
-- and displaying the given player
function ui.add_player(player)
	local w = aux.glade_load_autoconnect("ui/gtk/layout/new.glade", "Player")
	
	local p = {
		name = w.Name.handle;
		status = w.Status.handle;
		health = w.Health.handle;
		gestures = { L = {}, R = {} };
		monsters = w.Player.handle;
		handle = w.Player.handle;
	}
	for hand,list in pairs(p.gestures) do
		for t=1,8 do
			p.gestures[hand][t] = w["Gesture"..hand..t].handle
		end
	end

	players[player.name] = p

	if player.is_me then
		gtk.box_pack_end(playerlist.Players.handle, p.handle, false, true, 0)
	else
		gtk.box_pack_start(playerlist.PlayerList.handle, p.handle, false, true, 0)
	end
	
	ui.update_player(player)
end

-- update a player
-- passed a player information structure, updates the on screen information on them
function ui.update_player(player)
	local p = players[player.name]
	
	gtk.label_set_markup(p.name, '<b>'..player.name..'</b>')
	gtk.label_set_markup(p.status, player.status)
	gtk.label_set_markup(p.health, '['..player.hp..'/'..player.maxhp..']')
	
	for hand,list in pairs(player.gestures) do
		for t,gesture in pairs(list) do
			print(hand, t)
			gtk.image_set_from_file(p.gestures[hand][t], "ui/gtk/images/b"..gesture..".xbm")
		end
	end

	for name,monster in pairs(player.monsters) do
		-- FIXME
	end
end

function ui.remove_player(player)
	local p = players[player.name]
	gtk.widget_destroy(p.handle)
	players[player.name] = nil
end
