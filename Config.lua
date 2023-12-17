local ADDON, addon = ...

CrossHotbar_DB = {
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
         PadActions = {
            FACER = {"PAD2", "CLEARTARGETING"},
            FACEU = {"PAD4", "JUMP"},
            FACED = {"PAD1", "INTERACTTARGET"},
            FACEL = {"PAD3" ,"TOGGLEWORLDMAP"},
            DPADR = {"PADDRIGHT", "GROUPNAVIGATIONRIGHT"},
            DPADU = {"PADDUP", "GROUPNAVIGATIONUP"},
            DPADD = {"PADDDOWN", "GROUPNAVIGATIONDOWN"},
            DPADL = {"PADDLEFT", "GROUPNAVIGATIONLEFT"},
            STCKL = {"PADLSTICK", "MACRO CH_MACRO_1"},
            STCKR = {"PADRSTICK", "TOGGLESHEATH", "EXTRAACTIONBUTTON1"},
            SPADL = {"PADLSHOULDER", "TARGETSCANENEMY", "TARGETPREVIOUSENEMY", "TARGETNEARESTENEMY"},
            SPADR = {"PADRSHOULDER", "NEXTACTIONPAGE", "TARGETNEARESTENEMY", "TARGETPREVIOUSENEMY"},
            TRIGL = {"PADLTRIGGER", "NONE"},
            TRIGR = {"PADRTRIGGER", "NONE"},
            PPADL = {"PADPADDLE1", "NONE"},
            PPADR = {"PADPADDLE2", "NONE"}
         }
      },
      [2] = {
         Mutable = false,
         Name = "Keyboard_Preset",
         LeftModifier = "CTRL",
         RightModifier = "SHIFT",
         SwapModifier = "ALT",
         SwapType = 4,
         WXHBType = 2,
         PadActions = {
            FACER = {"1", "CLEARTARGETING"},
            FACEU = {"2", "JUMP"},
            FACED = {"3", "INTERACTTARGET"},
            FACEL = {"4" ,"TOGGLEWORLDMAP"},
            DPADR = {"5", "GROUPNAVIGATIONRIGHT"},
            DPADU = {"6", "GROUPNAVIGATIONUP"},
            DPADD = {"7", "GROUPNAVIGATIONDOWN"},
            DPADL = {"8", "GROUPNAVIGATIONLEFT"},
            STCKL = {"9", "MACRO CH_MACRO_1"},
            STCKR = {"0", "TOGGLESHEATH", "EXTRAACTIONBUTTON1"},
            SPADL = {"-", "TARGETSCANENEMY", "TARGETPREVIOUSENEMY", "TARGETNEARESTENEMY"},
            SPADR = {"=", "NEXTACTIONPAGE", "TARGETNEARESTENEMY", "TARGETPREVIOUSENEMY"},
            TRIGL = {"CTRL", "NONE"},
            TRIGR = {"SHIFT", "NONE"},
            PPADL = {"ALT", "NONE"},
            PPADR = {"ALT", "NONE"}
         }
      },
      [3] = {
         Mutable = false,
         Name = "SC_Preset",
         LeftModifier = "CTRL",
         RightModifier = "SHIFT",
         SwapModifier = "ALT",
         SwapType = 4,
         WXHBType = 2,
         PadActions = {
            FACER = {"1", "CLEARTARGETING"},
            FACEU = {"2", "JUMP"},
            FACED = {"3", "INTERACTTARGET"},
            FACEL = {"4" ,"TOGGLEWORLDMAP"},
            DPADR = {"5", "CLEARTARGETING", "CLEARTARGETING", "GROUPNAVIGATIONRIGHT"},
            DPADU = {"6", "JUMP", "JUMP", "GROUPNAVIGATIONUP"},
            DPADD = {"7", "INTERACTTARGET", "INTERACTTARGET","GROUPNAVIGATIONDOWN"},
            DPADL = {"8", "TOGGLEWORLDMAP", "TOGGLEWORLDMAP","GROUPNAVIGATIONLEFT"},
            STCKL = {"9", "MACRO CH_MACRO_1"},
            STCKR = {"0", "TOGGLESHEATH", "EXTRAACTIONBUTTON1"},
            SPADL = {"-", "TARGETSCANENEMY", "TARGETPREVIOUSENEMY", "TARGETLASTHOSTILE"},
            SPADR = {"=", "NEXTACTIONPAGE", "TARGETNEARESTENEMY", "ASSISTTARGET"},
            TRIGL = {"CTRL", "NONE"},
            TRIGR = {"SHIFT", "NONE"},
            PPADL = {"ALT", "NONE"},
            PPADR = {"ALT", "NONE"}
         }
      },
      [4] = {
         Mutable = true,
         Name = "Custom",
         LeftModifier = "PADLTRIGGER",
         RightModifier = "PADRTRIGGER",
         SwapModifier = "PADLSHOULDER",
         SwapType = 2,
         WXHBType = 2,
         PadActions = {
            FACER = {"PAD2", "CLEARTARGETING"},
            FACEU = {"PAD4", "JUMP"},
            FACED = {"PAD1", "INTERACTTARGET"},
            FACEL = {"PAD3" ,"TOGGLEWORLDMAP"},
            DPADR = {"PADDRIGHT", "GROUPNAVIGATIONRIGHT"},
            DPADU = {"PADDUP", "GROUPNAVIGATIONUP"},
            DPADD = {"PADDDOWN", "GROUPNAVIGATIONDOWN"},
            DPADL = {"PADDLEFT", "GROUPNAVIGATIONLEFT"},
            STCKL = {"PADLSTICK", "MACRO CH_MACRO_1"},
            STCKR = {"PADRSTICK", "TOGGLESHEATH", "EXTRAACTIONBUTTON1"},
            SPADL = {"PADLSHOULDER", "TARGETSCANENEMY", "TARGETPREVIOUSENEMY", "TARGETNEARESTENEMY"},
            SPADR = {"PADRSHOULDER", "NEXTACTIONPAGE", "TARGETNEARESTENEMY", "TARGETPREVIOUSENEMY"},
            TRIGL = {"PADLTRIGGER", "NONE"},
            TRIGR = {"PADRTRIGGER", "NONE"},
            PPADL = {"PADPADDLE1", "NONE"},
            PPADR = {"PADPADDLE2", "NONE"}
         }
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
   PadActions = {
         FACER = {"PAD2", "CLEARTARGETING"},
         FACEU = {"PAD4", "JUMP"},
         FACED = {"PAD1", "INTERACTTARGET"},
         FACEL = {"PAD3" ,"TOGGLEWORLDMAP"},
         DPADR = {"PADDRIGHT", "GROUPNAVIGATIONRIGHT"},
         DPADU = {"PADDUP", "GROUPNAVIGATIONUP"},
         DPADD = {"PADDDOWN", "GROUPNAVIGATIONDOWN"},
         DPADL = {"PADDLEFT", "GROUPNAVIGATIONLEFT"},
         STCKL = {"PADLSTICK", "MACRO CH_MACRO_1"},
         STCKR = {"PADRSTICK", "TOGGLESHEATH", "EXTRAACTIONBUTTON1"},
         SPADL = {"PADLSHOULDER", "TARGETSCANENEMY", "TARGETPREVIOUSENEMY", "TARGETNEARESTENEMY"},
         SPADR = {"PADRSHOULDER", "NEXTACTIONPAGE", "TARGETNEARESTENEMY", "TARGETPREVIOUSENEMY"},
         TRIGL = {"PADLTRIGGER", "NONE"},
         TRIGR = {"PADRTRIGGER", "NONE"},
         PPADL = {"PADPADDLE1", "NONE"},
         PPADR = {"PADPADDLE2", "NONE"}
   }
}

function addon.Config:GetSwapBinding(button)
   if self.SwapType == 1 then
      return nil
   end
   if button == "DPADR" then
      return self.PadActions.FACER
   end
   if button == "DPADU" then
      return self.PadActions.FACEU
   end
   if button == "DPADD" then
      return self.PadActions.FACED
   end
   if button == "DPADL" then
      return self.PadActions.FACEL
   end
end

-- Returns position dependant list of pairs
-- for action button bindings for buttons [1-12].
-- First pair entry is for non-swap (ALT) bindings.
-- Second pair entry is for swap (ALT) bindings
-- based on SwapType.
function addon.Config:GetKeyBindings()
   local bindings = {}
   local facebuttons = {self.PadActions.FACER[1], self.PadActions.FACEU[1],
                        self.PadActions.FACED[1], self.PadActions.FACEL[1]}
   local dpadbuttons = {self.PadActions.DPADR[1], self.PadActions.DPADU[1],
                        self.PadActions.DPADD[1], self.PadActions.DPADL[1]}
   
   for i,binding in ipairs(facebuttons) do
      table.insert(bindings, {binding, ""})
   end
   
   if self.SwapType == 1 then
      -- [5-8] on DPad.
      for i,binding in ipairs(dpadbuttons) do
         table.insert(bindings, {binding, ""})
      end
      -- [9-12] empty.
      for i=1,4 do
         table.insert(bindings, {"", ""})
      end
   end
   
   if self.SwapType == 2 then
      -- [5-8] on DPad with swap.
      for i,binding in ipairs(dpadbuttons) do
         table.insert(bindings, {binding, facebuttons[i]})
      end
      -- [9-12] empty.
      for i=1,4 do
         table.insert(bindings, {"", ""})
      end
   end

   if self.SwapType == 3 then
      -- [5-8] on DPad.
      for i,binding in ipairs(dpadbuttons) do
         table.insert(bindings, {binding, ""})
      end
      -- [9-12] on Face with swap.
      for i,binding in ipairs(facebuttons) do
         table.insert(bindings, {"", binding})
      end
   end
   
   if self.SwapType == 4 then
      -- [5-8] on Face with swap.
      for i,binding in ipairs(facebuttons) do
         table.insert(bindings, {"", binding})
      end

      -- [9-12] to DPad.
      for i,binding in ipairs(dpadbuttons) do
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
      for button, bindings in pairs(from.PadActions) do
         to.PadActions[button] = {unpack(bindings)} 
      end
   end
end

function addon.Config:ProcessConfig(config)
   if config.Mutable then
      local a = config.PadActions
      local leftfound, rightfound, swapfound = false,false,false
      for i, item in ipairs({a.TRIGL[1], a.TRIGR[1], a.SPADL[1], a.SPADR[1]}) do
         if item == config.LeftModifier then leftfound = true end
         if item == config.RightModifier then rightfound = true end
         if item == config.SwapModifier then swapfound = true end
      end
      for i, item in ipairs({a.STCKL[1], a.STCKR[1], a.PPADL[1], a.PPADR[1]}) do
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
