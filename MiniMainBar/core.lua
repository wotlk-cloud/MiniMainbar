
local defaults = {
	profile = {
		MainMenuBarScale = 1,
		MainMenuBarGryphonsHidden = false,
		MainMenuBarXPBarHidden = false,
		
		MicroMenuHidden = false,
		MicroMenuLocked = false,
		MicroMenuScale = 1,
		MicroMenuShowOnMouse = false,
		MicroMenuPoint = {
			XOffset = 0,
			YOffset = 0,
			Point = "CENTER",
			RelatedPoint = "CENTER",
			RelatedTo = "WorldFrame"
		},

		StanceBarHidden = false,
		StanceBarLocked = false,
		StanceBarScale = 1,
		StanceBarShowOnMouse = false,
		StanceBarPoint = {
			XOffset = 0,
			YOffset = 0,
			Point = "CENTER",
			RelatedPoint = "CENTER",
			RelatedTo = "WorldFrame"
		},
		
		BagsBarHidden = false,
		BagsBarLocked = false,
		BagsBarScale = 1,
		BagsBarShowOnMouse = false,
		BagsBarPoint = {
			XOffset = 0,
			YOffset = 0,
			Point = "CENTER",
			RelatedPoint = "CENTER",
			RelatedTo = "WorldFrame"
		},

		PetBarHidden = false,
		PetBarLocked = false,
		PetBarScale = 1,
		PetBarShowOnMouse = false,
		PetBarPoint = {
			XOffset = 0,
			YOffset = 0,
			Point = "CENTER",
			RelatedPoint = "CENTER",
			RelatedTo = "WorldFrame"
		}
	}
}

MiniMainBar = LibStub("AceAddon-3.0"):NewAddon("MiniMainBar", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")

function MiniMainBar:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MiniMainBarDB", defaults, "Default")

	self.db.RegisterCallback(self, "OnProfileChanged", "UpdateFromProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "UpdateFromProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "UpdateFromProfile")

	
	--self:RegisterEvent("UNIT_EXITED_VEHICLE", MiniMainBar.UpdateGUI)
	self:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA", MiniMainBar.UpdateGUI)
	--self:RegisterEvent("UNIT_EXITING_VEHICLE", MiniMainBar.UpdateGUI)
	--self:SecureHook("MainMenuBar_ToPlayerArt", MiniMainBar.UpdateGUI)
	self:SecureHook("UIParent_ManageFramePositions", MiniMainBar.UpdateGUI)
	
	MiniMainBar:InitOptions()
	MiniMainBar:InitGUI()
end

function MiniMainBar:UpdateFromProfile()

end

function MiniMainBar:InitGUI()
	MiniMainBar:InitMainMenuBar()
	MiniMainBar:InitMicroMenu()
	MiniMainBar:InitBagsBar()
	MiniMainBar:InitPetBar()
	MiniMainBar:InitStanceBar()
end

function MiniMainBar:UpdateGUI()
	if UnitHasVehicleUI("player") or InCombatLockdown() then return end
	
	MiniMainBar:UpdateMainMenuBar()
	MiniMainBar:UpdateMicroMenu()
	MiniMainBar:UpdateBagsBar()
	MiniMainBar:UpdatePetBar()
	MiniMainBar:UpdateStanceBar()
end

function MiniMainBar:InitMainMenuBar()
	-- Main Menu bar elements to be hidden
	MainMenuBarPageNumber:Hide()
	ActionBarUpButton:Hide()
	ActionBarDownButton:Hide()
	MainMenuBarTexture2:Hide()
	MainMenuBarTexture3:Hide()
	MainMenuMaxLevelBar2:Hide()
	MainMenuMaxLevelBar3:Hide()
	MainMenuXPBarTexture2:Hide()
	MainMenuXPBarTexture3:Hide()
	
	MainMenuXPBarTexture0:SetPoint("BOTTOM", "MainMenuExpBar", "BOTTOM", -128, 2)
	MainMenuXPBarTexture1:SetPoint("BOTTOM", "MainMenuExpBar", "BOTTOM", 128, 2)
	MainMenuMaxLevelBar0:SetPoint("BOTTOM", "MainMenuBarMaxLevelBar", "TOP", -128, 0)
	MainMenuBarTexture0:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -128, 0)
	MainMenuBarTexture1:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 128, 0)
	MainMenuBarLeftEndCap:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", -290, 0)
	MainMenuBarRightEndCap:SetPoint("BOTTOM", "MainMenuBarArtFrame", "BOTTOM", 287, 0)
	
	-- Clear XP/Rep bar textures
	ReputationWatchBarTexture2:SetTexture(nil)
	ReputationWatchBarTexture3:SetTexture(nil)
	ReputationXPBarTexture2:SetTexture(nil)
	ReputationXPBarTexture3:SetTexture(nil)
	
	-- Resize MainMenuBar
	MainMenuBar:SetWidth(512)
	MainMenuExpBar:SetWidth(512)
	ReputationWatchBar:SetWidth(512)
	MainMenuBarMaxLevelBar:SetWidth(512)
	ReputationWatchStatusBar:SetWidth(512)
	
	MiniMainBar:UpdateMainMenuBar()
end

function MiniMainBar:UpdateMainMenuBar()
	if MultiBarBottomRight:IsShown() then
		local YOffset = 0
		
		if MultiBarBottomLeft:IsShown() then
			YOffset = 42
		end
		
		MultiBarBottomRight:ClearAllPoints()
		MultiBarBottomRight:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "BOTTOMLEFT", 0, YOffset)
	end	
	
	MiniMainBar:HideGryphons(self.db.profile.MainMenuBarGryphonsHidden)
	MiniMainBar:ScaleMainMenuBar(self.db.profile.MainMenuBarScale)
end

-- Scale the Main bar
function MiniMainBar:ScaleMainMenuBar(scale)
	MainMenuBar:SetScale(scale)
	MultiBarBottomLeft:SetScale(scale)
	MultiBarBottomRight:SetScale(scale)
	MultiBarRight:SetScale(scale)
	MultiBarLeft:SetScale(scale)
	VehicleMenuBar:SetScale(scale)
end

-- Hide or show the gryphon endcaps
function MiniMainBar:HideGryphons(hidden)
	if (hidden) then
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
    else
		MainMenuBarLeftEndCap:Show()
		MainMenuBarRightEndCap:Show()	
	end
end