local ADDON, addon = ...
local config = addon.Config

local GamePadButtonList = addon.GamePadButtonList
local GamePadModifierList = addon.GamePadModifierList

local ActionList = {
   ["UNITNAVUP"] = true,
   ["UNITNAVDOWN"] = true,
   ["UNITNAVLEFT"] = true,
   ["UNITNAVRIGHT"] = true,
   ["CLEARTARGETING"] = true
}
config:ConfigListAdd("GamePadActions", ActionList, "NONE")
config:ConfigListAdd("GamePadModifierActions", ActionList, "NONE")

local GroupNavigatorMixin = {
   SoftTargetFrame = CrossHotbarAddon_GroupNavigator_SoftTarget,
   ActiveBindings = {}
}

function GroupNavigatorMixin:OnLoad()
   self:RegisterEvent("GROUP_JOINED")
   self:RegisterEvent("GROUP_LEFT")
   self:RegisterEvent("GROUP_ROSTER_UPDATE")
   self:RegisterEvent("PLAYER_ENTERING_WORLD")
   self:WrapOnClickDiscrete()
end

function GroupNavigatorMixin:OnEvent(event, ...)
   if event == "GROUP_JOINED" then
      self:updateRoster()
   elseif event == "GROUP_LEFT" then
      self:updateRoster()
      self.SoftTargetFrame:SetAlpha(0)
   elseif event == 'GROUP_ROSTER_UPDATE' then
      self:updateRoster()               
   elseif event == 'PLAYER_ENTERING_WORLD' then
      self:updateRoster()
      self:ApplyConfig()
      if ChatFrame1EditBox then
         ChatFrame1EditBox:SetAltArrowKeyMode(false)
      end
      local texCoords = { ["Raid-TargetFrame"] = { 0.00781250, 0.55468750, 0.28906250, 0.55468750 }}
      
      self.SoftTargetFrame.selectionHighlight:SetTexture("Interface\\RaidFrame\\Raid-FrameHighlights");
      self.SoftTargetFrame.selectionHighlight:SetTexCoord(unpack(texCoords["Raid-TargetFrame"]));
      self.SoftTargetFrame.selectionHighlight:SetVertexColor(0.2, 1.0, 0.6);
      self.SoftTargetFrame.selectionHighlight:SetAllPoints(self.SoftTargetFrame);
      
      local frameWidth = EditModeManagerFrame:GetRaidFrameWidth(true);
      local frameHeight = EditModeManagerFrame:GetRaidFrameHeight(true);
      
      self.SoftTargetFrame:SetSize(frameWidth+8, frameHeight+8)
      self.SoftTargetFrame:SetAlpha(0)
      self.SoftTargetFrame:Hide()
      
      SecureHandlerSetFrameRef(self, "softtarget", self.SoftTargetFrame)
      if UnitInRaid("player") or UnitInParty("player") then
         self:updateRoster()
      end
   end
end

function GroupNavigatorMixin:AddStateHandlers()
   self:SetAttribute("modstate", 0)
   self:SetAttribute("modname", "")
   
   self:SetAttribute("SetActionBindings",  [[
      local prefix = ...
      local binding = self:GetAttribute(prefix .. "UNITNAVUP")
      if binding and binding ~= "" then self:SetBindingClick(true, binding, self:GetName(), "Button4") end
      binding = self:GetAttribute(prefix .. "UNITNAVDOWN")                  
      if binding and binding ~= "" then self:SetBindingClick(true, binding, self:GetName(), "Button5") end
      binding = self:GetAttribute(prefix .. "UNITNAVLEFT")                  
      if binding and binding ~= "" then self:SetBindingClick(true, binding, self:GetName(), "LeftButton") end
      binding = self:GetAttribute(prefix .. "UNITNAVRIGHT")
      if binding and binding ~= "" then self:SetBindingClick(true, binding, self:GetName(), "RightButton") end
      binding = self:GetAttribute(prefix .. "CLEARTARGETING")                  
      if binding and binding ~= "" then self:SetBindingClick(true, binding, self:GetName(), "MiddleButton") end
   ]])

   self:SetAttribute("_onstate-trigger", [[
      local modstate = self:GetAttribute("modstate")
      if newstate ~= 4 then
         if modstate == 0 then
            self:SetAttribute("modstate", 1)
         end
      else
         if modstate == 1 then
            self:SetAttribute("modstate", 0)
         end
         local modname = self:GetAttribute("modname")
         self:RunAttribute("SetActionBindings", modname)
      end
   ]])

   self:SetAttribute("_onstate-shoulder", [[
      local modstate = self:GetAttribute("modstate")
      if modstate == 0 or modstate == 2 then
         if newstate == 6 or newstate == 3 or newstate == 2 then
            self:SetAttribute("modstate", 2)
            self:SetAttribute("modname", "SPADL")
            self:RunAttribute("SetActionBindings", "SPADL")
         elseif newstate == 7 or newstate == 5 or newstate == 1 then
            self:SetAttribute("modstate", 2)
            self:SetAttribute("modname", "SPADR")
            self:RunAttribute("SetActionBindings", "SPADL")
         else
            self:ClearBindings()
            self:SetAttribute("modstate", 0)
            self:SetAttribute("modname", "")
            self:RunAttribute("SetActionBindings", "")
         end
      end
   ]])
   
   self:SetAttribute("_onstate-paddle", [[
      local modstate = self:GetAttribute("modstate")
      if modstate == 0 or modstate == 3 then
         if newstate == 6 or newstate == 3 or newstate == 2 then
            self:SetAttribute("modstate", 3)
            self:SetAttribute("modname", "PPADL")
            self:RunAttribute("SetActionBindings", "PPADL")
         elseif newstate == 7 or newstate == 5 or newstate == 1 then
            self:SetAttribute("modstate", 3)
            self:SetAttribute("modname", "SPADR")
            self:RunAttribute("SetActionBindings", "PPADL")
         else
            self:ClearBindings()
            self:SetAttribute("modstate", 0)
            self:SetAttribute("modname", "")
            self:RunAttribute("SetActionBindings", "")
         end
      end
   ]])
end

function GroupNavigatorMixin:ClearConfig()
   for action in pairs(ActionList) do
      self:SetAttribute(action, "")
      for i,modifier in ipairs(GamePadModifierList) do
         self:SetAttribute(modifier .. action, "")
      end
   end
end

function GroupNavigatorMixin:ApplyConfig()
   self:ClearConfig()
   self.ActiveBindings = {}
   for button, attributes in pairs(config.PadActions) do
      if ActionList[ attributes.ACTION ] then
         self:SetAttribute(attributes.ACTION, attributes.BIND)
      end
      
      for i,modifier in ipairs(GamePadModifierList) do
         if ActionList[ attributes[modifier .. "ACTION"] ] then
            self:SetAttribute(modifier .. attributes[modifier .. "ACTION"], attributes.BIND)
         end
      end
   end
   self:Execute([[ self:ClearBindings(); self:RunAttribute("SetActionBindings", "") ]])
end

function GroupNavigatorMixin:updateRoster() 
   if not InCombatLockdown() then 
      local raid_id = UnitInRaid("player")
      if raid_id then
         
         local raid_units = {}
         for i=1, 40 do
            table.insert(raid_units, "raid"..i)
         end
         
         if CompactRaidFrameContainer.groupMode == "flush" then
            table.sort(raid_units, CompactRaidFrameContainer.flowSortFunc);
         end
         
         local raid_size = GetNumGroupMembers()
         
         local player_unit = "1"
         local player_group = "1"
         
         group_units = {}
         for i = 1, raid_size do  
            local id = tonumber(string.sub(raid_units[i], 5));
            name, rank, subgroup = GetRaidRosterInfo(id);
            if group_units[subgroup] == nil then group_units[subgroup] = {} end
            table.insert(group_units[subgroup], raid_units[i])
            if id == raid_id then 
               player_unit = tostring(table.getn(group_units[subgroup]))
               player_group = tostring(subgroup)
            end
         end
         
         local r_str = ""
         for i, group in ipairs(group_units) do
            r_str = r_str .. "["
            for j, unit in ipairs(group) do
               r_str = r_str .. " " .. unit
            end
            r_str = r_str .. "]"
         end
         
         self:SetAttribute("player_unit", player_unit)
         self:SetAttribute("player_group", player_group)
         self:SetAttribute("group_change", "true")
         self:SetAttribute("group_units", r_str) 
         self:AddUnitFrameRefs()
      elseif UnitInParty("player") then
         local party_size = GetNumGroupMembers()
         
         local party_units = {}
         table.insert(party_units, "player")
         for i=2, 5 do
            table.insert(party_units, "party"..(i-1))
         end
         
         if CompactRaidFrameContainer.groupMode == "flush" then
            table.sort(party_units, CompactRaidFrameContainer.flowSortFunc);
         end
         
         local player_unit = "1"
         local p_str = ""
         for i = 1, party_size do
            if party_units[i] == "player" then 
               player_unit = tostring(i)
            end
            if (i-1) % party_size == 0 then
               p_str = p_str .. "["
            end
            p_str = p_str .. " " .. party_units[i]
            if i % party_size == 0 then
               p_str = p_str .. "]"
            end
         end
         
         self:SetAttribute("player_unit", player_unit)
         self:SetAttribute("player_group", "1")
         self:SetAttribute("group_change", "true")
         self:SetAttribute("group_units", p_str)
         self:AddUnitFrameRefs()
      end
   end
end

function GroupNavigatorMixin:AddUnitFrameRefs()

   local inparty = true
   local groupType = CompactRaidGroupTypeEnum.Party;
   if UnitInRaid("player") then 
      inparty = false
      groupType = CompactRaidGroupTypeEnum.Raid;
   end 

   if CompactRaidFrameContainer.groupMode == "flush" then
      for _,frame in pairs(CompactRaidFrameContainer.flowFrames) do
         if frame.unit then
            SecureHandlerSetFrameRef(self, frame.unit, frame)
         end
      end
      self:WrapOnClickFlush()
   else
      if inparty == false then
         for i = 1,8 do
            for j = 1,5 do
               local frame = _G["CompactRaidGroup"..i.."Member"..j]
               if frame and frame:IsVisible() then 
                  local frame_unit = frame:GetAttribute("unit")
                  if frame_unit then
                     SecureHandlerSetFrameRef(self, i .. "_" .. j, frame)
                  end
               end
            end
         end
      else
         for j = 1,5 do
            local frame = _G["CompactPartyFrameMember"..j]
            if frame and frame:IsVisible() then
               local frame_unit = frame:GetAttribute("unit")
               if frame_unit then
                  SecureHandlerSetFrameRef(self, "1_" .. j, frame)
               end
            end
         end
      end
      self:WrapOnClickDiscrete()
   end
   
   local frameWidth = EditModeManagerFrame:GetRaidFrameWidth(groupType);
   local frameHeight = EditModeManagerFrame:GetRaidFrameHeight(groupType);
   self.SoftTargetFrame:SetSize(frameWidth+8, frameHeight+8)
   --self.SoftTargetFrame:SetAlpha(0)
   self.SoftTargetFrame:Show()
   
   SecureHandlerSetFrameRef(self, "softtarget", self.SoftTargetFrame)
end

function GroupNavigatorMixin:WrapOnClickDiscrete()
   SecureHandlerUnwrapScript(self, "OnClick")
   SecureHandlerWrapScript(self, "OnClick", self,  [[
   if not lastunit then lastunit = 1 end
   if not lastgroup then lastgroup = 1 end
   
   local newunit = "player"
   local player_unit = tonumber(self:GetAttribute("player_unit"))
   local player_group = tonumber(self:GetAttribute("player_group"))
   
   local group_units = table.new()
   for x = 1,8 do
      local newgroup = true
      for y = 1,5 do
         local frame = self:GetFrameRef(x .. "_" .. y)
         if frame and frame:IsVisible() then 
            if newgroup then 
               group_units[#group_units + 1] = table.new()
               newgroup = false
            end
            table.insert(group_units[#group_units], frame)
         end
      end
   end
   local num_groups = #group_units
   if num_groups > 0 then 
      if lastgroup > num_groups then
         lastgroup = num_groups
      end
      local num_units = #(group_units[lastgroup])
      if num_units > 0 then
         if lastunit > num_units then
            lastunit = num_units
         end
      end
   end
   local num_groups = #group_units
   if num_groups > 0 then 
      local num_units = #(group_units[lastgroup])
      if num_units > 0 then
         if PlayerInGroup() == "party" or PlayerInGroup() == "raid" then
            
            local unitfound = false
            local softtarget = self:GetFrameRef("softtarget")
            local frame = group_units[lastgroup][lastunit]
            if softtarget then
               if frame and frame:IsVisible() then
                  if softtarget:GetParent() == frame then
                     unitfound = true
                  end
               end
            end
            
            if unitfound then
               if UnitPlayerOrPetInRaid("target") or
                  UnitPlayerOrPetInParty("target") then      
                  if button == "Button4" then
                     lastunit = (lastunit + num_units - 1) % num_units
                  elseif button == "Button5" then
                     lastunit = (lastunit + 1) % num_units
                  elseif button == "LeftButton" then
                     lastgroup = (lastgroup + num_groups - 1) % num_groups
                  elseif button == "RightButton" then
                     lastgroup = (lastgroup + 1) % num_groups
                  end
                  
                  if lastgroup == 0 then
                     lastgroup = num_groups
                  end
                  
                  num_units = #(group_units[lastgroup])
                  
                  if lastunit > num_units then
                     lastunit = num_units
                  elseif lastunit == 0 then
                     lastunit = num_units
                  end
               end
            else 
               lastgroup = player_group
               lastunit = player_unit
            end
            
            frame = group_units[lastgroup][lastunit]
            if frame and frame:IsVisible() then
               newunit = frame:GetAttribute("unit")
               self:SetAttribute("unit", newunit)
               if softtarget then
                  softtarget:SetParent(frame)
                  softtarget:ClearAllPoints()
                  softtarget:SetPoint("CENTER", frame, "CENTER")
                  softtarget:SetAlpha(0.75)
               end
            elseif softtarget then               
               softtarget:SetAlpha(0)
            end
            
         else
            self:SetAttribute("unit", newunit)
         end
      else
         self:SetAttribute("unit", newunit)
      end
   else
      self:SetAttribute("unit", newunit)
   end
   ]])
end

function GroupNavigatorMixin:WrapOnClickFlush()
   SecureHandlerUnwrapScript(self, "OnClick")
   SecureHandlerWrapScript(self, "OnClick", self,  [[
   if not lastunit then lastunit = 1 end
   if not lastgroup then lastgroup = 1 end
   if not group_units then group_units = table.new() end
   local newunit = "player"
   local player_unit = tonumber(self:GetAttribute("player_unit"))
   local player_group = tonumber(self:GetAttribute("player_group"))
   if self:GetAttribute("group_change") == "true" then
      local g_str = self:GetAttribute("group_units")
      group_units = table.new()
      local i = 1
      for subgrp in string.gmatch(g_str, "%[([%w+%s]+)%]") do 
         group_units[i] = table.new()
         local j = 1
         for unitid in string.gmatch(subgrp, "%w+") do 
            table.insert(group_units[i], unitid)
            j = j + 1
         end
         i = i + 1
      end
      local num_groups = #group_units
      if num_groups > 0 then 
         if lastgroup > num_groups then
            lastgroup = num_groups
         end
         local num_units = #(group_units[lastgroup])
         if num_units > 0 then
            if lastunit > num_units then
               lastunit = num_units
            end
         end
      end
      self:SetAttribute("group_change", "false")
   end
   
   local num_groups = #group_units
   if num_groups > 0 then 
      local num_units = #(group_units[lastgroup])
      if num_units > 0 then
         if PlayerInGroup() == "party" or PlayerInGroup() == "raid" then
            
            local unitfound = false
            local softtarget = self:GetFrameRef("softtarget")
            if softtarget then
               local frame = self:GetFrameRef(group_units[lastgroup][lastunit])
               if frame and frame:IsVisible() then
                  local frame_unit = frame:GetAttribute("unit")
                  if frame_unit == group_units[lastgroup][lastunit] then
                     unitfound = true
                  end
               end
            end
            
            if unitfound then
               if UnitPlayerOrPetInRaid("target") or
                  UnitPlayerOrPetInParty("target") then      
                  if button == "Button4" then
                     lastunit = (lastunit + num_units - 1) % num_units
                  elseif button == "Button5" then
                     lastunit = (lastunit + 1) % num_units
                  elseif button == "LeftButton" then
                     lastgroup = (lastgroup + num_groups - 1) % num_groups
                  elseif button == "RightButton" then
                     lastgroup = (lastgroup + 1) % num_groups
                  end
                  
                  if lastgroup == 0 then
                     lastgroup = num_groups
                  end
                  
                  num_units = #(group_units[lastgroup])
                  
                  if lastunit > num_units then
                     lastunit = num_units
                  elseif lastunit == 0 then
                     lastunit = num_units
                  end
               end
            else 
               lastgroup = player_group
               lastunit = player_unit
            end
            
            newunit = group_units[lastgroup][lastunit]
            self:SetAttribute("unit", newunit)
               
            if softtarget then
               local found = false
               local frame = self:GetFrameRef(newunit)
               if frame and frame:IsVisible() then
                  local frame_unit = frame:GetAttribute("unit")
                  if frame_unit == newunit then
                     softtarget:SetParent(frame)
                     softtarget:ClearAllPoints()
                     softtarget:SetPoint("CENTER", frame, "CENTER")
                     softtarget:SetAlpha(0.75)
                     found = true
                  end
               end
               if found == false then
                  softtarget:SetAlpha(0)
               end
            end
         else
            self:SetAttribute("unit", newunit)
         end
      else
         self:SetAttribute("unit", newunit)
      end
   else
      self:SetAttribute("unit", newunit)
   end
   ]])
end

local CreateGroupNavigator = function(parent)
   local GroupNavigator = CreateFrame("Button", ADDON .. "GroupNavigator", parent,
                                      "SecureActionButtonTemplate, SecureHandlerStateTemplate")

   Mixin(GroupNavigator, GroupNavigatorMixin)

   GroupNavigator:SetFrameStrata("BACKGROUND")
   GroupNavigator:SetPoint("TOP", parent:GetName(), "LEFT", 0, 0)
   GroupNavigator:Hide()

   GroupNavigator:SetAttribute("player_unit", "1")
   GroupNavigator:SetAttribute("player_group", "1")
   GroupNavigator:SetAttribute("*type1", "target")
   GroupNavigator:SetAttribute("*type2", "target")
   GroupNavigator:SetAttribute("*type3", "macro")
   GroupNavigator:SetAttribute("*type4", "target")
   GroupNavigator:SetAttribute("*type5", "target")
   GroupNavigator:SetAttribute("unit", "player")
   GroupNavigator:SetAttribute("group_change", "true")
   GroupNavigator:SetAttribute("group_units", "[player party1 party2 party3 party4]")
   GroupNavigator:SetAttribute("macrotext3", "/cleartarget\n/stopspelltarget\n")

   GroupNavigator:AddStateHandlers()

   GroupNavigator:HookScript("OnEvent", GroupNavigator.OnEvent)
   GroupNavigator:OnLoad()

   addon.GroupNavigator = GroupNavigator
end

addon.CreateGroupNavigator = CreateGroupNavigator
