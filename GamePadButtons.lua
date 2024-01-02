local ADDON, addon = ...
local config = addon.Config

local GamePadButtonList = addon.GamePadButtonList
local GamePadModifierList = addon.GamePadModifierList

local ModifierList = {
   ["LEFTSHOULDER"] = true,
   ["RIGHTSHOULDER"] = true,
   ["LEFTHOTBAR"] = true,
   ["RIGHTHOTBAR"] = true,
   ["LEFTPADDLE"] = true,
   ["RIGHTPADDLE"] = true
}
config:ConfigListAdd("GamePadModifiers", ModifierList, "NONE")

local ActionList = {
   ["JUMP"] = true,
   ["INTERACTTARGET"] = true,
   ["TOGGLEWORLDMAP"] = true,
   ["TOGGLESHEATH"] = true,
   ["ASSISTTARGET"] = true,
   ["FOCUSTARGET"] = true,
   ["TARGETFOCUS"] = true,
   ["TARGETLASTHOSTILE"] = true,
   ["TARGETLASTTARGET"] = true,
   ["TARGETNEARESTFRIEND"] = true,
   ["TARGETPREVIOUSFRIEND"] = true,
   ["TARGETNEARESTENEMY"] = true,
   ["TARGETPREVIOUSENEMY"] = true,
   ["TARGETLASTTARGET"] = true,
   ["TARGETSELF"] = true,
   ["TARGETPARTYMEMBER1"] = true,
   ["TARGETPARTYMEMBER2"] = true,
   ["TARGETPARTYMEMBER3"] = true,
   ["TARGETPARTYMEMBER4"] = true,
   ["MACRO CH_MACRO_1"] = true,
   ["MACRO CH_MACRO_2"] = true,
   ["MACRO CH_MACRO_3"] = true,
   ["MACRO CH_MACRO_4"] = true
}
config:ConfigListAdd("GamePadActions", ActionList, "NONE")

local ModifierActions = {
   ["SIT"] = [[ local down = ...
      if down then
         self:SetAttribute("macrotext1", "/sit")
      end
   ]],
   ["MACRO CH_MACRO_1"] = [[ local down = ...
      if down then
         self:SetAttribute("macro", "CH_MACRO_1")
      end
   ]],
   ["MACRO CH_MACRO_2"] = [[ local down = ...
      if down then
         self:SetAttribute("macro", "CH_MACRO_2")
      end
   ]],
   ["MACRO CH_MACRO_3"] = [[ local down = ...
      if down then
         self:SetAttribute("macro", "CH_MACRO_3")
      end
   ]],
   ["MACRO CH_MACRO_4"] = [[ local down = ...
      if down then
         self:SetAttribute("macro", "CH_MACRO_4")
      end
   ]],
   ["EXTRAACTIONBUTTON1"] = [[ local down = ...
      if down then
         self:SetAttribute("macrotext1", "/click ExtraActionButton1")
      end
   ]],
   ["ASSISTTARGET"] = [[ local down = ...
      if down then
         self:SetAttribute("macrotext1", "/assist")
      end
   ]],
   ["TARGETLASTHOSTILE"] = [[ local down = ...
      if down then
         self:SetAttribute("macrotext1", "/targetlastenemy")
      end
   ]],
   ["TARGETLASTTARGET"] = [[local down = ...
      if down then
         self:SetAttribute("macrotext1", "/targetlasttarget")
      end
   ]],
   ["TARGETNEARESTENEMY"] = [[local down = ...
      if down then
         self:SetAttribute("macrotext1", "/targetenemy")
      end
   ]],
   ["TARGETPREVIOUSENEMY"] = [[local down = ...
      if down then
         self:SetAttribute("macrotext1", "/targetenemy 1")
      end
   ]],
   ["TARGETSELF"] = [[local down = ...
      if down then
         self:SetAttribute("macrotext1", "/target player")
      end
   ]],
   ["TARGETPARTYMEMBER1"] = [[local down = ...
      if down then
         self:SetAttribute("macrotext1", "/target party1")
      end
   ]],
   ["TARGETPARTYMEMBER2"] = [[local down = ...
      if down then
         self:SetAttribute("macrotext1", "/target party2")
      end
   ]],
   ["TARGETPARTYMEMBER3"] = [[local down = ...
      if down then
         self:SetAttribute("macrotext1", "/target party3")
      end
   ]],
   ["TARGETPARTYMEMBER4"] = [[local down = ...
      if down then
         self:SetAttribute("macrotext1", "/target party4")
      end
   ]],
   ["SHEATH"] = [[local down = ...
      if down then
        local GamePadButtons = self:GetFrameRef('GamePadButtons')
        if GamePadButtons then
           GamePadButtons:CallMethod("ToggleSheath")
        end
      end
   ]],
   ["ZOOMIN"] = [[local down = ...
      local GamePadButtons = self:GetFrameRef('GamePadButtons')
      if GamePadButtons then
         GamePadButtons:CallMethod("ZoomIn", down)
      end
   ]],
   ["ZOOMOUT"] = [[local down = ...
      local GamePadButtons = self:GetFrameRef('GamePadButtons')
      if GamePadButtons then
         GamePadButtons:CallMethod("ZoomOut", down)
      end
   ]],
   ["NEXTPAGE"] = [[local down = ...
      if down then
         local Crosshotbar = self:GetFrameRef('Crosshotbar')
         local offset = (Crosshotbar:GetAttribute("pageoffset") + 2)%10
         Crosshotbar:SetAttribute("state-nextpage", offset)
         Crosshotbar:SetAttribute("pageoffset", offset)
      end
   ]],
   ["PREVPAGE"] = [[local down = ...
      if down then
         local Crosshotbar = self:GetFrameRef('Crosshotbar')
         local offset = abs(Crosshotbar:GetAttribute("pageoffset") - 2)%10
         Crosshotbar:SetAttribute("state-nextpage", offset)
         Crosshotbar:SetAttribute("pageoffset", offset)
      end
   ]],
   ["PAGEONE"] = [[local down = ...
      if down then
         local Crosshotbar = self:GetFrameRef('Crosshotbar')
         local offset = 2
         Crosshotbar:SetAttribute("state-nextpage", offset)
         Crosshotbar:SetAttribute("pageoffset", offset)
      end
   ]],
   ["PAGETWO"] = [[local down = ...
      if down then
         local Crosshotbar = self:GetFrameRef('Crosshotbar')
         local offset = 0
         Crosshotbar:SetAttribute("state-nextpage", offset)
         Crosshotbar:SetAttribute("pageoffset", offset)
      end
   ]],
   ["PAGETHREE"] = [[local down = ...
      if down then
         local Crosshotbar = self:GetFrameRef('Crosshotbar')
         local offset = 4
         Crosshotbar:SetAttribute("state-nextpage", offset)
         Crosshotbar:SetAttribute("pageoffset", offset)
      end
   ]],
   ["PAGEFOUR"] = [[local down = ...
         if down then
            local Crosshotbar = self:GetFrameRef('Crosshotbar')
            local offset = 6
            Crosshotbar:SetAttribute("state-nextpage", offset)
            Crosshotbar:SetAttribute("pageoffset", offset)
         end
   ]]
}
config:ConfigListAdd("GamePadModifierActions", ModifierActions, "NONE")

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

function GamePadButtonsMixin:ZoomIn(down)
   if down then
      MoveViewInStart(1.0, 0, true);
   else
      CameraZoomIn(1.0)
   end
end

function GamePadButtonsMixin:ZoomOut(down)
   if down then
      MoveViewOutStart(1.0, 0, true);
   else
      CameraZoomOut(1.0)
   end
end

local SetButtonPairState = [[
   local button, down, pairname  = ...

   local type = 0
   if button == "LeftButton" then type = 2 end
   if button == "RightButton" then type = 3 end

   local GamePadButtons = self:GetFrameRef('GamePadButtons')

   if GamePadButtons ~= nil and type ~= 0 then
      local state = GamePadButtons:GetAttribute(pairname.."state")

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
         GamePadButtons:SetAttribute("state-"..pairname, state)
      else
         print("Error " .. state .. " " .. a .. " " .. b .. " " .. type)
      end
   end
]]

local SetButtonExpanded = [[
   local button = ...

   local GamePadButtons = self:GetFrameRef('GamePadButtons')
   if GamePadButtons ~= nill then
      if button == "LeftButton" then
         GamePadButtons:SetAttribute("state-expanded", 1)
      end
      if button == "RightButton" then
         GamePadButtons:SetAttribute("state-expanded", 2)
      end
   end
]]

function GamePadButtonsMixin:CreatePairButton(ButtonName)
   local Button = CreateFrame("Button", ADDON .. ButtonName .. "ButtonFrame",
                                         self, "SecureActionButtonTemplate" )
   Button:SetFrameStrata("BACKGROUND")
   Button:SetPoint("TOP", self, "LEFT", 0, 0)
   Button:RegisterForClicks("AnyDown", "AnyUp")
   Button:Hide()
   Button:RegisterEvent("PLAYER_ENTERING_WORLD")
   local function OnEvent(self, event, ...)
      if event == 'PLAYER_ENTERING_WORLD' then
         SecureHandlerSetFrameRef(self, 'Crosshotbar', addon.Crosshotbar)
         SecureHandlerSetFrameRef(self, 'GamePadButtons', addon.GamePadButtons)
         SecureHandlerSetFrameRef(self, 'GroupNavigator', addon.GroupNavigator)
      end
   end
   Button:HookScript("OnEvent", OnEvent)
   SecureHandlerSetFrameRef(self, ButtonName, Button)
   return Button
end

function GamePadButtonsMixin:CreateLeftTriggerButton()
   self.LeftTriggerButton = self:CreatePairButton("LeftTrigger")
   self.LeftTriggerButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   self.LeftTriggerButton:SetAttribute("SetButtonExpanded", SetButtonExpanded)
   SecureHandlerWrapScript(self.LeftTriggerButton, "OnClick", self.LeftTriggerButton,
                           [[self:RunAttribute("SetButtonPairState", "LeftButton", down, "trigger")]])
   SecureHandlerWrapScript(self.LeftTriggerButton, "OnDoubleClick", self.LeftTriggerButton,
                           [[self:RunAttribute("SetButtonPairState", "LeftButton", false, "trigger")
                             self:RunAttribute("SetButtonExpanded", "LeftButton")]])
end

function GamePadButtonsMixin:CreateRightTriggerButton()
   self.RightTriggerButton = self:CreatePairButton("RightTrigger")
   self.RightTriggerButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   self.RightTriggerButton:SetAttribute("SetButtonExpanded", SetButtonExpanded)
   SecureHandlerWrapScript(self.RightTriggerButton, "OnClick", self.RightTriggerButton,
                           [[self:RunAttribute("SetButtonPairState", "RightButton", down, "trigger")]])
   SecureHandlerWrapScript(self.RightTriggerButton, "OnDoubleClick", self.RightTriggerButton,
                           [[self:RunAttribute("SetButtonPairState", "RightButton", false, "trigger")
                             self:RunAttribute("SetButtonExpanded", "RightButton")]])
end

function GamePadButtonsMixin:CreateLeftShoulderButton()
   self.LeftShoulderButton = self:CreatePairButton("LeftShoulder")
   self.LeftShoulderButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   SecureHandlerWrapScript(self.LeftShoulderButton, "OnClick", self.LeftShoulderButton,
                           [[self:RunAttribute("SetButtonPairState", "LeftButton", down, "shoulder")]])
end

function GamePadButtonsMixin:CreateRightShoulderButton()
   self.RightShoulderButton = self:CreatePairButton("RightShoulder")
   self.RightShoulderButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   SecureHandlerWrapScript(self.RightShoulderButton, "OnClick", self.RightShoulderButton,
                           [[self:RunAttribute("SetButtonPairState", "RightButton", down, "shoulder")]])
end

function GamePadButtonsMixin:CreateLeftPaddleButton()
   self.LeftPaddleButton = self:CreatePairButton("LeftPaddle")
   self.LeftPaddleButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   SecureHandlerWrapScript(self.LeftPaddleButton, "OnClick", self.LeftPaddleButton,
                           [[self:RunAttribute("SetButtonPairState", "LeftButton", down, "paddle")]])
end

function GamePadButtonsMixin:CreateRightPaddleButton()
   self.RightPaddleButton = self:CreatePairButton("RightPaddle")
   self.RightPaddleButton:SetAttribute("SetButtonPairState", SetButtonPairState)
   SecureHandlerWrapScript(self.RightPaddleButton, "OnClick", self.RightPaddleButton,
                           [[self:RunAttribute("SetButtonPairState", "RightButton", down, "paddle")]])
end

function GamePadButtonsMixin:CreateModifierButton(Name)
   self[Name.."Button"] = CreateFrame("Button", ADDON .. Name .. "ButtonFrame",
                                      self, "SecureActionButtonTemplate, SecureHandlerStateTemplate" )
   self[Name.."Button"]:SetFrameStrata("BACKGROUND")
   self[Name.."Button"]:SetPoint("TOP", self, "LEFT", 0, 0)
   self[Name.."Button"]:RegisterForClicks("AnyDown", "AnyUp")
   self[Name.."Button"]:Hide()
   self[Name.."Button"]:RegisterEvent("PLAYER_ENTERING_WORLD")
   local function OnEvent(self, event, ...)
      if event == 'PLAYER_ENTERING_WORLD' then
         SecureHandlerSetFrameRef(self, 'Crosshotbar', addon.Crosshotbar)
         SecureHandlerSetFrameRef(self, 'GamePadButtons', addon.GamePadButtons)
         SecureHandlerSetFrameRef(self, 'GroupNavigator', addon.GroupNavigator)
      end
   end
   self[Name.."Button"]:HookScript("OnEvent", OnEvent)
   self[Name.."Button"]:SetAttribute("*type1", "macro")
   self[Name.."Button"]:SetAttribute("macrotext1", "")
   self[Name.."Button"]:SetAttribute("modstate", 0)
   self[Name.."Button"]:SetAttribute("modname", "")
   self[Name.."Button"]:SetAttribute("trigstate", 4)
   self[Name.."Button"]:SetAttribute("_onstate-trigger", [[
      self:SetAttribute("trigstate", newstate)
      local modstate = self:GetAttribute("modstate")
      if newstate ~= 4 then
         if modstate == 0 then
            self:SetAttribute("modstate", 1)
         end
         local modname = self:GetAttribute("modname")
         local binding = self:GetAttribute(modname .. "TRIGBINDING")
         if binding ~= nil and binding ~= "" then
            local action = self:GetAttribute(modname .. "TRIGACTION")
            self:SetAttribute("ACTIVE", action) 
            self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
         else 
            local binding = self:GetAttribute("TRIGBINDING")
            if binding ~= nil and binding ~= "" then
               local action = self:GetAttribute("TRIGACTION")
               self:SetAttribute("ACTIVE", action) 
               self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
            end
         end
      else
         self:ClearBindings()
         if modstate == 1 then
            self:SetAttribute("modstate", 0)
         else
            local modname = self:GetAttribute("modname")
            local binding = self:GetAttribute(modname .. "BINDING")
            if binding ~= nil and binding ~= "" then
               local action = self:GetAttribute(modname .. "ACTION")
               self:SetAttribute("ACTIVE", action) 
               self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
            end
         end
      end
   ]])
   self[Name.."Button"]:SetAttribute("_onstate-shoulder", [[
      local modstate = self:GetAttribute("modstate")
      if modstate == 0 or modstate == 2 then
         if newstate == 6 or newstate == 3 or newstate == 2 then
            self:SetAttribute("modstate", 2)
            self:SetAttribute("modname", "SPADL")
            local binding = self:GetAttribute("SPADLBINDING")
            if binding ~= nil and binding ~= "" then
               local action = self:GetAttribute("SPADLACTION")
               self:SetAttribute("ACTIVE", action)
               self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
            end
         elseif newstate == 7 or newstate == 5 or newstate == 1 then
            self:SetAttribute("modstate", 2)
            self:SetAttribute("modname", "SPADR")
            local binding = self:GetAttribute("SPADRBINDING")
            if binding ~= nil and binding ~= "" then
               local action = self:GetAttribute("SPADRACTION")
               self:SetAttribute("ACTIVE", action)
               self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
            end
         else
            self:ClearBindings()
            local trigstate = self:GetAttribute("trigstate")
            if trigstate == 4 then
               self:SetAttribute("modstate", 0)
               self:SetAttribute("modname", "")
               local binding = self:GetAttribute("BINDING")
               if binding ~= nil and binding ~= "" then
                  local action = self:GetAttribute("ACTION")
                  self:SetAttribute("ACTIVE", action) 
                  self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
               end
            else
               self:SetAttribute("modstate", 1)
               self:SetAttribute("modname", "")
               local binding = self:GetAttribute("TRIGBINDING")
               if binding ~= nil and binding ~= "" then
                  local action = self:GetAttribute("TRIGACTION")
                  self:SetAttribute("ACTIVE", action) 
                  self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
               end
            end
         end
      end
   ]])
   self[Name.."Button"]:SetAttribute("_onstate-paddle", [[                         
      local modstate = self:GetAttribute("modstate")
      if modstate == 0 or modstate == 3 then
         if newstate == 6 or newstate == 3 or newstate == 2 then
            self:SetAttribute("modstate", 3)
            self:SetAttribute("modname", "PPADL")
            local binding = self:GetAttribute("PPADLBINDING")
            if binding ~= nil and binding ~= "" then
               local action = self:GetAttribute("PPADLACTION")
               self:SetAttribute("ACTIVE", action)
               self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
            end
         elseif  newstate == 7 or newstate == 5 or newstate == 1 then
            self:SetAttribute("modstate", 3)
            self:SetAttribute("modname", "PPADR")
            local binding = self:GetAttribute("PPADRBINDING")
            if binding ~= nil and binding ~= "" then
               local action = self:GetAttribute("PPADRACTION")
               self:SetAttribute("ACTIVE", action)
               self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
            end
         else
            self:ClearBindings()
            local trigstate = self:GetAttribute("trigstate")
            if trigstate == 4 then
               self:SetAttribute("modstate", 0)
               self:SetAttribute("modname", "")
               local binding = self:GetAttribute("BINDING")
               if binding ~= nil and binding ~= "" then
                  local action = self:GetAttribute("ACTION")
                  self:SetAttribute("ACTIVE", action) 
                  self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
               end
            else
               self:SetAttribute("modstate", 1)
               self:SetAttribute("modname", "")
               local binding = self:GetAttribute("TRIGBINDING")
               if binding ~= nil and binding ~= "" then
                  local action = self:GetAttribute("TRIGACTION")
                  self:SetAttribute("ACTIVE", action) 
                  self:SetBindingClick(true, binding, self:GetName(), "LeftButton")
               end
            end
         end
      end
   ]])
   SecureHandlerWrapScript(self[Name.."Button"], "OnClick", self[Name.."Button"], [[
      if self:GetAttribute("ACTIVE")  then
         local action = self:GetAttribute("ACTIVE")
         --print(action)
         self:RunAttribute("ACTIVE", down)
      end
   ]])
end

function GamePadButtonsMixin:AddTriggerHandler()
   self:SetAttribute("triggerstate", 4)
   self:SetAttribute("_onstate-trigger", [[
      self:SetAttribute("triggerstate", newstate)
      local nbuttons = self:GetAttribute("NumModifierButtons")
      for i = 1,nbuttons do
         local button = self:GetFrameRef('ModifierButton'..i)
         if button ~= nil then
            button:SetAttribute("state-trigger", newstate)
         end
      end
      
      local GroupNavigator = self:GetFrameRef('GroupNavigator')
      if GroupNavigator ~= nil then
         GroupNavigator:SetAttribute("state-trigger", newstate)
      end
      
      local Crosshotbar = self:GetFrameRef('Crosshotbar')
      if Crosshotbar ~= nil then
         Crosshotbar:SetAttribute("state-trigger", newstate)
      end
   ]])
end

function GamePadButtonsMixin:AddShoulderHandler()
   self:SetAttribute("shoulderstate", 4)
   self:SetAttribute("_onstate-shoulder", [[
      self:SetAttribute("shoulderstate", newstate)
      local nbuttons = self:GetAttribute("NumModifierButtons")
      for i = 1,nbuttons do
         local button = self:GetFrameRef('ModifierButton'..i)
         if button ~= nil then
            button:SetAttribute("state-shoulder", newstate)
         end
      end

      local GroupNavigator = self:GetFrameRef('GroupNavigator')
      if GroupNavigator ~= nil then
         GroupNavigator:SetAttribute("state-shoulder", newstate)
      end
      
      local Crosshotbar = self:GetFrameRef('Crosshotbar')
      if Crosshotbar ~= nil then
         Crosshotbar:SetAttribute("state-shoulder", newstate)
      end
   ]])
end

function GamePadButtonsMixin:AddPaddleHandler()
   self:SetAttribute("paddlestate", 4)
   self:SetAttribute("_onstate-paddle", [[
      self:SetAttribute("paddlestate", newstate)
      local nbuttons = self:GetAttribute("NumModifierButtons")
      for i = 1,nbuttons do
         local button = self:GetFrameRef('ModifierButton'..i)
         if button ~= nil then
            button:SetAttribute("state-paddle", newstate)
         end
      end
      
      local GroupNavigator = self:GetFrameRef('GroupNavigator')
      if GroupNavigator ~= nil then
         GroupNavigator:SetAttribute("state-paddle", newstate)
      end
      
      local Crosshotbar = self:GetFrameRef('Crosshotbar')
      if Crosshotbar ~= nil then
         Crosshotbar:SetAttribute("state-paddle", newstate)
      end
   ]])
end

function GamePadButtonsMixin:AddExpandedHandler()
   self:SetAttribute("expandstate", 4)
   self:SetAttribute("_onstate-expanded", [[
      self:SetAttribute("expandstate", newstate)
      local Crosshotbar = self:GetFrameRef('Crosshotbar')
      if Crosshotbar ~= nil then
         Crosshotbar:SetAttribute("state-expanded", newstate)
      end
   ]])
end

function GamePadButtonsMixin:OnLoad()
   self:SetAttribute("GetActionBindings", GetActionBindings)
   self:SetAttribute("SetActionBindings", SetActionBindings)
   self:SetAttribute("SetButtonModified", SetButtonModified)

   self:AddTriggerHandler()
   self:AddShoulderHandler()
   self:AddPaddleHandler()
   self:AddExpandedHandler()
   
   self:CreateLeftTriggerButton()
   self:CreateRightTriggerButton()
   self:CreateLeftShoulderButton()
   self:CreateRightShoulderButton()
   self:CreateLeftPaddleButton()
   self:CreateRightPaddleButton()

   for i,button in ipairs(GamePadButtonList) do
      self:CreateModifierButton(button)
      SecureHandlerSetFrameRef(self, "ModifierButton"..i, self[button.."Button"])
   end
   self:SetAttribute("NumModifierButtons", #GamePadButtonList)

   self:RegisterEvent("PLAYER_ENTERING_WORLD")
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

function GamePadButtonsMixin:SetupGamePad()
   if config.GPCVars then
      SetCVar('GamePadEnable', config.GPEnable);
      SetCVar('GamePadEmulateShift', 'NONE');
      SetCVar('GamePadEmulateCtrl', 'NONE');
      SetCVar('GamePadEmulateAlt', 'NONE');
      SetCVar('GamePadCursorLeftClick', 'PAD6');
      SetCVar('GamePadCursorRightClick', 'PADBACK');
      SetCVar('GamePadCameraYawSpeed', config.GPYawSpeed);
      SetCVar('GamePadCameraPitchSpeed', config.GPPitchSpeed);
      SetCVar('GamePadSingleActiveID', config.GPDeviceID)
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
end

function GamePadButtonsMixin:ClearConfig()
   for button, attributes in pairs(config.PadActions) do
      self:SetAttribute(button, "")
   end
   ClearOverrideBindings(self.LeftTriggerButton);
   ClearOverrideBindings(self.RightTriggerButton);
   ClearOverrideBindings(self.LeftShoulderButton);
   ClearOverrideBindings(self.RightShoulderButton);
   ClearOverrideBindings(self.LeftPaddleButton);
   ClearOverrideBindings(self.RightPaddleButton);
end

function GamePadButtonsMixin:ApplyConfig()
   self:SetupGamePad()
   self:ClearConfig()
   for button, attributes in pairs(config.PadActions) do
      if ActionList[attributes.ACTION] then
         SetOverrideBinding(self, true, attributes.BIND, attributes.ACTION)
      elseif ModifierList[attributes.ACTION] then
         if attributes.ACTION == "LEFTHOTBAR" then
            SetOverrideBindingClick(self.LeftTriggerButton, true, attributes.BIND,
                                    self.LeftTriggerButton:GetName(), "LeftButton")            
         end
         if attributes.ACTION == "RIGHTHOTBAR" then
            SetOverrideBindingClick(self.RightTriggerButton, true, attributes.BIND,
                                    self.RightTriggerButton:GetName(), "LeftButton")
         end
         if attributes.ACTION == "LEFTSHOULDER" then
            SetOverrideBindingClick(self.LeftShoulderButton, true, attributes.BIND,
                                    self.LeftShoulderButton:GetName(), "LeftButton")
         end
         if attributes.ACTION == "RIGHTSHOULDER" then
            SetOverrideBindingClick(self.RightShoulderButton, true, attributes.BIND,
                                    self.RightShoulderButton:GetName(), "LeftButton")
         end
         if attributes.ACTION == "LEFTPADDLE" then
            SetOverrideBindingClick(self.LeftPaddleButton, true, attributes.BIND,
                                    self.LeftPaddleButton:GetName(), "LeftButton")
         end
         if attributes.ACTION == "RIGHTPADDLE" then
            SetOverrideBindingClick(self.RightPaddleButton, true, attributes.BIND,
                                    self.RightPaddleButton:GetName(), "LeftButton")
         end
      end

      for i,modifier in ipairs(GamePadModifierList) do
         if ModifierActions[ attributes[modifier .. "ACTION"] ] then
            if self[button.."Button"] ~= nil then
               self[button.."Button"]:SetAttribute(modifier .. "BINDING", attributes.BIND)
               self[button.."Button"]:SetAttribute(modifier .. "ACTION", ModifierActions[ attributes[modifier .. "ACTION" ] ])
            end
         end
         if ModifierActions[ attributes[modifier .. "TRIGACTION"] ] then
            if self[button.."Button"] ~= nil then
               self[button.."Button"]:SetAttribute(modifier .. "TRIGBINDING", attributes.BIND)
               self[button.."Button"]:SetAttribute(modifier .. "TRIGACTION", ModifierActions[ attributes[modifier .. "TRIGACTION"] ])
            end
         end
      end
      
      if ModifierActions[attributes.TRIGACTION] then
         if self[button.."Button"] ~= nil then
            self[button.."Button"]:SetAttribute("TRIGBINDING", attributes.BIND)
            self[button.."Button"]:SetAttribute("TRIGACTION", ModifierActions[attributes.TRIGACTION])
         end
      end
      self:SetAttribute(button, attributes.BIND)
   end
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
