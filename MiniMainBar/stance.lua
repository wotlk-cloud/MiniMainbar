UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"] = nil
UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil
	
function MiniMainBar:InitStanceBar()
	for i = 1, 10 do
		local b = _G["ShapeshiftButton" .. tostring(i)]
		b:SetParent(MiniMainBar_StanceBar)
	end
	
	local b = _G["ShapeshiftButton" .. tostring(1)]
	b:ClearAllPoints()
	b:SetPoint("BOTTOMLEFT", MiniMainBar_StanceBar, "BOTTOMLEFT", 6, 8)
	
	for i = 1, 2 do
		local b = _G["PossessButton" .. tostring(i)]
		b:SetParent(MiniMainBar_StanceBar)
	end	
	
	MultiCastActionBarFrame:SetParent(MiniMainBar_StanceBar)
	MultiCastActionBarFrame:ClearAllPoints()	
	MultiCastActionBarFrame:SetScript("OnShow", nil)
	MultiCastActionBarFrame:SetScript("OnHide", nil)
	MultiCastActionBarFrame:SetScript("OnUpdate", nil)
	MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", MiniMainBar_StanceBar, "BOTTOMLEFT", 6, 4)

	ShapeshiftBarFrame:SetWidth(1)
	PossessBarFrame:SetWidth(1)
		
	MiniMainBar:HideStanceBar(self.db.profile.StanceBarHidden)
	MiniMainBar:LockStanceBar(self.db.profile.StanceBarLocked)
	MiniMainBar:ScaleStanceBar(self.db.profile.StanceBarScale)
end

function MiniMainBar:UpdateStanceBar()
	if InCombatLockdown() then return end
	
    ShapeshiftBarLeft:Hide()
    ShapeshiftBarMiddle:Hide()
    ShapeshiftBarRight:Hide()
    PossessBackground1:Hide()
    PossessBackground2:Hide()
	
	--if UnitHasVehicleUI("player") then return end
	if UnitUsingVehicle("player") then return end 
	
	local b = _G["ShapeshiftButton" .. tostring(1)]
	b:ClearAllPoints()
	b:SetPoint("BOTTOMLEFT", MiniMainBar_StanceBar, "BOTTOMLEFT", 6, 8)	
	
	local b = _G["PossessButton" .. tostring(1)]
	b:ClearAllPoints()
	b:SetPoint("BOTTOMLEFT", MiniMainBar_StanceBar, "BOTTOMLEFT", 6, 8)

	MiniMainBar:HideStanceBar(self.db.profile.StanceBarHidden)
	
	if not self.db.profile.StanceBarHidden then
		MiniMainBar:LockStanceBar(self.db.profile.StanceBarLocked)
		MiniMainBar:ScaleStanceBar(self.db.profile.StanceBarScale)
	
		MiniMainBar_StanceBar:ClearAllPoints()
		MiniMainBar_StanceBar:SetPoint(
			self.db.profile.StanceBarPoint.Point, 
			WorldFrame, 
			self.db.profile.StanceBarPoint.RelativePoint, 
			self.db.profile.StanceBarPoint.XOffset, 
			self.db.profile.StanceBarPoint.YOffset
		)
	end
end

function MiniMainBar:HideStanceBar(value)
	if value then
		MiniMainBar_StanceBar:Hide()
	else
		MiniMainBar_StanceBar:Show()
	end
end

function MiniMainBar:LockStanceBar(value)
	if value then
		MiniMainBar_StanceBar:EnableMouse(false)
		MiniMainBar_StanceBar:SetMovable(false)
		MiniMainBar_StanceBar:RegisterForDrag(nil)
		MiniMainBar_StanceBar:SetBackdrop({ })
	else
		MiniMainBar_StanceBar:EnableMouse(true)
		MiniMainBar_StanceBar:SetMovable(true);
		MiniMainBar_StanceBar:RegisterForDrag("RightButton")
		MiniMainBar_StanceBar:SetBackdrop({ 
			bgFile = "Interface/DialogFrame/UI-DialogBox-Background" 
		})
	end
end

function MiniMainBar:ScaleStanceBar(value)
	MiniMainBar_StanceBar:SetScale(value)
end

function MiniMainBar_StanceBar_OnDragStart()
	if MiniMainBar.db.profile.StanceBarLocked then return end
	
	MiniMainBar_StanceBar:StartMoving();
	MiniMainBar_StanceBar.isMoving = true;
end

function MiniMainBar_StanceBar_OnDragStop()
	MiniMainBar_StanceBar:StopMovingOrSizing();
	MiniMainBar_StanceBar.isMoving = false;
	
	Point, RelativeTo, RelativePoint, XOffset, YOffset = MiniMainBar_StanceBar:GetPoint()
	
	MiniMainBar.db.profile.StanceBarPoint.XOffset = XOffset
	MiniMainBar.db.profile.StanceBarPoint.YOffset = YOffset
	MiniMainBar.db.profile.StanceBarPoint.Point = Point						
	MiniMainBar.db.profile.StanceBarPoint.RelativePoint = RelativePoint
end
