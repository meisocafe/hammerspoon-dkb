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

-- Transforms options form to something hs.hotkey.bind can understand
function transform_options(action, options)
    local pressed = options.pressed or true
    local released = options.released or false
    local hold_repeat = options.hold_repeat or false

    if pressed and type(pressed) ~= "function" then
        pressed = action
    end
    if release and type(release) ~= "function" then
        release = action
    end
    if hold_repeat and type(hold_repeat) ~= "function" then
        hold_repeat = action
    end

    return pressed, release, hold_repeat
end

---Bind mod+key to an action.
-- It is recommended to use `Bindings:bindmod` instead.
-- @tparam string mods String containing the necessary modifier. Same as supported by hs.hotkey. 
-- @tparam string key String representing the key to be mapped. See hs.keycodes.map.
-- @tparam func action Function to be executed when the keybinding is pressed.
-- @tparam table options Table containing the possible options. Defaults to function called on
-- press if an empty table is passed. Each option can accept a `bool` or `func`.
-- If `bool` is provied and true, action will be invoked. If `func` is provided, it will be
-- invoked instead.
-- Possible options are:
--
-- - `pressed`: defaults to `true`
--
-- - `released`: defaults to `false`
--
-- - `hold_repeat`: defaults to `false`
--
-- @function Bindings:bind
-- @see Bindings:bindmod

function Bindings:bind(mods, key, action, options)
    -- Parse options
    local pressed, release, hold_repeat = transform_options(action, options)

    -- Bind in modal if some modal is active, bind globally otherwise
    if self.modal then
        self.modal:bind(mods, keycodes.map[key], pressed, release, hold_repeat)
    else
        hotkey.bind(mods, keycodes.map[key], pressed, release, hold_repeat)
    end
end


--- Returns a function that binds a key with a specific mod to a default action.
-- The action can receive parameters or can be replaced with a provided one. This 
-- allows for aliasing modifier combinations, making them easily identificable through
-- the code.
-- @tparam string mods String containing the necessary modifier. Same as supported by hs.hotkey. 
-- @tparam func action Default function to be called if none are provided
-- @treturn func Function be used to declare bindings with the provided mods and default_function
-- documented in `Binding:bindmod:return`.
-- @usage
-- mod1 = keybindings:bindmod("⌃⌘", yabai.cmd)
--
-- mod1("l", "window --focus east") --> Will execute yabai.cmd with provied argument
-- mod1("p", print, "key p pressed") --> Will print "key p pressed" when pressing ⌃⌘+p
-- @function Bindings:bindmod
-- @see Binding:bindmod:return
function Bindings:bindmod(mods, default_function)
    local self = self

    --- Returned functions
    -- @section Returns
    
    --- Function returned by Bindings:bindmod
    -- @tparam string key String representing the key to be mapped. See hs.keycodes.map.
    -- @tparam func[opt] action If provided as second argument, the provided function will be called
    -- instead of the default_function.
    -- @tparam string[opt] arguments Each separate string will be passed in order as arguments to
    -- either the default function or to action if provided as second param.
    -- @tparam table[opt] options if last argument is a table, it will be interepreted as options
    -- same as `Bindings:bind`.
    -- @function Binding:bindmod:return
    -- @see Bindings:bindmod
    -- @see Bindings:bind

    return function(key, action, ...)
        local args = {...}
        local options = {}

        -- Check last arg, to see if it's an options parameter (table type)
        if #args > 0 then
            if type(args[#args]) == "table" then
                options = table.remove(args, #args)
            end
        end

        self:bind(mods, key, function()
            coroutine.wrap(function()
                if type(action) == "function" then
                    action(table.unpack(args))
                else
                    default_function(action, table.unpack(args))
                end
            end)()
        end, options)
    end
end

-- A simgleton class, so no need for constructor
return Bindings