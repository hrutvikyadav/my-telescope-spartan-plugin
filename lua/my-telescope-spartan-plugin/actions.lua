local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local transform_mod = require("telescope.actions.mt").transform_mod

local mod = {}

-- Edit selected task with your editor (configured inside taskrc)
mod.task_edit = function(prompt_bufnr)
    -- your code goes here
    -- You can access the picker/global state as described above in (1).
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()

    vim.cmd("tabedit term://task edit " .. selection.value.id)
end

-- Show task info and KEEP terminal to run further commands
mod.task_terminal = function(prompt_bufnr)
    -- your code goes here
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    -- print(vim.inspect(selection))
    vim.cmd("tabedit term://zsh")
    print( vim.fn.expand("%") )
    -- Wait for a moment to ensure the terminal initializes
    vim.defer_fn(function()
        -- Get the job ID of the terminal
        local job_id = vim.b.terminal_job_id
        if job_id then
            -- Send a command to the terminal
            vim.fn.chansend(job_id, "echo 'Hello from Neovim'\n")

            -- Send another command (example)
            vim.fn.chansend(job_id, "ls -la\n")

            -- The terminal will remain interactive after the commands
        else
            print("No terminal job found!")
        end
    end, 100) -- Delay of 100ms to allow the terminal to initialize
    -- vim.api.nvim_put({ selection.display }, "", false, true)
end

-- Show task info
mod.task_info = function(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    -- print(vim.inspect(selection))
    print("Task ID: ", selection.value.id)
    vim.cmd("edit term://task " .. selection.value.id)
    -- vim.api.nvim_put({ selection.display }, "", false, true)
end

mod = transform_mod(mod)

return mod
-- Now the following is possible. This means that actions a2 will be executed
-- after action a1. You can chain as many actions as you want.
-- local action = mod.a1 + mod.a2
-- action(bufnr)

