local PetBarButtons = {
	PetActionButton1,
	PetActionButton2,
	PetActionButton3,
	PetActionButton4,
	PetActionButton5,
	PetActionButton6,
	PetActionButton7,
	PetActionButton8,
	PetActionButton9,
	PetActionButton10
}

function MiniMainBar:InitPetBar()
	UIPARENT_MANAGED_FRAME_POSITIONS["PetActionBarFrame"] = nil
	PetActionBarFrame:SetAttribute("unit", "pet")
	RegisterUnitWatch(PetActionBarFrame)

	for i = 1, #PetBarButtons do
		local button = PetBarButtons[i]
		button:SetParent(MiniMainBar_PetBar)
		button:HookScript("OnEnter",  MiniMainBar_PetBar_OnMouseOver)
		button:HookScript("OnLeave",  MiniMainBar_PetBar_OnMouseOut)
	end
	
	--self:SecureHook("PetActionButton_OnUpdate")
	self:SecureHook("PetActionBarFrame_OnUpdate")
	
	PetActionBarFrame:SetWidth(1)
	
	MiniMainBar:HidePetBar(self.db.profile.PetBarHidden)
	MiniMainBar:LockPetBar(self.db.profile.PetBarLocked)
	MiniMainBar:ScalePetBar(self.db.profile.PetBarScale)
end

function MiniMainBar:UpdatePetBar()
	if InCombatLockdown() then return end
	
	SlidingActionBarTexture0:Hide()
	SlidingActionBarTexture1:Hide()
	
	if UnitUsingVehicle("player") then return end 
	
	local b = PetActionButton1
	b:ClearAllPoints()
	b:SetPoint("BOTTOMLEFT", MiniMainBar_PetBar, "BOTTOMLEFT", 6, 8)	
	
	MiniMainBar:HidePetBar(self.db.profile.PetBarHidden)
	MiniMainBar:LockPetBar(self.db.profile.PetBarLocked)
	MiniMainBar:ScalePetBar(self.db.profile.PetBarScale)
	
	MiniMainBar_PetBar:ClearAllPoints()
	MiniMainBar_PetBar:SetPoint(
		self.db.profile.PetBarPoint.Point, 
		WorldFrame, 
		self.db.profile.PetBarPoint.RelativePoint, 
		self.db.profile.PetBarPoint.XOffset, 
		self.db.profile.PetBarPoint.YOffset
	)
end

function MiniMainBar:HidePetBar(hidden)
	if hidden then	
		MiniMainBar_PetBar:SetAlpha(0)
			
		for i = 1, #PetBarButtons do
			local button = PetBarButtons[i]
			button:RegisterForClicks(nil)
			button:EnableMouse(false)
		end
	else
	    MiniMainBar_PetBar:SetAlpha(1)
			
		for i = 1, #PetBarButtons do
			local button = PetBarButtons[i]
			button:RegisterForClicks("LeftButtonUp")
			button:EnableMouse(true)
		end
	end
end

function MiniMainBar:LockPetBar(locked)
	if locked then
		MiniMainBar_PetBar:EnableMouse(true)
		MiniMainBar_PetBar:SetMovable(false)
		MiniMainBar_PetBar:RegisterForDrag(nil)
		MiniMainBar_PetBar:SetBackdrop({ })
	else
		MiniMainBar_PetBar:EnableMouse(true)
		MiniMainBar_PetBar:SetMovable(true)
		MiniMainBar_PetBar:RegisterForDrag("RightButton")
		MiniMainBar_PetBar:SetBackdrop({ 
			bgFile = "Interface/DialogFrame/UI-DialogBox-Background" 
		})
	end
end

function MiniMainBar:ScalePetBar(scale)
	MiniMainBar_PetBar:SetScale(scale)
end

function MiniMainBar_PetBar_OnDragStart()
	if MiniMainBar.db.profile.PetBarLocked then return end
	
	this:StartMoving();
	this.isMoving = true;
end

function MiniMainBar:PetActionBarFrame_OnUpdate()
	if self.db.profile.PetBarHidden then
		MiniMainBar_PetBar:SetAlpha(0)
			
		for i = 1, #PetBarButtons do
			local button = PetBarButtons[i]
			button:RegisterForClicks(nil)
			button:EnableMouse(false)
		end
	end
end

function MiniMainBar:PetActionButton_OnUpdate()
	if self.db.profile.PetBarHidden then
		MiniMainBar_PetBar:SetAlpha(0)
			
		for i = 1, #PetBarButtons do
			local button = PetBarButtons[i]
			button:RegisterForClicks(nil)
			button:EnableMouse(false)
		end
	end
end

function MiniMainBar_PetBar_OnDragStop()
	MiniMainBar_PetBar:StopMovingOrSizing()
	MiniMainBar_PetBar.isMoving = false;
	
	Point, RelativeTo, RelativePoint, XOffset, YOffset = MiniMainBar_PetBar:GetPoint()
	
	MiniMainBar.db.profile.PetBarPoint.XOffset = XOffset
	MiniMainBar.db.profile.PetBarPoint.YOffset = YOffset
	MiniMainBar.db.profile.PetBarPoint.Point = Point						
	MiniMainBar.db.profile.PetBarPoint.RelativePoint = RelativePoint
end

function MiniMainBar_PetBar_OnMouseOver(self)
	if	MiniMainBar.db.profile.PetBarHidden then
		if MiniMainBar.db.profile.PetBarShowOnMouse then
			MiniMainBar_PetBar:SetAlpha(1)
			
			for i = 1, #PetBarButtons do
				local button = PetBarButtons[i]
				button:RegisterForClicks("LeftButtonUp")
				button:EnableMouse(true)
			end
		end
	end
end

function MiniMainBar_PetBar_OnMouseOut(self)
	if	MiniMainBar.db.profile.PetBarHidden then
		if MiniMainBar.db.profile.PetBarShowOnMouse then
			MiniMainBar_PetBar:SetAlpha(0)
			
			for i = 1, #PetBarButtons do
				local button = PetBarButtons[i]
				button:RegisterForClicks(nil)
				button:EnableMouse(false)
			end
		end
	end
end
