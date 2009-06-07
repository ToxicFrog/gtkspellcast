--[[
	This file is part of lobj.

	lobj is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	lobj is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with lobj.  If not, see <http://www.gnu.org/licenses/>.

    Copyright (C) 2008 Lucas Hermann Negri
--]]

require("_lobj")

-- ** Library helpers **

---
-- Registers a special object (ie, an Object thats not a GObject)
--
-- @param meta Metatable of the userdata
-- @param namespace Namespace of the class, as a string (like lobj). Can be nil
-- @param class Class, as a string
-- @param gc GC function
-- @param tostr tostring function
-- @param eq eq function
function __lobjRegisterSpecial(meta, namespace, class, gc, tostr, eq)
	if namespace then
		meta.__index = _G[namespace][class]
	else
		meta.__index = class
	end

	meta.__gc = gc
	meta.__tostring = tostr or __lobjStructTostring
	meta.__eq = eq or __lobjEq
end

-- ** Lua functions **

---
-- Helps to inherit from a class.
--
-- @param class Class to inherit
function lobj.Object:inheritFrom(class)
	local mt = getmetatable(self)
	local oldIndex = mt.__index
	mt.__index = class
end

---
-- Does a type cast.
--
-- @param new New classs
-- @return The object itself
function lobj.Object:cast(new)
	getmetatable(self).__index = new
	return self
end

-- For easier access
__lobjObject = lobj.Object
__lobjMainLoop = lobj.MainLoop
__lobjTypeFromName = lobj.Type.fromName

-- ** Enums **

-- Timeout Priority
lobj.PRIORITY_HIGH					= -100
lobj.PRIORITY_DEFAULT				= 0
lobj.PRIORITY_HIGH_IDLE				= 100
lobj.PRIORITY_DEFAULT_IDLE			= 200
lobj.PRIORITY_LOW					= 300

-- GNormalizeMode
lobj.NORMALIZE_DEFAULT				= 0
lobj.NORMALIZE_NFD					= 0
lobj.NORMALIZE_DEFAULT_COMPOSE		= 1
lobj.NORMALIZE_NFC					= 1
lobj.NORMALIZE_ALL					= 2
lobj.NORMALIZE_NFKD					= 2
lobj.NORMALIZE_ALL_COMPOSE			= 3
lobj.NORMALIZE_NFKC					= 3
