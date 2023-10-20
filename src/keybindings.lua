---
-- Module to set keybindings
-- This module is the base of dkb. You can use it by itself or together
-- with the other modules to produce very readable and self-documented
-- files of lua code that set-up the keybindings. See the examples below
-- for the recommended usage.
-- @module dkb.keybindings

local hotkey = require("hs.hotkey")
local keycodes = require("hs.keycodes")

Bindings = {}

---Bind mod+key to an action.
-- It is recommended to use `Bindings:bindmod` instead.
-- @tparam string mods String containing the necessary modifier. Same as supported by hs.hotkey. 
-- @tparam string key String representing the key to be mapped. See hs.keycodes.map.
-- @tparam func action Function to be executed when the keybinding is pressed.
-- @function Bindings:bind
-- @see Bindings:bindmod

function Bindings:bind(mods, key, action)
    -- Bind in modal if some modal is active, bind globally otherwise
    if self.modal then
        self.modal:bind(mods, keycodes.map[key], action)
    else
        hotkey.bind(mods, keycodes.map[key], action)
    end
end


--- Returns a function that binds a key with a specific mod to a default action.
-- The action can receive parameters or can be replaced with a provided one. This 
-- allows for aliasing modifier combinations, making them easily identificable through
-- the code.
-- @tparam string mods String containing the necessary modifier. Same as supported by hs.hotkey. 
-- @tparam func action Default function to be called if none are provided
-- @treturn func A function that can be used to declare mappings with the provided modifier
-- @usage
-- mod1 = keybindings:bindmod("⌃⌘", yabai.cmd)
--
-- mod1("l", "window --focus east") --> Will execute yabai.cmd with provied argument
-- mod1("p", print, "key p pressed") --> Will print "key p pressed" when pressing ⌃⌘+p
-- @function Bindings:bindmod
function Bindings:bindmod(mods, default_function)
    local self = self

    return function(key, action, ...)
        local args = {...}

        self:bind(mods, key, function()
            coroutine.wrap(function()
                if type(action) == "function" then
                    action(table.unpack(args))
                else
                    default_function(action, table.unpack(args))
                end
            end)()
        end)
    end
end

-- A simgleton class, so no need for constructor
return Bindings