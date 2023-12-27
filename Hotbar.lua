
HotbarMixin = {
   Padding = 0.0,
   LHotbar = {
      BtnPos = {{-1.0, 0.5}, {-1.0, -0.5}, {-2.0, 0}}, 
      BtnOff = {{-6.0, 2.0}, {-6.0, 2.0}, {-6.0, 2.0}},
      GrpPos = {{8.05, 0.0}, {1.70, 0.0}, {-2.25, 2.5}},
      GrpOff = {{10.0, 0.0}, {-12.0, 0.0}, {0.0, 0.0}},
      SclOff = {{-0.5, 0.5}, {-0.5, 0.5}, {-0.5, 0.5}}
   },
   RHotbar = {
      BtnPos = {{-1.0, 0.5}, {-1.0, -0.5}, {-2.0, 0}}, 
      BtnOff = {{-6.0, 2.0}, {-6.0, 2.0}, {-6.0, 2.0}},
      GrpPos = {{11.30, 0.0}, {4.90, 0.0}, {14.90, 2.5}},
      GrpOff = {{10.0, 0.0}, {-12.0, 0.0}, {10.0, 0.0}},
      SclOff = {{-0.5, 0.5}, {-0.5, 0.5}, {-1.0, 1.0}}
   },
   RLHotbar = {
      BtnPos = {{-1.0, 0.5}, {-1.0, -0.5}, {-2.0, 0}}, 
      BtnOff = {{-6.0, 2.0}, {-6.0, 2.0}, {-6.0, 2.0}},
      GrpPos = {{8.05, 0.0}, {4.90, 0.0}, {14.90, 2.5}},
      GrpOff = {{10.0, 0.0}, {-12.0, 0.0}, {10.0, 0.0}},
      SclOff = {{-0.5, 0.5}, {-0.5, 0.5}, {-1.0, 1.0}}
   },
   LRHotbar = {
      BtnPos = {{-1.0, 0.5}, {-1.0, -0.5}, {-2.0, 0}}, 
      BtnOff = {{-6.0, 2.0}, {-6.0, 2.0}, {-6.0, 2.0}},
      GrpPos = {{8.05, 0.0}, {4.90, 0.0}, { -2.25, 2.5}},
      GrpOff = {{10.0, 0.0}, {-12.0, 0.0}, {0.0, 0.0}},
      SclOff = {{-0.5, 0.5}, {-0.5, 0.5}, {-0.5, 0.5}}
   }
}

function HotbarMixin:OnLoad()
   self.AnchorButtons = {}
   self.Highlights = {}
   self.ActionBar = _G[self.BarName]
   self:AddActionBar()
   self:AddPageHandler()
   self:AddModHandler()
   self:AddStateHandler()
   self:AddExpandHandler()
   self:AddNextPageHandler()
   
   local pageindex = self:GetAttribute("pageindex")
   local pageprefix = self:GetAttribute("pageprefix")
   
   UnregisterStateDriver(self.ActionBar,'visibility')
   UnregisterStateDriver(self,'page')
   RegisterStateDriver(self, 'page', pageprefix .. pageindex)
   
   self.Locked = true
   self.Point = {self:GetPoint(1)}
   self.ActionBar.hotbar = self
   hooksecurefunc(self.ActionBar, "SetPoint", self.hSetPoint)

   self:RegisterEvent("PLAYER_ENTERING_WORLD");
   self:RegisterEvent("UPDATE_BINDINGS");
   self:RegisterEvent("GAME_PAD_ACTIVE_CHANGED");
   
   self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_RETICLE_TARGET", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_RETICLE_CLEAR", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", "player");
   self:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", "player");
end

function HotbarMixin.hSetPoint(f, ...)
   --   print(f.hotbar:GetName(), f.hotbar.Point, f.hotbar.Locked) 
   if f.hotbar and f.hotbar.Point ~= nil then
      if f.hotbar.Locked == false then 
         f.hotbar.Point = {f:GetPoint(1)}
      else
         local p = f.hotbar.Point
         f.hotbar.Point = nil
         f:ClearAllPoints()
         
         f:SetPoint(unpack(p))
         f.hotbar.Point = p
         p = nil
      end
      
   end
end

function HotbarMixin:AddActionBar()
   local idx = 1
   local containers = { self.ActionBar:GetChildren() }
   for i,container in ipairs(containers) do
      SecureHandlerSetFrameRef(self, 'Container'..i, container)
      local buttons = { container:GetChildren() }
      for j,button in ipairs(buttons) do
         if button ~= nil and button:GetName() ~= nil then
            if string.find(button:GetName(), "Button") then -- self.BtnPrefix 
               SecureHandlerSetFrameRef(self, 'ActionButton'..idx, button)
               idx = idx + 1
            end
         end
      end
   end
   
   SecureHandlerSetFrameRef(self, 'ActionBar', self.ActionBar)
end

function HotbarMixin:AddPageHandler()
   self:SetAttribute("_onstate-page", [[
   if newstate == "possess" or newstate == "11" then
      if HasVehicleActionBar() then
         newstate = GetVehicleBarIndex()
      elseif HasOverrideActionBar() then
         newstate = GetOverrideBarIndex()
      elseif HasTempShapeshiftActionBar() then
         newstate = GetTempShapeshiftBarIndex()
      elseif HasBonusActionBar() then
         newstate = GetBonusBarIndex()
      else
         newstate = nil
      end
      if not newstate then
         print("Unknow page state")
         newstate = 12
      end
   end
   for i = 1, 12 do
      local button = self:GetFrameRef('ActionButton'..i)
      button:SetAttribute('actionpage', newstate)
   end
   
   local bar = self:GetFrameRef('ActionBar')
   bar:SetAttribute('actionpage', newstate)
   self:SetAttribute('actionpage', newstate)
   ]])
end

function HotbarMixin:AddModHandler()
   self:SetAttribute('_onstate-mod', [[
   local laststate = self:GetAttribute("state-page")
   if newstate == 2 and laststate == 6 then
      newstate = 5
   end
   laststate = newstate
   local activestate = self:GetAttribute("activestate")
   local bar = self:GetFrameRef('ActionBar')
   if newstate == activestate then
      bar:SetAlpha(1)
      for i = 1, 12 do
         local b = self:GetFrameRef('ActionButton'..i)
         local key1 = b:GetAttribute('over_key1')
         local key2 = b:GetAttribute('over_key2')
         --print("Here", key1, key2, b:GetName())
         if key1 then b:SetBindingClick(true, key1, b:GetName(), "LeftButton") end
         if key2 then b:SetBindingClick(true, key2, b:GetName(), "LeftButton") end
      end
   else
      bar:SetAlpha(0.0)
   end
   bar:SetAttribute('state-page', newstate)
   self:SetAttribute('state-page', newstate)
   ]])
end

function HotbarMixin:AddStateHandler()
   self:SetAttribute('_onstate-hotbar-visibility', [[
      local actionbar = self:GetFrameRef('ActionBar')
      local shownstate = self:GetAttribute("shownstate")
      local activestate = self:GetAttribute("activestate")
      local swap = self:GetAttribute("swap")
      local expanded = self:GetAttribute("expanded")
      actionbar = self:GetFrameRef('ActionBar')
      if newstate == shownstate then
         RegisterStateDriver(actionbar, "visibility", "[petbattle]hide;show")
         if newstate == activestate then
            for i = 1, 12 do
               local b = self:GetFrameRef('ActionButton'..i)
               local key1 = b:GetAttribute('over_key1')
               local key2 = b:GetAttribute('over_key2')
               local key3 = b:GetAttribute('over_key3')
               --print("Here", key1, key2, b:GetName())
               if swap == 0 then
                  if key1 then b:SetBindingClick(true, key1, b:GetName(), "LeftButton") end
               else
                  if key2 then b:SetBindingClick(true, key2, b:GetName(), "LeftButton") end
               end
               if expanded == 1 then
                  if key3 then b:SetBindingClick(true, key3, b:GetName(), "LeftButton") end
               end
            end
         end
      else
         for i = 1, 12 do
            local b = self:GetFrameRef('ActionButton'..i)
            if b then b:ClearBindings() end
         end
         RegisterStateDriver(actionbar, "visibility", "[petbattle]hide;hide")
      end
   ]])
end

function HotbarMixin:AddExpandHandler()
   self:SetAttribute('_onstate-hotbar-expand', [[
      local actionbar = self:GetFrameRef('ActionBar')
      local activestate = self:GetAttribute("activestate")

      local enable = 0
      if newstate == 1 and (activestate == 1 or activestate == 3) then enable = 1 end 
      if newstate == 2 and (activestate == 2 or activestate == 4) then enable = 1 end

      self:SetAttribute("expanded", enable)

      if enable == 1 then
         for i = 1, 3 do
            local highlight = self:GetFrameRef('Highlight'..i)
            if highlight ~= nil then
               if i == 3 then
                  highlight:SetAlpha(1.0)
               else 
                  highlight:SetAlpha(0.0)
               end
            end
         end
      else
         for i = 1, 3 do
            local highlight = self:GetFrameRef('Highlight'..i)
            if highlight ~= nil then
               if i == 3 then
                  highlight:SetAlpha(0.0)
               else 
                  highlight:SetAlpha(1.0)
               end
            end
         end
      end

      if newstate ~= 0 then
         for i = 1, 12 do
            local b = self:GetFrameRef('ActionButton'..i)
            if i >= 9 and enable == 1 then 
               b:SetAlpha(1.0)
            else
               b:SetAlpha(0.5)
            end
         end
      else
         for i = 1, 12 do
            local b = self:GetFrameRef('ActionButton'..i)
            if i >= 9 then 
               b:SetAlpha(0.0)
            else
               b:SetAlpha(1.0)
            end
         end
      end
   ]])
end

function HotbarMixin:AddNextPageHandler()
   self:SetAttribute('_onstate-hotbar-nextpage', [[
      local activestate = self:GetAttribute("activestate")
      if activestate < 3 then
         local pageindex = self:GetAttribute("pageindex")
         local pageprefix = self:GetAttribute("pageprefix")

         pageindex = (pageindex + newstate)%10

         if pageindex == 0 then
            pageindex = 10
         end

         RegisterStateDriver(self, 'page', pageprefix .. pageindex)
      end
   ]])
end

function HotbarMixin:StopTargettingReticleAnim()
   local containers = { self.ActionBar:GetChildren() }
   for i,container in ipairs(containers) do
      local buttons = { container:GetChildren() }
      for j,button in ipairs(buttons) do
         if button ~= nil and button:GetName() ~= nil then
            if string.find(button:GetName(), "Button") then -- self.BtnPrefix 
               button.TargetReticleAnimFrame:Hide()
            end
         end
      end
   end
end
function HotbarMixin:UpdateHotbar()
   local parent_scaling = self:GetParent():GetScale()
   local bar = self[self.Type]
   if bar then
      local mxw = 0
      local mxh = 0
      
      local buttons = { self.ActionBar:GetChildren() }
      for i, button in ipairs(buttons) do
         if button ~= nil and button:GetName() ~= nil then
            if string.find(button:GetName(), self.BtnPrefix) then
               local width = math.ceil(button:GetWidth()+0.5)
               width = width + width%2
               local height = math.ceil(button:GetHeight()+0.5)
               height = height + height%2
               if mxw < width then mxw = width end
               if mxh < height then mxh = height end
            end
         end
      end
      
      local mxw = mxw+self.Padding
      local mxh = mxh+self.Padding
      
      self:SetSize(mxw*parent_scaling*12-4, mxh*parent_scaling)
      self.ActionBar:SetSize(mxw*parent_scaling*12-4, mxh*parent_scaling)
      
      local CHBar = {{0, 0}, {0, 0}, { 0, 0}}
      
      for i=1,3 do
         CHBar[i][1] = (bar.GrpPos[i][1]*mxw + bar.BtnOff[i][1]*self.Padding + bar.GrpOff[i][1] + 
                        (1.0 - self.Scaling)*bar.SclOff[i][1]*mxw)/self.Scaling;
         CHBar[i][2] = (bar.GrpPos[i][2]*mxh + bar.BtnOff[i][2]*self.Padding + bar.GrpOff[i][2] +
                        (1.0 - self.Scaling)*bar.SclOff[i][2]*mxh)/self.Scaling;
      end
      
      local anchor = nil
      local anchorIdx = 0
      
      
      local idx = 0
      self.AnchorButtons = {}
      for i, button in ipairs(buttons) do
         if button ~= nil and button:GetName() ~= nil then
            if string.find(button:GetName(), self.BtnPrefix) then
               if idx%4 == 0 then
                  anchorIdx = idx
                  anchor = button
                  button:SetScale(self.Scaling*parent_scaling)
                  button:ClearAllPoints()
                  button:SetPoint("BOTTOMLEFT", CHBar[(idx+4)/4][1], CHBar[(idx+4)/4][2])
                  table.insert(self.AnchorButtons, button)
               else
                  bIdx = idx-anchorIdx
                  button:SetScale(self.Scaling*parent_scaling)
                  button:ClearAllPoints()
                  button:SetPoint("CENTER", anchor, "CENTER", bar.BtnPos[bIdx][1]*mxw, bar.BtnPos[bIdx][2]*mxh)
               end
               idx = idx+1
            end
         end
      end
      
      if self.hasHighlights then
         if #self.Highlights == 0 then
            for i,anchor in ipairs(self.AnchorButtons) do
               local highlight = CreateFrame("Frame", self:GetName() .. "Highlight" .. i, anchor, "SecureHandlerBaseTemplate")
               local tex = highlight:CreateTexture(nil, "BACKGROUND")
               tex:SetAllPoints()
               tex:SetAtlas("AftLevelup-WhiteIconGlow")
               tex:SetVertexColor(0.88, 0.78, 0.68, 0.58)
               highlight:SetSize(5.0*mxw,3.5*mxh)
               highlight:SetFrameStrata("LOW")
               highlight:SetPoint("CENTER", anchor, "CENTER", -1*mxw, 0)
               highlight:SetFrameLevel(0) 
               table.insert(self.Highlights, highlight)
            end
         else
            for i,anchor in ipairs(self.AnchorButtons) do
               local highlight = self.Highlights[i]
               highlight:SetSize(5.0*mxw,3.5*mxh)
               highlight:SetFrameStrata("LOW")
               highlight:SetPoint("CENTER", anchor, "CENTER", -1*mxw, 0)
               highlight:SetFrameLevel(0) 
            end
         end
      end
      
      local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()  
      local w, h = self.ActionBar:GetSize()
      local s = self:GetScale()
      
      self.Locked = false
      self.ActionBar:SetScale(s)
      self.ActionBar:ClearAllPoints()
      self.ActionBar:SetPoint("BOTTOMLEFT", relativeTo, relativePoint, xOfs*s-w*0.5, yOfs*s-h*0.5)
      self.Locked = true
   end
end

function HotbarMixin:getGroupAnchors()
   local bar = self[self.Type]
   if bar then
      return  self.AnchorButtons
   end
end

function HotbarMixin:UpdateVisibility()
   self.ActionBar:UpdateGridLayout();
   self:UpdateHotbar();
end

function HotbarMixin:UpdateHotkeys(type)
   local containers = { self.ActionBar:GetChildren() }
   for i,container in ipairs(containers) do
      local buttons = { container:GetChildren() }
      for j, button in ipairs(buttons) do            
         if button ~= nil and button:GetName() ~= nil then      
            if string.find(button:GetName(), "Button") then --self.BtnPrefix
               button.HotKey:SetText(RANGE_INDICATOR);
               button.HotKey:Show();
            end
         end
      end
   end
end

function HotbarMixin:OnEvent(event, ...)
   if ( event == "PLAYER_ENTERING_WORLD" ) then
      self:UpdateHotbar();
      for i,highlight in ipairs(self.Highlights) do
         SecureHandlerSetFrameRef(self, 'Highlight'..i, highlight)
      end
   elseif ( event == "UPDATE_BINDINGS" or
            event == "GAME_PAD_ACTIVE_CHANGED" ) then
      self:UpdateHotkeys(self.buttonType);
   elseif ( event == "UNIT_SPELLCAST_RETICLE_CLEAR" or 
            event == "UNIT_SPELLCAST_EMPOWER_STOP" or 
            event == "UNIT_SPELLCAST_CHANNEL_STOP" or 
            event == "UNIT_SPELLCAST_INTERUPTED" or 
            event == "UNIT_SPELLCAST_SUCCEEDED" or 
            event == "UNIT_SPELLCAST_FAILED" or 
            event == "UNIT_SPELLCAST_SENT" or 
            event == "UNIT_SPELLCAST_STOP" ) then
      self:StopTargettingReticleAnim()
   end
end
