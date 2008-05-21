-- load config file
require "config"

require "ui.gtk"

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

ui.load_spellbook(require "spellbooks.classic")

ui.mainloop()
