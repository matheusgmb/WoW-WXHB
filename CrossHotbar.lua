local ADDON, addon = ...
local config = addon.Config

local ActionList = {
   ["HOTBARBTN1"] = true,
   ["HOTBARBTN2"] = true,
   ["HOTBARBTN3"] = true,
   ["HOTBARBTN4"] = true,
   ["HOTBARBTN5"] = true,
   ["HOTBARBTN6"] = true,
   ["HOTBARBTN7"] = true,
   ["HOTBARBTN8"] = true,
   ["HOTBARBTN9"] = true,
   ["HOTBARBTN10"] = true,
   ["HOTBARBTN11"] = true,
   ["HOTBARBTN12"] = true
}
config:ConfigListAdd("HotbarActions", ActionList, "NONE")
config:ConfigListAdd("HotbarSwapActions", ActionList, "NONE")

CrossHotbarMixin = {
}

function CrossHotbarMixin:SetupCrosshotbar()
   self.LHotbar = { LHotbar1, LHotbar2, LHotbar3 }
   self.RHotbar = { RHotbar1, RHotbar2, RHotbar3 }
   self.MHotbar = { LRHotbar1, RLHotbar1 }
   
   SecureHandlerSetFrameRef(self, 'Hotbar1', LHotbar1)
   SecureHandlerSetFrameRef(self, 'Hotbar2', LHotbar2)
   SecureHandlerSetFrameRef(self, 'Hotbar3', LHotbar3)
   SecureHandlerSetFrameRef(self, 'Hotbar4', RHotbar1)
   SecureHandlerSetFrameRef(self, 'Hotbar5', RHotbar2)
   SecureHandlerSetFrameRef(self, 'Hotbar6', RHotbar3)
   SecureHandlerSetFrameRef(self, 'Hotbar7', LRHotbar1)
   SecureHandlerSetFrameRef(self, 'Hotbar8', RLHotbar1)
   
   if GetCVar('GamePadEnable') == "1" then
      print("Setting GamePad CVars")
      SetCVar('GamePadEnable', 1);
      SetCVar('GamePadEmulateShift', 'NONE');
      SetCVar('GamePadEmulateCtrl', 'NONE');
      SetCVar('GamePadEmulateAlt', 'NONE');
      SetCVar('GamePadCursorLeftClick', 'PAD6');
      SetCVar('GamePadCursorRightClick', 'PADBACK');
      SetCVar('GamePadCameraYawSpeed', 3);
      SetCVar('GamePadCameraPitchSpeed', 3);
      SetCVar('GamePadSingleActiveID', 1)
      --[[
         for _, i in ipairs(C_GamePad.GetAllDeviceIDs()) do
   
   local device = C_GamePad.GetDeviceRawState(i)
   if(device) then
      print(i .. " " .. table.concat(device[1]))
   end
   print(device)
         end
      --]]
   end
   
   print("CrossHotbar Setup")
end

function CrossHotbarMixin:ApplyConfig()
   local bindings = {}

   for action,value in pairs(ActionList) do
      bindings[action] = {"", "", ""}
   end
   
   for button, attributes in pairs(config.PadActions) do
      if ActionList[attributes.TRIGACTION] then
         bindings[attributes.TRIGACTION][1] = attributes.BIND
      end
      if ActionList[attributes.SWAPTRIGACTION] then
         bindings[attributes.SWAPTRIGACTION][2] = attributes.BIND
      end
   end
   
   bindings["HOTBARBTN9"][3] = bindings["HOTBARBTN1"][1]
   bindings["HOTBARBTN10"][3] = bindings["HOTBARBTN2"][1]
   bindings["HOTBARBTN11"][3] = bindings["HOTBARBTN3"][1]
   bindings["HOTBARBTN12"][3] = bindings["HOTBARBTN4"][1]
   
   self:OverrideKeyBindings(LHotbar1.ActionBar, "ACTIONBUTTON", "ActionButton", bindings)
   self:OverrideKeyBindings(RHotbar1.ActionBar, "MULTIACTIONBAR1BUTTON", RHotbar1.BtnPrefix, bindings)
   self:OverrideKeyBindings(LRHotbar1.ActionBar, "MULTIACTIONBAR2BUTTON", LRHotbar1.BtnPrefix, bindings)
   self:OverrideKeyBindings(RLHotbar1.ActionBar, "MULTIACTIONBAR2BUTTON", RLHotbar1.BtnPrefix, bindings)

   local hotbars = { self:GetChildren() }
   for k,hotbar in pairs(hotbars) do
      if hotbar.ApplyConfig then
         hotbar:ApplyConfig()
      end
   end
   
   self:UpdateCrosshotbar()
end

function CrossHotbarMixin:OnLoad()
   self:SetScale(0.90)
   self:AddStateHandler()
   self:AddSwapHandler()
   self:AddExpandHandler()
   self:AddNextPageHandler()
   self:RegisterEvent("PLAYER_ENTERING_WORLD")
   self:HideHudElements()
   addon.Crosshotbar = self
   addon.CreateGamePadButtons(self)
   addon.CreateGroupNavigator(self)
end

function CrossHotbarMixin:OnEvent(event, ...)
   if ( event == "PLAYER_ENTERING_WORLD" ) then
      self:SetupCrosshotbar()
      self:ApplyConfig()
      self:UpdateCrosshotbar()
      self:Execute([[
         self:SetAttribute("triggerstate", 4)
         self:SetAttribute("state-trigger", 4)
      ]])
   end
end

function CrossHotbarMixin:AddStateHandler()
   self:SetAttribute('_onstate-trigger', [[
      self:SetAttribute("triggerstate", newstate)

      local expanded = self:GetAttribute("expanded")
      if not ((expanded == 1 and (newstate == 6 or newstate == 3)) or
              (expanded == 2 and (newstate == 7 or newstate == 5))) then
         expanded = 0
         self:SetAttribute("expanded", 0)
      end

      local state = 0
      if newstate == 6 or newstate == 2 then state = 1 end
      if newstate == 7 or newstate == 1 then state = 2 end
      if newstate == 3 then state = 3 end
      if newstate == 5 then state = 4 end

      for i=1,8 do
         local hotbar = self:GetFrameRef('Hotbar'..i)
         hotbar:SetAttribute("state-hotbar-expanded", expanded)
         hotbar:SetAttribute("state-hotbar-visibility", state)
      end
  ]])
end

function CrossHotbarMixin:AddSwapHandler()
   self:SetAttribute('_onstate-swap', [[
      for i=1,8 do
         local hotbar = self:GetFrameRef('Hotbar'..i)
         hotbar:SetAttribute("state-hotbar-swap", newstate)
      end
   ]])
end

function CrossHotbarMixin:AddExpandHandler()
   self:SetAttribute('_onstate-expanded', [[
      local hotbarstate = self:GetAttribute("triggerstate")
      if hotbarstate == 4 then               
         self:SetAttribute("expanded", newstate)
         for i=1,8 do
            local hotbar = self:GetFrameRef('Hotbar'..i)
            hotbar:SetAttribute("state-hotbar-expanded", newstate)
         end
      end
  ]])
end

function CrossHotbarMixin:AddNextPageHandler()
   self:SetAttribute('_onstate-nextpage', [[
      for i=1,8 do
         local hotbar = self:GetFrameRef('Hotbar'..i)
         hotbar:SetAttribute("state-hotbar-nextpage", newstate)
      end
  ]])
end

function CrossHotbarMixin:OverrideKeyBindings(ActBar, ActionPrefix, BtnPrefix, ConfigBindings)
   --local idx = 1
   local containers = { ActBar:GetChildren() }
   for i, container in ipairs(containers) do
      local buttons = { container:GetChildren() }
      for j, button in ipairs(buttons) do            
         if button ~= nil and button:GetName() ~= nil then
            if string.find(button:GetName(), BtnPrefix) then
               local index = button:GetID();
               local ActionName = string.gsub(button:GetName(), BtnPrefix, ActionPrefix)
               --local key1, key2 = GetBindingKey(ActionName)
               local key1, key2, key3 = unpack(ConfigBindings["HOTBARBTN"..index])
               
               button:SetAttribute('over_key1', key1)
               button:SetAttribute('over_key2', key2)
               button:SetAttribute('over_key3', key3)

               button.HotKey:SetText(RANGE_INDICATOR);
               button.HotKey:Show();
               --idx = idx + 1
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
