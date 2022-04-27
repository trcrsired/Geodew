local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew")

local unit_range = Geodew.unit_range

local function cofunc(yd)
	local specid = 62
	local n = 4
	local grids_meta = Geodew.CreateGrids(specid,n)
	local globalframe = grids_meta.globalframe
	local backgrounds = grids_meta.backgrounds
	local center_texts = grids_meta.center_texts
	local bottom_texts = grids_meta.bottom_texts
	local cooldowns = grids_meta.cooldowns
	local grid_profile
	local coyield = coroutine.yield
	local GetSpellTexture = GetSpellTexture
	local IsUsableSpell = IsUsableSpell
	local UnitPower = UnitPower
	local UnitPowerMax = UnitPowerMax
	local GetTime = GetTime
	local GetMasteryEffect = GetMasteryEffect
	local GetHaste = GetHaste
	local UnitIsPVP = UnitIsPVP
	local C_PvP_IsPVPMap = C_PvP.IsPVPMap
	local UnitCastingInfo = UnitCastingInfo
	local Geodew_GridCenter = Geodew.GridCenter
	local center_text1 = center_texts[1]
	while true do
		repeat
		if yd ==1 or yd == 2 then
			local gcd_start, gcd_duration, gcd_enabled, gcd_modRate = GetSpellCooldown(61304)
			local charges = UnitPower("player", 16)
			local max_charges = UnitPowerMax("player", 16)

			local mana = UnitPower("player", 0)
			local max_mana = UnitPowerMax("player", 0)
			local val = GetMasteryEffect()/100 + 1
			local mana_no_master = max_mana/val
			local percentage = mana / mana_no_master
			local chargemana =  max_charges * (max_charges + 1) * 0.01375
			local current_time = GetTime()
			local haste_effect = 1 + GetHaste()/100
			local real_gcd_val = 1.5 / haste_effect
			local arcane_harmony_stacks = 0
			local max_arcane_harmony_stacks = 18
			if C_PvP_IsPVPMap() then
				max_arcane_harmony_stacks = 10
			end
			for i=1,40 do
				local name, icon, count, debuffType, duration, expirationTime, source, isStealable, 
				nameplateShowPersonal, spellId = UnitAura("PLAYER",i,"PLAYER|HELPFUL")
				if name == nil then
					break
				end
				if spellId == 332777 then	--arcane harmony
					arcane_harmony_stacks = count
				end
			end
			local arcane_orb_casted = false
			local casting_first_spell = true
			local pom_casted = false
			local i = 1
			while i <= n do
				local current_spell = 44425
				repeat
					if percentage < chargemana then
						-- Evocation
						if IsUsableSpell(12051) then
							local evocation_start,evocation_duration,evocation_enabled,evocation_modRate = GetSpellCooldown(12051)
							if gcd_duration < evocation_duration or (evocation_duration <= gcd_duration and current_time + gcd_duration >= evocation_start + evocation_duration)  then
								current_spell = 12051
								current_time = current_time + 6/haste_effect
								percentage = val
							end
							break
						end
					end
					if charges == 0 then
						-- Touch of the Magi
						if IsUsableSpell(321507) then
							local start, duration, enabled, modRate = GetSpellCooldown(321507)
							if duration <= gcd_duration then
								current_spell = 321507
								charges = max_charges
								current_time = current_time + real_gcd_val
								break
							end
						end
						-- Arcane Orb
						if IsUsableSpell(153626) then
							if not arcane_orb_casted then
								local start, duration, enabled, modRate = GetSpellCooldown(153626)
								if duration <= gcd_duration then
									current_spell = 153626
									charges = charges + 1
									percentage = percentage - 0.1
									current_time = current_time + real_gcd_val
									arcane_orb_casted = true
									break
								end
							end
						end
						-- Presense of Mind
						if IsUsableSpell(205025) then
							if not pom_casted then
								local start, duration, enabled, modRate = GetSpellCooldown(205025)
								if duration == 0 then
									current_spell = 205025
									charges = charges + 1
									pom_casted = true
									break
								end
							end
						end
					end
					if charges < max_charges then
						current_spell = 30451
						charges = charges + 1
						break
					end
					-- arcane harmony
					if IsUsableSpell(332777) then
						if arcane_harmony_stacks >= max_arcane_harmony_stacks then
							current_spell = 44425	-- arcane barrage
							charges = 0
							arcane_harmony_stacks = 0
						else
							arcane_harmony_stacks = arcane_harmony_stacks + 5
							current_spell = 5143
						end
					else
						current_spell = 30451
						charges = charges + 1
					end
				until true
				local skip_this_round = false
				if casting_first_spell then
					local castname, casttext, casttexture, caststartTimeMS, castendTimeMS, castisTradeSkill, castcastID, castnotInterruptible, castspellId = UnitCastingInfo("player")
					if castname then
						if castendTimeMS < caststartTimeMS + 0.5 and castspellId == current_spell then
							skip_this_round = true
						end
						casting_first_spell = false
					end
				end
				if not skip_this_round then
					backgrounds[i]:SetTexture(GetSpellTexture(current_spell))
					cooldowns[i]:SetCooldown(gcd_start, gcd_duration, gcd_enabled, gcd_modRate)
					i = i + 1
				end
			end
			local t = unit_range("target")
			if t then
				Geodew_GridCenter(grid_profile,t,10,43,center_texts[1],"%.0f")
			end
		elseif yd == 0 then
			if GetSpecialization() == 1 then
				grid_profile = Geodew.GridsConfig(Geodew.GetProfile(specid),grids_meta)
				if grid_profile.Enable then
					yd=coyield(true)
				else
					yd=coyield(false)
				end
			else
				globalframe:Hide()
				yd=coyield(false)
			end
			break
		end
		yd=coyield()
		until true
	end
end

Geodew.AddCoroutine(coroutine.create(cofunc))
