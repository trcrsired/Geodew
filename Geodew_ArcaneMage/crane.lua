local Myta = LibStub("AceAddon-3.0"):GetAddon("Myta")

local IsItemInRange = IsItemInRange
local CheckInteractDistance = CheckInteractDistance
local UnitInRange = UnitInRange

local function unit_range(uId)
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

local function cofunc(yd)
	local spellid = 107428
	local gframe,gbackground,center_text,bottom_text,cd,secure_frame = Myta.CreateGrid(spellid,coroutine.running())
	local rsk_texture = select(3,GetSpellInfo(107428))
	local tp_texture = select(3,GetSpellInfo(100780))
	local bok_texture = select(3,GetSpellInfo(100784))

	local tft_texture = select(3,GetSpellInfo(116680))
	local grid_profile
	local GetSpellCooldown = GetSpellCooldown
	local GetTime = GetTime
	local GetHaste = GetHaste
	local UnitAffectingCombat = UnitAffectingCombat
	local UnitIsVisible = UnitIsVisible
	local rising_mist
	while true do
		repeat
		if 1 == yd or yd == 2 then
			local player_self = UnitIsUnit("player","target")
			if UnitAffectingCombat("player") or (not player_self and UnitIsVisible("target")) then
				local atotm,atotm_duration
				for i=1,40 do
					local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
					nameplateShowPersonal, spellId = UnitAura("PLAYER",i,"PLAYER|HELPFUL")
					if name == nil then
						break
					end
					if spellId == 347553 then	--atotm
						atotm = expirationTime
						atotm_duration = duration
					end
				end
				local gcd_start, gcd_duration, gcd_enabled = GetSpellCooldown(61304)
				
				local gtime = GetTime()
				local gcd_done = gcd_duration == 0 and gtime + 1.5/(1+GetHaste()/100) or gcd_duration
				local start, duration, enabled  = GetSpellCooldown(107428)
				if (gcd_duration == 0 and start + duration < gcd_done) or (gcd_duration ~= 0 and (duration == gcd_duration or (duration ~= 0 and start + duration < gcd_start + gcd_duration))) then
					local use_tft
					if rising_mist then
						local tft_start, tft_duration, tft_enabled = GetSpellCooldown(116680)
						if tft_start == 0 and tft_duration == 0 then
							use_tft = true
						end
					end
					if use_tft then
						gbackground:SetTexture(tft_texture)
					else
						gbackground:SetTexture(rsk_texture)
					end
				else
					local bok_start, bok_duration, bok_enabled = GetSpellCooldown(100784)
					local fd_bok = false
					if (gcd_duration == 0 and bok_start + bok_duration < gcd_done) or
						(gcd_duration ~= 0 and (bok_duration == gcd_duration or (bok_duration ~= 0 and bok_start + bok_duration < gcd_start + gcd_duration))) then
						if gtime <= start + duration then
							fd_bok = true
						elseif not atotm then
							for i=1,40 do
								local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
								nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, subsequent1 = UnitAura("player",i,"PLAYER|HELPFUL")
								if name == nil then
									break
								end
								if spellId == 202090 then
									if 2 < subsequent1 then
										fd_bok = true
									end
									break
								end
							end
						end
					end
					if fd_bok then
						gbackground:SetTexture(bok_texture)
					else
						gbackground:SetTexture(tp_texture)
					end
				end
				if player_self then
					center_text:Hide()
				else
					local rg = unit_range("target")
					if rg then
						Myta.GridCenter(grid_profile,rg,8,40,center_text)
						center_text:Show()
					else
						center_text:Hide()
					end
				end
				gframe:Show()
				if atotm then
					cd:SetCooldown(atotm-atotm_duration,atotm_duration)
					local v = atotm-gtime
					if v < 0 then
						bottom_text:Hide()
					else
						bottom_text:SetFormattedText("%.1f",v)
						bottom_text:Show()
					end
				else
					cd:Hide()
					bottom_text:Hide()
				end
			else
				bottom_text:Hide()
				gframe:Hide()
				cd:Hide()
			end
		elseif yd == 0 then
			grid_profile = Myta.GridConfig(Myta.GetProfile(spellid),gframe,gbackground,center_text,bottom_text,cd,secure_frame)
			rising_mist = select(5,GetTalentInfo(7,3,1))
		elseif yd == -1 then
			gframe:Hide()
		end
		yd=coroutine.yield()
		until true
	end
end

Myta.AddCoroutine(coroutine.create(cofunc))