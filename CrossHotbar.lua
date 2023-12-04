

CrossHotbarMixin = {}

function CrossHotbarMixin:SetupCrosshotbar()
	self.LHotbar = { LHotbar1, LHotbar2, LHotbar3 }
	self.RHotbar = { RHotbar1, RHotbar2, RHotbar3 }
	self.MHotbar = { LRHotbar1, RLHotbar1 }
	
	self:OverrideKeyBindings(LHotbar1.ActionBar, "ACTIONBUTTON", LHotbar1.BtnPrefix)
	self:OverrideKeyBindings(RHotbar1.ActionBar, "MULTIACTIONBAR1BUTTON", RHotbar1.BtnPrefix)
	self:OverrideKeyBindings(LRHotbar1.ActionBar, "MULTIACTIONBAR2BUTTON", LRHotbar1.BtnPrefix)
	self:OverrideKeyBindings(RLHotbar1.ActionBar, "MULTIACTIONBAR2BUTTON", RLHotbar1.BtnPrefix)
    
	UnregisterStateDriver(LHotbar1.ActionBar,'visibility')
    UnregisterStateDriver(LHotbar2.ActionBar,'visibility')
    UnregisterStateDriver(LHotbar3.ActionBar,'visibility')
    UnregisterStateDriver(RHotbar1.ActionBar,'visibility')
    UnregisterStateDriver(RHotbar2.ActionBar,'visibility')
    UnregisterStateDriver(RHotbar3.ActionBar,'visibility')
	
	RegisterStateDriver(LHotbar1.ActionBar, "visibility", "[petbattle]hide;[mod:shift,mod:ctrl]hide;[mod:ctrl]show;hide")
	RegisterStateDriver(LHotbar2.ActionBar, "visibility", "[petbattle]hide;[mod:shift,mod:ctrl]hide;[mod:shift]hide;[mod:ctrl]hide;show")
	RegisterStateDriver(LHotbar3.ActionBar, "visibility", "[petbattle]hide;[mod:shift,mod:ctrl]hide;[mod:ctrl]hide;[mod:shift]show;hide")
	RegisterStateDriver(RHotbar1.ActionBar, "visibility", "[petbattle]hide;[mod:shift,mod:ctrl]hide;[mod:shift]show;hide")
	RegisterStateDriver(RHotbar2.ActionBar, "visibility", "[petbattle]hide;[mod:shift,mod:ctrl]hide;[mod:ctrl]hide;[mod:shift]hide;show")
	RegisterStateDriver(RHotbar3.ActionBar, "visibility", "[petbattle]hide;[mod:shift,mod:ctrl]hide;[mod:shift]hide;[mod:ctrl]show;hide")
	RegisterStateDriver(LRHotbar1.ActionBar, "visibility", "[petbattle]hide;[mod:shift,mod:ctrl]show;hide")
	RegisterStateDriver(RLHotbar1.ActionBar, "visibility", "[petbattle]hide;[mod:shift,mod:ctrl]show;hide") 
	
    UnregisterStateDriver(LHotbar1,'page')
    UnregisterStateDriver(LHotbar2,'page')
    UnregisterStateDriver(LHotbar3,'page')
    UnregisterStateDriver(RHotbar1,'page')
    UnregisterStateDriver(RHotbar2,'page')
    UnregisterStateDriver(RHotbar3,'page')
	
    RegisterStateDriver(LHotbar1, 'page', "[overridebar][possessbar][shapeshift][bonusbar:5]possess;[bonusbar:3]9;[bonusbar:1,stealth:1]8;[bonusbar:1]7;[bonusbar:4]10;1")
    RegisterStateDriver(LHotbar2, 'page', "[overridebar][possessbar][shapeshift][bonusbar:5]possess;[bonusbar:3]9;[bonusbar:1,stealth:1]8;[bonusbar:1]7;[bonusbar:4]10;1")
    RegisterStateDriver(LHotbar3, 'page', "[overridebar][possessbar][shapeshift][bonusbar:5]possess;[bonusbar:3]9;[bonusbar:1,stealth:1]8;[bonusbar:1]7;[bonusbar:4]10;1")
	RegisterStateDriver(RHotbar1, 'page', "6")
	RegisterStateDriver(RHotbar2, 'page', "6")
	RegisterStateDriver(RHotbar3, 'page', "6")
	
    UnregisterStateDriver(LRHotbar1,'mod')
    UnregisterStateDriver(RLHotbar1,'mod')
	
    RegisterStateDriver(LRHotbar1, 'mod', "[mod:shift,mod:ctrl]2;[mod:shift]6; [mod:ctrl]1;5")
    RegisterStateDriver(RLHotbar1, 'mod', "[mod:shift,mod:ctrl]2;[mod:shift]6; [mod:ctrl]1;5")
	
    print("CrossHotbar Setup")
end

function CrossHotbarMixin:OnLoad()
	self:SetScale(0.90)
	--self:RegisterForDrag("LeftButton");
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:HideHudElements()
	--self:HideBlizzard()
end

function CrossHotbarMixin:OnEvent(event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		self:SetupCrosshotbar()
		self:UpdateCrosshotbar()
	end
end

function CrossHotbarMixin:OverrideKeyBindings(ActBar, ActionPrefix, BtnPrefix)
	local containers = { ActBar:GetChildren() }
	for i, container in ipairs(containers) do
		local buttons = { container:GetChildren() }
		for j, button in ipairs(buttons) do            
			if button ~= nil and button:GetName() ~= nil then	
				if string.find(button:GetName(), BtnPrefix) then
					local ActionName = string.gsub(button:GetName(), BtnPrefix, ActionPrefix)
					local key1, key2 = GetBindingKey(ActionName)
					if key1 then
						SetOverrideBindingClick(button, true, key1, button:GetName(), "LeftButton")
					end
					if key2 then
						SetOverrideBindingClick(button, true, key2, button:GetName(), "LeftButton")
					end
					
					button:SetAttribute('over_key1', key1)
					button:SetAttribute('over_key2', key2)
				--	print(ActionName, button:GetName(), key1, key2)
					button.HotKey:SetText(RANGE_INDICATOR);
					button.HotKey:Show();
				end
			end
		end
	end
end

function CrossHotbarMixin:UpdateCrosshotbar()
	local point = "CENTER"
	local relativeTo = self:GetParent()
	local relativePoint = "CENTER"
	local xOfs = 0
	local yOfs = 0  
	
    local w, h = self:GetSize()
    local s = self:GetScale()
	
    self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", relativeTo, relativePoint, xOfs*s-w*0.5, yOfs*s-h*0.5)
	
	local hotbars = { self:GetChildren() }
	for k,hotbar in pairs(hotbars) do
		if hotbar.UpdateHotbar then
			hotbar:UpdateHotbar()
		end
	end	
end

function CrossHotbarMixin:HideHudElements()
	if self.UIHider == nil then
		self.UIHider = CreateFrame("Frame")
		self.UIHider:Hide()
	end
	
	OverrideActionBar:Hide()
	OverrideActionBar:SetParent(self.UIHider)
	
	hooksecurefunc(MainMenuBarVehicleLeaveButton, "Update", self.MainMenuBarVehicleLeaveButton_Update)
	
	-- remove EditMode hooks
	MainMenuBarVehicleLeaveButton.ClearAllPoints = nil
	MainMenuBarVehicleLeaveButton.SetPoint = nil
	MainMenuBarVehicleLeaveButton.SetScale = nil

	MainMenuBarVehicleLeaveButton:SetParent(self)
	MainMenuBarVehicleLeaveButton:SetScript("OnShow", nil)
	MainMenuBarVehicleLeaveButton:SetScript("OnHide", nil)
end

local function ShouldVehicleButtonBeShown()
	if not CanExitVehicle then
		return UnitOnTaxi("player")
	else
		return CanExitVehicle()
	end
end

function CrossHotbarMixin:MainMenuBarVehicleLeaveButton_Update()
	if ShouldVehicleButtonBeShown() then
		--self.bar:PerformLayout()
		MainMenuBarVehicleLeaveButton:Show()
		MainMenuBarVehicleLeaveButton:Enable()
	else
		MainMenuBarVehicleLeaveButton:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]], "ADD")
		MainMenuBarVehicleLeaveButton:UnlockHighlight()
		MainMenuBarVehicleLeaveButton:Hide()
	end
end