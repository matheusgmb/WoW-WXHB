local ADDON, addon = ...

CrossHotbar_DB = {
   Config = {
      Mutable = true,
      Name = "Custom",
      LeftModifier = "PADLTRIGGER",
      RightModifier = "PADRTRIGGER",
      SwapModifier = "PADLSHOULDER",
      SwapType = 2,
      WXHBType = 2,
      ActionBindings = {"PAD1", "PAD2", "PAD3", "PAD4", "PADDUP", "PADDRIGHT", "PADDDOWN", "PADDLEFT"},
      SwapBindings = {"PAD1", "PAD2", "PAD3", "PAD4"},
      ExpdBindings = {"PAD1", "PAD2", "PAD3", "PAD4"}
   },
   ActivePreset = 3,
   Presets = {
      [1] = {
         Mutable = false,
         Name = "Gamepad_Preset",
         LeftModifier = "PADLTRIGGER",
         RightModifier = "PADRTRIGGER",
         SwapModifier = "PADLSHOULDER",
         SwapType = 2,
         WXHBType = 2,
         ActionBindings = {"PAD1", "PAD2", "PAD3", "PAD4", "PADDUP", "PADDRIGHT", "PADDDOWN", "PADDLEFT"},
         SwapBindings = {"PAD1", "PAD2", "PAD3", "PAD4"},
         ExpdBindings = {"PAD1", "PAD2", "PAD3", "PAD4"}
      },
      [2] = {
         Mutable = false,
         Name = "Keyboard_Preset",
         LeftModifier = "CTRL",
         RightModifier = "SHIFT",
         SwapModifier = "ALT",
         SwapType = 2,
         WXHBType = 2,
         ActionBindings = {"1", "2", "3", "4", "5", "6", "7", "8"},
         SwapBindings = {"1", "2", "3", "4"},
         ExpdBindings = {"1", "2", "3", "4"}
      },
      [3] = {
         Mutable = true,
         Name = "Custom",
         LeftModifier = "PADLTRIGGER",
         RightModifier = "PADRTRIGGER",
         SwapModifier = "PADLSHOULDER",
         SwapType = 2,
         WXHBType = 2,
         ActionBindings = {"PAD1", "PAD2", "PAD3", "PAD4", "PADDUP", "PADDRIGHT", "PADDDOWN", "PADDLEFT"},
         SwapBindings = {"PAD1", "PAD2", "PAD3", "PAD4"},
         ExpdBindings = {"PAD1", "PAD2", "PAD3", "PAD4"}
      }
   }
}

local preset = CrossHotbar_DB.ActivePreset;
local config = CrossHotbar_DB.Config

local frame = CreateFrame("Frame", ADDON .. "ConfigFrame", InterfaceOptionsFramePanelContainer)
frame.name = ADDON
frame:Hide()

frame:SetScript("OnShow", function(frame)                   
    local Refresh;
    local ConfigSpacing = -20
    local DescrpSpacing = -10
    
    local leftmodifiers = {"CTRL", "PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER", "PADPADDLE1", "PADPADDLE2", "PADPADDLE3", "PADPADDLE4"}
    local rightmodifiers = {"SHIFT", "PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER", "PADPADDLE1", "PADPADDLE2", "PADPADDLE3", "PADPADDLE4"}
    local swapmodifiers = {"ALT", "PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER", "PADPADDLE1", "PADPADDLE2", "PADPADDLE3", "PADPADDLE4"}
    local swaptypes = {"disable", "buttons [5-8]", "buttons [9-12]"}
    local wxhbtypes = {"disable", "buttons [9-12]"}
   
    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("CrossHotbar")

    --[[
       Presets
    --]]
    
    local presetsubtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    presetsubtitle:SetHeight(20)
    presetsubtitle:SetWidth(200)
    presetsubtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, ConfigSpacing)
    presetsubtitle:SetNonSpaceWrap(true)
    presetsubtitle:SetJustifyH("LEFT")
    presetsubtitle:SetJustifyV("TOP")
    presetsubtitle:SetText("Presets")
    
    local PresetsFrame = CreateFrame("Frame", ADDON .. "PresetDropDownMenu", frame, "UIDropDownMenuTemplate")
    PresetsFrame:SetPoint("TOPLEFT", presetsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(PresetsFrame, 120)
    UIDropDownMenu_SetText(PresetsFrame, "Presets")
    
    local function PresetDropDownDemo_OnClick(self, arg1, arg2, checked)
       if preset ~= arg1 then
          preset = arg1
          Refresh()
       end
    end
    
    UIDropDownMenu_Initialize(PresetsFrame, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
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
    
    local presetloadbutton = CreateFrame("Button", ADDON .. "PresetLoad", frame, "UIPanelButtonTemplate")
    presetloadbutton:SetPoint("TOPLEFT", PresetsFrame, "TOPRIGHT", 0, 0)
    presetloadbutton:SetHeight(20)
    presetloadbutton:SetWidth(80)
    presetloadbutton:SetText("Load")
    
    presetloadbutton:SetScript("OnClick", function(self, button, down)
       if CrossHotbar_DB.Presets[preset].Mutable then
          config.Name = CrossHotbar_DB.Presets[preset].Name
       end
       config.LeftModifier = CrossHotbar_DB.Presets[preset].LeftModifier
       config.RightModifier = CrossHotbar_DB.Presets[preset].RightModifier
       config.SwapModifier = CrossHotbar_DB.Presets[preset].SwapModifier
       config.SwapType = CrossHotbar_DB.Presets[preset].SwapType
       config.WXHBType = CrossHotbar_DB.Presets[preset].WXHBType
       config.ActionBindings = {unpack(CrossHotbar_DB.Presets[preset].ActionBindings)}
       config.SwapBindings = {unpack(CrossHotbar_DB.Presets[preset].SwapBindings)}
       config.ExpdBindings = {unpack(CrossHotbar_DB.Presets[preset].ExpdBindings)}
       Refresh()
    end)
    
    local presetdeletebutton = CreateFrame("Button", ADDON .. "PresetDelete", frame, "UIPanelButtonTemplate")
    presetdeletebutton:SetPoint("TOPLEFT", presetloadbutton, "TOPRIGHT", 0, 0)
    presetdeletebutton:SetHeight(20)
    presetdeletebutton:SetWidth(80)
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
       if CrossHotbar_DB.Presets[preset].Mutable then
          config.Name = CrossHotbar_DB.Presets[preset].Name
       end
       config.LeftModifier = CrossHotbar_DB.Presets[preset].LeftModifier
       config.RightModifier = CrossHotbar_DB.Presets[preset].RightModifier
       config.SwapModifier = CrossHotbar_DB.Presets[preset].SwapModifier
       config.SwapType = CrossHotbar_DB.Presets[preset].SwapType
       config.WXHBType = CrossHotbar_DB.Presets[preset].WXHBType
       config.ActionBindings = {unpack(CrossHotbar_DB.Presets[preset].ActionBindings)}
       config.SwapBindings = {unpack(CrossHotbar_DB.Presets[preset].SwapBindings)}
       config.ExpdBindings = {unpack(CrossHotbar_DB.Presets[preset].ExpdBindings)}
       Refresh()
    end)
    
    local presetfileeditbox = CreateFrame("EditBox", ADDON .. "PresetFileEditBox", frame, "InputBoxTemplate")
    presetfileeditbox:SetPoint("LEFT", presetdeletebutton, "RIGHT", 40, 0)
    presetfileeditbox:SetWidth(100)
    presetfileeditbox:SetHeight(30)
    presetfileeditbox:SetMovable(false)
    presetfileeditbox:SetAutoFocus(false)
    presetfileeditbox:EnableMouse(true)
    presetfileeditbox:SetText(config.Name)
    
    local presetsavebutton = CreateFrame("Button", ADDON .. "PresetSave", frame, "UIPanelButtonTemplate")
    presetsavebutton:SetPoint("LEFT", presetfileeditbox, "RIGHT", 10, 0)
    presetsavebutton:SetHeight(20)
    presetsavebutton:SetWidth(80)
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
             Mutable = true,
             Name = config.Name,
             LeftModifier = config.LeftModifier,
             RightModifier = config.RightModifier,
             SwapModifier = config.SwapModifier,
             SwapType = config.SwapType,
             WXHBType = config.WXHBType,
             ActionBindings = {unpack(config.ActionBindings)},
             SwapBindings = {unpack(config.SwapBindings)},
             ExpdBindings = {unpack(config.ExpdBindings)}
          }
          table.insert(CrossHotbar_DB.Presets, newpreset)
          preset = #CrossHotbar_DB.Presets
          CrossHotbar_DB.ActivePreset = preset
       elseif CrossHotbar_DB.Presets[foundpreset].Mutable then
          preset = foundpreset
          config.Name = presetfileeditbox:GetText()
          CrossHotbar_DB.ActivePreset = preset
          CrossHotbar_DB.Presets[preset].LeftModifier = config.LeftModifier
          CrossHotbar_DB.Presets[preset].RightModifier = config.RightModifier
          CrossHotbar_DB.Presets[preset].SwapModifier = config.SwapModifier
          CrossHotbar_DB.Presets[preset].SwapType = config.SwapType
          CrossHotbar_DB.Presets[preset].WXHBType = config.WXHBType
          CrossHotbar_DB.Presets[preset].ActionBindings = {unpack(config.ActionBindings)}
          CrossHotbar_DB.Presets[preset].SwapBindings = {unpack(config.SwapBindings)}
          CrossHotbar_DB.Presets[preset].ExpdBindings = {unpack(config.ExpdBindings)}
       end
       Refresh()
    end)
    
    --[[
       Modifier button binding
    --]]

    local leftsubtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    leftsubtitle:SetHeight(20)
    leftsubtitle:SetWidth(200)
    leftsubtitle:SetPoint("TOPLEFT", PresetsFrame, "BOTTOMLEFT", 0, ConfigSpacing)
    leftsubtitle:SetNonSpaceWrap(true)
    leftsubtitle:SetJustifyH("LEFT")
    leftsubtitle:SetJustifyV("TOP")
    leftsubtitle:SetText("Left Modifier")

    local rightsubtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    rightsubtitle:SetHeight(20)
    rightsubtitle:SetWidth(200)
    rightsubtitle:SetPoint("TOPLEFT", leftsubtitle, "TOPRIGHT", 0, 0)
    rightsubtitle:SetNonSpaceWrap(true)
    rightsubtitle:SetJustifyH("LEFT")
    rightsubtitle:SetJustifyV("TOP")
    rightsubtitle:SetText("Right Modifier")
    
    local swapsubtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    swapsubtitle:SetHeight(20)
    swapsubtitle:SetWidth(200)
    swapsubtitle:SetPoint("TOPLEFT", rightsubtitle, "TOPRIGHT", 0, 0)
    swapsubtitle:SetNonSpaceWrap(true)
    swapsubtitle:SetJustifyH("LEFT")
    swapsubtitle:SetJustifyV("TOP")
    swapsubtitle:SetText("Swap Modifier")
    
    local function ModifierDropDownDemo_OnClick(self, arg1, arg2, checked)
       if arg1 == "left" then
          config.LeftModifier = self:GetText()
       end
       if arg1 == "right" then
          config.RightModifier = self:GetText()
       end
       if arg1 == "swap" then
          config.SwapModifier = self:GetText()
       end
       
       UIDropDownMenu_SetText(arg2, self:GetText())
    end
    
    local leftmodifierframe = CreateFrame("Frame", ADDON .. "LeftModifierDropDownMenu", frame, "UIDropDownMenuTemplate")
    leftmodifierframe:SetPoint("TOPLEFT", leftsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(leftmodifierframe, 120)
    UIDropDownMenu_SetText(leftmodifierframe, "LeftModifier")

    UIDropDownMenu_Initialize(leftmodifierframe, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
        if (level or 1) == 1 then
           for _,modifier in ipairs(leftmodifiers) do
              info.text, info.checked, info.disabled = modifier, (config.LeftModifier == modifier), (config.RightModifier == modifier) or (config.SwapModifier == modifier)
              info.menuList, info.hasArrow = i, false
              info.arg1 = "left"
              info.arg2 = self
              info.func = ModifierDropDownDemo_OnClick
              UIDropDownMenu_AddButton(info)
              if (config.LeftModifier == modifier) then 
                 UIDropDownMenu_SetText(self, modifier)
              end
           end
        end
    end)

    local rightmodifierframe = CreateFrame("Frame", ADDON .. "RightModifierDropDownMenu", frame, "UIDropDownMenuTemplate")
    rightmodifierframe:SetPoint("TOPLEFT", rightsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(rightmodifierframe, 120)
    UIDropDownMenu_SetText(rightmodifierframe, "RightModifier")
    
    UIDropDownMenu_Initialize(rightmodifierframe, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
        if (level or 1) == 1 then
           for _,modifier in ipairs(rightmodifiers) do
              info.text, info.checked, info.disabled = modifier, (config.RightModifier == modifier), (config.LeftModifier == modifier) or (config.SwapModifier == modifier)
              info.menuList, info.hasArrow = i, false
              info.arg1 = "right"
              info.arg2 = self
              info.func = ModifierDropDownDemo_OnClick
              UIDropDownMenu_AddButton(info)
              if (config.RightModifier == modifier) then 
                 UIDropDownMenu_SetText(self, modifier)
              end
           end
        end
    end)

    local swapmodifierframe = CreateFrame("Frame", ADDON .. "SwapModifierDropDownMenu", frame, "UIDropDownMenuTemplate")
    swapmodifierframe:SetPoint("TOPLEFT", swapsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(swapmodifierframe, 120)
    UIDropDownMenu_SetText(swapmodifierframe, "SwapModifier")
    
    UIDropDownMenu_Initialize(swapmodifierframe, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
        if (level or 1) == 1 then
           for _,modifier in ipairs(swapmodifiers) do
              info.text, info.checked, info.disabled = modifier, (config.SwapModifier == modifier), (config.LeftModifier == modifier) or (config.RightModifier == modifier)
              info.menuList, info.hasArrow = i, false
              info.arg1 = "swap"
              info.arg2 = self
              info.func = ModifierDropDownDemo_OnClick
              UIDropDownMenu_AddButton(info)
              if (config.SwapModifier == modifier) then 
                 UIDropDownMenu_SetText(self, modifier)
              end
           end
        end
    end)
 
    local moddescrip = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
    moddescrip:SetHeight(50)
    moddescrip:SetPoint("TOPLEFT", leftmodifierframe, "BOTTOMLEFT", 0, DescrpSpacing)
    moddescrip:SetPoint("RIGHT", frame, -32, 0)
    moddescrip:SetNonSpaceWrap(true)
    moddescrip:SetJustifyH("LEFT")
    moddescrip:SetJustifyV("TOP")
    moddescrip:SetText([[Modifier button assignments for Left and Right Hotbars and Swap Button.
Selecting a gamepad button will turn on the modifier emulation.
CTRL, SHIFT, and ALT are always used.]])

    --[[
       Action button bindings
    --]]
    
    local bindsubtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    bindsubtitle:SetHeight(20)
    bindsubtitle:SetPoint("TOPLEFT", moddescrip, "BOTTOMLEFT", 0, ConfigSpacing)
    bindsubtitle:SetPoint("RIGHT", frame, -32, 0)
    bindsubtitle:SetNonSpaceWrap(true)
    bindsubtitle:SetJustifyH("LEFT")
    bindsubtitle:SetJustifyV("TOP")
    bindsubtitle:SetText("Hotbar bindings")
    
    local actionbindingseditbox = CreateFrame("EditBox", ADDON .. "ActionbindingsEditBox", frame, "InputBoxTemplate")
    actionbindingseditbox:SetPoint("TOPLEFT", bindsubtitle, "BOTTOMLEFT", 20, 0)
    actionbindingseditbox:SetWidth(450)
    actionbindingseditbox:SetHeight(30)
    actionbindingseditbox:SetMovable(false)
    actionbindingseditbox:SetAutoFocus(false)
    actionbindingseditbox:EnableMouse(true)

    local actionbindingapply = CreateFrame("Button", ADDON .. "ActionBindingApply", frame, "UIPanelButtonTemplate")
    actionbindingapply:SetPoint("LEFT", actionbindingseditbox, "RIGHT", 10, 0)
    actionbindingapply:SetHeight(20)
    actionbindingapply:SetWidth(80)
    actionbindingapply:SetText("Apply")
    
    actionbindingapply:SetScript("OnClick", function(self, button, down)
       text = actionbindingseditbox:GetText()
       config.ActionBindings = {}
       for binding in text:gmatch("%S+") do
          table.insert(config.ActionBindings, binding)
       end
       if #config.ActionBindings == 8 then
          config.SwapBindings = unpack(config.ActionBindings, 1, 4)
          config.ExpdBindings = unpack(config.ActionBindings, 1, 4)
       else
          message("ERROR: Incorrent number of bindings.")
       end
    end)

    local binddescrip = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
    binddescrip:SetHeight(30)
    binddescrip:SetPoint("TOPLEFT", actionbindingseditbox, "BOTTOMLEFT", -20, DescrpSpacing)
    binddescrip:SetPoint("RIGHT", frame, -32, 0)
    binddescrip:SetNonSpaceWrap(true)
    binddescrip:SetJustifyH("LEFT")
    binddescrip:SetJustifyV("TOP")
    binddescrip:SetText([[List of base keybinds that will be mapped to each hotbar for buttons [1-8].
Combinations of Left and Right modifiers are prepended to each keybind.]])

    --[[
       Swap button bindings
    --]]    

    local swapsubtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    swapsubtitle:SetHeight(20)
    swapsubtitle:SetPoint("TOPLEFT", binddescrip, "BOTTOMLEFT", 0, ConfigSpacing)
    swapsubtitle:SetPoint("RIGHT", frame, -32, 0)
    swapsubtitle:SetNonSpaceWrap(true)
    swapsubtitle:SetJustifyH("LEFT")
    swapsubtitle:SetJustifyV("TOP")
    swapsubtitle:SetText("Swap Type")
    
    local swapdropdown = CreateFrame("Frame", ADDON .. "SwapDropDownMenu", frame, "UIDropDownMenuTemplate")
    swapdropdown:SetPoint("TOPLEFT", swapsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(swapdropdown, 100)
    UIDropDownMenu_SetText(swapdropdown, "Type")

    local function SwapDropDownDemo_OnClick(self, arg1, arg2, checked)
       config.SwapType = arg1
       UIDropDownMenu_SetText(arg2, self:GetText())
    end
    
    UIDropDownMenu_Initialize(swapdropdown, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
        if (level or 1) == 1 then
           local type = CrossHotbar_DB.Presets[preset].SwapType
           for i,swaptype in ipairs(swaptypes) do
              info.text, info.checked = swaptype, (type == i)
              info.menuList, info.hasArrow = i, false
              info.arg1 = i
              info.arg2 = self
              info.func = SwapDropDownDemo_OnClick
              UIDropDownMenu_AddButton(info)
              if type == i then 
                 UIDropDownMenu_SetText(self, swaptype)
              end
           end
        end
    end)

    local swapdescrip = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
    swapdescrip:SetHeight(20)
    swapdescrip:SetPoint("TOPLEFT", swapdropdown, "BOTTOMLEFT", 0, DescrpSpacing)
    swapdescrip:SetPoint("RIGHT", frame, -32, 0)
    swapdescrip:SetNonSpaceWrap(true)
    swapdescrip:SetJustifyH("LEFT")
    swapdescrip:SetJustifyV("TOP")
    swapdescrip:SetText([[Using the Swap Modifier will swap these buttons to [1-4].]])

    --[[
       Expanded button bindings
    --]]    

    local expdsubtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    expdsubtitle:SetHeight(20)
    expdsubtitle:SetPoint("TOPLEFT", swapdescrip, "BOTTOMLEFT", 0, ConfigSpacing)
    expdsubtitle:SetPoint("RIGHT", frame, -32, 0)
    expdsubtitle:SetNonSpaceWrap(true)
    expdsubtitle:SetJustifyH("LEFT")
    expdsubtitle:SetJustifyV("TOP")
    expdsubtitle:SetText("Expanded Type")

    local expddropdown = CreateFrame("Frame", ADDON .. "ExpandedDropDownMenu", frame, "UIDropDownMenuTemplate")
    expddropdown:SetPoint("TOPLEFT", expdsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(expddropdown, 100)
    UIDropDownMenu_SetText(expddropdown, "Type")

    local function ExpdDropDownDemo_OnClick(self, arg1, arg2, checked)
       config.SwapType = arg1
       UIDropDownMenu_SetText(arg2, self:GetText())
    end
        
    UIDropDownMenu_Initialize(expddropdown, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
        if (level or 1) == 1 then
           local type = CrossHotbar_DB.Presets[preset].WXHBType
           for i,wxhbtype in ipairs(wxhbtypes) do
              info.text, info.checked = wxhbtype, (type == i)
              info.menuList, info.hasArrow = i, false
              info.arg1 = i
              info.arg2 = self
              info.func = ExpdDropDownDemo_OnClick
              UIDropDownMenu_AddButton(info)
              if type == i then 
                 UIDropDownMenu_SetText(self, wxhbtype)
              end
           end
        end
    end)

    local expddescrip = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
    expddescrip:SetHeight(20)
    expddescrip:SetPoint("TOPLEFT", expddropdown, "BOTTOMLEFT", 0, DescrpSpacing)
    expddescrip:SetPoint("RIGHT", frame, -32, 0)
    expddescrip:SetNonSpaceWrap(true)
    expddescrip:SetJustifyH("LEFT")
    expddescrip:SetJustifyV("TOP")
    expddescrip:SetText([[Double tapping the left or right modifier will map buttons [9-12] to [1-4].]])

    function Refresh()
       if not frame:IsVisible() then return end
       
       presetdeletebutton:SetEnabled(CrossHotbar_DB.Presets[preset].Mutable)
       presetfileeditbox:SetText(config.Name)
       
       UIDropDownMenu_SetText(PresetsFrame, CrossHotbar_DB.Presets[preset].Name)
       UIDropDownMenu_SetText(leftmodifierframe, config.LeftModifier);
       UIDropDownMenu_SetText(rightmodifierframe, config.RightModifier);
       UIDropDownMenu_SetText(swapmodifierframe, config.SwapModifier);

       local actionbindings = config.ActionBindings
       local actionbindingtext = ""
       for i,binding in ipairs(actionbindings) do
          actionbindingtext = actionbindingtext .. binding .. " "
       end
       actionbindingseditbox:SetText(actionbindingtext)
       
       UIDropDownMenu_SetText(swapdropdown, swaptypes[config.SwapType]);
       UIDropDownMenu_SetText(expddropdown, wxhbtypes[config.WXHBType]);
    end

    frame:SetScript("OnShow", Refresh) 
    Refresh()
end)

InterfaceOptions_AddCategory(frame)
