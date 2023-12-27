local ADDON, addon = ...

local config = addon.Config
local preset = CrossHotbar_DB.ActivePreset

local GamePadBindingList = {
   "PAD2",        
   "PAD4",        
   "PAD1",        
   "PAD3" ,       
   "PADDRIGHT",   
   "PADDUP",      
   "PADDDOWN",    
   "PADDLEFT",    
   "PADLSTICK",   
   "PADRSTICK",   
   "PADLSHOULDER",
   "PADRSHOULDER",   
   "PADLTRIGGER",    
   "PADRTRIGGER", 
   "PADPADDLE1",  
   "PADPADDLE2"
}

local ActionList1 = {
   "CLEARTARGETING",  
   "JUMP",
   "INTERACTTARGET",  
   "TOGGLEWORLDMAP",  
   "UNITNAVRIGHT",        
   "UNITNAVUP",        
   "UNITNAVDOWN",      
   "UNITNAVLEFT",  
   "TOGGLESHEATH",        
   "MACRO CH_MACRO_1",
   "MACRO CH_MACRO_2", 
   "MACRO CH_MACRO_3",
   "MACRO CH_MACRO_4",  
   "NONE"        
}

local ActionList2 = {
   "CAMERAPAGE1",     
   "CAMERAPAGE2",     
   "LEFTHOTBAR",      
   "RIGHTHOTBAR",
   "SWAPHOTBAR",
   "NONE"                           
}

local HotbarBtnList = {
   "HOTBARBTN1",
   "HOTBARBTN2",
   "HOTBARBTN3",
   "HOTBARBTN4",
   "HOTBARBTN5",
   "HOTBARBTN6",
   "HOTBARBTN7",
   "HOTBARBTN8",
   "HOTBARBTN9",
   "HOTBARBTN10",
   "HOTBARBTN11",
   "HOTBARBTN12",
   "NONE"
}

local GamePadButtonList = {
   "FACER",
   "FACEU",
   "FACED",
   "FACEL",
   "DPADR",
   "DPADU",
   "DPADD",
   "DPADL",
   "STCKL",
   "STCKR",
   "SPADL",
   "SPADR",
   "TRIGL",
   "TRIGR",
   "PPADL",
   "PPADR"
}

local GamePadButtonShp = {
   FACER="Shp_Circle",
   FACEU="Shp_Triangle",
   FACED="Shp_Cross",
   FACEL="Shp_Square",
   DPADR="Gen_Right",
   DPADU="Gen_Up",
   DPADD="Gen_Down",
   DPADL="Gen_Left",
   STCKL="Shp_LStickIn",
   STCKR="Shp_RStickIn",
   SPADL="Shp_LShoulder",
   SPADR="Shp_RShoulder",
   TRIGL="Shp_LTrigger",
   TRIGR="Shp_RTrigger",
   PPADL="Gen_Paddle1",
   PPADR="Gen_Paddle2"
}

local GamePadActionMap = {
   FACER=ActionList1,
   FACEU=ActionList1,
   FACED=ActionList1,
   FACEL=ActionList1,
   DPADR=ActionList1,
   DPADU=ActionList1,
   DPADD=ActionList1,
   DPADL=ActionList1,
   STCKL=ActionList1,
   STCKR=ActionList1,
   SPADL=ActionList2,
   SPADR=ActionList2,
   TRIGL=ActionList2,
   TRIGR=ActionList2,
   PPADL=ActionList2,
   PPADR=ActionList2
}

local GamePadHotbarMap = {
   FACER=HotbarBtnList,
   FACEU=HotbarBtnList,
   FACED=HotbarBtnList,
   FACEL=HotbarBtnList,
   DPADR=HotbarBtnList,
   DPADU=HotbarBtnList,
   DPADD=HotbarBtnList,
   DPADL=HotbarBtnList,
   STCKL={"NONE"},
   STCKR={"EXTRAACTIONBUTTON1"},
   SPADL={"TARGETPREVIOUSENEMY"},
   SPADR={"TARGETNEARESTENEMY"},
   TRIGL={"NONE"},
   TRIGR={"NONE"},
   PPADL={"NONE"},
   PPADR={"NONE"}
}

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

local function BindingDropDownDemo_OnClick(self, arg1, arg2, checked)
   local newaction = self:GetText()
   local currentaction = config.PadActions[arg1].BIND
   if currentaction ~= newaction then
      if newaction ~= "NONE" then
         for button, attributes in pairs(config.PadActions) do
            if button ~= arg1 then
               if attributes.BIND == newaction then
                  config.PadActions[button].BIND = "NONE"
                  break
               end
            end
         end
      end
      config.PadActions[arg1].BIND = newaction
   end
   arg2:Refresh()

end

local function ActionDropDownDemo_OnClick(self, arg1, arg2, checked)
   local newaction = self:GetText()
   local currentaction = config.PadActions[arg1].ACTION
   if currentaction ~= newaction then
      if newaction ~= "NONE" then
         for button, attributes in pairs(config.PadActions) do
            if button ~= arg1 then
               if attributes.ACTION == newaction then
                  config.PadActions[button].ACTION = "NONE"
                  break
               end
            end
         end
      end
      config.PadActions[arg1].ACTION = newaction
   end
   arg2:Refresh()
end

local function HotbarBtnDropDownDemo_OnClick(self, arg1, arg2, checked)
   local newaction = self:GetText()
   local currentaction = config.PadActions[arg1].TRIGACTION
   if currentaction ~= newaction then
      if newaction ~= "NONE" then
         for button, attributes in pairs(config.PadActions) do
            if button ~= arg1 then
               if attributes.TRIGACTION == newaction then
                  config.PadActions[button].TRIGACTION = "NONE"
                  break
               end
            end
         end
      end
      config.PadActions[arg1].TRIGACTION = newaction
   end
   arg2:Refresh()
end

local ConfigUI = {
   Inset = 16,
   ConfigSpacing = 20,
   TextHeight = 20,
   SymbolHeight = 32,
   SymbolWidth = 32,
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
      anchor = ConfigUI:CreatePadBindingActions(scrollChild, anchor)
      --anchor = ConfigUI:CreateTriggers(scrollChild, anchor)
      --anchor = ConfigUI:CreateFeatures(scrollChild, anchor)
      --anchor = ConfigUI:CreateBindings(scrollChild, anchor)

      self.InterfaceFrame:SetScript("OnShow", ConfigUI.Refresh) 
      ConfigUI:Refresh()
   end)

   InterfaceOptions_AddCategory(self.InterfaceFrame)
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
   Pad bindings and actions.
--]]

function ConfigUI:CreatePadBindingActions(configFrame, anchorFrame)
   local DropDownWidth = (configFrame:GetWidth() - 2*self.Inset - self.SymbolWidth - self.Inset)/3
   
   local buttontitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   buttontitle:SetHeight(self.TextHeight)
   buttontitle:SetWidth(self.SymbolWidth+self.Inset)
   buttontitle:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -self.ConfigSpacing)
   buttontitle:SetNonSpaceWrap(true)
   buttontitle:SetJustifyH("LEFT")
   buttontitle:SetJustifyV("TOP")
   buttontitle:SetText("Button")
   
   local bindingtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   bindingtitle:SetHeight(self.TextHeight)
   bindingtitle:SetWidth(DropDownWidth)
   bindingtitle:SetPoint("TOPLEFT", buttontitle, "TOPRIGHT", 0, 0)
   bindingtitle:SetNonSpaceWrap(true)
   bindingtitle:SetJustifyH("LEFT")
   bindingtitle:SetJustifyV("TOP")
   bindingtitle:SetText("Binding")

   local actionsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   actionsubtitle:SetHeight(self.TextHeight)
   actionsubtitle:SetWidth(DropDownWidth)
   actionsubtitle:SetPoint("TOPLEFT", bindingtitle, "TOPRIGHT", 0, 0)
   actionsubtitle:SetNonSpaceWrap(true)
   actionsubtitle:SetJustifyH("LEFT")
   actionsubtitle:SetJustifyV("TOP")
   actionsubtitle:SetText("Action")

   local hotbarsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   hotbarsubtitle:SetHeight(self.TextHeight)
   hotbarsubtitle:SetWidth(DropDownWidth)
   hotbarsubtitle:SetPoint("TOPLEFT", actionsubtitle, "TOPRIGHT", 0, 0)
   hotbarsubtitle:SetNonSpaceWrap(true)
   hotbarsubtitle:SetJustifyH("LEFT")
   hotbarsubtitle:SetJustifyV("TOP")
   hotbarsubtitle:SetText("Hotbar Button")


   local buttoninset = self.Inset
   local buttonanchor = buttontitle
   local bindinganchor = bindingtitle
   local actionanchor = actionsubtitle
   local hotbaranchor = hotbarsubtitle
   for i,button in ipairs(GamePadButtonList) do
      if config.PadActions[button] then
         local attributes = config.PadActions[button]
         local buttonsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
         buttonsubtitle:SetHeight(32)
         buttonsubtitle:SetWidth(self.SymbolWidth+100)
         buttonsubtitle:SetPoint("TOPLEFT", buttonanchor, "BOTTOMLEFT", buttoninset, 0)
         buttonsubtitle:SetNonSpaceWrap(true)
         buttonsubtitle:SetJustifyH("LEFT")
         buttonsubtitle:SetJustifyV("TOP")
         buttonsubtitle:SetText(("|A:Gamepad_%s_64:24:24|a"):format(GamePadButtonShp[button]))
         
         local bindingframe = CreateFrame("Frame", ADDON .. button.."BindingDropDownMenu", configFrame, "UIDropDownMenuTemplate")
         bindingframe:SetPoint("TOPLEFT", bindinganchor, "BOTTOMLEFT", 0, 0)
         
         UIDropDownMenu_SetWidth(bindingframe, DropDownWidth-self.DropDownSpacing)
         UIDropDownMenu_SetText(bindingframe, "Binding")
         UIDropDownMenu_JustifyText(bindingframe, "LEFT")
         UIDropDownMenu_Initialize(bindingframe, function(self, level, menuList)     
            local info = UIDropDownMenu_CreateInfo()
            UIDropDownMenu_SetText(self, "")
            if (level or 1) == 1 then
               local a = config.PadActions
               for _,binding in ipairs(GamePadBindingList) do
                  info.text, info.checked = binding, (a[button].BIND == binding)
                  info.menuList, info.hasArrow = i, false
                  info.arg1, info.arg2 = button, ConfigUI
                  info.func = BindingDropDownDemo_OnClick
                  UIDropDownMenu_AddButton(info)
                  if (a[button].BIND == binding) then 
                     UIDropDownMenu_SetText(self, binding)
                  end
               end
            end
         end)

         local actionframe = CreateFrame("Frame", ADDON .. button .. "ActionDropDownMenu", configFrame, "UIDropDownMenuTemplate")
         actionframe:SetPoint("TOPLEFT", actionanchor, "BOTTOMLEFT", 0, 0)
         
         UIDropDownMenu_SetWidth(actionframe, DropDownWidth-self.DropDownSpacing)
         UIDropDownMenu_SetText(actionframe, "Action")
         UIDropDownMenu_JustifyText(actionframe, "LEFT")
         UIDropDownMenu_Initialize(actionframe, function(self, level, menuList)     
            local info = UIDropDownMenu_CreateInfo()
            UIDropDownMenu_SetText(self, "")
            if (level or 1) == 1 then
               local a = config.PadActions
               for _,action in ipairs(GamePadActionMap[button]) do
                  info.text, info.checked = action, (a[button].ACTION == action)
                  info.menuList, info.hasArrow = i, false
                  info.arg1, info.arg2 = button, ConfigUI
                  info.func = ActionDropDownDemo_OnClick
                  UIDropDownMenu_AddButton(info)
                  if (a[button].ACTION == action) then 
                     UIDropDownMenu_SetText(self, action)
                  end
               end
            end
         end)

         local hotbaractionframe = CreateFrame("Frame", ADDON .. button .. "HotbarActionDropDownMenu", configFrame, "UIDropDownMenuTemplate")
         hotbaractionframe:SetPoint("TOPLEFT", hotbaranchor, "BOTTOMLEFT", 0, 0)
         
         UIDropDownMenu_SetWidth(hotbaractionframe, DropDownWidth-self.DropDownSpacing)
         UIDropDownMenu_SetText(hotbaractionframe, "Hotbar Action")
         UIDropDownMenu_JustifyText(hotbaractionframe, "LEFT")
         UIDropDownMenu_Initialize(hotbaractionframe, function(self, level, menuList)     
            local info = UIDropDownMenu_CreateInfo()
            UIDropDownMenu_SetText(self, "")
            if (level or 1) == 1 then
               local a = config.PadActions
               for _,action in ipairs(GamePadHotbarMap[button]) do
                  info.text, info.checked = action, (a[button].TRIGACTION == action)
                  info.menuList, info.hasArrow = i, false
                  info.arg1, info.arg2 = button, ConfigUI
                  info.func = HotbarBtnDropDownDemo_OnClick
                  UIDropDownMenu_AddButton(info)
                  if (a[button].TRIGACTION == action) then 
                     UIDropDownMenu_SetText(self, action)
                  end
               end
            end
         end)
         
         ConfigUI:AddToolTip(actionframe, Locale.LeftModifierToolTip, true)
         ConfigUI:AddToolTip(hotbaractionframe, Locale.RightModifierToolTip, true)
         
         table.insert(self.RefreshCallbacks, function()
                         UIDropDownMenu_SetText(bindingframe, config.PadActions[button].BIND)
                         UIDropDownMenu_SetText(actionframe, config.PadActions[button].ACTION)
                         UIDropDownMenu_SetText(hotbaractionframe, config.PadActions[button].TRIGACTION)
         end)
         
         buttoninset = 0
         buttonanchor = buttonsubtitle
         bindinganchor = bindingframe
         actionanchor = actionframe
         hotbaranchor = hotbaractionframe
      end
   end
   
   return buttonanchor
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
