---
-- Class to bind keys within modals.
-- Uses `hs.hotkey.modal` behind the scenes.
-- Use it in combination with `dkb.keybindings` to easily define modals and bind keys
-- to them.
-- If you want to filter keybindings based on the focuse window, see `dkb.filter`.
-- Nesting modals is possible, the one activated on top (later) will have precedence over 
-- the previous one and so on. Nesting can get out of hand quickly so be sure you understand
-- how it works if you want to get creative with it.
--
-- This module returns a `func` used to instantiate modals. See usage in the function below.
-- @classmod dkb.modal
-- @see dkb.filter

local hotkey = require("hs.hotkey")
local bindings = require("dkb.keybindings")

--- Function returned by this module when imported. Used to create Modal instances.
-- @tparam func[opt] init_function The provied function will be executed on modal creation.
-- Keybindings inside the function will map to the modal.
-- @function dkb.modal
-- @usage
-- local Modal = require("dkb.modal") --> Import class
--
-- local test_modal = Modal(function(modal) --> Define new modal
--     -- Actions will be mapped only when the modal is active
--     mod1("p", print, "printing from inside modal!") 
--     -- Action to exit modal
--     mod1("s", modal.exit, function(modal) print("exit test modal") end) 
-- end)
--
-- -- Map action to enter modal
-- mod1("s", stack_modal.enter, function(modal) print("enter modal") end)
-- @see dkb.keybindings
local function Modal(init_function)
    local self = {}

    self.modal = hotkey.modal.new()

    --# Private

    local function enable_bindings(enable)
        if enable then
            bindings.modal = self.modal
        else
            bindings.modal = nil
        end
    end

    --# Public

    --- Enter modal. Activates it's keybindings.
    -- @tparam func[opt] action Function to be executed after entering the modal.
    -- @function enter
    function self.enter(action)
        self.modal:enter()

        if action then
            action(self)
        end
    end

    --- Exit modal. Deactivates it's keybindings and restores previous ones.
    -- @tparam func[opt] action Function to be executed after exiting the modal.
    -- @function exit
    function self.exit(action)
        self.modal:exit()

        if action then
            action(self)
        end
    end

    --- Execute a function with bindings enabled.
    -- This means that bindigns executed within the function will be bound
    -- to the modal only.
    -- @tparam func `func` Function to be executed.
    -- @param arg Any extra argument will be passed to the provided function.
    -- @function bind

    function self.bind(func, ...)
        enable_bindings(true)
        func(...)
        enable_bindings(false)
    end

    -- Self Initialization

    -- Execute init function with bindings enabled if provided
    if init_function then
        self.bind(init_function, self)
    end

    return self
end


return Modal