local Geodew = LibStub("AceAddon-3.0"):NewAddon("Geodew","AceEvent-3.0","AceConsole-3.0")

function Geodew:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GeodewDB",{},true)
	self:RegisterChatCommand("Geodew", "ChatCommand")
	local _,_,classId = UnitClass("player")
	for i = 1, GetNumAddOns() do
		if GetAddOnMetadata(i,"X-GEODEW-CLASS") == classId then
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
	local function resume(...)
		coresume(current,...)
	end

	local ticker
	Geodew:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED",resume,0)
	Geodew:RegisterEvent("PLAYER_TALENT_UPDATE",resume,0)
	Geodew:RegisterEvent("ACTIONBAR_UPDATE_STATE",resume,2)
	Geodew:RegisterEvent("ACTIONBAR_UPDATE_USABLE",resume,2)
	Geodew:RegisterEvent("SPELL_UPDATE_CHARGES",resume,2)
	Geodew:RegisterEvent("PLAYER_TARGET_CHANGED",resume,2)
	Geodew:RegisterMessage("Geodew_OnProfileChanged",resume,0)

	for i=1,#coroutines do
		coresume(coroutines[i],0)
	end
	local yd,arg1,arg2 = 0
	local refresh = 0
	while true do
		repeat
		if yd == 3 then
			refresh = refresh + 1
			if refresh < 20 then
				break
			end
--			yd = 1
		end
		if yd == 0 then
			if GetSpecialization() == 2 then
				is_mistweaver = true
				if ticker == nil then
					ticker = C_Timer.NewTicker(0.05,function()
						coroutine.resume(current,1)
					end)
				end
--				Geodew:RegisterEvent("UNIT_HEALTH",resume,3)
			else
				is_mistweaver = nil
				if ticker then
					ticker:Cancel()
					ticker = nil
				end
--				Geodew:UnregisterEvent("UNIT_HEALTH")
				yd = -1
			end
			if InCombatLockdown() then
				break
			end
		end
		if not is_mistweaver and yd ~= -1 then
			break
		end
		for i=1,#coroutines do
			local status=coresume(coroutines[i],yd,arg1,arg2)
			if not status then
				Geodew:Print(i,status,v,t)
				table.remove(coroutines,i)
				break
			end
		end
		until true
		yd,arg1,arg2 = coroutine.yield()
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
