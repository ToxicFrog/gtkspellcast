--[[
	This file is part of lgui.

	lgui is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	lgui is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with lgui.  If not, see <http://www.gnu.org/licenses/>.

    Copyright (C) 2008 Lucas Hermann Negri
--]]

require("lobj")

-- [[ Aux functions ]]

---
-- Special cases
local __lguiSpecial =
{
	["GdkCursor"] 				= "Cursor",
	["GdkScreenX11"] 			= "Screen",
	["GdkScreenWin32"] 			= "Screen",
	["GladeXML"] 				= "Glade",
	["PangoLayout"] 			= "PangoLayout",
	["PangoFontDescription"] 	= "PangoFontDescription",
}

---
-- Gets the class table from a type name
--
-- @param typeName Type name
-- @return Class table for the type name
function __lguiGetClassTable(typeName)
	local name = __lguiSpecial[typeName]

	if not name then
		local pos = typeName:find("%u", 2)
		name = typeName:sub(pos)

		-- Threat all unbinded objects like a GObject (evil)
		if not lgui[name] then
			lgui[name] = {}
			setmetatable(lgui[name], {__index = lobj["Object"]})
		end
	end

	return lgui[name]
end

---
-- Registers the base object
function __lguiRegisterBaseObject()
	lgui.Object = lobj.Object
end

---
-- Do the bad job
--
-- @param name Class name (like "Widget")
-- @param base Base class name (like "Object")
-- @param class Table that will have the "__index" pointed to "lgui.base" and
-- will be called "name"
function __lguiBuildInheritance(name, base, class)
	if base then
		setmetatable(class, {__index = lgui[base]})
	end

	lgui[name] = class
end

---
-- Now we can load the C library...
require("_lgui")

--[[ Common Enums ]]--

-- GtkWindowPosition
lgui.WIN_POS_NONE 				= 0
lgui.WIN_POS_CENTER 			= 1
lgui.WIN_POS_MOUSE				= 2
lgui.WIN_POS_CENTER_ALWAYS		= 3
lgui.WIN_POS_CENTER_ON_PARENT	= 4

-- GtkWindowType
lgui.WINDOW_TOPLEVEL			= 0
lgui.WINDOW_POPUP	 			= 1

-- ProgressBar orientation
lgui.PROGRESS_LEFT_TO_RIGHT		= 0
lgui.PROGRESS_RIGHT_TO_LEFT		= 1
lgui.PROGRESS_BOTTOM_TO_TOP		= 2
lgui.PROGRESS_TOP_TO_BOTTOM		= 3

-- ProgressBar style
lgui.PROGRESS_CONTINUOUS		= 0
lgui.PROGRESS_DISCRETE			= 1

-- GtkFileChooserAction
lgui.FILE_CHOOSER_ACTION_OPEN			= 0
lgui.FILE_CHOOSER_ACTION_SAVE			= 1
lgui.FILE_CHOOSER_ACTION_SELECT_FOLDER	= 2
lgui.FILE_CHOOSER_ACTION_CREATE_FOLDER	= 3

-- GtkResponse
lgui.RESPONSE_NONE 				= -1
lgui.RESPONSE_REJECT 			= -2
lgui.RESPONSE_ACCEPT 			= -3
lgui.RESPONSE_DELETE_EVENT 		= -4
lgui.RESPONSE_OK     			= -5
lgui.RESPONSE_CANCEL 			= -6
lgui.RESPONSE_CLOSE  			= -7
lgui.RESPONSE_YES    			= -8
lgui.RESPONSE_NO     			= -9
lgui.RESPONSE_APPLY  			= -10
lgui.RESPONSE_HELP   			= -11

-- GtkSortType
lgui.SORT_ASCENDING				= 0
lgui.SORT_DESCENDING			= 1

-- Pango
lgui.PANGO_SCALE				= 1024

--PangoAlignment
lgui.PANGO_ALIGN_LEFT 			= 0
lgui.PANGO_ALIGN_CENTER			= 1
lgui.PANGO_ALIGN_RIGHT			= 2

-- PangoEllipsize
lgui.PANGO_ELLIPSIZE_NONE		= 0
lgui.PANGO_ELLIPSIZE_START		= 1
lgui.PANGO_ELLIPSIZE_MIDDLE		= 2
lgui.PANGO_ELLIPSIZE_END		= 3

-- PangoWeight
lgui.PANGO_WEIGHT_ULTRALIGHT 	= 200
lgui.PANGO_WEIGHT_LIGHT 		= 300
lgui.PANGO_WEIGHT_NORMAL 		= 400
lgui.PANGO_WEIGHT_SEMIBOLD 		= 600
lgui.PANGO_WEIGHT_BOLD 			= 700
lgui.PANGO_WEIGHT_ULTRABOLD 	= 800
lgui.PANGO_WEIGHT_HEAVY 		= 900

-- GtkDestDefaults
lgui.DEST_DEFAULT_MOTION     	= 1
lgui.DEST_DEFAULT_HIGHLIGHT 	= 2
lgui.DEST_DEFAULT_DROP      	= 4
lgui.DEST_DEFAULT_ALL       	= 0x07

-- GdkDragAction
lgui.ACTION_DEFAULT 			= 1
lgui.ACTION_COPY    			= 2
lgui.ACTION_MOVE    			= 4
lgui.ACTION_LINK   			 	= 8
lgui.ACTION_PRIVATE 			= 16
lgui.ACTION_ASK     			= 32

-- GdkModifierType
lgui.SHIFT_MASK    				= 1
lgui.LOCK_MASK	    			= 2
lgui.CONTROL_MASK  				= 4
lgui.MOD1_MASK	    			= 8
lgui.MOD2_MASK	    			= 16
lgui.MOD3_MASK	   				= 32
lgui.MOD4_MASK	    			= 64
lgui.MOD5_MASK	    			= 128
lgui.BUTTON1_MASK  				= 256
lgui.BUTTON2_MASK  				= 512
lgui.BUTTON3_MASK  				= 1024
lgui.BUTTON4_MASK 				= 2048
lgui.BUTTON5_MASK  				= 4096
lgui.SUPER_MASK    				= 67108864
lgui.HYPER_MASK    				= 134217728
lgui.META_MASK     				= 268435456
lgui.RELEASE_MASK  				= 1073741824
lgui.MODIFIER_MASK 				= 0x5c001fff

-- GdkEventMask
lgui.EXPOSURE_MASK				= 2
lgui.POINTER_MOTION_MASK		= 4
lgui.POINTER_MOTION_HINT_MASK	= 8
lgui.BUTTON_MOTION_MASK			= 16
lgui.BUTTON1_MOTION_MASK		= 32
lgui.BUTTON2_MOTION_MASK		= 64
lgui.BUTTON3_MOTION_MASK		= 128
lgui.BUTTON_PRESS_MASK			= 256
lgui.BUTTON_RELEASE_MASK		= 512
lgui.KEY_PRESS_MASK				= 1024
lgui.KEY_RELEASE_MASK			= 2048
lgui.ENTER_NOTIFY_MASK			= 4096
lgui.LEAVE_NOTIFY_MASK			= 8192
lgui.FOCUS_CHANGE_MASK			= 16384
lgui.STRUCTURE_MASK				= 32768
lgui.PROPERTY_CHANGE_MASK		= 65536
lgui.VISIBILITY_NOTIFY_MASK		= 131072
lgui.PROXIMITY_IN_MASK			= 262144
lgui.PROXIMITY_OUT_MASK			= 524288
lgui.SUBSTRUCTURE_MASK			= 1048576
lgui.SCROLL_MASK             	= 2097152
lgui.ALL_EVENTS_MASK			= 0x3FFFFE

-- GtkSelectionMode
lgui.SELECTION_NONE				= 0
lgui.SELECTION_SINGLE			= 1
lgui.SELECTION_BROWSE			= 2
lgui.SELECTION_MULTIPLE			= 3

-- GtkPolicyType
lgui.POLICY_ALWAYS				= 0
lgui.POLICY_AUTOMATIC			= 1
lgui.POLICY_NEVER				= 2

-- PangoSomething
lgui.PANGO_WRAP_WORD			= 0
lgui.PANGO_WRAP_CHAR			= 1
lgui.PANGO_WRAP_WORD_CHAR		= 2

-- GtkCalendarDisplayOptions
lgui.CALENDAR_SHOW_HEADING		= 1
lgui.CALENDAR_SHOW_DAY_NAMES	= 2
lgui.CALENDAR_NO_MONTH_CHANGE	= 4
lgui.CALENDAR_SHOW_WEEK_NUMBERS	= 8
lgui.CALENDAR_WEEK_START_MONDAY	= 16

-- GtkPrintOperationAction
lgui.PRINT_OPERATION_ACTION_PRINT_DIALOG 	= 0
lgui.PRINT_OPERATION_ACTION_PRINT 			= 1
lgui.PRINT_OPERATION_ACTION_PREVIEW 		= 2
lgui.PRINT_OPERATION_ACTION_EXPORT 			= 3

-- GtkPrintOperationResult
lgui.PRINT_OPERATION_RESULT_ERROR			= 0
lgui.PRINT_OPERATION_RESULT_APPLY			= 1
lgui.PRINT_OPERATION_RESULT_CANCEL			= 2
lgui.PRINT_OPERATION_RESULT_IN_PROGRESS		= 3

-- GtkAssistant
lgui.ASSISTANT_PAGE_CONTENT		= 0
lgui.ASSISTANT_PAGE_INTRO		= 1
lgui.ASSISTANT_PAGE_CONFIRM		= 2
lgui.ASSISTANT_PAGE_SUMMARY		= 3
lgui.ASSISTANT_PAGE_PROGRESS	= 4

-- GtkState
lgui.STATE_NORMAL		= 0
lgui.STATE_ACTIVE		= 1
lgui.STATE_PRELIGHT		= 2
lgui.STATE_SELECTED		= 3
lgui.STATE_INSENSITIVE	= 4

-- GtkJustification
lgui.JUSTIFY_LEFT		= 0
lgui.JUSTIFY_RIGHT		= 1
lgui.JUSTIFY_CENTER		= 2
lgui.JUSTIFY_FILL		= 3

-- GtkTreeViewGridlines
lgui.TREE_VIEW_GRID_LINES_NONE			= 0
lgui.TREE_VIEW_GRID_LINES_HORIZONTAL	= 1
lgui.TREE_VIEW_GRID_LINES_VERTICAL		= 2
lgui.TREE_VIEW_GRID_LINES_BOTH			= 3

-- GtkShadowType
lgui.SHADOW_NONE		= 0
lgui.SHADOW_IN			= 1
lgui.SHADOW_OUT			= 2
lgui.SHADOW_ETCHED_IN	= 3
lgui.SHADOW_ETCHED_OUT	= 4

-- GtkWrapMode
lgui.WRAP_NONE			= 0
lgui.WRAP_CHAR			= 1
lgui.WRAP_WORD			= 2
lgui.WRAP_WORD_CHAR		= 3

-- GtkSizeGroupMode
lgui.SIZE_GROUP_NONE		= 0
lgui.SIZE_GROUP_HORIZONTAL	= 1
lgui.SIZE_GROUP_VERTICAL	= 2
lgui.SIZE_GROUP_BOTH		= 3

-- GtkButtonBoxStyle
lgui.BUTTONBOX_DEFAULT_STYLE 	= 0
lgui.BUTTONBOX_SPREAD			= 1
lgui.BUTTONBOX_EDGE				= 2
lgui.BUTTONBOX_START			= 3
lgui.BUTTONBOX_END				= 4
lgui.BUTTONBOX_CENTER			= 5

-- GtkAssistantPageType
lgui.ASSISTANT_PAGE_CONTENT		= 0
lgui.ASSISTANT_PAGE_INTRO		= 1
lgui.ASSISTANT_PAGE_CONFIRM		= 2
lgui.ASSISTANT_PAGE_SUMMARY		= 3
lgui.ASSISTANT_PAGE_PROGRESS	= 4

-- GtkIconSize
lgui.ICON_SIZE_INVALID			= 0
lgui.ICON_SIZE_MENU				= 1
lgui.ICON_SIZE_SMALL_TOOLBAR	= 2
lgui.ICON_SIZE_LARGE_TOOLBAR	= 3
lgui.ICON_SIZE_BUTTON			= 4
lgui.ICON_SIZE_DND				= 5
lgui.ICON_SIZE_DIALOG			= 6

-- GtkToolbarStyle
lgui.TOOLBAR_ICONS				= 0
lgui.TOOLBAR_TEXT				= 1
lgui.TOOLBAR_BOTH				= 2
lgui.TOOLBAR_BOTH_HORIZ			= 3

-- GtkTextSearchFlags
lgui.TEXT_SEARCH_VISIBLE_ONLY 	= 1
lgui.TEXT_SEARCH_TEXT_ONLY    	= 2


-- GtkUpdateType
lgui.UPDATE_CONTINUOUS			= 0
lgui.UPDATE_DISCONTINUOUS		= 1
lgui.UPDATE_DELAYED				= 2

-- Some GDK keys
lgui.GDK_BackSpace		= 0xff08
lgui.GDK_Escape 		= 0xff1b
lgui.GDK_Delete 		= 0xffff
lgui.GDK_Home 			= 0xff50
lgui.GDK_Left 			= 0xff51
lgui.GDK_Up 			= 0xff52
lgui.GDK_Right 			= 0xff53
lgui.GDK_Down 			= 0xff54
lgui.GDK_Shift_L 		= 0xffe1
lgui.GDK_Shift_R 		= 0xffe2
lgui.GDK_Control_L 		= 0xffe3
lgui.GDK_Control_R 		= 0xffe4
lgui.GDK_Meta_L 		= 0xffe7
lgui.GDK_Meta_R 		= 0xffe8
lgui.GDK_Alt_L 			= 0xffe9
lgui.GDK_Alt_R	 		= 0xffea
lgui.GDK_Super_L 		= 0xffeb
lgui.GDK_Super_R 		= 0xffec
lgui.GDK_space 			= 0x020
lgui.GDK_Return 		= 0xff0d

-- GtkArrowType
lgui.ARROW_UP			= 0
lgui.ARROW_DOWN			= 1
lgui.ARROW_LEFT			= 2
lgui.ARROW_RIGHT		= 3
lgui.ARROW_NONE			= 4

-- GtkTargetFlags
lgui.TARGET_SAME_APP 		= 1
lgui.TARGET_SAME_WIDGET 	= 2
lgui.TARGET_OTHER_APP		= 4
lgui.TARGET_OTHER_WIDGET 	= 8

-- GtkPositionType
lgui.POS_LEFT				= 0
lgui.POS_RIGHT				= 1
lgui.POS_TOP				= 2
lgui.POS_BOTTOM				= 3

-- GtkTreeSortable
lgui.TREE_SORTABLE_DEFAULT_SORT_COLUMN_ID 	= -1
lgui.TREE_SORTABLE_UNSORTED_SORT_COLUMN_ID 	= -2

-- GtkSortType
lgui.SORT_ASCENDING 		= 0
lgui.SORT_DESCENDING 		= 1

-- GdkWindowTypeHint
lgui.WINDOW_TYPE_HINT_NORMAL		= 0
lgui.WINDOW_TYPE_HINT_DIALOG		= 1
lgui.WINDOW_TYPE_HINT_MENU			= 2
lgui.WINDOW_TYPE_HINT_TOOLBAR		= 3
lgui.WINDOW_TYPE_HINT_SPLASHSCREEN	= 4

-- GdkIterpType
lgui.GDK_INTERP_NEAREST		= 0
lgui.GDK_INTERP_TILES		= 1
lgui.GDK_INTERP_BILINEAR	= 2
lgui.GDK_INTERP_HYPER		= 3

-- GdkCursorType
lgui.GDK_X_CURSOR			= 0
lgui.GDK_ARROW				= 2
lgui.GDK_CROSS				= 30
lgui.GDK_FLEUR 				= 52
lgui.GDK_HAND1				= 58
lgui.GDK_HAND2				= 60
lgui.GDK_LEFT_PTR			= 64
lgui.GDK_PENCIL				= 86
lgui.GDK_QUESTION			= 92
lgui.GDK_RIGHT_PTR			= 94
lgui.GDK_WATCH 				= 150
lgui.GDK_XTERM				= 152
lgui.GDK_CURSOR_IS_PIXMAP 	= -1

-- GtkUnit
lgui.UNIT_PIXEL				= 0
lgui.UNIT_POINTS			= 1
lgui.UNIT_INCH				= 2
lgui.UNIT_MM				= 3

-- GtkAttachOptions
lgui.EXPAND 				= 1
lgui.SHRINK 				= 2
lgui.FILL   				= 4
