local Geodew = LibStub("AceAddon-3.0"):NewAddon("Geodew","AceEvent-3.0","AceConsole-3.0")

function Geodew:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GeodewDB",{},true)
	self:RegisterChatCommand("Geodew", "ChatCommand")
	local _,_,classId = UnitClass("player")
	local classidstr = tostring(classId)
	for i = 1, GetNumAddOns() do
		if GetAddOnMetadata(i,"X-GEODEW-CLASS") == classidstr then
			LoadAddOn(i)
		end
		local event = GetAddOnMetadata(i, "X-GEODEW-EVENT")
		if event then
			self:RegisterEvent(event,"loadevent",i)
		end
		local messages = GetAddOnMetadata(i,"X-GEODEW-MESSAGE")
		if messages then
			for message in gmatch(messages, "([^,]+)") do
				self:RegisterMessage(message,"loadevent",i)
			end
		end
	end
end

function Geodew:ChatCommand(input)
	self:SendMessage("Geodew_ChatCommand",input)
end

function Geodew:loadevent(p,event,...)
	Geodew:UnregisterEvent(event)
	Geodew:UnregisterMessage(event)
	if IsAddOnLoaded(p) then
		self:SendMessage(event,...)
		return true
	end
	LoadAddOn(p)
	if IsAddOnLoaded(p) then
		local addon = GetAddOnInfo(p)
		local a = LibStub("AceAddon-3.0"):GetAddon(addon)
		a[event](a,event,...)
		return true
	end
end

local coroutines = {}
Geodew.coroutines = coroutines

function Geodew.AddCoroutine(co)
	coroutines[#coroutines+1]=co
end

function Geodew.GetProfile(name)
	local profile = Geodew.db.profile
	local t = profile[name]
	if t == nil then
		t = {}
		profile[name] = t
	end
	return t
end

local function cofunc()
	local current = coroutine.running()
	local coresume = coroutine.resume
	local coyield = coroutine.yield
	local function resume(...)
		coresume(current,...)
	end
	local ticker
	Geodew:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED",resume,0)
	Geodew:RegisterEvent("PLAYER_TALENT_UPDATE",resume,0)
	Geodew:RegisterMessage("Geodew_OnProfileChanged",resume,0)
	local runnings = {}
	local yd = 0
	local fullyrunning
	while true do
		if yd == 0 then
			fullyrunning = nil
			for i=1,#coroutines do
				local status,yval = coresume(coroutines[i],0)
				if status then
					if yval then
						fullyrunning = true
						runnings[i] = true
					else
						runnings[i] = false
					end
				else
					Geodew:Print(status,yval)
				end
			end
			if fullyrunning then
				Geodew:RegisterEvent("ACTIONBAR_UPDATE_STATE",resume,2)
				Geodew:RegisterEvent("ACTIONBAR_UPDATE_USABLE",resume,2)
				Geodew:RegisterEvent("SPELL_UPDATE_CHARGES",resume,2)
				Geodew:RegisterEvent("PLAYER_TARGET_CHANGED",resume,2)
				if ticker == nil then
					ticker = C_Timer.NewTicker(0.05,function()
						coroutine.resume(current,1)
					end)
				end
			else
				Geodew:UnregisterEvent("ACTIONBAR_UPDATE_STATE")
				Geodew:UnregisterEvent("ACTIONBAR_UPDATE_USABLE")
				Geodew:UnregisterEvent("SPELL_UPDATE_CHARGES")
				Geodew:UnregisterEvent("PLAYER_TARGET_CHANGED")
				if ticker then
					ticker:Cancel()
					ticker = nil
				end
			end
		end
		for i=1,#coroutines do
			if runnings[i] then
				coresume(coroutines[i],2)
			end
		end
		yd = coyield()
	end
end

function Geodew:OnEnable()
	coroutine.wrap(cofunc)()
end

function Geodew.unit_range(uId)
	if IsItemInRange(90175, uId) then return 4
	elseif IsItemInRange(37727, uId) then return 6
	elseif IsItemInRange(8149, uId) then return 8
	elseif CheckInteractDistance(uId, 3) then return 10
	elseif CheckInteractDistance(uId, 2) then return 11
	elseif IsItemInRange(32321, uId) then return 13
	elseif IsItemInRange(6450, uId) then return 18
	elseif IsItemInRange(21519, uId) then return 23
	elseif CheckInteractDistance(uId, 1) then return 30
	elseif IsItemInRange(1180, uId) then return 33
	elseif UnitInRange(uId) then return 43
	elseif IsItemInRange(32698, uId) then return 48
	elseif IsItemInRange(116139, uId) then return 53
	elseif IsItemInRange(32825, uId) then return 60
	elseif IsItemInRange(35278, uId) then return 80
	end
end
