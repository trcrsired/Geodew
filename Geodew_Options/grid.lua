local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew")
local Geodew_Options = LibStub("AceAddon-3.0"):GetAddon("Geodew_Options")
local LSM = LibStub("LibSharedMedia-3.0")

local cvar_width,cvar_height = string.match(GetScreenResolutions(), "(%d+)x(%d+)")
cvar_width = tonumber(cvar_width)
cvar_height = tonumber(cvar_height)
local cvar_min = min(cvar_width,cvar_height)

local set_func = Geodew_Options.set_func
local get_func = Geodew_Options.get_func
local set_func_color = Geodew_Options.set_func_color
local get_func_color = Geodew_Options.get_func_color

local order = 0
local function get_order()
	local temp = order
	order = order + 1
	return temp
end

Geodew_Options.GenerateB("grid","Grid",
{
	Enable =
	{
		name = ENABLE,
		type = "toggle",
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	Lock =
	{
		name = LOCK,
		type = "toggle",
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	Left =
	{
		name = WARDROBE_PREV_VISUAL_KEY,
		type = "range",
		min = 0,
		max = cvar_width,
		step = 1,
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	Bottom =
	{
		name = "BOTTOM",
		type = "range",
		min = 0,
		max = cvar_height,
		step = 1,
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	Size = 
	{
		name = "Size",
		type = "range",
		min = 0,
		max = cvar_min,
		step = 1,
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	CenterTextFont = 
	{
		type = 'select',
		dialogControl = 'LSM30_Font',
		name = "CENTER",
		values = LSM:HashTable("font"),
		set = set_func,
		get = get_func,
	},
	CenterTextSize =
	{
		name = "Center Text Size",
		type = "range",
		min = 0,
		max = 500,
		step = 1,
		set = set_func,
		get = get_func,
	},
	BottomTextFont = 
	{
		type = 'select',
		dialogControl = 'LSM30_Font',
		name = "Bottom Text Font",
		values = LSM:HashTable("font"),
		set = set_func,
		get = get_func,
	},
	BottomTextSize =
	{
		name = "Bottom Text Size",
		type = "range",
		min = 0,
		max = 500,
		step = 1,
		set = set_func,
		get = get_func,
	},
	LowColor =
	{
		type = "color",
		order = get_order(),
		name = LOW,
		hasAlpha = true,
		set = set_func_color,
		get = get_func_color,
	},
	MidColor =
	{
		type = "color",
		order = get_order(),
		name = PLAYER_DIFFICULTY1,
		hasAlpha = true,
		set = set_func_color,
		get = get_func_color,
	},
	HighColor =
	{
		type = "color",
		order = get_order(),
		name = HIGH,
		hasAlpha = true,
		set = set_func_color,
		get = get_func_color,
	},
	BottomTextColor =
	{
		type = "color",
		order = get_order(),
		name = "Bottom Text",
		hasAlpha = true,
		set = set_func_color,
		get = get_func_color,
	}
})