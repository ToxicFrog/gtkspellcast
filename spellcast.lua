-- top level design:
--  load supporting libraries and set up environment and configuration
--  load configured UI
--  enter main loop
--      select() on open sockets for 100ms
--      call all registered update functions

package.path = "./?.lua;lib/?.lua"

--package.path = package.path.."/home/ben/devel/lualibs/?.lua;/home/ben/devel/lualibs/?/init.lua"

require "socket"
require "util"

require "config"
require "events"
require "ui.gtk"

require "client.core"
require "server.core"

ui.load_spellbook(require "spellbooks.classic")

pcall(function() return require "autoexec" end)

event.mainloop()

os.exit(0)


function ui.add_player() end
function ui.update_player() end

ui.add_player {
	name = "Me";
	is_me = true;
	status = "";
	hp = 15;
	maxhp = 15;
	gestures = {
		L = { "n", "n", "n", "n", "n", "n", "n", "n" };
		R = { "n", "n", "n", "n", "n", "n", "n", "n" };
	};
	monsters = {};
}

for i=1,3 do
	ui.add_player {
		name = "Player "..i;
		status = "";
		hp = 15;
		maxhp = 15;
		gestures = {
			L = { "u", "n", "n", "n", "n", "n", "n", "n" };
			R = { "u", "n", "n", "n", "n", "n", "n", "n" };
		};
		monsters = {};
	}
end

ui.update_player {
	name = "Player 2";
	status = "Poison(3)";
	hp = 10;
	maxhp = 15;
	gestures = {
		L = { "u", "n", "n", "n", "n", "n", "n", "n" };
		R = { "u", "n", "n", "n", "n", "n", "n", "n" };
	};
	monsters = {};
}

ui.mainloop()
