---
-- Class to represent and display Toasts.
-- Each toast will be displayed according to the provided parameters, and can
-- be reused. A toast can belong to a group. Each time a toast belonging to a group
-- is displayed any toast pertaining to that group that is being displayed
-- will be dismissed.
-- Uses `hs.alert` behind the scenes.
--
-- This module returns a `func` used to instantiate toasts. See usage in the function below.
-- @classmod dkb.toast

local DEF_DURATION = 0.5
local DEF_FADE_DURATION = 0.1
local DEF_PADDING = 6

local groups = {}

--- Function returned by this module when imported. Used to create Modal instances.
-- @tparam string[opt] message Text to display.
-- @tparam string[opt] group Group name.
-- @tparam int[opt] duration Time the toast will be displayed.
-- @tparam table[opt] params Parameters acccepted by `hs.alert.show`. At the moment the following
-- parameters are accepted:
--
-- * padding
-- * fadeInDuration
-- * fadeOutDuration
-- @function dkb.toast
-- @usage
-- local Toast = require("dkb.toast") --> Import class
--
-- -- Instantiate toasts in group main
-- local t1 = Toast("1", "main")
-- local t2 = Toast("2", "main")
-- 
-- -- t2 will dismiss t1 and show itself
-- t1.show()
-- t2.show()
--
local function Toast(message, group, duration, params)
    local self = {}

    --- Dismiss toast.
    -- @treturn Toast toast object
    -- @function dismiss
    function self.dismiss()
        if self.toast ~= nil then
            hs.alert.closeSpecific(self.toast, self.params.fadeOutDuration or DEF_FADE_DURATION)
            self.toast = nil
        end

        return self
    end

    --- Dismiss any toast pertaining to the provided group
    -- @function dismiss_group
    function self.dismiss_group(group)
        if groups[group] then
            groups[group].dismiss()
        end
        groups[group] = nil
    end

    --- Display the toast.
    -- @treturn Toast toast object
    -- @function show
    function self.show()
        if self.group then
            self.dismiss_group(self.group)
            groups[self.group] = self
        end

        self.toast = hs.alert(self.message, {
            fillColor = { white = 0, alpha = 0.4 },
            strokeColor = { alpha = 0 },
            strokeWidth = 0,
            textColor = { white = 1, alpha = 1 },
            radius = 0,
            padding = self.params.padding or DEF_PADDING,
            atScreenEdge = 0,
            fadeInDuration = self.params.fadeInDuration or DEF_FADE_DURATION,
            fadeOutDuration = self.params.fadeOutDuration or DEF_FADE_DURATION,
        }, self.duration)

        return self
    end

    ---
    -- @tparam string message Message to display 
    -- @treturn Toast toast object
    -- @function set_message
    function self.set_message(message)
        self.message = message
        return self
    end

    ---
    -- @tparam int duration
    -- @treturn Toast toast object
    -- @function set_duration
    function self.set_duration(duration)
        self.duration = duration
        return self
    end

    ---
    -- @tparam table params See `dkb.toast` for reference.
    -- @treturn Toast toast object
    -- @function set_params
    function self.set_params(params)
        self.params = params
        return self
    end

    self.message = message
    self.duration = duration or DEF_DURATION
    self.params = params or {}
    self.group = group

    return self
end

return Toast