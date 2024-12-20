local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local transform_mod = require("telescope.actions.mt").transform_mod

local mod = {}
mod.a1 = function(prompt_bufnr)
    -- your code goes here
    -- You can access the picker/global state as described above in (1).
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()

    vim.cmd("tabedit term://task edit " .. selection.value.id)
end

mod.a2 = function(prompt_bufnr)
    -- your code goes here
end
mod = transform_mod(mod)

return mod
-- Now the following is possible. This means that actions a2 will be executed
-- after action a1. You can chain as many actions as you want.
-- local action = mod.a1 + mod.a2
-- action(bufnr)

