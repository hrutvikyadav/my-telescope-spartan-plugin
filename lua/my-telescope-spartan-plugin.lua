-- main module file
local module = require("my-telescope-spartan-plugin.module")

---@class Config
---@field opt string Your config option
local config = {
  opt = "Hello!",
    features = {
        ""
    },
}

---@class MyModule
local M = {}

M.tasklist_enable = function(arg)
    print("calling taskwarrior enable")
    vim.api.nvim_create_user_command("SpartanTasks", arg, {})
end

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

    if M.config.features[1] == "Task" then
        local taskwarrior = require("my-telescope-spartan-plugin.taskwarrior")
        M.tasklist_enable(taskwarrior.task_list_browse)
    end
end

M.hello = function()
  print(module.my_first_function(M.config.opt))
end

return M
