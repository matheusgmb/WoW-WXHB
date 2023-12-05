
UtilityButtonsMixin = {}

function UtilityButtonsMixin:OnLoad()
   self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function UtilityButtonsMixin:OnEvent(event, ...)
   if event == 'PLAYER_ENTERING_WORLD' then
      SetOverrideBindingClick(self, true, "5", self:GetName(), "RightButton")
      SetOverrideBindingClick(self, true, "0", self:GetName(), "MiddleButton")
   end
end
