local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew",true)
if not Geodew then return end
Geodew.grids = {}
local LSM = LibStub("LibSharedMedia-3.0")

local default =
{
	Lock = false,
	Enable = true,
	x = -300,
	y = 0,
	Size = 35,
	CenterTextFont = LSM:GetDefault("font"),
	CenterTextSize = 30,
	BottomTextFont = LSM:GetDefault("font"),
	BottomTextSize = 15,

	LowColorR = 1,
	LowColorG = 1,
	LowColorB = 1,
	LowColorA = 1,

	MidColorR = 0,
	MidColorG = 0,
	MidColorB = 1,
	MidColorA = 1,

	HighColorR = 1,
	HighColorG = 0,
	HighColorB = 0,
	HighColorA = 1,

	BottomTextColorR = 1,
	BottomTextColorG = 1,
	BottomTextColorB = 1,
	BottomTextColorA = 1,
}
default.__index = default

function Geodew.CreateGrids(name,n)
-- data driven design
	local grids_meta = {}
	grids_meta.n = n
	Geodew.grids[name] = grids_meta
	local globalframe = CreateFrame("Frame",nil,UIParent)
	globalframe:Hide()
--	globalframe:SetFrameStrata("MEDIUM")
--	globalframe:SetClampedToScreen(true)

	grids_meta.globalframe = globalframe
	local frame_tbls = {}
	grids_meta.frames = frame_tbls
	local background_tbls = {}
	grids_meta.backgrounds = background_tbls
	local center_text_tbls = {}
	grids_meta.center_texts = center_text_tbls
	local bottom_text_tbls = {}
	grids_meta.bottom_texts = bottom_text_tbls
	local cd_tbls = {}
	grids_meta.cooldowns = cd_tbls
	for i=1,n do
		local frme = CreateFrame("Frame",nil,globalframe)
		if i==1 then
			frme:SetPoint("BOTTOMLEFT",globalframe,"BOTTOMLEFT")
			frme:SetPoint("TOPLEFT",globalframe,"TOPLEFT")
		else
			local lastfrm = frame_tbls[i-1]
			if i ~= 2 then
				frme:SetPoint("TOPLEFT",lastfrm,"TOPRIGHT")
			end
			frme:SetPoint("BOTTOMLEFT",lastfrm,"BOTTOMRIGHT")
			if i == n then
				frme:SetPoint("BOTTOMRIGHT",globalframe,"BOTTOMRIGHT")
				frme:SetPoint("TOPRIGHT",globalframe,"TOPRIGHT")
			end
		end
		frame_tbls[i] = frme
		local b =  frme : CreateTexture(nil, "BACKGROUND")
		b:SetAllPoints(frme)
		b:SetTexCoord(0.1,0.9,0.1,0.9)
		background_tbls[i] = b
		local ct = frme:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		ct:SetPoint("Center", frme, "CENTER",0, 0)
		center_text_tbls[i] = ct
		local btmt = frme:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		btmt:SetPoint("Bottom", frme, "Bottom",0, 0)
		bottom_text_tbls[i] = btmt
		local cd = CreateFrame("Cooldown", nil, frme, "CooldownFrameTemplate")
		cd:SetHideCountdownNumbers(true)
		cd_tbls[i] = cd
	end
	return grids_meta
end

function Geodew.GridsConfig(db,grids_meta)
	local tb = db.grids
	if tb == nil then
		tb = {}
		db.grids = tb
	end
	setmetatable(tb,default)
	local globalframe = grids_meta.globalframe
	local enable = tb.Enable
	if enable then
		local size = tb.Size
		local frame_tbls = grids_meta.frames
		local center_text_tbls = grids_meta.center_texts
		local bottom_text_tbls = grids_meta.bottom_texts
		local n = #frame_tbls
		for i=1,n do
			local frame = frame_tbls[i]
			local center_text = center_text_tbls[i]
			local bottom_text = bottom_text_tbls[i]
			local sz = size
			if i == 1 then
				sz = sz*2
			end
			frame:SetSize(sz,sz)
			center_text:SetFont(LSM:HashTable("font")[tb.CenterTextFont], tb.CenterTextSize, "OUTLINE")
			bottom_text:SetFont(LSM:HashTable("font")[tb.BottomTextFont], tb.BottomTextSize, "OUTLINE")
		end
		globalframe:SetSize(size*(n+1),size*2)
		globalframe:SetPoint("CENTER",UIParent,"CENTER",tb.x,tb.y)
		globalframe:Show()
	else
		globalframe:Hide()
	end
	return tb
end

function Geodew.GridCenter(tb,count,L,M,center_text,format)
	if count < L then
		center_text:SetTextColor(tb.HighColorR,tb.HighColorG,tb.HighColorB,tb.HighColorA)
	elseif count < M then
		center_text:SetTextColor(tb.MidColorR,tb.MidColorG,tb.MidColorB,tb.MidColorA)
	else
		center_text:SetTextColor(tb.LowColorR,tb.LowColorG,tb.LowColorB,tb.LowColorA)
	end
	if format then
		center_text:SetFormattedText(format,count)
	else
		center_text:SetText(count)
	end
end