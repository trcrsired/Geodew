local AceAddon = LibStub("AceAddon-3.0")
local Geodew = AceAddon:GetAddon("Geodew")
local Geodew_Options = AceAddon:NewAddon("Geodew_Options","AceEvent-3.0")
Geodew_Options.options = {
	type = "group",
	name = "Geodew",
	args = {profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(Geodew.db)}
}
function Geodew_Options:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Geodew", Geodew_Options.options)
	Geodew.db.RegisterCallback(Geodew_Options, "OnProfileChanged")
	Geodew.db.RegisterCallback(Geodew_Options, "OnProfileCopied", "OnProfileChanged")
	Geodew.db.RegisterCallback(Geodew_Options, "OnProfileReset", "OnProfileChanged")
end

function Geodew_Options:Geodew_ChatCommand(message,input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("Geodew")
	else
		LibStub("AceConfigCmd-3.0"):HandleCommand("Geodew", "Geodew",input)
	end
end

function Geodew_Options:OnProfileChanged()
	Geodew_Options:SendMessage("Geodew_OnProfileChanged")
end

function Geodew_Options.set_func(info,val)
	local id = tonumber(info[2])
	local p = Geodew.db.profile[id][info[1]]
	local meta = getmetatable(p)
	local name = info[3]
	if meta[name] == val then
		val = nil
	end
	rawset(p,name,val)
	coroutine.resume(Geodew[info[1]][id],0)
end

function Geodew_Options.get_func(info)
	return Geodew.db.profile[tonumber(info[2])][info[1]][info[3]]
end

function Geodew_Options.set_func_color(info,r,g,b,a)
	local id = tonumber(info[2])
	local p = Geodew.db.profile[id][info[1]]
	local n = info[3]
	local meta = getmetatable(p)
	local function mrawset(c,val)
		local nm = n..c
		if meta[nm] == val then
			val = nil
		end
		rawset(p,nm,val)
	end
	mrawset("R",r)
	mrawset("G",g)
	mrawset("B",b)
	mrawset("A",a)
	coroutine.resume(Geodew[info[1]][id],0)
end

function Geodew_Options.get_func_color(info)
	local id = tonumber(info[2])
	local p = Geodew.db.profile[id][info[1]]
	local n = info[3]
	return p[n.."R"],p[n.."G"],p[n.."B"],p[n.."A"]
end

function Geodew_Options.GenerateB(key,name,b)
	local gm = {}
	for k,v in pairs(Geodew[key]) do
		gm[tostring(k)] = 
		{
			name = GetSpellInfo(k),
			type = "group",
			args = b
		}
	end
	Geodew_Options.options.args[key] = 
	{
		type = "group",
		name = name,
		args = gm
	}
end