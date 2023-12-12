local ADDON, addon = ...

local config = addon.Config
local preset = CrossHotbar_DB.ActivePreset;

local frame = CreateFrame("Frame", ADDON .. "ConfigFrame", InterfaceOptionsFramePanelContainer)
frame.name = ADDON
frame:Hide()

frame:SetScript("OnShow", function(frame)
                   
    local Refresh;
    local Inset = 16
    
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 3, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    local scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(frame:GetWidth()-Inset)
    scrollChild:SetHeight(1) 

    local ConfigSpacing = 20
    local DescrpSpacing = 10
    local textheight = 20
    local buttonwidth = 80
    local buttonheight = 20
    local DropDownWidth = scrollChild:GetWidth()/3 - 2*Inset
    local DropDownSpacing = 60
    local EditBoxWidth = scrollChild:GetWidth() - 2*Inset
    local EditBoxHeight = 30
    local EditBoxSpacing = 30
    local validbindings 
    local leftmodifiers = {"CTRL", "PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER", "PADPADDLE1", "PADPADDLE2", "PADPADDLE3", "PADPADDLE4"}
    local rightmodifiers = {"SHIFT", "PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER", "PADPADDLE1", "PADPADDLE2", "PADPADDLE3", "PADPADDLE4"}
    local swapmodifiers = {"ALT", "PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER", "PADPADDLE1", "PADPADDLE2", "PADPADDLE3", "PADPADDLE4"}
    local swaptypes = {"disable", "DPad to Face", "Expanded to Face", "DPad on Face only"}
    local wxhbtypes = {"disable", "Expanded to Face"}
   
    local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", Inset, -Inset)
    title:SetText("CrossHotbar")

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
          map[item] = true;
       end
       for i,item in ipairs(l1) do
          if map[item] then
             table.insert(matches, item)
             map[item] = false
          end
       end
       return matches
    end
    
    --[[
       Presets
    --]]
    
    local presetsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    presetsubtitle:SetHeight(textheight)
    presetsubtitle:SetWidth(DropDownWidth)
    presetsubtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -ConfigSpacing)
    presetsubtitle:SetNonSpaceWrap(true)
    presetsubtitle:SetJustifyH("LEFT")
    presetsubtitle:SetJustifyV("TOP")
    presetsubtitle:SetText("Presets")
    
    local PresetsFrame = CreateFrame("Frame", ADDON .. "PresetDropDownMenu", scrollChild, "UIDropDownMenuTemplate")
    PresetsFrame:SetPoint("TOPLEFT", presetsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(PresetsFrame, DropDownWidth-DropDownSpacing)
    UIDropDownMenu_SetText(PresetsFrame, "Presets")
    
    local function PresetDropDownDemo_OnClick(self, arg1, arg2, checked)
       if preset ~= arg1 then
          preset = arg1
          Refresh()
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
    
    local presetloadbutton = CreateFrame("Button", ADDON .. "PresetLoad", scrollChild, "UIPanelButtonTemplate")
    presetloadbutton:SetPoint("TOPLEFT", PresetsFrame, "TOPRIGHT", 0, 0)
    presetloadbutton:SetHeight(buttonheight)
    presetloadbutton:SetWidth(buttonwidth)
    presetloadbutton:SetText("Load")
    
    presetloadbutton:SetScript("OnClick", function(self, button, down)
       config:StorePreset(config, CrossHotbar_DB.Presets[preset])
       Refresh()
    end)
    
    local presetdeletebutton = CreateFrame("Button", ADDON .. "PresetDelete", scrollChild, "UIPanelButtonTemplate")
    presetdeletebutton:SetPoint("TOPLEFT", presetloadbutton, "TOPRIGHT", 0, 0)
    presetdeletebutton:SetHeight(buttonheight)
    presetdeletebutton:SetWidth(buttonwidth)
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
       Refresh()
    end)
    
    local presetfileeditbox = CreateFrame("EditBox", ADDON .. "PresetFileEditBox", scrollChild, "InputBoxTemplate")
    presetfileeditbox:SetPoint("LEFT", presetdeletebutton, "RIGHT", 40, 0)
    presetfileeditbox:SetWidth(100)
    presetfileeditbox:SetHeight(EditBoxHeight)
    presetfileeditbox:SetMovable(false)
    presetfileeditbox:SetAutoFocus(false)
    presetfileeditbox:EnableMouse(true)
    presetfileeditbox:SetText(config.Name)
    
    local presetsavebutton = CreateFrame("Button", ADDON .. "PresetSave", scrollChild, "UIPanelButtonTemplate")
    presetsavebutton:SetPoint("LEFT", presetfileeditbox, "RIGHT", 10, 0)
    presetsavebutton:SetHeight(buttonheight)
    presetsavebutton:SetWidth(buttonwidth)
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
       Refresh()
    end)
    
    --[[
       Modifier button binding
    --]]

    local leftsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    leftsubtitle:SetHeight(textheight)
    leftsubtitle:SetWidth(DropDownWidth)
    leftsubtitle:SetPoint("TOPLEFT", PresetsFrame, "BOTTOMLEFT", 0, -ConfigSpacing)
    leftsubtitle:SetNonSpaceWrap(true)
    leftsubtitle:SetJustifyH("LEFT")
    leftsubtitle:SetJustifyV("TOP")
    leftsubtitle:SetText("Left Modifier")

    local rightsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    rightsubtitle:SetHeight(textheight)
    rightsubtitle:SetWidth(DropDownWidth)
    rightsubtitle:SetPoint("TOPLEFT", leftsubtitle, "TOPRIGHT", 0, 0)
    rightsubtitle:SetNonSpaceWrap(true)
    rightsubtitle:SetJustifyH("LEFT")
    rightsubtitle:SetJustifyV("TOP")
    rightsubtitle:SetText("Right Modifier")
    
    local swapsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    swapsubtitle:SetHeight(textheight)
    swapsubtitle:SetWidth(DropDownWidth)
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
    
    local leftmodifierframe = CreateFrame("Frame", ADDON .. "LeftModifierDropDownMenu", scrollChild, "UIDropDownMenuTemplate")
    leftmodifierframe:SetPoint("TOPLEFT", leftsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(leftmodifierframe, DropDownWidth-DropDownSpacing)
    UIDropDownMenu_SetText(leftmodifierframe, "LeftModifier")

    UIDropDownMenu_Initialize(leftmodifierframe, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
        UIDropDownMenu_SetText(self, "")
        if (level or 1) == 1 then
           local bindings = {}
           for i, item in ipairs(config.TPadButtons) do table.insert(bindings, item) end
           for i, item in ipairs(config.SPadButtons) do table.insert(bindings, item) end
           local modifiers = Intersection(bindings,leftmodifiers)
           for _,modifier in ipairs(modifiers) do
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

    local rightmodifierframe = CreateFrame("Frame", ADDON .. "RightModifierDropDownMenu", scrollChild, "UIDropDownMenuTemplate")
    rightmodifierframe:SetPoint("TOPLEFT", rightsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(rightmodifierframe, DropDownWidth-DropDownSpacing)
    UIDropDownMenu_SetText(rightmodifierframe, "RightModifier")
    
    UIDropDownMenu_Initialize(rightmodifierframe, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
        UIDropDownMenu_SetText(self, "")
        if (level or 1) == 1 then
           local bindings = {}
           for i, item in ipairs(config.TPadButtons) do table.insert(bindings, item) end
           for i, item in ipairs(config.SPadButtons) do table.insert(bindings, item) end
           local modifiers = Intersection(bindings,rightmodifiers)
           for _,modifier in ipairs(modifiers) do
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

    local swapmodifierframe = CreateFrame("Frame", ADDON .. "SwapModifierDropDownMenu", scrollChild, "UIDropDownMenuTemplate")
    swapmodifierframe:SetPoint("TOPLEFT", swapsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(swapmodifierframe, DropDownWidth-DropDownSpacing)
    UIDropDownMenu_SetText(swapmodifierframe, "SwapModifier")
    
    UIDropDownMenu_Initialize(swapmodifierframe, function(self, level, menuList)     
        local info = UIDropDownMenu_CreateInfo()
        UIDropDownMenu_SetText(self, "")
        if (level or 1) == 1 then
           local bindings = {}
           for i, item in ipairs(config.TPadButtons) do table.insert(bindings, item) end
           for i, item in ipairs(config.SPadButtons) do table.insert(bindings, item) end
           local modifiers = Intersection(bindings,swapmodifiers)
           for _,modifier in ipairs(modifiers) do
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
 --[[
    local moddescrip = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
    moddescrip:SetHeight(textheight)
    moddescrip:SetPoint("TOPLEFT", leftmodifierframe, "BOTTOMLEFT", 0, -DescrpSpacing)
    moddescrip:SetPoint("RIGHT", scrollChild, -2*Inset, 0)
    moddescrip:SetNonSpaceWrap(true)
    moddescrip:SetJustifyH("LEFT")
    moddescrip:SetJustifyV("TOP")
    moddescrip:SetText("Modifier button assignments for Left and Right Hotbars and Swap Button.")
--]]
    --[[
       Face button bindings
    --]]
    
    local facebindsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    facebindsubtitle:SetHeight(textheight)
    facebindsubtitle:SetWidth(EditBoxWidth)
    facebindsubtitle:SetPoint("TOPLEFT", leftmodifierframe, "BOTTOMLEFT", 0, -ConfigSpacing)
    facebindsubtitle:SetNonSpaceWrap(true)
    facebindsubtitle:SetJustifyH("LEFT")
    facebindsubtitle:SetJustifyV("TOP")
    facebindsubtitle:SetText("Face button bindings")
    
    local facebuttonseditbox = CreateFrame("EditBox", ADDON .. "FaceButtonsEditBox", scrollChild, "InputBoxTemplate")
    facebuttonseditbox:SetPoint("TOPLEFT", facebindsubtitle, "BOTTOMLEFT", Inset, 0)
    facebuttonseditbox:SetWidth(EditBoxWidth-EditBoxSpacing)
    facebuttonseditbox:SetHeight(EditBoxHeight)
    facebuttonseditbox:SetMovable(false)
    facebuttonseditbox:SetAutoFocus(false)
    facebuttonseditbox:EnableMouse(true)

    --[[
       Dpad button bindings
    --]]
    
    local dpadbindsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    dpadbindsubtitle:SetHeight(textheight)
    dpadbindsubtitle:SetWidth(EditBoxWidth)
    dpadbindsubtitle:SetPoint("TOPLEFT", facebuttonseditbox, "BOTTOMLEFT", -Inset, -Inset)
    dpadbindsubtitle:SetNonSpaceWrap(true)
    dpadbindsubtitle:SetJustifyH("LEFT")
    dpadbindsubtitle:SetJustifyV("TOP")
    dpadbindsubtitle:SetText("DPad button bindings")
    
    local dpadbuttonseditbox = CreateFrame("EditBox", ADDON .. "DPadButtonsEditBox", scrollChild, "InputBoxTemplate")
    dpadbuttonseditbox:SetPoint("TOPLEFT", dpadbindsubtitle, "BOTTOMLEFT", Inset, 0)
    dpadbuttonseditbox:SetWidth(EditBoxWidth-EditBoxSpacing)
    dpadbuttonseditbox:SetHeight(EditBoxHeight)
    dpadbuttonseditbox:SetMovable(false)
    dpadbuttonseditbox:SetAutoFocus(false)
    dpadbuttonseditbox:EnableMouse(true)
    
    --[[
       TPad button bindings
    --]]
    
    local tpadbindsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    tpadbindsubtitle:SetHeight(textheight)
    tpadbindsubtitle:SetWidth(EditBoxWidth)
    tpadbindsubtitle:SetPoint("TOPLEFT", dpadbuttonseditbox, "BOTTOMLEFT", -Inset, -Inset)
    tpadbindsubtitle:SetNonSpaceWrap(true)
    tpadbindsubtitle:SetJustifyH("LEFT")
    tpadbindsubtitle:SetJustifyV("TOP")
    tpadbindsubtitle:SetText("Left Right Trigger & Shoulder bindings")
    
    local tpadbuttonseditbox = CreateFrame("EditBox", ADDON .. "TPadButtonsEditBox", scrollChild, "InputBoxTemplate")
    tpadbuttonseditbox:SetPoint("TOPLEFT", tpadbindsubtitle, "BOTTOMLEFT", Inset, 0)
    tpadbuttonseditbox:SetWidth(EditBoxWidth-EditBoxSpacing)
    tpadbuttonseditbox:SetHeight(EditBoxHeight)
    tpadbuttonseditbox:SetMovable(false)
    tpadbuttonseditbox:SetAutoFocus(false)

    --[[
       SPad button bindings
    --]]
    
    local spadbindsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    spadbindsubtitle:SetHeight(textheight)
    spadbindsubtitle:SetWidth(EditBoxWidth)
    spadbindsubtitle:SetPoint("TOPLEFT", tpadbuttonseditbox, "BOTTOMLEFT", -Inset, -Inset)
    spadbindsubtitle:SetNonSpaceWrap(true)
    spadbindsubtitle:SetJustifyH("LEFT")
    spadbindsubtitle:SetJustifyV("TOP")
    spadbindsubtitle:SetText("Left Right Stick & Paddle bindings")
    
    local spadbuttonseditbox = CreateFrame("EditBox", ADDON .. "SPadButtonsEditBox", scrollChild, "InputBoxTemplate")
    spadbuttonseditbox:SetPoint("TOPLEFT", spadbindsubtitle, "BOTTOMLEFT", Inset, 0)
    spadbuttonseditbox:SetWidth(EditBoxWidth-EditBoxSpacing)
    spadbuttonseditbox:SetHeight(EditBoxHeight)
    spadbuttonseditbox:SetMovable(false)
    spadbuttonseditbox:SetAutoFocus(false)
    spadbuttonseditbox:EnableMouse(true)
    
    --[[
       Apply button bindings
    --]]
    
    local bindingsapply = CreateFrame("Button", ADDON .. "BindingsApply", scrollChild, "UIPanelButtonTemplate")
    bindingsapply:SetPoint("TOPLEFT", spadbuttonseditbox, "BOTTOMLEFT", -Inset, -Inset)
    bindingsapply:SetHeight(buttonheight)
    bindingsapply:SetWidth(scrollChild:GetWidth() + -2*Inset)
    bindingsapply:SetText("Apply")
    
    bindingsapply:SetScript("OnClick", function(self, button, down)
       local bindings = StrToBindings(facebuttonseditbox:GetText())
       if #bindings == 4 then
          config.FaceButtons = {unpack(bindings)}
       else
          message("ERROR: Incorrent number of bindings.")
       end
       bindings = StrToBindings(dpadbuttonseditbox:GetText())
       if #bindings == 4 then config.DPadButtons = {unpack(bindings)} end
       bindings = StrToBindings(tpadbuttonseditbox:GetText())
       if #bindings == 4 then config.TPadButtons = {unpack(bindings)} end
       bindings = StrToBindings(spadbuttonseditbox:GetText())
       if #bindings == 4 then config.SPadButtons = {unpack(bindings)} end
       Refresh()
    end)
--[[
    local binddescrip = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
    binddescrip:SetHeight(textheight)
    binddescrip:SetPoint("TOPLEFT", bindingsapply, "BOTTOMLEFT", 0, -DescrpSpacing)
    binddescrip:SetPoint("RIGHT", scrollChild, -2*Inset, 0)
    binddescrip:SetNonSpaceWrap(true)
    binddescrip:SetJustifyH("LEFT")
    binddescrip:SetJustifyV("TOP")
    binddescrip:SetText("Bindings for controller actions.")
--]]
    
    --[[
       Swap button bindings
    --]]    

    local swapsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    swapsubtitle:SetHeight(textheight)
    swapsubtitle:SetWidth(DropDownWidth)
    swapsubtitle:SetPoint("TOPLEFT", bindingsapply, "BOTTOMLEFT", 0, -ConfigSpacing)
    swapsubtitle:SetNonSpaceWrap(true)
    swapsubtitle:SetJustifyH("LEFT")
    swapsubtitle:SetJustifyV("TOP")
    swapsubtitle:SetText("Swap Type")
    
    local swapdropdown = CreateFrame("Frame", ADDON .. "SwapDropDownMenu", scrollChild, "UIDropDownMenuTemplate")
    swapdropdown:SetPoint("TOPLEFT", swapsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(swapdropdown, DropDownWidth-DropDownSpacing)
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
              if config.SwapType == i then 
                 UIDropDownMenu_SetText(self, swaptype)
              end
           end
        end
    end)

    --[[
    local swapdescrip = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
    swapdescrip:SetHeight(textheight)
    swapdescrip:SetPoint("TOPLEFT", swapdropdown, "BOTTOMLEFT", 0, -DescrpSpacing)
    swapdescrip:SetPoint("RIGHT", scrollChild, -2*Inset, 0)
    swapdescrip:SetNonSpaceWrap(true)
    swapdescrip:SetJustifyH("LEFT")
    swapdescrip:SetJustifyV("TOP")
    swapdescrip:SetText("Using the Swap Modifier will swap these buttons to [1-4].")
    --]]
    
    --[[
       Expanded button bindings
    --]]    

    local expdsubtitle = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    expdsubtitle:SetHeight(textheight)
    expdsubtitle:SetWidth(DropDownWidth)
    expdsubtitle:SetPoint("TOPLEFT", swapsubtitle, "TOPRIGHT", 0, 0)
    expdsubtitle:SetNonSpaceWrap(true)
    expdsubtitle:SetJustifyH("LEFT")
    expdsubtitle:SetJustifyV("TOP")
    expdsubtitle:SetText("Expanded Type")

    local expddropdown = CreateFrame("Frame", ADDON .. "ExpandedDropDownMenu", scrollChild, "UIDropDownMenuTemplate")
    expddropdown:SetPoint("TOPLEFT", expdsubtitle, "BOTTOMLEFT", 0, 0)
    
    UIDropDownMenu_SetWidth(expddropdown, DropDownWidth-DropDownSpacing)
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

    --[[
    local expddescrip = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
    expddescrip:SetHeight(textheight)
    expddescrip:SetPoint("TOPLEFT", expddropdown, "BOTTOMLEFT", 0, -DescrpSpacing)
    expddescrip:SetPoint("RIGHT", scrollChild, -2*Inset, 0)
    expddescrip:SetNonSpaceWrap(true)
    expddescrip:SetJustifyH("LEFT")
    expddescrip:SetJustifyV("TOP")
    expddescrip:SetText("Double tapping the left or right modifier will map buttons [9-12] to [1-4].")
    --]]
    
    function Refresh()
       if not frame:IsVisible() then return end
       
       config:ProcessConfig(config)
       
       presetdeletebutton:SetEnabled(CrossHotbar_DB.Presets[preset].Mutable)
       presetfileeditbox:SetText(config.Name)
       
       UIDropDownMenu_SetText(PresetsFrame, CrossHotbar_DB.Presets[preset].Name)
       UIDropDownMenu_SetText(leftmodifierframe, config.LeftModifier);
       UIDropDownMenu_SetText(rightmodifierframe, config.RightModifier);
       UIDropDownMenu_SetText(swapmodifierframe, config.SwapModifier);

       facebuttonseditbox:SetText(BindingsToStr(config.FaceButtons))
       dpadbuttonseditbox:SetText(BindingsToStr(config.DPadButtons))
       tpadbuttonseditbox:SetText(BindingsToStr(config.TPadButtons))
       spadbuttonseditbox:SetText(BindingsToStr(config.SPadButtons))
       
       UIDropDownMenu_SetText(swapdropdown, swaptypes[config.SwapType]);
       UIDropDownMenu_SetText(expddropdown, wxhbtypes[config.WXHBType]);

       Crosshotbar:SetupCrosshotbar()
    end

    frame:SetScript("OnShow", Refresh) 
    Refresh()
end)

InterfaceOptions_AddCategory(frame)
