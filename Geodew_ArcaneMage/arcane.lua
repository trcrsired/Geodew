local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew")

local unit_range = Geodew.unit_range

local function cofunc(yd)
	local specid = 62
	local n = 4
	local grids_meta = Geodew.CreateGrids(specid,n)
--	for k,v in pairs(grids_meta) do
--		print(k,v)
--	end
	local globalframe = grids_meta.globalframe
	local backgrounds = grids_meta.backgrounds
	local center_texts = grids_meta.center_texts
	local bottom_texts = grids_meta.bottom_texts
	local cooldowns = grids_meta.cooldowns
	local grid_profile
	local coyield = coroutine.yield
	local GetSpellTexture = GetSpellTexture
	local arcane_mage_texture = GetSpellTexture(30451)
	while true do
		repeat
		if yd ==1 or yd == 2 then
			for i=1,n do
				backgrounds[i]:SetTexture(arcane_mage_texture)
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
