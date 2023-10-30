---
-- Class to bind keys only when specific window(s) are focused.
-- Uses `hs.window.filter` to filter windows and `hs.hotkey.modal` to set the bindings 
-- behind the scenes.
-- This class acts the same as a `dkb.modal`, this is important to consider if nesting them.
-- Use it in combination with `dkb.keybindings` to easily define modals and bind keys
-- to them.
--
-- This module returns a `func` used to instantiate modals. See usage in the function below.
-- @classmod dkb.filter
-- @see dkb.modal

local Modal = require("dkb.modal")
local w_filter = require("hs.window.filter")

--- Function returned by this module when imported. Used to create Filter instances.
-- @tparam hs.window.filter filter Defines on which windows to act
-- @tparam func[opt] init_function The provied function will be executed on modal creation.
-- Keybindings inside the function will map to the modal.
-- @function dkb.filter
-- @usage
-- local Filter = require("dkb.filter") --> Import class
-- local wf = require("hs.window.filter")
-- loal keystroke = require("hs.eventtap.keyStroke")
--
-- mod3 = keybindings:bindmod("⌃", keystroke) 
--
-- local test_modal = Filter(wf.new{'Floorp','Firefox'}, --> Filter by window title
--    function(filter)
--     -- Mappings will be active only when the windows described by the filter 
--     -- are focused.
--     -- Send down/up arrow when pressing ctrl+j/k
--     mod3("j", "", "down") 
--     mod3("k", "", "up") 
-- end)
-- @see dkb.keybindings
local function Filter(filter, init_function)
    --- Properties of this class instance
    -- @field modal `dkb.modal` object that gets activated when the fiter conditions are met    
    -- @field w_filter `hs.window.filter` object provided on initialization
    -- @table dkb.filter

    local self = {
        modal = Modal(init_function),
        w_filter = filter
    }

    --# Public

    --- Execute a function with bindings enabled.
    -- This means that bindigns executed within the function will be bound
    -- to the filter.
    -- @tparam func `func` Function to be executed.
    -- @param arg Any extra argument will be passed to the provided function.
    -- @function bind

    function self.bind(func, ...)
        self.modal.bind(func, ...)
    end

    --# Private

    function enter()
        self.modal.enter()
    end

    function exit()
        self.modal.exit()
    end

    -- self.modal.enter
    self.w_filter:subscribe(w_filter.windowFocused, enter)
    self.w_filter:subscribe(w_filter.windowUnfocused, exit)


    return self
end

return Filter