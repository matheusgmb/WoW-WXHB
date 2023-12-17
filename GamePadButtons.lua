local ADDON, addon = ...
local config = addon.Config

local ActionList = {
   ["MACRO CH_MACRO_1"] = true,
   ["MACRO CH_MACRO_2"] = true,
   ["MACRO CH_MACRO_3"] = true,
   ["MACRO CH_MACRO_4"] = true,
   ["JUMP"] = true,
   ["INTERACTTARGET"] = true,
   ["TOGGLEWORLDMAP"] = true,
   ["TOGGLEGAMEMENU"] = true,
   ["TOGGLESHEATH"] = true,
   ["TARGETNEARESTFRIEND"] = true,
   ["TARGETPREVIOUSFRIEND"] = true,
   ["TARGETNEARESTENEMY"] = true,
   ["TARGETPREVIOUSENEMY"] = true,
   ["TARGETSCANENEMY"] = true,
   ["TARGETLASTHOSTILE"] = true,
   ["ASSISTTARGET"] = true,
   ["NEXTACTIONPAGE"] = true,
   ["PREVIOUSACTIONPAGE"] = true,
   ["EXTRAACTIONBUTTON1"] = true,
   ["SHAPESHIFTBUTTON1"] = true,
   ["SHAPESHIFTBUTTON2"] = true,
   ["BONUSACTIONBUTTON1"] = true,
   ["BONUSACTIONBUTTON"] = true
}

addon.GamePadActions = ActionList

local GamePadButtonsMixin = {}

function GamePadButtonsMixin:OnLoad()
   self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function GamePadButtonsMixin:OnEvent(event, ...)
   if event == 'PLAYER_ENTERING_WORLD' then
      self:ApplyConfig()
      --SetOverrideBindingClick(self, true, "5", self:GetName(), "RightButton")
      --SetOverrideBindingClick(self, true, "5", self:GetName(), "RightButton")
      --SetOverrideBindingClick(self, true, "0", self:GetName(), "MiddleButton")
      --[[
         SetOverrideBinding(self, true, "6", "JUMP")
         SetOverrideBinding(self, true, "7", "INTERACTTARGET")
         SetOverrideBinding(self, true, "8", "TOGGLEWORLDMAP")
      --]]
   end
end

function GamePadButtonsMixin:ApplyConfig()
   for button, actions in pairs(config.PadActions) do
      local binding, action, leftrightaction, swapaction = unpack(actions)
      
      if ActionList[action] then
         SetOverrideBinding(self, true, binding, action)
         
         if ActionList[leftrightaction] then action = leftrightaction end

         SetOverrideBinding(self, true, "CTRL-" .. binding, action)
         
         SetOverrideBinding(self, true, "SHIFT-" .. binding, action)
         SetOverrideBinding(self, true, "CRTL-SHIFT-" .. binding, action)
         
         if ActionList[swapaction] then action = swapaction end
         
         SetOverrideBinding(self, true, "ALT-" .. binding, action)
         SetOverrideBinding(self, true, "ALT-CTRL-" .. binding, action)
         SetOverrideBinding(self, true, "ALT-SHIFT-" .. binding, action)
         SetOverrideBinding(self, true, "ALT-CRTL-SHIFT-" .. binding, action)

         local swapbingings = addon.Config:GetSwapBinding(button)
         if swapbindings then
            SetOverrideBinding(self, true, "ALT-" .. swapbindings[1], action)
            SetOverrideBinding(self, true, "ALT-CTRL-" .. swapbindings[1], action)
            SetOverrideBinding(self, true, "ALT-SHIFT-" ..swapbindings[1], action)
            SetOverrideBinding(self, true, "ALT-CRTL-SHIFT-" .. swapbindings[1], action)
         end
      end
   end
end



local GamePadButtons = CreateFrame("Button", ADDON .. "GamePadButtonsFrame",
                                   UIParent, "SecureActionButtonTemplate" )
GamePadButtons:SetFrameStrata("BACKGROUND")
GamePadButtons:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0)
GamePadButtons:Hide()

Mixin(GamePadButtons, GamePadButtonsMixin)

GamePadButtons:SetAttribute("*type1", "action")
GamePadButtons:SetAttribute("*type2", "macro")
GamePadButtons:SetAttribute("*type3", "action")
GamePadButtons:SetAttribute("*type4", "macro")
GamePadButtons:SetAttribute("*type5", "target")
GamePadButtons:SetAttribute("macrotext2", "/cleartarget\n/stopspelltarget\n")
GamePadButtons:SetAttribute("action3", 25)

GamePadButtons:HookScript("OnEvent", GamePadButtons.OnEvent)
GamePadButtons:OnLoad()

addon.GamePadButtons = GamePadButtons
