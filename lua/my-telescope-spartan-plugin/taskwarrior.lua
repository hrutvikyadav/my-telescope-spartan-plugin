---@class TaskwarriorModule
local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require("telescope.previewers")
local utils = require("telescope.previewers.utils")
local log = require("plenary.log"):new()
log.level = 'debug'

M.taskwarrior = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "tasks",
        -- finder = finders.new_table({
        --     results = {
        --         { "task1", "#1",},
        --         { "task2", "#2",},
        --         { "task3", "#3",},
        --     },
        --     entry_maker = function(entry)
        --         return {
        --             value = entry,
        --             display = entry[1],
        --             ordinal = entry[1] .. entry[2],
        --         }
        --     end
        -- }),
        finder = finders.new_async_job({
            command_generator = function()
                -- return { "docker", "images", "--format", "json" }
                -- return { "task", "export", ">", "jq", "'.'" }
                return { "task", "export" }
            end,
            entry_maker = function(entry)
                local parsed_data = vim.json.decode(entry)
                -- log.debug(parsed_data)
                return {
                    value = parsed_data,
                    display = parsed_data.description .. tostring(parsed_data.id),
                    ordinal = ( parsed_data.project or "" ) .. parsed_data.description,
                }
            end
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                -- print(vim.inspect(selection))
                print("Task ID: ", selection.value.id)
                vim.cmd("edit term://task " .. selection.value.id)
                -- vim.api.nvim_put({ selection.display }, "", false, true)
            end)

            actions.select_tab:replace(function ()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()

                vim.cmd("tabedit term://task edit " .. selection.value.id)
            end)

            map({"n", "i"}, "<C-i>", function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                -- print(vim.inspect(selection))
                print("Task ID: ", selection.value.id)
                vim.cmd("edit term://task " .. selection.value.id)
                -- vim.api.nvim_put({ selection.display }, "", false, true)
            end)

            map({"n", "i"}, "<C-e>", function()
                require("my-telescope-spartan-plugin.actions").a1(prompt_bufnr)
            end)

            map({"n", "i"}, "<C-t>", function()
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
            end)

            return false -- WARNING: THIS WILL not map default telescope bindings if false
        end,
        previewer = previewers.new_buffer_previewer({
            title = "Task Details",
            define_preview = function (self, entry)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, true, vim.tbl_flatten( {
                    "# Task ID",
                    "**" .. tostring(entry.value.id) .. "**",
                    entry.value.description,
                    "```lua",
                    vim.split(vim.inspect(entry.value), "\n"),
                    "```",
                }))
                utils.highlighter(self.state.bufnr, "markdown")
            end
        })
    }):find()
end

-- tasks(require("telescope.themes").get_dropdown{})
-- NOTE: tasks() calls the picker

return M
