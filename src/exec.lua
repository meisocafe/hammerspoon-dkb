---
-- Module to easily invoke os commands.
-- Powered by hs.task, launches async tasks and can wait for them
-- synchronously inside a coroutine through applicationYield function.
-- @module dkb.exec

local Task = require("hs.task")

local invoke = function(cmd, args, completion, wait)
    split_args = {}
    for arg in args:gmatch("[^ ]+") do table.insert(split_args, arg) end
    
    -- Initialize variables
    local output = ""
    local error = ""
    local taskIsDone = false

    -- Prepare task and output parse
    local cmd_task = Task.new(cmd, nil, function(task, stdout, stderr)
        if stdout ~= nil then
            output = output .. stdout
        end

        if stderr ~= nil then
            error = error .. stderr
        end

        return true
    end, split_args)

    -- Mark task comletion and run callback if necessary
    cmd_task:setCallback(function()
        taskIsDone = true
        if type(completion) == "function" then
            completion(output, error)
        end
    end)

    -- Start task
    cmd_task:start()

    -- Wait if necessary
    if wait then
        while not taskIsDone do
            coroutine.applicationYield()
        end
        return cmd_task:terminationStatus(), output, error
    end

    return cmd_task
end

--- Executes a cmd asyncrhonously
-- @tparam string cmd Command to execute (needs full path)
-- @tparam string args Arguments in a string separated by a space
-- @tparam[opt] func completion Executed after the task finishes
-- @treturn hs.task The task that was started with the provided cmd and args
-- @function async 
local invoke_async = function(cmd, args, completion)
    return invoke(cmd, args, completion, false)
end

---Executes a cmd syncrhonously
-- @tparam string cmd Command to execute (needs full path)
-- @tparam string args Arguments in a string separated by a space
-- @tparam[opt] func completion Executed after the task finishes before returning
-- @treturn int|string|string Return code, stdout and stderr of the executed cmd
-- @function sync
local invoke_sync = function(cmd, args, completion)
    local result, out, err = invoke(cmd, args, nil, true)

    if completion then
        completion()
    end

    return result, out, err
end

return {
    async = invoke_async,
    sync = invoke_sync
}