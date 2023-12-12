local ADDON, addon = ...

CrossHotbar_DB = {
   ActivePreset = 2,
   Presets = {
      [1] = {
         Mutable = false,
         Name = "Gamepad_Preset",
         LeftModifier = "PADLTRIGGER",
         RightModifier = "PADRTRIGGER",
         SwapModifier = "PADLSHOULDER",
         SwapType = 2,
         WXHBType = 2,
         FaceButtons = {"PAD2", "PAD4", "PAD1", "PAD3"},
         DPadButtons = {"PADDRIGHT", "PADDUP", "PADDDOWN", "PADDLEFT"},
         TPadButtons = {"PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER"},
         SPadButtons = {"PADLSTICK", "PADRSTICK", "PADPADDLE1", "PADPADDLE2"}
      },
      [2] = {
         Mutable = false,
         Name = "Keyboard_Preset",
         LeftModifier = "CTRL",
         RightModifier = "SHIFT",
         SwapModifier = "ALT",
         SwapType = 4,
         WXHBType = 2,
         FaceButtons = {"1", "2", "3", "4"},
         DPadButtons = {"5", "6", "7", "8"},
         TPadButtons = {"CTRL", "SHIFT", "-", "="},
         SPadButtons = {"9", "0", "ALT", "ALT"}
      },
      [3] = {
         Mutable = true,
         Name = "Custom",
         LeftModifier = "PADLTRIGGER",
         RightModifier = "PADRTRIGGER",
         SwapModifier = "PADLSHOULDER",
         SwapType = 2,
         WXHBType = 2,
         FaceButtons = {"PAD2", "PAD4", "PAD1", "PAD3"},
         DPadButtons = {"PADDRIGHT", "PADDUP", "PADDDOWN", "PADDLEFT"},
         TPadButtons = {"PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER"},
         SPadButtons = {"PADLSTICK", "PADRSTICK", "PADPADDLE1", "PADPADDLE2"}
      }
   }
}

addon.Config = {
   Mutable = true,
   Name = "Custom",
   LeftModifier = "PADLTRIGGER",
   RightModifier = "PADRTRIGGER",
   SwapModifier = "PADLSHOULDER",
   SwapType = 2,
   WXHBType = 2,
   FaceButtons = {"PAD2", "PAD4", "PAD1", "PAD3"},
   DPadButtons = {"PADDRIGHT", "PADDUP", "PADDDOWN", "PADDLEFT"},
   TPadButtons = {"PADLTRIGGER", "PADRTRIGGER", "PADLSHOULDER", "PADRSHOULDER"},
   SPadButtons = {"PADLSTICK", "PADRSTICK", "PADPADDLE1", "PADPADDLE2"}
}
-- Returns position dependant list of pairs
-- for action button bindings for buttons [1-12].
-- First pair entry is for non-swap (ALT) bindings.
-- Second pair entry is for swap (ALT) bindings
-- based on SwapType.
function addon.Config:GetKeyBindings()
   local bindings = {}
   
   for i,binding in ipairs(self.FaceButtons) do
      table.insert(bindings, {binding, ""})
   end
   
   if self.SwapType == 1 then
      -- [5-8] on DPad.
      for i,binding in ipairs(self.DPadButtons) do
         table.insert(bindings, {binding, ""})
      end
      -- [9-12] empty.
      for i in 1,4 do
         table.insert(bindings, {"", ""})
      end
   end
   
   if self.SwapType == 2 then
      -- [5-8] on DPad with swap.
      for i,binding in ipairs(self.DPadButtons) do
         table.insert(bindings, {binding, self.FaceButtons[i]})
      end
      -- [9-12] empty.
      for i=1,4 do
         table.insert(bindings, {"", ""})
      end
   end

   if self.SwapType == 3 then
      -- [5-8] on DPad.
      for i,binding in ipairs(self.DPadButtons) do
         table.insert(bindings, {binding, ""})
      end
      -- [9-12] on Face with swap.
      for i,binding in ipairs(self.FaceButtons) do
         table.insert(bindings, {"", binding})
      end
   end
   
   if self.SwapType == 4 then
      -- [5-8] on Face with swap.
      for i,binding in ipairs(self.FaceButtons) do
         table.insert(bindings, {"", binding})
      end

      -- [9-12] to DPad.
      for i,binding in ipairs(self.DPadButtons) do
         table.insert(bindings, {binding, ""})
      end
   end
   
   return bindings
end

function addon.Config:AddModifier(bindings, modifier)
   for i,binding in ipairs(bindings) do
      bindings[i][1] = modifier .. binding[1]
      bindings[i][2] = "ALT-" .. modifier .. binding[2]
   end
   return bindings
end

function addon.Config:GetKeyBindingsLeft()
   return self:AddModifier(self:GetKeyBindings(), "CTRL-")
end

function addon.Config:GetKeyBindingsRight()
   return self:AddModifier(self:GetKeyBindings(), "SHIFT-")
end

function addon.Config:GetKeyBindingsRightLeft()
   return self:AddModifier(self:GetKeyBindings(), "CTRL-SHIFT-")
end

function addon.Config:PrintBindings(bindings)
   binding_str = ""
   for i,binding_pair in ipairs(bindings) do
       binding_str = binding_str .. "[" .. i .."]{" 
      for j,binding in ipairs(binding_pair) do
         binding_str = binding_str .. "\"" .. binding .. "\""
         if j == 1 then
            binding_str = binding_str .. ","
         end
      end
      binding_str = binding_str .. "}\n"
   end
   print(binding_str)
end

function addon.Config:StorePreset(to, from)
   if to.Mutable then
      if from.Mutable then
         to.Name = from.Name
      end
      to.LeftModifier = from.LeftModifier
      to.RightModifier = from.RightModifier
      to.SwapModifier = from.SwapModifier
      to.SwapType = from.SwapType
      to.WXHBType = from.WXHBType
      to.FaceButtons = {unpack(from.FaceButtons)}
      to.DPadButtons = {unpack(from.DPadButtons)}
      to.TPadButtons = {unpack(from.TPadButtons)}
      to.SPadButtons = {unpack(from.SPadButtons)}
   end
end

function addon.Config:ProcessConfig(config)
   if config.Mutable then
      local leftfound, rightfound, swapfound = false,false,false
      for i, item in ipairs(config.TPadButtons) do
         if item == config.LeftModifier then leftfound = true end
         if item == config.RightModifier then rightfound = true end
         if item == config.SwapModifier then swapfound = true end
      end
      for i, item in ipairs(config.SPadButtons) do
         if item == config.LeftModifier then leftfound = true end
         if item == config.RightModifier then rightfound = true end
         if item == config.SwapModifier then swapfound = true end
      end
      if leftfound == false then config.LeftModifier = nil end
      if rightfound == false then config.RightModifier = nil end
      if swapfound == false then config.SwapModifier = nil end
   end
end

local config = addon.Config
local preset = CrossHotbar_DB.ActivePreset;
config:StorePreset(config, CrossHotbar_DB.Presets[preset])
