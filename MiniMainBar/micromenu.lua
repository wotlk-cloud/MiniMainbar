local MicroMenuButtons = {
	CharacterMicroButton, 
	SpellbookMicroButton, 
	TalentMicroButton, 
	AchievementMicroButton, 
	QuestLogMicroButton,
	SocialsMicroButton, 
	PVPMicroButton, 
	LFDMicroButton, 
	MainMenuMicroButton, 
	HelpMicroButton
}

function MiniMainBar:InitMicroMenu()
	for i = 1, #MicroMenuButtons do
		local button = MicroMenuButtons[i]
		button:SetParent(MiniMainBar_MicroMenu)
		
		button:HookScript("OnEnter",  MiniMainBar_MicroMenu_OnMouseOver)
		button:HookScript("OnLeave",  MiniMainBar_MicroMenu_OnMouseOut)
	end
	
	self:SecureHook("UpdateMicroButtons")
	
	-- The micromenu MainMenuMicroButton calls this function instead of just showing a GameTooltip
	-- So MiniMainBar hooks into this function just to hide the tooltip
	self:SecureHook("MainMenuBarPerformanceBarFrame_OnEnter")
	
	MiniMainBar:HideMicroMenu(self.db.profile.MicroMenuHidden)
	MiniMainBar:LockMicroMenu(self.db.profile.MicroMenuLocked)
	MiniMainBar:ScaleMicroMenu(self.db.profile.MicroMenuScale)
end

function MiniMainBar:UpdateMicroMenu()
	if UnitUsingVehicle("player") then return end 
	
	local b = CharacterMicroButton
	b:ClearAllPoints()
	b:SetPoint("BOTTOMLEFT", MiniMainBar_MicroMenu, "BOTTOMLEFT", 2, 3)
	
	MiniMainBar:HideMicroMenu(self.db.profile.MicroMenuHidden)
	MiniMainBar:LockMicroMenu(self.db.profile.MicroMenuLocked)
	MiniMainBar:ScaleMicroMenu(self.db.profile.MicroMenuScale)
	
	MiniMainBar_MicroMenu:ClearAllPoints()
	MiniMainBar_MicroMenu:SetPoint(
		MiniMainBar.db.profile.MicroMenuPoint.Point, 
		WorldFrame, 
		self.db.profile.MicroMenuPoint.RelativePoint, 
		self.db.profile.MicroMenuPoint.XOffset, 
		self.db.profile.MicroMenuPoint.YOffset
	)
end

function MiniMainBar:UpdateMicroButtons()
	if UnitUsingVehicle("player") then return end 
	
	-- Blizzard code resets the UIParent of the micromenu buttons, so we override that here.
	for i = 1, #MicroMenuButtons do
		local button = MicroMenuButtons[i]
		button:SetParent(MiniMainBar_MicroMenu)
	end
end

function MiniMainBar:MainMenuBarPerformanceBarFrame_OnEnter()
	if MiniMainBar.db.profile.MicroMenuHidden then
		if not MiniMainBar.db.profile.MicroMenuShowOnMouse then
			GameTooltip:Hide()	
		end
	end
end

function MiniMainBar:HideMicroMenu(hidden)
	if hidden then	
		MiniMainBar_MicroMenu:SetAlpha(0)
		
		for i = 1, #MicroMenuButtons do
			local button = MicroMenuButtons[i]
			button:RegisterForClicks(nil)
			button:EnableMouse(false)
		end
	else
	    MiniMainBar_MicroMenu:SetAlpha(1)

		for i = 1, #MicroMenuButtons do
			local button = MicroMenuButtons[i]
			button:RegisterForClicks("LeftButtonUp")
			button:EnableMouse(true)
		end
	end
end

function MiniMainBar:LockMicroMenu(locked)
	if locked then
		MiniMainBar_MicroMenu:EnableMouse(true)
		MiniMainBar_MicroMenu:SetMovable(false)
		MiniMainBar_MicroMenu:RegisterForDrag(nil)
		MiniMainBar_MicroMenu:SetBackdrop({ })
	else
		MiniMainBar_MicroMenu:EnableMouse(true)
		MiniMainBar_MicroMenu:SetMovable(true)
		MiniMainBar_MicroMenu:RegisterForDrag("RightButton")
		MiniMainBar_MicroMenu:SetBackdrop({ 
			bgFile = "Interface/DialogFrame/UI-DialogBox-Background" 
		})
	end
end

function MiniMainBar:ScaleMicroMenu(scale)
	MiniMainBar_MicroMenu:SetScale(scale)
end

function MiniMainBar_MicroMenu_OnDragStart()
	if MiniMainBar.db.profile.MicroMenuLocked then return end
	
	MiniMainBar_MicroMenu:StartMoving();
	MiniMainBar_MicroMenu.isMoving = true;
end

function MiniMainBar_MicroMenu_OnDragStop()
	MiniMainBar_MicroMenu:StopMovingOrSizing();
	MiniMainBar_MicroMenu.isMoving = false;
	
	Point, RelativeTo, RelativePoint, XOffset, YOffset = MiniMainBar_MicroMenu:GetPoint()
	
	MiniMainBar.db.profile.MicroMenuPoint.XOffset = XOffset
	MiniMainBar.db.profile.MicroMenuPoint.YOffset = YOffset
	MiniMainBar.db.profile.MicroMenuPoint.Point = Point						
	MiniMainBar.db.profile.MicroMenuPoint.RelativePoint = RelativePoint
end

function MiniMainBar_MicroMenu_OnMouseOver(self)
	if MiniMainBar.db.profile.MicroMenuHidden then
		if MiniMainBar.db.profile.MicroMenuShowOnMouse then
			MiniMainBar_MicroMenu:SetAlpha(1)
			
			for i = 1, #MicroMenuButtons do
				local button = MicroMenuButtons[i]
				button:RegisterForClicks("LeftButtonUp")
				button:EnableMouse(true)
			end
		else
			GameTooltip:Hide()	
		end
	end
end

function MiniMainBar_MicroMenu_OnMouseOut(self)
	if	MiniMainBar.db.profile.MicroMenuHidden then
		if MiniMainBar.db.profile.MicroMenuShowOnMouse then
			MiniMainBar_MicroMenu:SetAlpha(0)
			
			for i = 1, #MicroMenuButtons do
				local button = MicroMenuButtons[i]
				button:RegisterForClicks(nil)
				button:EnableMouse(false)
			end
		end
	end
end

