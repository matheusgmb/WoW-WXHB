local ADDON, addon = ...

local config = addon.Config
local preset = CrossHotbar_DB.ActivePreset

local function BindingsToStr(bindings)
   return table.concat(bindings, " ")
end

local function StrToBindings(text)
   bindings = {}
   for binding in text:gmatch("%S+") do
      table.insert(bindings, binding)
   end
   return bindings
end

local function Intersection(l1, l2)
   local matches = {}
   local map = {}
   for i,item in ipairs(l2) do
      map[item] = true
   end
   for i,item in ipairs(l1) do
      if map[item] then
         table.insert(matches, item)
         map[item] = false
      end
   end
   return matches
end

local function ActionDropDownDemo_OnClick(self, arg1, arg2, checked)
   local newaction = self:GetText()
   local currentaction = config.PadActions[arg1].ACTION
   if currentaction ~= newaction then
      for button, attributes in pairs(config.PadActions) do
         if button ~= arg1 then
            if attributes.ACTION == newaction then
               config.PadActions[button].ACTION = currentaction
               break
            end
         end
      end
      config.PadActions["arg1"].ACTION = newaction
   end
   UIDropDownMenu_SetText(arg2, newaction)
end
   
StaticPopupDialogs["CROSSHOTBAR_ENABLEGAMEPAD"] = {
   text = [[This config requires GamePad mode enabled.
CVar GamePadEnable is 0.
Click "Enable" to enable or use the Console command:
"/console GamePadEnable 1"]],
  button1 = "Enable",
  button2 = "Cancel",
  OnAccept = function()
     print("Enabled")
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3
}

local Locale = {
   LeftModifierToolTip = "Configures left modifier (CTRL) button binding. This modifier enables the left side of the Cross Hotbar",
   RightModifierToolTip = "Configures right modifier (SHIFT) button binding. This modifier enables the right side of the Cross Hotbar",
   SwapTypeToolTip=[[Sets the unsage of the swap modifier.

"disable":
       Swap button behaviour is unchanged.

"DPad to Face":
       DPad buttons will be map to the face buttons when held.

"Expanded to Face":
       Action buttons [9-12] will be map to the Face buttons when held.

"DPad on Face only":
       Action buttons [9-12] are bound to the DPad.
       When held the DPad is mapped to the Face buttons with actions [5-8].
]]
}

local ConfigUI = {
   Inset = 16,
   ConfigSpacing = 20,
   TextHeight = 20,
   ButtonWidth = 80,
   ButtonHeight = 20,
   DropDownSpacing = 60,
   EditBoxHeight = 30,
   EditBoxSpacing = 30,
   InterfaceFrame = nil,
   ApplyCallbacks = {},
   RefreshCallbacks = {}
}

function ConfigUI:AddToolTip(frame, text, wrap)
   frame:SetScript("OnEnter", function(self)
     GameTooltip:SetOwner(self, "ANCHOR_TOP")
     GameTooltip:ClearLines()
     GameTooltip:SetText(text, 1, 1, 1, 1, wrap)
   end)
   frame:SetScript("OnLeave", function(self)
     GameTooltip:SetOwner(WorldFrame, "ANCHOR_LEFT")
     GameTooltip:ClearLines()
   end)
end

function ConfigUI:Refresh()
   if not ConfigUI.InterfaceFrame:IsVisible() then return end
   
   config:ProcessConfig(config)

   for i,callback in ipairs(ConfigUI.RefreshCallbacks) do
      callback()
   end

   addon.GamePadButtons:ApplyConfig()
   addon.GroupNavigator:ApplyConfig()
   addon.Crosshotbar:ApplyConfig()
end

function ConfigUI:Apply()
  
   if GetCVar('GamePadEnable') == "0" then
      StaticPopup_Show ("CROSSHOTBAR_ENABLEGAMEPAD")
   end
   
   for i,callback in ipairs(ConfigUI.ApplyCallbacks) do
      callback()
   end
   
   ConfigUI:Refresh()
end

function ConfigUI:CreateFrame()
   self.InterfaceFrame = CreateFrame("Frame", ADDON .. "ConfigFrame", InterfaceOptionsFramePanelContainer)
   self.InterfaceFrame.name = ADDON
   self.InterfaceFrame:Hide()

   self.InterfaceFrame:SetScript("OnShow", function(InterfaceFrame)
      local scrollFrame = CreateFrame("ScrollFrame", nil, self.InterfaceFrame, "UIPanelScrollFrameTemplate")
      scrollFrame:SetPoint("TOPLEFT", 3, -4)
      scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)
      
      local scrollChild = CreateFrame("Frame")
      scrollFrame:SetScrollChild(scrollChild)
      scrollChild:SetWidth(self.InterfaceFrame:GetWidth()-self.Inset)
      scrollChild:SetHeight(1) 
      
      local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
      title:SetPoint("TOPLEFT", self.Inset, -self.Inset)
      title:SetText("CrossHotbar")

      local anchor = title
      anchor = ConfigUI:CreatePresets(scrollChild, anchor)
      anchor = ConfigUI:CreateApply(scrollChild, anchor)
      anchor = ConfigUI:CreateTriggers(scrollChild, anchor)
      anchor = ConfigUI:CreateFeatures(scrollChild, anchor)
      anchor = ConfigUI:CreateBindings(scrollChild, anchor)

      self.InterfaceFrame:SetScript("OnShow", ConfigUI.Refresh) 
      ConfigUI:Refresh()
   end)

   InterfaceOptions_AddCategory(self.InterfaceFrame)
end

--[[
   Apply button.
--]]

function ConfigUI:CreateApply(configFrame, anchorFrame)
   local applybutton = CreateFrame("Button", ADDON .. "ApplyButton", configFrame, "UIPanelButtonTemplate")
   applybutton:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", -self.Inset, -self.Inset)
   applybutton:SetHeight(self.ButtonHeight)
   applybutton:SetWidth(configFrame:GetWidth() + -2*self.Inset)
   applybutton:SetText("Apply")
   
   applybutton:SetScript("OnClick", ConfigUI.Apply)
   return applybutton
end

--[[
   Presets
--]]

function ConfigUI:CreatePresets(configFrame, anchorFrame)
   local DropDownWidth = configFrame:GetWidth()/3 - 2*self.Inset
   local presetsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   presetsubtitle:SetHeight(self.TextHeight)
   presetsubtitle:SetWidth(DropDownWidth)
   presetsubtitle:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -self.ConfigSpacing)
   presetsubtitle:SetNonSpaceWrap(true)
   presetsubtitle:SetJustifyH("LEFT")
   presetsubtitle:SetJustifyV("TOP")
   presetsubtitle:SetText("Presets")
   
   local PresetsFrame = CreateFrame("Frame", ADDON .. "PresetDropDownMenu", configFrame, "UIDropDownMenuTemplate")
   PresetsFrame:SetPoint("TOPLEFT", presetsubtitle, "BOTTOMLEFT", 0, 0)
   
   UIDropDownMenu_SetWidth(PresetsFrame, DropDownWidth-self.DropDownSpacing)
   UIDropDownMenu_SetText(PresetsFrame, "Presets")
   
   local function PresetDropDownDemo_OnClick(self, arg1, arg2, checked)
      if preset ~= arg1 then
         preset = arg1
         ConfigUI:Refresh()
      end
   end
   
   UIDropDownMenu_Initialize(PresetsFrame, function(self, level, menuList)     
      local info = UIDropDownMenu_CreateInfo()
      UIDropDownMenu_SetText(self, "")
      if (level or 1) == 1 then
         local presets = CrossHotbar_DB.Presets
         for i,p in ipairs(presets) do
            info.text, info.checked = p.Name, preset == i
            info.menuList, info.hasArrow = i, false
            info.arg1 = i
            info.arg2 = self
            info.func = PresetDropDownDemo_OnClick
            UIDropDownMenu_AddButton(info)
            if preset == i then 
               UIDropDownMenu_SetText(self, config.Name)
            end
         end
      end
   end)
   
   local presetloadbutton = CreateFrame("Button", ADDON .. "PresetLoad", configFrame, "UIPanelButtonTemplate")
   presetloadbutton:SetPoint("TOPLEFT", PresetsFrame, "TOPRIGHT", 0, 0)
   presetloadbutton:SetHeight(self.ButtonHeight)
   presetloadbutton:SetWidth(self.ButtonWidth)
   presetloadbutton:SetText("Load")
   
   presetloadbutton:SetScript("OnClick", function(self, button, down)
      config:StorePreset(config, CrossHotbar_DB.Presets[preset])
      ConfigUI:Refresh()
   end)
   
   local presetdeletebutton = CreateFrame("Button", ADDON .. "PresetDelete", configFrame, "UIPanelButtonTemplate")
   presetdeletebutton:SetPoint("TOPLEFT", presetloadbutton, "TOPRIGHT", 0, 0)
   presetdeletebutton:SetHeight(self.ButtonHeight)
   presetdeletebutton:SetWidth(self.ButtonWidth)
   presetdeletebutton:SetEnabled(false)
   presetdeletebutton:SetText("Delete")

   presetdeletebutton:SetScript("OnClick", function(self, button, down)
      if CrossHotbar_DB.Presets[preset].Mutable then
         table.remove(CrossHotbar_DB.Presets, preset)
         preset = preset + 1
         if preset > #CrossHotbar_DB.Presets then             
            preset = #CrossHotbar_DB.Presets
         end
         CrossHotbar_DB.ActivePreset = preset
      end
      config.Name = "Custom"
      config:StorePreset(config, CrossHotbar_DB.Presets[preset])
      ConfigUI:Refresh()
   end)
   
   local presetfileeditbox = CreateFrame("EditBox", ADDON .. "PresetFileEditBox", configFrame, "InputBoxTemplate")
   presetfileeditbox:SetPoint("LEFT", presetdeletebutton, "RIGHT", 40, 0)
   presetfileeditbox:SetWidth(100)
   presetfileeditbox:SetHeight(self.EditBoxHeight)
   presetfileeditbox:SetMovable(false)
   presetfileeditbox:SetAutoFocus(false)
   presetfileeditbox:EnableMouse(true)
   presetfileeditbox:SetText(config.Name)
   
   local presetsavebutton = CreateFrame("Button", ADDON .. "PresetSave", configFrame, "UIPanelButtonTemplate")
   presetsavebutton:SetPoint("LEFT", presetfileeditbox, "RIGHT", 10, 0)
   presetsavebutton:SetHeight(self.ButtonHeight)
   presetsavebutton:SetWidth(self.ButtonWidth)
   presetsavebutton:SetText("Save")
   
   presetsavebutton:SetScript("OnClick", function(self, button, down)
      local foundpreset = 0
      for i,p in ipairs(CrossHotbar_DB.Presets) do
         if p.Name == presetfileeditbox:GetText() then
            foundpreset = i
         end
      end
      if foundpreset == 0 then
         config.Name = presetfileeditbox:GetText()
         local newpreset = {
            Mutable = true
         }
         config:StorePreset(newpreset, config)
         table.insert(CrossHotbar_DB.Presets, newpreset)
         preset = #CrossHotbar_DB.Presets
         CrossHotbar_DB.ActivePreset = preset
      elseif CrossHotbar_DB.Presets[foundpreset].Mutable then
         preset = foundpreset
         CrossHotbar_DB.ActivePreset = preset
         config:StorePreset(CrossHotbar_DB.Presets[preset], config)
      end
      ConfigUI:Refresh()
   end)

   table.insert(self.RefreshCallbacks, function()
                   presetdeletebutton:SetEnabled(CrossHotbar_DB.Presets[preset].Mutable)
                   presetfileeditbox:SetText(config.Name)
                   UIDropDownMenu_SetText(PresetsFrame, CrossHotbar_DB.Presets[preset].Name)
   end)
   
   return PresetsFrame
end

--[[
   Trigger button actions
--]]

function ConfigUI:CreateTriggers(configFrame, anchorFrame)
   local DropDownWidth = (configFrame:GetWidth() - 2*self.Inset)/3
   local leftsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   leftsubtitle:SetHeight(self.TextHeight)
   leftsubtitle:SetWidth(DropDownWidth)
   leftsubtitle:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -self.ConfigSpacing)
   leftsubtitle:SetNonSpaceWrap(true)
   leftsubtitle:SetJustifyH("LEFT")
   leftsubtitle:SetJustifyV("TOP")
   leftsubtitle:SetText("Left Trigger")

   local rightsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   rightsubtitle:SetHeight(self.TextHeight)
   rightsubtitle:SetWidth(DropDownWidth)
   rightsubtitle:SetPoint("TOPLEFT", leftsubtitle, "TOPRIGHT", 0, 0)
   rightsubtitle:SetNonSpaceWrap(true)
   rightsubtitle:SetJustifyH("LEFT")
   rightsubtitle:SetJustifyV("TOP")
   rightsubtitle:SetText("Right Trigger")
   
   local lefttriggerframe = CreateFrame("Frame", ADDON .. "LeftTriggerDropDownMenu", configFrame, "UIDropDownMenuTemplate")
   lefttriggerframe:SetPoint("TOPLEFT", leftsubtitle, "BOTTOMLEFT", 0, 0)
   
   UIDropDownMenu_SetWidth(lefttriggerframe, DropDownWidth-self.DropDownSpacing)
   UIDropDownMenu_SetText(lefttriggerframe, "LeftTrigger")
   UIDropDownMenu_JustifyText(lefttriggerframe, "RIGHT")
   UIDropDownMenu_Initialize(lefttriggerframe, function(self, level, menuList)     
      local info = UIDropDownMenu_CreateInfo()
      UIDropDownMenu_SetText(self, "")
      if (level or 1) == 1 then
         local a = config.PadActions
         local actions = {a.TRIGL.ACTION, a.TRIGR.ACTION, a.SPADL.ACTION, a.SPADR.ACTION, a.PPADL.ACTION, a.PPADR.ACTION}
         for _,action in ipairs(actions) do
            info.text, info.checked = action, (a.TRIGL.ACTION == action)
            info.menuList, info.hasArrow = i, false
            info.arg1, info.arg2 = "left", self
            info.func = ActionDropDownDemo_OnClick
            UIDropDownMenu_AddButton(info)
            if (a.TRIGL.ACTION == action) then 
               UIDropDownMenu_SetText(self, action)
            end
         end
      end
   end)

   local righttriggerframe = CreateFrame("Frame", ADDON .. "RightTriggerDropDownMenu", configFrame, "UIDropDownMenuTemplate")
   righttriggerframe:SetPoint("TOPLEFT", rightsubtitle, "BOTTOMLEFT", 0, 0)
   
   UIDropDownMenu_SetWidth(righttriggerframe, DropDownWidth-self.DropDownSpacing)
   UIDropDownMenu_SetText(righttriggerframe, "RightTrigger")
   UIDropDownMenu_JustifyText(righttriggerframe, "RIGHT")
   UIDropDownMenu_Initialize(righttriggerframe, function(self, level, menuList)     
      local info = UIDropDownMenu_CreateInfo()
      UIDropDownMenu_SetText(self, "")
      if (level or 1) == 1 then
         local a = config.PadActions
         local actions = {a.TRIGL.ACTION, a.TRIGR.ACTION, a.SPADL.ACTION, a.SPADR.ACTION, a.PPADL.ACTION, a.PPADR.ACTION}
         for _,action in ipairs(actions) do
            info.text, info.checked = action, (a.TRIGR.ACTION == action)
            info.menuList, info.hasArrow = i, false
            info.arg1, info.arg2 = "left", self
            info.func = ActionDropDownDemo_OnClick
            UIDropDownMenu_AddButton(info)
            if (a.TRIGR.ACTION == action) then 
               UIDropDownMenu_SetText(self, action)
            end
         end
      end
   end)

   ConfigUI:AddToolTip(lefttriggerframe, Locale.LeftModifierToolTip, true)
   ConfigUI:AddToolTip(righttriggerframe, Locale.RightModifierToolTip, true)
   
   table.insert(self.RefreshCallbacks, function()
       UIDropDownMenu_SetText(lefttriggerframe, config.PadActions.TRIGL.ACTION)
       UIDropDownMenu_SetText(righttriggerframe, config.PadActions.TRIGR.ACTION)
   end)
   
   return lefttriggerframe
end

--[[
   Bindings UI
--]]

function ConfigUI:CreateBindings(configFrame, anchorFrame)
    --[[
       Face button bindings
    --]]
    
   local EditBoxWidth = configFrame:GetWidth() - 2*self.Inset
   local facebindsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   facebindsubtitle:SetHeight(self.TextHeight)
   facebindsubtitle:SetWidth(EditBoxWidth)
   facebindsubtitle:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -self.ConfigSpacing)
   facebindsubtitle:SetNonSpaceWrap(true)
   facebindsubtitle:SetJustifyH("LEFT")
   facebindsubtitle:SetJustifyV("TOP")
   facebindsubtitle:SetText("Face button bindings")
   
   local facebuttonseditbox = CreateFrame("EditBox", ADDON .. "FaceButtonsEditBox", configFrame, "InputBoxTemplate")
   facebuttonseditbox:SetPoint("TOPLEFT", facebindsubtitle, "BOTTOMLEFT", self.Inset, 0)
   facebuttonseditbox:SetWidth(EditBoxWidth-self.EditBoxSpacing)
   facebuttonseditbox:SetHeight(self.EditBoxHeight)
   facebuttonseditbox:SetMovable(false)
   facebuttonseditbox:SetAutoFocus(false)
   facebuttonseditbox:EnableMouse(true)

   --[[
      Dpad button bindings
   --]]
   
   local dpadbindsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   dpadbindsubtitle:SetHeight(self.TextHeight)
   dpadbindsubtitle:SetWidth(EditBoxWidth)
   dpadbindsubtitle:SetPoint("TOPLEFT", facebuttonseditbox, "BOTTOMLEFT", -self.Inset, -self.Inset)
   dpadbindsubtitle:SetNonSpaceWrap(true)
   dpadbindsubtitle:SetJustifyH("LEFT")
   dpadbindsubtitle:SetJustifyV("TOP")
   dpadbindsubtitle:SetText("DPad button bindings")
   
   local dpadbuttonseditbox = CreateFrame("EditBox", ADDON .. "DPadButtonsEditBox", configFrame, "InputBoxTemplate")
   dpadbuttonseditbox:SetPoint("TOPLEFT", dpadbindsubtitle, "BOTTOMLEFT", self.Inset, 0)
   dpadbuttonseditbox:SetWidth(EditBoxWidth-self.EditBoxSpacing)
   dpadbuttonseditbox:SetHeight(self.EditBoxHeight)
   dpadbuttonseditbox:SetMovable(false)
   dpadbuttonseditbox:SetAutoFocus(false)
   dpadbuttonseditbox:EnableMouse(true)
   
   --[[
      TPad button bindings
   --]]
   
   local tpadbindsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   tpadbindsubtitle:SetHeight(self.TextHeight)
   tpadbindsubtitle:SetWidth(EditBoxWidth)
   tpadbindsubtitle:SetPoint("TOPLEFT", dpadbuttonseditbox, "BOTTOMLEFT", -self.Inset, -self.Inset)
   tpadbindsubtitle:SetNonSpaceWrap(true)
   tpadbindsubtitle:SetJustifyH("LEFT")
   tpadbindsubtitle:SetJustifyV("TOP")
   tpadbindsubtitle:SetText("Left Right Trigger & Shoulder bindings")
   
   local tpadbuttonseditbox = CreateFrame("EditBox", ADDON .. "TPadButtonsEditBox", configFrame, "InputBoxTemplate")
   tpadbuttonseditbox:SetPoint("TOPLEFT", tpadbindsubtitle, "BOTTOMLEFT", self.Inset, 0)
   tpadbuttonseditbox:SetWidth(EditBoxWidth-self.EditBoxSpacing)
   tpadbuttonseditbox:SetHeight(self.EditBoxHeight)
   tpadbuttonseditbox:SetMovable(false)
   tpadbuttonseditbox:SetAutoFocus(false)

   --[[
      SPad button bindings
   --]]
   
   local spadbindsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   spadbindsubtitle:SetHeight(self.TextHeight)
   spadbindsubtitle:SetWidth(EditBoxWidth)
   spadbindsubtitle:SetPoint("TOPLEFT", tpadbuttonseditbox, "BOTTOMLEFT", -self.Inset, -self.Inset)
   spadbindsubtitle:SetNonSpaceWrap(true)
   spadbindsubtitle:SetJustifyH("LEFT")
   spadbindsubtitle:SetJustifyV("TOP")
   spadbindsubtitle:SetText("Left Right Stick & Paddle bindings")
   
   local spadbuttonseditbox = CreateFrame("EditBox", ADDON .. "SPadButtonsEditBox", configFrame, "InputBoxTemplate")
   spadbuttonseditbox:SetPoint("TOPLEFT", spadbindsubtitle, "BOTTOMLEFT", self.Inset, 0)
   spadbuttonseditbox:SetWidth(EditBoxWidth-self.EditBoxSpacing)
   spadbuttonseditbox:SetHeight(self.EditBoxHeight)
   spadbuttonseditbox:SetMovable(false)
   spadbuttonseditbox:SetAutoFocus(false)
   spadbuttonseditbox:EnableMouse(true)

   table.insert(self.ApplyCallbacks, function()
      local facebindings = StrToBindings(facebuttonseditbox:GetText())
      local dpadbindings = StrToBindings(dpadbuttonseditbox:GetText())
      local tpadbindings = StrToBindings(tpadbuttonseditbox:GetText())
      local spadbindings = StrToBindings(spadbuttonseditbox:GetText())
      if #facebindings == 4 and #dpadbindings == 4 and
         #tpadbindings == 4 and #spadbindings == 4 then
         local a = config.PadActions
         a.FACER.BIND, a.FACEU.BIND, a.FACED.BIND, a.FACEL.BIND = unpack(facebindings)
         a.DPADR.BIND, a.DPADU.BIND, a.DPADD.BIND, a.DPADL.BIND = unpack(dpadbindings)
         a.TRIGL.BIND, a.TRIGR.BIND, a.SPADL.BIND, a.SPADR.BIND = unpack(tpadbindings)
         a.STCKL.BIND, a.STCKR.BIND, a.PPADL.BIND, a.PPADR.BIND = unpack(spadbindings)
      else
         message("ERROR: Incorrent number of bindings.")
      end
   end)
   
   table.insert(self.RefreshCallbacks, function()
      local a = config.PadActions
      facebuttonseditbox:SetText(BindingsToStr({a.FACER.BIND, a.FACEU.BIND, a.FACED.BIND, a.FACEL.BIND}))
      dpadbuttonseditbox:SetText(BindingsToStr({a.DPADR.BIND, a.DPADU.BIND, a.DPADD.BIND, a.DPADL.BIND}))
      tpadbuttonseditbox:SetText(BindingsToStr({a.TRIGL.BIND, a.TRIGR.BIND, a.SPADL.BIND, a.SPADR.BIND}))
      spadbuttonseditbox:SetText(BindingsToStr({a.STCKL.BIND, a.STCKR.BIND, a.PPADL.BIND, a.PPADR.BIND}))
   end)
   
   return spadbuttonseditbox
end

--[[
   Features
--]]  

function ConfigUI:CreateFeatures(configFrame, anchorFrame)

   --[[
      Swap button bindings
   --]]    

   local swaptypes = {"disable", "DPad to Face", "Expanded to Face", "DPad on Face only"}
   local wxhbtypes = {"disable", "Expanded to Face"}
   
   local DropDownWidth = (configFrame:GetWidth() - 2*self.Inset)/3
   local swapsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   swapsubtitle:SetHeight(self.TextHeight)
   swapsubtitle:SetWidth(DropDownWidth)
   swapsubtitle:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -self.ConfigSpacing)
   swapsubtitle:SetNonSpaceWrap(true)
   swapsubtitle:SetJustifyH("LEFT")
   swapsubtitle:SetJustifyV("TOP")
   swapsubtitle:SetText("Swap Type")
   
   local swapdropdown = CreateFrame("Frame", ADDON .. "SwapDropDownMenu", configFrame, "UIDropDownMenuTemplate")
   swapdropdown:SetPoint("TOPLEFT", swapsubtitle, "BOTTOMLEFT", 0, 0)
   
   UIDropDownMenu_SetWidth(swapdropdown, DropDownWidth-self.DropDownSpacing)
   UIDropDownMenu_SetText(swapdropdown, "Type")

   local function SwapDropDownDemo_OnClick(self, arg1, arg2, checked)
      config.SwapType = arg1
      UIDropDownMenu_SetText(arg2, self:GetText())
   end
   
   UIDropDownMenu_Initialize(swapdropdown, function(self, level, menuList)     
      local info = UIDropDownMenu_CreateInfo()
      UIDropDownMenu_SetText(self, "")
      if (level or 1) == 1 then
         for i,swaptype in ipairs(swaptypes) do
            info.text, info.checked = swaptype, (config.SwapType == i)
            info.menuList, info.hasArrow = i, false
            info.arg1 = i
            info.arg2 = self
            info.func = SwapDropDownDemo_OnClick
            UIDropDownMenu_AddButton(info)
            UIDropDownMenu_SetText(self, swaptype)
         end
      end
   end)
   
   --[[
      Expanded button bindings
   --]]    

   local expdsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   expdsubtitle:SetHeight(self.TextHeight)
   expdsubtitle:SetWidth(DropDownWidth)
   expdsubtitle:SetPoint("TOPLEFT", swapsubtitle, "TOPRIGHT", 0, 0)
   expdsubtitle:SetNonSpaceWrap(true)
   expdsubtitle:SetJustifyH("LEFT")
   expdsubtitle:SetJustifyV("TOP")
   expdsubtitle:SetText("Expanded Type")

   local expddropdown = CreateFrame("Frame", ADDON .. "ExpandedDropDownMenu", configFrame, "UIDropDownMenuTemplate")
   expddropdown:SetPoint("TOPLEFT", expdsubtitle, "BOTTOMLEFT", 0, 0)
   
   UIDropDownMenu_SetWidth(expddropdown, DropDownWidth-self.DropDownSpacing)
   UIDropDownMenu_SetText(expddropdown, "Type")

   local function ExpdDropDownDemo_OnClick(self, arg1, arg2, checked)
      config.WXHBType = arg1
      UIDropDownMenu_SetText(arg2, self:GetText())
   end
   
   UIDropDownMenu_Initialize(expddropdown, function(self, level, menuList)     
      local info = UIDropDownMenu_CreateInfo()
      UIDropDownMenu_SetText(self, "")
      if (level or 1) == 1 then
         for i,wxhbtype in ipairs(wxhbtypes) do
            info.text, info.checked = wxhbtype, (config.WXHBType == i)
            info.menuList, info.hasArrow = i, false
            info.arg1 = i
            info.arg2 = self
            info.func = ExpdDropDownDemo_OnClick
            UIDropDownMenu_AddButton(info)
            if config.WXHBType == i then 
               UIDropDownMenu_SetText(self, wxhbtype)
            end
         end
      end
   end)

   ConfigUI:AddToolTip(swapdropdown, Locale.SwapTypeToolTip, false)
   
   table.insert(self.RefreshCallbacks, function()
                   UIDropDownMenu_SetText(swapdropdown, swaptypes[config.SwapType])
                   UIDropDownMenu_SetText(expddropdown, wxhbtypes[config.WXHBType])
   end)
   
   return swapdropdown
end

ConfigUI:CreateFrame()
