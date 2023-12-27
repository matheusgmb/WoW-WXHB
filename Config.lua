local ADDON, addon = ...

CrossHotbar_DB = {
   ActivePreset = 3,
   Presets = {
      [1] = {
         Mutable = false,
         Name = "Gamepad_Preset",
         SwapType = 2,
         WXHBType = 2,
         PadActions = {
            FACER = {BIND="PAD2",         ACTION="CLEARTARGETING",   TRIGACTION="HOTBARBTN1",          SWAPACTION="GRPNAVRIGHT",      SWAPTRIGACTION="HOTBARBTN5"},
            FACEU = {BIND="PAD4",         ACTION="JUMP",             TRIGACTION="HOTBARBTN2",          SWAPACTION="GRPNAVUP",         SWAPTRIGACTION="HOTBARBTN6"},
            FACED = {BIND="PAD1",         ACTION="INTERACTTARGET",   TRIGACTION="HOTBARBTN3",          SWAPACTION="GRPNAVDOWN",       SWAPTRIGACTION="HOTBARBTN7"},
            FACEL = {BIND="PAD3" ,        ACTION="TOGGLEWORLDMAP",   TRIGACTION="HOTBARBTN4",          SWAPACTION="GRPNAVLEFT",       SWAPTRIGACTION="HOTBARBTN8"},
            DPADR = {BIND="PADDRIGHT",    ACTION="GRPNAVRIGHT",      TRIGACTION="HOTBARBTN5",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN9"},
            DPADU = {BIND="PADDUP",       ACTION="GRPNAVUP",         TRIGACTION="HOTBARBTN6",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN10"},
            DPADD = {BIND="PADDDOWN",     ACTION="GRPNAVDOWN",       TRIGACTION="HOTBARBTN7",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN11"},
            DPADL = {BIND="PADDLEFT",     ACTION="GRPNAVLEFT",       TRIGACTION="HOTBARBTN8",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN12"},
            STCKL = {BIND="PADLSTICK",    ACTION="MACRO CH_MACRO_1", TRIGACTION="MACRO CH_MACRO_1",    SWAPACTION="MACRO CH_MACRO_1", SWAPTRIGACTION="MACRO CH_MACRO_1"},
            STCKR = {BIND="PADRSTICK",    ACTION="TOGGLESHEATH",     TRIGACTION="EXTRAACTIONBUTTON1",  SWAPACTION="TOGGLESHEATH",     SWAPTRIGACTION="EXTRAACTIONBUTTON1"},
            SPADL = {BIND="PADLSHOULDER", ACTION="CAMERAPAGE1",      TRIGACTION="TARGETPREVIOUSENEMY", SWAPACTION="CAMERAPAGE2",      SWAPTRIGACTION="TARGETNEARESTENEMY"},
            SPADR = {BIND="PADRSHOULDER", ACTION="CAMERAPAGE2",      TRIGACTION="TARGETNEARESTENEMY",  SWAPACTION="CAMERAPAGE1",      SWAPTRIGACTION="TARGETPREVIOUSENEMY"},
            TRIGL = {BIND="PADLTRIGGER",  ACTION="LEFTHOTBAR",       TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            TRIGR = {BIND="PADRTRIGGER",  ACTION="RIGHTHOTBAR",      TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            PPADL = {BIND="PADPADDLE1",   ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            PPADR = {BIND="PADPADDLE2",   ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"}
         }
      },
      [2] = {
         Mutable = false,
         Name = "Keyboard_Preset",
         SwapType = 4,
         WXHBType = 2,
         PadActions = {
            FACER = {BIND="1",  ACTION="CLEARTARGETING",   TRIGACTION="HOTBARBTN1",          SWAPACTION="GRPNAVRIGHT",      SWAPTRIGACTION="HOTBARBTN5"},
            FACEU = {BIND="2",  ACTION="JUMP",             TRIGACTION="HOTBARBTN2",          SWAPACTION="GRPNAVUP",         SWAPTRIGACTION="HOTBARBTN6"},
            FACED = {BIND="3",  ACTION="INTERACTTARGET",   TRIGACTION="HOTBARBTN3",          SWAPACTION="GRPNAVDOWN",       SWAPTRIGACTION="HOTBARBTN7"},
            FACEL = {BIND="4" , ACTION="TOGGLEWORLDMAP",   TRIGACTION="HOTBARBTN4",          SWAPACTION="GRPNAVLEFT",       SWAPTRIGACTION="HOTBARBTN8"},
            DPADR = {BIND="5",  ACTION="GRPNAVRIGHT",      TRIGACTION="HOTBARBTN5",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN9"},
            DPADU = {BIND="6",  ACTION="GRPNAVUP",         TRIGACTION="HOTBARBTN6",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN10"},
            DPADD = {BIND="7",  ACTION="GRPNAVDOWN",       TRIGACTION="HOTBARBTN7",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN11"},
            DPADL = {BIND="8",  ACTION="GRPNAVLEFT",       TRIGACTION="HOTBARBTN8",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN12"},
            STCKL = {BIND="9",  ACTION="MACRO CH_MACRO_1", TRIGACTION="MACRO CH_MACRO_1",    SWAPACTION="MACRO CH_MACRO_1", SWAPTRIGACTION="MACRO CH_MACRO_1"},
            STCKR = {BIND="0",  ACTION="TOGGLESHEATH",     TRIGACTION="EXTRAACTIONBUTTON1",  SWAPACTION="TOGGLESHEATH",     SWAPTRIGACTION="EXTRAACTIONBUTTON1"},
            SPADL = {BIND="-",  ACTION="CAMERAPAGE1",      TRIGACTION="TARGETPREVIOUSENEMY", SWAPACTION="CAMERAPAGE2",      SWAPTRIGACTION="TARGETNEARESTENEMY"},
            SPADR = {BIND="=",  ACTION="CAMERAPAGE2",      TRIGACTION="TARGETNEARESTENEMY",  SWAPACTION="CAMERAPAGE1",      SWAPTRIGACTION="TARGETPREVIOUSENEMY"},
            TRIGL = {BIND="[",  ACTION="LEFTHOTBAR",       TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            TRIGR = {BIND="]",  ACTION="RIGHTHOTBAR",      TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            PPADL = {BIND="\\", ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            PPADR = {BIND="'",  ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"}
         }
      },
      [3] = {
         Mutable = false,
         Name = "SC_Preset",
         SwapType = 4,
         WXHBType = 2,
         PadActions = {
            FACER = {BIND="1",  ACTION="CLEARTARGETING",   TRIGACTION="HOTBARBTN1",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN5"},
            FACEU = {BIND="2",  ACTION="JUMP",             TRIGACTION="HOTBARBTN2",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN6"},
            FACED = {BIND="3",  ACTION="INTERACTTARGET",   TRIGACTION="HOTBARBTN3",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN7"},
            FACEL = {BIND="4" , ACTION="TOGGLEWORLDMAP",   TRIGACTION="HOTBARBTN4",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN8"},
            DPADR = {BIND="5",  ACTION="CLEARTARGETING",   TRIGACTION="HOTBARBTN9",          SWAPACTION="GRPNAVRIGHT",      SWAPTRIGACTION="HOTBARBTN9"},
            DPADU = {BIND="6",  ACTION="JUMP",             TRIGACTION="HOTBARBTN10",         SWAPACTION="GRPNAVUP",         SWAPTRIGACTION="HOTBARBTN10"},
            DPADD = {BIND="7",  ACTION="INTERACTTARGET",   TRIGACTION="HOTBARBTN11",         SWAPACTION="GRPNAVDOWN",       SWAPTRIGACTION="HOTBARBTN11"},
            DPADL = {BIND="8",  ACTION="TOGGLEWORLDMAP",   TRIGACTION="HOTBARBTN12",         SWAPACTION="GRPNAVLEFT",       SWAPTRIGACTION="HOTBARBTN12"},
            STCKL = {BIND="9",  ACTION="MACRO CH_MACRO_1", TRIGACTION="MACRO CH_MACRO_1",    SWAPACTION="MACRO CH_MACRO_1", SWAPTRIGACTION="MACRO CH_MACRO_1"},
            STCKR = {BIND="0",  ACTION="TOGGLESHEATH",     TRIGACTION="EXTRAACTIONBUTTON1",  SWAPACTION="TOGGLESHEATH",     SWAPTRIGACTION="EXTRAACTIONBUTTON1"},
            SPADL = {BIND="-",  ACTION="CAMERAPAGE1",      TRIGACTION="TARGETPREVIOUSENEMY", SWAPACTION="CAMERAPAGE2",      SWAPTRIGACTION="TARGETNEARESTENEMY"},
            SPADR = {BIND="=",  ACTION="CAMERAPAGE2",      TRIGACTION="TARGETNEARESTENEMY",  SWAPACTION="CAMERAPAGE1",      SWAPTRIGACTION="TARGETPREVIOUSENEMY"},
            TRIGL = {BIND="[",  ACTION="LEFTHOTBAR",       TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            TRIGR = {BIND="]",  ACTION="RIGHTHOTBAR",      TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            PPADL = {BIND="\\", ACTION="SWAPHOTBAR",       TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            PPADR = {BIND="'",  ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"}
         }
      },
      [4] = {
         Mutable = true,
         Name = "Custom",
         SwapType = 2,
         WXHBType = 2,
         PadActions = {
            FACER = {BIND="PAD2",         ACTION="CLEARTARGETING",   TRIGACTION="HOTBARBTN1",          SWAPACTION="GRPNAVRIGHT",      SWAPTRIGACTION="HOTBARBTN5"},
            FACEU = {BIND="PAD4",         ACTION="JUMP",             TRIGACTION="HOTBARBTN2",          SWAPACTION="GRPNAVUP",         SWAPTRIGACTION="HOTBARBTN6"},
            FACED = {BIND="PAD1",         ACTION="INTERACTTARGET",   TRIGACTION="HOTBARBTN3",          SWAPACTION="GRPNAVDOWN",       SWAPTRIGACTION="HOTBARBTN7"},
            FACEL = {BIND="PAD3" ,        ACTION="TOGGLEWORLDMAP",   TRIGACTION="HOTBARBTN4",          SWAPACTION="GRPNAVLEFT",       SWAPTRIGACTION="HOTBARBTN8"},
            DPADR = {BIND="PADDRIGHT",    ACTION="GRPNAVRIGHT",      TRIGACTION="HOTBARBTN5",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN5"},
            DPADU = {BIND="PADDUP",       ACTION="GRPNAVUP",         TRIGACTION="HOTBARBTN6",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN6"},
            DPADD = {BIND="PADDDOWN",     ACTION="GRPNAVDOWN",       TRIGACTION="HOTBARBTN7",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN7"},
            DPADL = {BIND="PADDLEFT",     ACTION="GRPNAVLEFT",       TRIGACTION="HOTBARBTN8",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN8"},
            STCKL = {BIND="PADLSTICK",    ACTION="MACRO CH_MACRO_1", TRIGACTION="MACRO CH_MACRO_1",    SWAPACTION="MACRO CH_MACRO_1", SWAPTRIGACTION="MACRO CH_MACRO_1"},
            STCKR = {BIND="PADRSTICK",    ACTION="TOGGLESHEATH",     TRIGACTION="EXTRAACTIONBUTTON1",  SWAPACTION="TOGGLESHEATH",     SWAPTRIGACTION="EXTRAACTIONBUTTON1"},
            SPADL = {BIND="PADLSHOULDER", ACTION="SWAPHOTBAR",       TRIGACTION="TARGETPREVIOUSENEMY", SWAPACTION="CAMERAPAGE2",      SWAPTRIGACTION="TARGETNEARESTENEMY"},
            SPADR = {BIND="PADRSHOULDER", ACTION="CAMERAPAGE2",      TRIGACTION="TARGETNEARESTENEMY",  SWAPACTION="CAMERAPAGE1",      SWAPTRIGACTION="TARGETPREVIOUSENEMY"},
            TRIGL = {BIND="PADLTRIGGER",  ACTION="LEFTHOTBAR",       TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            TRIGR = {BIND="PADRTRIGGER",  ACTION="RIGHTHOTBAR",      TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            PPADL = {BIND="PADPADDLE1",   ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
            PPADR = {BIND="PADPADDLE2",   ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"}
         }
      }
   }
}

addon.Config = {
   Mutable = true,
   Name = "Custom",
   SwapType = 2,
   WXHBType = 2,
   PadActions = {
      FACER = {BIND="PAD2",         ACTION="CLEARTARGETING",   TRIGACTION="HOTBARBTN1",          SWAPACTION="GRPNAVRIGHT",      SWAPTRIGACTION="HOTBARBTN5"},
      FACEU = {BIND="PAD4",         ACTION="JUMP",             TRIGACTION="HOTBARBTN2",          SWAPACTION="GRPNAVUP",         SWAPTRIGACTION="HOTBARBTN6"},
      FACED = {BIND="PAD1",         ACTION="INTERACTTARGET",   TRIGACTION="HOTBARBTN3",          SWAPACTION="GRPNAVDOWN",       SWAPTRIGACTION="HOTBARBTN7"},
      FACEL = {BIND="PAD3" ,        ACTION="TOGGLEWORLDMAP",   TRIGACTION="HOTBARBTN4",          SWAPACTION="GRPNAVLEFT",       SWAPTRIGACTION="HOTBARBTN8"},
      DPADR = {BIND="PADDRIGHT",    ACTION="GRPNAVRIGHT",      TRIGACTION="HOTBARBTN5",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN9"},
      DPADU = {BIND="PADDUP",       ACTION="GRPNAVUP",         TRIGACTION="HOTBARBTN6",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN10"},
      DPADD = {BIND="PADDDOWN",     ACTION="GRPNAVDOWN",       TRIGACTION="HOTBARBTN7",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN11"},
      DPADL = {BIND="PADDLEFT",     ACTION="GRPNAVLEFT",       TRIGACTION="HOTBARBTN8",          SWAPACTION="NONE",             SWAPTRIGACTION="HOTBARBTN12"},
      STCKL = {BIND="PADLSTICK",    ACTION="MACRO CH_MACRO_1", TRIGACTION="MACRO CH_MACRO_1",    SWAPACTION="MACRO CH_MACRO_1", SWAPTRIGACTION="MACRO CH_MACRO_1"},
      STCKR = {BIND="PADRSTICK",    ACTION="TOGGLESHEATH",     TRIGACTION="EXTRAACTIONBUTTON1",  SWAPACTION="TOGGLESHEATH",     SWAPTRIGACTION="EXTRAACTIONBUTTON1"},
      SPADL = {BIND="PADLSHOULDER", ACTION="CAMERAPAGE1",      TRIGACTION="TARGETPREVIOUSENEMY", SWAPACTION="CAMERAPAGE2",      SWAPTRIGACTION="TARGETNEARESTENEMY"},
      SPADR = {BIND="PADRSHOULDER", ACTION="CAMERAPAGE2",      TRIGACTION="TARGETNEARESTENEMY",  SWAPACTION="CAMERAPAGE1",      SWAPTRIGACTION="TARGETPREVIOUSENEMY"},
      TRIGL = {BIND="PADLTRIGGER",  ACTION="LEFTHOTBAR",       TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
      TRIGR = {BIND="PADRTRIGGER",  ACTION="RIGHTHOTBAR",      TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
      PPADL = {BIND="PADPADDLE1",   ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"},
      PPADR = {BIND="PADPADDLE2",   ACTION="NONE",             TRIGACTION="NONE",                SWAPACTION="NONE",             SWAPTRIGACTION="NONE"}
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
   local facebuttons = {self.PadActions.FACER.BIND, self.PadActions.FACEU.BIND,
                        self.PadActions.FACED.BIND, self.PadActions.FACEL.BIND}
   local dpadbuttons = {self.PadActions.DPADR.BIND, self.PadActions.DPADU.BIND,
                        self.PadActions.DPADD.BIND, self.PadActions.DPADL.BIND}

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
      to.SwapType = from.SwapType
      to.WXHBType = from.WXHBType
      for button, attributes in pairs(from.PadActions) do
         for key, value in pairs(attributes) do
            to.PadActions[button][key] = value 
         end
      end
   end
end

function addon.Config:ProcessConfig(config)
end

local config = addon.Config
local preset = CrossHotbar_DB.ActivePreset;
config:StorePreset(config, CrossHotbar_DB.Presets[preset])
