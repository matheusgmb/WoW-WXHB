local ADDON, addon = ...

local config = addon.Config
local preset = CrossHotbar_DB.ActivePreset

local GamePadButtonList = addon.GamePadButtonList

local GamePadBindingList = {
"PAD1",
"PAD2",
"PAD3",
"PAD4",
"PAD5",
"PAD6",
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
"PADFOWARD",
"PADBACK",
"PADSYSTEM",
"PADSOCIAL",
"PADPADDLE1",
"PADPADDLE2",
"PADPADDLE3",
"PADPADDLE4",
"1", 
"2", 
"3", 
"4" ,
"5", 
"6", 
"7", 
"8", 
"9", 
"0", 
"-", 
"=", 
"[", 
"]", 
"\\",
";",
"'",
",",
".",
"/",
"SHIFT",
"CTRL",
"ALT"
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
   FACER=addon.GamePadActions,
   FACEU=addon.GamePadActions,
   FACED=addon.GamePadActions,
   FACEL=addon.GamePadActions,
   DPADR=addon.GamePadActions,
   DPADU=addon.GamePadActions,
   DPADD=addon.GamePadActions,
   DPADL=addon.GamePadActions,
   STCKL=addon.GamePadActions,
   STCKR=addon.GamePadActions,
   SPADL=addon.GamePadModifiers,
   SPADR=addon.GamePadModifiers,
   TRIGL=addon.GamePadModifiers,
   TRIGR=addon.GamePadModifiers,
   PPADL=addon.GamePadModifiers,
   PPADR=addon.GamePadModifiers
}

local GamePadModifierActionMap = {
   FACER=addon.GamePadModifierActions,
   FACEU=addon.GamePadModifierActions,
   FACED=addon.GamePadModifierActions,
   FACEL=addon.GamePadModifierActions,
   DPADR=addon.GamePadModifierActions,
   DPADU=addon.GamePadModifierActions,
   DPADD=addon.GamePadModifierActions,
   DPADL=addon.GamePadModifierActions,
   STCKL=addon.GamePadModifierActions,
   STCKR=addon.GamePadModifierActions,
   SPADL=addon.GamePadModifierActions,
   SPADR=addon.GamePadModifierActions,
   TRIGL={"NONE"},
   TRIGR={"NONE"},
   PPADL=addon.GamePadModifierActions,
   PPADR=addon.GamePadModifierActions
}

local GamePadHotbarMap = {
   FACER=addon.HotbarActions,
   FACEU=addon.HotbarActions,
   FACED=addon.HotbarActions,
   FACEL=addon.HotbarActions,
   DPADR=addon.HotbarActions,
   DPADU=addon.HotbarActions,
   DPADD=addon.HotbarActions,
   DPADL=addon.HotbarActions,
   STCKL=addon.GamePadModifierActions,
   STCKR=addon.GamePadModifierActions,
   SPADL=addon.GamePadModifierActions,
   SPADR=addon.GamePadModifierActions,
   TRIGL={"NONE"},
   TRIGR={"NONE"},
   PPADL=addon.GamePadModifierActions,
   PPADR=addon.GamePadModifierActions
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
}


local ConfigUI = {
   Inset = 16,
   ConfigSpacing = 20,
   TextHeight = 20,
   SymbolHeight = 32,
   SymbolWidth = 32,
   ButtonWidth = 80,
   ButtonHeight = 24,
   TabWidth = 64,
   TabHeight = 32,
   DropDownSpacing = 60,
   EditBoxHeight = 30,
   EditBoxSpacing = 30,
   InterfaceFrame = nil,
   ApplyCallbacks = {},
   RefreshCallbacks = {}
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
   ConfigUI:Refresh()
end

local function ActionDropDownDemo_OnClick(self, arg1, arg2, checked)
   local newaction = self:GetText()
   local currentaction = config.PadActions[arg1][arg2]
   if currentaction ~= newaction then
      if newaction ~= "NONE" then
         for button, attributes in pairs(config.PadActions) do
            if button ~= arg1 then
               if attributes[arg2] == newaction then
                  config.PadActions[button][arg2] = "NONE"
                  break
               end
            end
         end
      end
      config.PadActions[arg1][arg2] = newaction
   end
   ConfigUI:Refresh()
end

local function HotbarBtnDropDownDemo_OnClick(self, arg1, arg2, checked)
   local newaction = self:GetText()
   local currentaction = config.PadActions[arg1][arg2]
   if currentaction ~= newaction then
      if newaction ~= "NONE" then
         for button, attributes in pairs(config.PadActions) do
            if button ~= arg1 then
               if attributes[arg2] == newaction then
                  config.PadActions[button][arg2] = "NONE"
                  break
               end
            end
         end
      end
      config.PadActions[arg1][arg2] = newaction
   end
   ConfigUI:Refresh()
end

local function FilterDropDownText(name)
   if name == "NONE" then
      return ""
   else
      return name
   end
end

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
      anchor = ConfigUI:CreateFeatures(scrollChild, anchor)
      anchor = ConfigUI:CreateApply(scrollChild, anchor)
      anchor = ConfigUI:CreatePadBindings(scrollChild, anchor)
      
      anchor, tab1, tab2, tab3, tab4, tab5 =
         ConfigUI:CreateTabFrame(scrollChild, anchor)

      ConfigUI:CreatePadActions(tab1, tab1, "", GamePadActionMap, GamePadHotbarMap)
      ConfigUI:CreatePadActions(tab2, tab2, "SPADL", GamePadModifierActionMap, GamePadHotbarMap)
      ConfigUI:CreatePadActions(tab3, tab3, "SPADR", GamePadModifierActionMap, GamePadHotbarMap)
      ConfigUI:CreatePadActions(tab4, tab4, "PPADL", GamePadModifierActionMap, GamePadHotbarMap)
      ConfigUI:CreatePadActions(tab5, tab5, "PPADR", GamePadModifierActionMap, GamePadHotbarMap)
      
      self.InterfaceFrame:SetScript("OnShow", ConfigUI.Refresh) 
      ConfigUI:Refresh()
   end)

   InterfaceOptions_AddCategory(self.InterfaceFrame)
end


function ConfigUI:CreateTabFrame(configFrame, anchorFrame)
   local DropDownWidth = (configFrame:GetWidth() - self.SymbolWidth - 4*self.Inset)/3
   local tabframe = CreateFrame("Frame", ADDON .. "TabFrame", configFrame, "BackdropTemplate")
   tabframe:EnableMouse(true)
   tabframe:SetHeight(anchorFrame:GetHeight())
   tabframe:SetWidth(2*DropDownWidth)
   tabframe:SetBackdropColor(0, 0, 1, .5)

   tabframe:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 0, 0)

   tabframe:SetBackdrop({
        bgFile="Interface/DialogFrame/UI-DialogBox-Background",
        edgeFile="Interface/DialogFrame/UI-DialogBox-Border",
	tile = false,
	tileEdge = false,
	tileSize = 0,
	edgeSize = 16,
	insets = { left = 0, right = 0, top = 0, bottom = 0 }
   })
      
   local tab1frame = CreateFrame("Frame", tabframe:GetName() .. "Page1", tabframe)
   tab1frame:SetPoint("TOPLEFT", tabframe, "TOPLEFT", 0, 0)
   tab1frame:SetHeight(tabframe:GetHeight())
   tab1frame:SetWidth(tabframe:GetWidth())
   
   local tab2frame = CreateFrame("Frame", tabframe:GetName() .. "Page2", tabframe)
   tab2frame:SetPoint("TOPLEFT", tabframe, "TOPLEFT", 0, 0)
   tab2frame:SetHeight(tabframe:GetHeight())
   tab2frame:SetWidth(tabframe:GetWidth())

   local tab3frame = CreateFrame("Frame", tabframe:GetName() .. "Page3", tabframe)
   tab3frame:SetPoint("TOPLEFT", tabframe, "TOPLEFT", 0, 0)
   tab3frame:SetHeight(tabframe:GetHeight())
   tab3frame:SetWidth(tabframe:GetWidth())

   local tab4frame = CreateFrame("Frame", tabframe:GetName() .. "Page4", tabframe)
   tab4frame:SetPoint("TOPLEFT", tabframe, "TOPLEFT", 0, 0)
   tab4frame:SetHeight(tabframe:GetHeight())
   tab4frame:SetWidth(tabframe:GetWidth())

   local tab5frame = CreateFrame("Frame", tabframe:GetName() .. "Page5", tabframe)
   tab5frame:SetPoint("TOPLEFT", tabframe, "TOPLEFT", 0, 0)
   tab5frame:SetHeight(tabframe:GetHeight())
   tab5frame:SetWidth(tabframe:GetWidth())
   
   --[[
      Tab Default
   --]]

   local tab1button = CreateFrame("Button", tabframe:GetName() .. "Tab1", tabframe, "PanelTopTabButtonTemplate")
   tab1button:SetPoint("BOTTOMLEFT", tabframe, "TOPLEFT", 0, 0)
   tab1button:SetHeight(self.TabHeight)
   tab1button:SetWidth(self.TabWidth)
   tab1button:SetText("DEFAULT")
   tab1button:SetID(1)
   
   tab1button:SetScript("OnClick", function(self)
       PanelTemplates_SetTab(tabframe, 1)
       tab1frame:Show()
       tab2frame:Hide()
       tab3frame:Hide()
       tab4frame:Hide()
       tab5frame:Hide()
   end)
   
   --[[
      Tab Left Shoulder
   --]]
   
   local tab2button = CreateFrame("Button", tabframe:GetName() .. "Tab2", tabframe, "PanelTopTabButtonTemplate")
   tab2button:SetPoint("TOPLEFT", tab1button, "TOPRIGHT", 0, 0)
   tab2button:SetHeight(self.TabHeight)
   tab2button:SetWidth(self.TabWidth)
   tab2button:SetText("SPADR")
   tab2button:SetID(2)
   
   tab2button:SetScript("OnClick", function(self)
       PanelTemplates_SetTab(tabframe, 2)
       tab1frame:Hide()
       tab2frame:Show()
       tab3frame:Hide()
       tab4frame:Hide()
       tab5frame:Hide()
   end)
   
   --[[
      Tab Right Shoulder
   --]]
   
   local tab3button = CreateFrame("Button", tabframe:GetName() .. "Tab3", tabframe, "PanelTopTabButtonTemplate")
   tab3button:SetPoint("TOPLEFT", tab2button, "TOPRIGHT", 0, 0)
   tab3button:SetHeight(self.TabHeight)
   tab3button:SetWidth(self.TabWidth)
   tab3button:SetText("SPADL")
   tab3button:SetID(3)
   
   tab3button:SetScript("OnClick", function(self)
       PanelTemplates_SetTab(tabframe, 3)
       tab1frame:Hide()
       tab2frame:Hide()
       tab3frame:Show()
       tab4frame:Hide()
       tab5frame:Hide()
   end)
   
   --[[
      Tab Left Paddle
   --]]

   local tab4button = CreateFrame("Button", tabframe:GetName() .. "Tab4", tabframe, "PanelTopTabButtonTemplate")
   tab4button:SetPoint("TOPLEFT", tab3button, "TOPRIGHT", 0, 0)
   tab4button:SetHeight(self.TabHeight)
   tab4button:SetWidth(self.TabWidth)
   tab4button:SetText("PPADL")
   tab4button:SetID(4)
   
   tab4button:SetScript("OnClick", function(self)
       PanelTemplates_SetTab(tabframe, 4)
       tab1frame:Hide()
       tab2frame:Hide()
       tab3frame:Hide()
       tab4frame:Show()
       tab5frame:Hide()
   end)
   
   --[[
      Tab Right Paddle
   --]]

   local tab5button = CreateFrame("Button", tabframe:GetName() .. "Tab5", tabframe, "PanelTopTabButtonTemplate")
   tab5button:SetPoint("TOPLEFT", tab4button, "TOPRIGHT", 0, 0)
   tab5button:SetHeight(self.TabHeight)
   tab5button:SetWidth(self.TabWidth)
   tab5button:SetText("PPADR")
   tab5button:SetID(5)
   
   tab5button:SetScript("OnClick", function(self)
       PanelTemplates_SetTab(tabframe, 5)
       tab1frame:Hide()
       tab2frame:Hide()
       tab3frame:Hide()
       tab4frame:Hide()
       tab5frame:Show()
   end)
   
   tabframe:SetScript("OnShow", function(self)
      PanelTemplates_SetTab(tabframe, 1)
      tab1frame:Show()
      tab2frame:Hide()
      tab3frame:Hide()
      tab4frame:Hide()
      tab5frame:Hide()
   end)

   PanelTemplates_SetNumTabs(tabframe, 5)
   PanelTemplates_SetTab(tabframe, 1)
   tab1frame:Show()
   tab2frame:Hide()
   tab3frame:Hide()
   tab4frame:Hide()
   tab5frame:Hide()
      
   return tabframe, tab1frame, tab2frame, tab3frame, tab4frame, tab5frame
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
   presetsubtitle:SetJustifyH("Middle")
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
               UIDropDownMenu_SetText(self, CrossHotbar_DB.Presets[preset].Name)
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
   applybutton:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -self.ConfigSpacing)
   applybutton:SetHeight(self.ButtonHeight)
   applybutton:SetWidth(self.SymbolWidth + 100 + (configFrame:GetWidth() - self.SymbolWidth - 4*self.Inset)/3 - self.DropDownSpacing - self.Inset)
   applybutton:SetText("Apply")
   
   applybutton:SetScript("OnClick", ConfigUI.Apply)
   return applybutton
end

--[[
   Features
--]]  

function ConfigUI:CreateFeatures(configFrame, anchorFrame)

   --[[
      Expanded button settings
   --]]    

   local ddaatypes = {"DPad + Action / DPad + Action", "DPad + DPad / Action + Action"}   
   local DropDownWidth = (configFrame:GetWidth() - 2*self.Inset)/4
   local expdsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   expdsubtitle:SetHeight(self.TextHeight)
   expdsubtitle:SetWidth(DropDownWidth)
   expdsubtitle:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -self.ConfigSpacing)
   expdsubtitle:SetNonSpaceWrap(true)
   expdsubtitle:SetJustifyH("MIDDLE")
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
         for i,wxhbtype in ipairs(addon.HotbarWXHBTypes) do
            info.text, info.checked = wxhbtype, (config.WXHBType == wxhbtype)
            info.menuList, info.hasArrow = i, false
            info.arg1 = wxhbtype
            info.arg2 = self
            info.func = ExpdDropDownDemo_OnClick
            UIDropDownMenu_AddButton(info)
            if config.WXHBType == wxhbtype then 
               UIDropDownMenu_SetText(self, wxhbtype)
            end
         end
      end
   end)
   
   --[[
      DDAA hotbar button layout
   --]]    

   local ddaasubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   ddaasubtitle:SetHeight(self.TextHeight)
   ddaasubtitle:SetWidth(DropDownWidth)
   ddaasubtitle:SetPoint("TOPLEFT", expdsubtitle, "TOPRIGHT", 0, 0)
   ddaasubtitle:SetNonSpaceWrap(true)
   ddaasubtitle:SetJustifyH("MIDDLE")
   ddaasubtitle:SetJustifyV("TOP")
   ddaasubtitle:SetText("Hotbar Layout")

   local ddaadropdown = CreateFrame("Frame", ADDON .. "DDAADropDownMenu", configFrame, "UIDropDownMenuTemplate")
   ddaadropdown:SetPoint("TOPLEFT", ddaasubtitle, "BOTTOMLEFT", 0, 0)
   
   UIDropDownMenu_SetWidth(ddaadropdown, DropDownWidth-self.DropDownSpacing)
   UIDropDownMenu_SetText(ddaadropdown, "Type")

   local function DdaaDropDownDemo_OnClick(self, arg1, arg2, checked)
      config.DDAAType = arg1
      UIDropDownMenu_SetText(arg2, self:GetText())
   end
   
   UIDropDownMenu_Initialize(ddaadropdown, function(self, level, menuList)     
      local info = UIDropDownMenu_CreateInfo()
      UIDropDownMenu_SetText(self, "")
      if (level or 1) == 1 then
         for i,ddaatype in ipairs(addon.HotbarDDAATypes) do
            info.text, info.checked = ddaatype, (config.DDAAType == ddaatype)
            info.menuList, info.hasArrow = i, false
            info.arg1 = ddaatype
            info.arg2 = self
            info.func = DdaaDropDownDemo_OnClick
            UIDropDownMenu_AddButton(info)
            if config.DDAAType == ddaatype then 
               UIDropDownMenu_SetText(self, ddaatype)
            end
         end
      end
   end)

   table.insert(self.RefreshCallbacks, function()
                   UIDropDownMenu_SetText(expddropdown, config.WXHBType)
                   UIDropDownMenu_SetText(ddaadropdown, config.DDAAType)
   end)
   
   return expddropdown
end

--[[
   Pad bindings.
--]]

function ConfigUI:CreatePadBindings(configFrame, anchorFrame)
   local DropDownWidth = (configFrame:GetWidth() - self.SymbolWidth - 4*self.Inset)/3

   local bindingframe = CreateFrame("Frame", ADDON .. "BindingFrame", configFrame, "BackdropTemplate")
   bindingframe:EnableMouse(true)
   bindingframe:SetHeight(#GamePadButtonList * 32 + 2*self.TextHeight + self.ConfigSpacing)
   bindingframe:SetWidth(self.SymbolWidth + 100 + DropDownWidth - self.DropDownSpacing - self.Inset)
   bindingframe:SetBackdropColor(0, 0, 1, .5)
   bindingframe:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, 0)

   bindingframe:SetBackdrop({
        bgFile="Interface/DialogFrame/UI-DialogBox-Background",
        edgeFile="Interface/DialogFrame/UI-DialogBox-Border",
	tile = false,
	tileEdge = false,
	tileSize = 0,
	edgeSize = 16,
	insets = { left = 0, right = 0, top = 0, bottom = 0 }
   })

   local buttonsubtitle = bindingframe:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   buttonsubtitle:SetHeight(self.TextHeight)
   buttonsubtitle:SetWidth(self.SymbolWidth+self.Inset)
   buttonsubtitle:SetPoint("TOPLEFT", bindingframe, "TOPLEFT", self.Inset, -self.ConfigSpacing)
   buttonsubtitle:SetNonSpaceWrap(true)
   buttonsubtitle:SetJustifyH("MIDDLE")
   buttonsubtitle:SetJustifyV("TOP")
   buttonsubtitle:SetText("Button")
   
   local bindingsubtitle = bindingframe:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   bindingsubtitle:SetHeight(self.TextHeight)
   bindingsubtitle:SetWidth(DropDownWidth)
   bindingsubtitle:SetPoint("TOPLEFT", buttonsubtitle, "TOPRIGHT", 0, 0)
   bindingsubtitle:SetNonSpaceWrap(true)
   bindingsubtitle:SetJustifyH("MIDDLE")
   bindingsubtitle:SetJustifyV("TOP")
   bindingsubtitle:SetText("Binding")

   local buttoninset = self.Inset
   local buttonanchor = buttonsubtitle
   local bindinganchor = bindingsubtitle
   for i,button in ipairs(GamePadButtonList) do
      if config.PadActions[button] then
         local attributes = config.PadActions[button]
         local buttonsubtitle = bindingframe:CreateFontString(nil, "ARTWORK", "GameFontNormal")
         buttonsubtitle:SetHeight(32)
         buttonsubtitle:SetWidth(self.SymbolWidth+100)
         buttonsubtitle:SetPoint("TOPLEFT", buttonanchor, "BOTTOMLEFT", buttoninset, 0)
         buttonsubtitle:SetNonSpaceWrap(true)
         buttonsubtitle:SetJustifyH("MIDDLE")
         buttonsubtitle:SetJustifyV("TOP")
         buttonsubtitle:SetText(("|A:Gamepad_%s_64:24:24|a"):format(GamePadButtonShp[button]))
         
         local bindingframe = CreateFrame("Frame", ADDON .. button.."BindingDropDownMenu", bindingframe, "UIDropDownMenuTemplate")
         bindingframe:SetPoint("TOPLEFT", bindinganchor, "BOTTOMLEFT", 0, 0)
         
         UIDropDownMenu_SetWidth(bindingframe, DropDownWidth-self.DropDownSpacing)
         UIDropDownMenu_SetText(bindingframe, "NONE")
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
         
         table.insert(self.RefreshCallbacks, function()
                         UIDropDownMenu_SetText(bindingframe, config.PadActions[button].BIND)
         end)
         
         buttoninset = 0
         buttonanchor = buttonsubtitle
         bindinganchor = bindingframe
      end
   end
   
   return bindingframe
end

--[[
   Pad bindings and actions.
--]]

function ConfigUI:CreatePadActions(configFrame, anchorFrame, prefix, ActionMap, HotbarMap)
   local DropDownWidth = (configFrame:GetWidth() - self.Inset)/2
   
   local actionsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   actionsubtitle:SetHeight(self.TextHeight)
   actionsubtitle:SetWidth(DropDownWidth)
   actionsubtitle:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", self.Inset, -self.ConfigSpacing)
   actionsubtitle:SetNonSpaceWrap(true)
   actionsubtitle:SetJustifyH("MIDDLE")
   actionsubtitle:SetJustifyV("TOP")
   actionsubtitle:SetText("Action")

   local hotbarsubtitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
   hotbarsubtitle:SetHeight(self.TextHeight)
   hotbarsubtitle:SetWidth(DropDownWidth)
   hotbarsubtitle:SetPoint("TOPLEFT", actionsubtitle, "TOPRIGHT", 0, 0)
   hotbarsubtitle:SetNonSpaceWrap(true)
   hotbarsubtitle:SetJustifyH("MIDDLE")
   hotbarsubtitle:SetJustifyV("TOP")
   hotbarsubtitle:SetText("Hotbar Action")

   local actionanchor = actionsubtitle
   local hotbaranchor = hotbarsubtitle
   for i,button in ipairs(GamePadButtonList) do
      if config.PadActions[button] then
         local attributes = config.PadActions[button]
         local actionframe = CreateFrame("Frame", ADDON .. button .. "ActionDropDownMenu", configFrame, "UIDropDownMenuTemplate")
         actionframe:SetPoint("TOPLEFT", actionanchor, "BOTTOMLEFT", 0, 0)
         
         UIDropDownMenu_SetWidth(actionframe, DropDownWidth-self.DropDownSpacing)
         UIDropDownMenu_SetText(actionframe, "NONE")
         UIDropDownMenu_JustifyText(actionframe, "LEFT")
         UIDropDownMenu_Initialize(actionframe, function(self, level, menuList)     
            local info = UIDropDownMenu_CreateInfo()
            UIDropDownMenu_SetText(self, "")
            if (level or 1) == 1 then
               local a = config.PadActions
               for _,action in ipairs(ActionMap[button]) do
                  info.text, info.checked = action, (a[button][prefix .. "ACTION"] == action)
                  info.menuList, info.hasArrow = i, false
                  info.arg1, info.arg2 = button, prefix .. "ACTION"
                  info.func = ActionDropDownDemo_OnClick
                  UIDropDownMenu_AddButton(info)
                  if (a[button][prefix .. "ACTION"] == action) then 
                     UIDropDownMenu_SetText(self, FilterDropDownText(action))
                  end
               end
            end
         end)

         local hotbaractionframe = CreateFrame("Frame", ADDON .. button .. "HotbarActionDropDownMenu", configFrame, "UIDropDownMenuTemplate")
         hotbaractionframe:SetPoint("TOPLEFT", hotbaranchor, "BOTTOMLEFT", 0, 0)
         
         UIDropDownMenu_SetWidth(hotbaractionframe, DropDownWidth-self.DropDownSpacing)
         UIDropDownMenu_SetText(hotbaractionframe, "NONE")
         UIDropDownMenu_JustifyText(hotbaractionframe, "LEFT")
         UIDropDownMenu_Initialize(hotbaractionframe, function(self, level, menuList)     
            local info = UIDropDownMenu_CreateInfo()
            UIDropDownMenu_SetText(self, "")
            if (level or 1) == 1 then
               local a = config.PadActions
               for _,action in ipairs(HotbarMap[button]) do
                  info.text, info.checked = action, (a[button][prefix .. "TRIGACTION"] == action)
                  info.menuList, info.hasArrow = i, false
                  info.arg1, info.arg2 = button, prefix .. "TRIGACTION"
                  info.func = HotbarBtnDropDownDemo_OnClick
                  UIDropDownMenu_AddButton(info)
                  if (a[button][prefix .. "TRIGACTION"] == action) then 
                     UIDropDownMenu_SetText(self, FilterDropDownText(action))
                  end
               end
            end
         end)
         
         ConfigUI:AddToolTip(actionframe, Locale.LeftModifierToolTip, true)
         ConfigUI:AddToolTip(hotbaractionframe, Locale.RightModifierToolTip, true)
         
         table.insert(self.RefreshCallbacks, function()
                         UIDropDownMenu_SetText(actionframe, FilterDropDownText(config.PadActions[button][prefix .. "ACTION"]))
                         UIDropDownMenu_SetText(hotbaractionframe, FilterDropDownText(config.PadActions[button][prefix .. "TRIGACTION"]))
         end)
         
         actionanchor = actionframe
         hotbaranchor = hotbaractionframe
      end
   end
   
   return buttonanchor
end

ConfigUI:CreateFrame()
