local Geodew = LibStub("AceAddon-3.0"):NewAddon("Geodew","AceEvent-3.0","AceConsole-3.0")

local unit_range = Geodew.unit_range

local function cofunc(yd)
	local specid = 62
	local gframe,gbackground,center_text,bottom_text,cd,secure_frame = Geodew.CreateGrid(specid,coroutine.running())

	while true do
		repeat
		if 1 == yd or yd == 2 then
		elseif yd == 0 then
			grid_profile = Geodew.GridConfig(Geodew.GetProfile(specid))
--			rising_mist = select(5,GetTalentInfo(7,3,1))
		elseif yd == -1 then
			gframe:Hide()
		end
		yd=coroutine.yield()
		until true
	end
end

Geodew.AddCoroutine(coroutine.create(cofunc))
