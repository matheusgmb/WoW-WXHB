local ADDON, addon = ...
local config = addon.Config

local ActionList = {
   ["MACRO CH_MACRO_1"] = true,
   ["MACRO CH_MACRO_2"] = true,
   ["MACRO CH_MACRO_3"] = true,
   ["MACRO CH_MACRO_4"] = true,
   ["JUMP"] = true,
   ["INTERACTMOUSEOVER"] = true,
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

local SetButtonPairState = [[
   local button, down, pairname  = ...

   local type = 0
   if button == "LeftButton" then type = 2 end
   if button == "RightButton" then type = 3 end

   local Crosshotbar = self:GetFrameRef('Crosshotbar')
   local GamePadButtons = self:GetFrameRef('GamePadButtons')
   local GroupNavigator = self:GetFrameRef('GroupNavigator')

   if Crosshotbar ~= nill and GamePadButtons ~= nil and type ~= 0 then
      local state = Crosshotbar:GetAttribute(pairname.."state")

      local a = 0
      if state == 6 or state == 3 then a = 2 end
      if state == 7 or state == 5 then a = 3 end
      local b = a - state + 4

      if a == 0 then
         a = b
         b = 0
      end

      local found = true
      if down and a == 0 then
         a = type
      elseif down and b == 0 then
         b = type
      elseif not down and a == type then
         a = 0
      elseif not down and b == type then
         b = 0
      else
         found = false
      end

      if found then
         state = a - b + 4
         Crosshotbar:SetAttribute(pairname.."state", state)
         Crosshotbar:SetAttribute("state-"..pairname, state)
         GamePadButtons:SetAttribute("state-"..pairname, state)
         GroupNavigator:SetAttribute("state-"..pairname, state)
      else
         print("Error " .. state .. " " .. a .. " " .. b .. " " .. type)
      end
   end
]]

local SetButtonExpanded = [[
   local button = ...

   local type = 0
   if button == "LeftButton" then type = 2 end
   if button == "RightButton" then type = 3 end

   local Crosshotbar = self:GetFrameRef('Crosshotbar')

   if Crosshotbar ~= nill and type ~= 0 then
      local expanded = Crosshotbar:GetAttribute("expanded")
      if expanded == 0 then
         if type == 2 then
            Crosshotbar:SetAttribute("expanded", 1)
         else
            Crosshotbar:SetAttribute("expanded", 2)
         end
      end
   end
]]

local SetButtonSwapped = [[
   local down = ...

   local Crosshotbar = self:GetFrameRef('Crosshotbar')
   if Crosshotbar ~= nil then
      if down then Crosshotbar:SetAttribute("state-swap", 1)
      else Crosshotbar:SetAttribute("state-swap", 0) end
   end

   local GamePadButtons = self:GetFrameRef('GamePadButtons')
   if GamePadButtons ~= nil then
      if down then GamePadButtons:SetAttribute("state-swap", 1)
      else GamePadButtons:SetAttribute("state-swap", 0) end
   end

   local GroupNavigator = self:GetFrameRef('GroupNavigator')
   if GroupNavigator ~= nil then
      if down then GroupNavigator:SetAttribute("state-swap", 1)
      else GroupNavigator:SetAttribute("state-swap", 0) end
   end

]]

addon.GamePadActions = ActionList

local GamePadButtonsMixin = {
   LeftTriggerButton = nil,
   RightTriggerButton = nil,
   LeftShoulderButton = nil,
   RightShoulderButton = nil,
   LeftPaddleButton = nil,
   RightPaddleButton = nil
}

function GamePadButtonsMixin:ToggleSheath()
   ToggleSheath()
end

function GamePadButtonsMixin:ZoomIn()
   MoveViewInStart(1.0, 0, true);
end

function GamePadButtonsMixin:ZoomOut()
   MoveViewOutStart(1.0, 0, true);
end

function GamePadButtonsMixin:CreateButton(ButtonName)
   local Button = CreateFrame("Button", ADDON .. ButtonName .. "ButtonFrame",
                                         self, "SecureActionButtonTemplate" )
   Button:SetFrameStrata("BACKGROUND")
   Button:SetPoint("TOP", self, "LEFT", 0, 0)
   Button:RegisterForClicks("AnyDown", "AnyUp")
   Button:Hide()
   Button:RegisterEvent("PLAYER_ENTERING_WORLD")
   local function OnEvent(self, event, ...)
      if event == 'PLAYER_ENTERING_WORLD' then
         SecureHandlerSetFrameRef(Button, 'Crosshotbar', addon.Crosshotbar)
         SecureHandlerSetFrameRef(Button, 'GamePadButtons', addon.GamePadButtons)
         SecureHandlerSetFrameRef(Button, 'GroupNavigator', addon.GroupNavigator)
      end
   end
   Button:HookScript("OnEvent", OnEvent)
   SecureHandlerSetFrameRef(self, ButtonName, Button)
   return Button
end

function GamePadButtonsMixin:CreateLeftTriggerButton()
   self.LeftTriggerButton = self:CreateButton("LeftTrigger")
   self.LeftTriggerButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   self.LeftTriggerButton:SetAttribute("SetButtonExpanded", SetButtonExpanded)
   SecureHandlerWrapScript(self.LeftTriggerButton, "OnClick", self.LeftTriggerButton,
                           [[self:RunAttribute("SetButtonPairState", "LeftButton", down, "trigger")]])
   SecureHandlerWrapScript(self.LeftTriggerButton, "OnDoubleClick", self.LeftTriggerButton,
                           [[self:RunAttribute("SetButtonPairState", "LeftButton", false, "trigger")
                             self:RunAttribute("SetButtonExpanded", "LeftButton")]])
end

function GamePadButtonsMixin:CreateRightTriggerButton()
   self.RightTriggerButton = self:CreateButton("RightTrigger")
   self.RightTriggerButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   self.RightTriggerButton:SetAttribute("SetButtonExpanded", SetButtonExpanded)
   SecureHandlerWrapScript(self.RightTriggerButton, "OnClick", self.RightTriggerButton,
                           [[self:RunAttribute("SetButtonPairState", "RightButton", down, "trigger")]])
   SecureHandlerWrapScript(self.RightTriggerButton, "OnDoubleClick", self.RightTriggerButton,
                           [[self:RunAttribute("SetButtonPairState", "RightButton", false, "trigger")
                             self:RunAttribute("SetButtonExpanded", "RightButton")]])
end

function GamePadButtonsMixin:CreateLeftShoulderButton()
   self.LeftShoulderButton = self:CreateButton("LeftShoulder")
   self.LeftShoulderButton:SetAttribute("*type1", "macro")
   self.LeftShoulderButton:SetAttribute("macrotext1", "")
   self.LeftShoulderButton:SetAttribute("padaction", "/targetenemy 1\n")
   self.LeftShoulderButton:SetAttribute("padswapaction", "/targetenemy\n")
   self.LeftShoulderButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   SecureHandlerWrapScript(self.LeftShoulderButton, "OnClick", self.LeftShoulderButton,
                           [[self:RunAttribute("SetButtonPairState", "LeftButton", down, "shoulder")]])
end

function GamePadButtonsMixin:CreateRightShoulderButton()
   self.RightShoulderButton = self:CreateButton("RightShoulder")
   self.RightShoulderButton:SetAttribute("*type1", "macro")
   self.RightShoulderButton:SetAttribute("macrotext1", "")
   self.RightShoulderButton:SetAttribute("padaction", "/targetenemy\n")
   self.RightShoulderButton:SetAttribute("padswapaction", "/targetenemy 1\n")
   self.RightShoulderButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   SecureHandlerWrapScript(self.RightShoulderButton, "OnClick", self.RightShoulderButton,
                           [[self:RunAttribute("SetButtonPairState", "RightButton", down, "shoulder")]])
end

function GamePadButtonsMixin:CreateLeftPaddleButton()
   self.LeftPaddleButton = self:CreateButton("LeftPaddle")
   self.LeftPaddleButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   SecureHandlerWrapScript(self.LeftPaddleButton, "OnClick", self.LeftPaddleButton,
                           [[self:RunAttribute("SetButtonPairState", "LeftButton", down, "paddle")]])
end

function GamePadButtonsMixin:CreateRightPaddleButton()
   self.RightPaddleButton = self:CreateButton("RightPaddle")
   self.RightPaddleButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   SecureHandlerWrapScript(self.RightPaddleButton, "OnClick", self.RightPaddleButton,
                           [[self:RunAttribute("SetButtonPairState", "RightButton", down, "paddle")]])
end

function GamePadButtonsMixin:OnLoad()
   self:SetAttribute("GetActionBindings", GetActionBindings)
   self:SetAttribute("SetActionBindings", SetActionBindings)
   self:SetAttribute("SetButtonSwapped", SetButtonSwapped)
   --self:SetAttribute("_onstate-trigger", [[]])
   self:SetAttribute("_onstate-shoulder", [[
      local Crosshotbar = self:GetFrameRef('Crosshotbar')
      local swapbutton = self:GetAttribute("swapbutton")
      if Crosshotbar ~= nil then
         local triggerstate = Crosshotbar:GetAttribute("triggerstate")
         if triggerstate == 4 then
            local LeftShoulderButton = self:GetFrameRef('LeftShoulder')
            local RightShoulderButton = self:GetFrameRef('RightShoulder')
            if LeftShoulderButton ~= nil and RightShoulderButton ~= nil then
               LeftShoulderButton:SetAttribute("macrotext1", "")
               RightShoulderButton:SetAttribute("macrotext1", "")
            end
            if newstate == 3 then
               self:CallMethod("ToggleSheath")
            end
            if newstate == 7 then
               local offset = (Crosshotbar:GetAttribute("pageoffset") + 2)%10
               --Crosshotbar:SetAttribute("state-nextpage", offset)
               --Crosshotbar:SetAttribute("pageoffset", offset)
            end
         else
            local LeftShoulderButton = self:GetFrameRef('LeftShoulder')
            local RightShoulderButton = self:GetFrameRef('RightShoulder')
            if LeftShoulderButton ~= nil and RightShoulderButton ~= nil then
               local attrname = "padaction"
               local swap = self:GetAttribute('swap')
               if swap == 1 then attrname = "padswapaction" end
               local leftaction = LeftShoulderButton:GetAttribute(attrname)
               local rightaction = RightShoulderButton:GetAttribute(attrname)
               if swapbutton ~= "SPADL" then
                  LeftShoulderButton:SetAttribute("macrotext1", leftaction)
               end
               if swapbutton ~= "SPADR" then
                  RightShoulderButton:SetAttribute("macrotext1", rightaction)
               end
            end
         end
         if swapbutton == "SPADL" then
            if newstate == 6 or newstate == 3 or newstate == 2 then
               self:RunAttribute("SetButtonSwapped", true)
            else
               self:RunAttribute("SetButtonSwapped", false)
            end
         end
         if swapbutton == "SPADR" then
            if newstate == 7 or newstate == 5 or newstate == 1 then
               self:RunAttribute("SetButtonSwapped", true)
            else
               self:RunAttribute("SetButtonSwapped", false)
            end
         end
      end
   ]])
   self:SetAttribute("_onstate-paddle", [[
      local swapbutton = self:GetAttribute("swapbutton")
      if swapbutton == "PPADL" then
         if newstate == 6 or newstate == 3 or newstate == 2 then
            self:RunAttribute("SetButtonSwapped", true)
         else
            self:RunAttribute("SetButtonSwapped", false)
         end
      end
      if swapbutton == "PPADR" then
         if newstate == 7 or newstate == 5 or newstate == 1 then
            self:RunAttribute("SetButtonSwapped", true)
         else
            self:RunAttribute("SetButtonSwapped", false)
         end
      end
   ]])

   self:SetAttribute("_onstate-swap", [[
      self:SetAttribute("swap", newstate)
   ]])
   
   self:RegisterEvent("PLAYER_ENTERING_WORLD")

   self:CreateLeftTriggerButton()
   self:CreateRightTriggerButton()
   self:CreateLeftShoulderButton()
   self:CreateRightShoulderButton()
   self:CreateLeftPaddleButton()
   self:CreateRightPaddleButton()
end

function GamePadButtonsMixin:OnEvent(event, ...)
   if event == 'PLAYER_ENTERING_WORLD' then
      SecureHandlerSetFrameRef(self, 'Crosshotbar', addon.Crosshotbar)
      SecureHandlerSetFrameRef(self, 'GamePadButtons', addon.GamePadButtons)
      SecureHandlerSetFrameRef(self, 'GroupNavigator', addon.GroupNavigator)
      self:ApplyConfig()
      self:Execute([[
         self:SetAttribute("state-trigger", 4)
      ]])
   end
end

function GamePadButtonsMixin:ApplyConfig()
   local swapbutton = ""
   for button, attributes in pairs(config.PadActions) do
      if ActionList[attributes.ACTION] then
         SetOverrideBinding(self, true, attributes.BIND, attributes.ACTION)
      end
      self:SetAttribute(button, attributes.BIND)
      if attributes.ACTION == "SWAPHOTBAR" then
         swapbutton = button
      end
   end
   
   SetOverrideBindingClick(self.LeftTriggerButton, true, config.PadActions.TRIGL.BIND,
                           self.LeftTriggerButton:GetName(), "LeftButton")
   SetOverrideBindingClick(self.RightTriggerButton, true, config.PadActions.TRIGR.BIND,
                           self.RightTriggerButton:GetName(), "LeftButton")
   SetOverrideBindingClick(self.LeftShoulderButton, true, config.PadActions.SPADL.BIND,
                           self.LeftShoulderButton:GetName(), "LeftButton")
   SetOverrideBindingClick(self.RightShoulderButton, true, config.PadActions.SPADR.BIND,
                           self.RightShoulderButton:GetName(), "LeftButton")
   SetOverrideBindingClick(self.LeftPaddleButton, true, config.PadActions.PPADL.BIND,
                           self.LeftPaddleButton:GetName(), "LeftButton")
   SetOverrideBindingClick(self.RightPaddleButton, true, config.PadActions.PPADR.BIND,
                           self.RightPaddleButton:GetName(), "LeftButton")

   self:SetAttribute("swapbutton", swapbutton)
   
end

local CreateGamePadButtons = function(parent)
   local GamePadButtons = CreateFrame("Frame", ADDON .. "GamePadButtonsFrame",
                                      parent, "SecureHandlerStateTemplate" )
   Mixin(GamePadButtons, GamePadButtonsMixin)
   GamePadButtons:SetFrameStrata("BACKGROUND")
   GamePadButtons:SetPoint("TOP", parent:GetName(), "LEFT", 0, 0)
   GamePadButtons:HookScript("OnEvent", GamePadButtons.OnEvent)
   GamePadButtons:Hide()
   GamePadButtons:OnLoad()
   addon.GamePadButtons = GamePadButtons
end

addon.CreateGamePadButtons = CreateGamePadButtons
