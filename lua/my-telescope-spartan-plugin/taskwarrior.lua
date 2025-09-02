---@class TaskwarriorModule
local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local utils = require("telescope.previewers.utils")
local log = require("plenary.log"):new()
log.level = "debug"

local default_action_maps = {
  task_info = "<C-i>",
  task_edit = "<C-e>",
  task_terminal = "<C-t>",
  task_start = "<C-s>",
  task_stop = "<C-x>",
  task_annotate = "<C-a>",
  task_browse = "<C-b>",
  tasks_weekly_log = "<C-l>",
  task_send_to_harpoon = "<C-h>",
}

M.taskwarrior = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Project:Description:Status:Tag(s)",
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
            ordinal = (parsed_data.project or "") .. ":" .. parsed_data.description .. ":" .. parsed_data.status,
          }
        end,
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

        actions.select_tab:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          vim.cmd("tabedit term://task edit " .. selection.value.id)
        end)

        map({ "n", "i" }, "<C-i>", function()
          -- require("my-telescope-spartan-plugin.actions").task_info(prompt_bufnr)
          require("my-telescope-spartan-plugin.actions").task_info_and_worklog_comments(prompt_bufnr)
        end)

        map({ "n", "i" }, "<C-e>", function()
          require("my-telescope-spartan-plugin.actions").task_edit(prompt_bufnr)
        end)

        map({ "n", "i" }, "<C-t>", function()
          require("my-telescope-spartan-plugin.actions").task_terminal(prompt_bufnr)
        end)

        map({ "n", "i" }, "<C-s>", function()
          require("my-telescope-spartan-plugin.actions").task_start(prompt_bufnr)
        end)

        map({ "n", "i" }, "<C-x>", function()
          require("my-telescope-spartan-plugin.actions").task_stop(prompt_bufnr)
        end)

        map({ "n", "i" }, "<C-l>", function()
          require("my-telescope-spartan-plugin.actions").tasks_weekly_log(prompt_bufnr)
        end)

        return true -- WARNING: THIS WILL not map default telescope bindings if false
      end,
      previewer = previewers.new_buffer_previewer({
        title = "Task Details",
        define_preview = function(self, entry)
          vim.api.nvim_buf_set_lines(
            self.state.bufnr,
            0,
            0,
            true,
            vim.tbl_flatten({
              "# Task ID",
              "**" .. tostring(entry.value.id) .. "**",
              entry.value.description,
              "```lua",
              vim.split(vim.inspect(entry.value), "\n"),
              "```",
            })
          )
          utils.highlighter(self.state.bufnr, "markdown")
        end,
      }),
    })
    :find()
end

M.taskwarrior_init = function(ext_config)
  -- default_action_maps = ext_config.maps.actions or default_action_maps -- INFO: Disable user config for now
  vim.print(ext_config)

  local f = function(opts)
    opts = opts or {}
    pickers
      .new(opts, {
        prompt_title = "Project:Description:Status:Tag(s)",
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
              display = parsed_data.description .. " ID: " .. tostring(parsed_data.id),
              ordinal = (parsed_data.project or "") .. ":" .. parsed_data.description .. ":" .. parsed_data.status .. ( parsed_data.tags and ":" .. table.concat(parsed_data.tags, ":") or "" ),
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            -- print(vim.inspect(selection))
            print("Task ID: ", selection.value.uuid)
            vim.cmd("edit term://task " .. selection.value.uuid)
            -- vim.api.nvim_put({ selection.display }, "", false, true)
          end)

          actions.select_tab:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()

            vim.cmd("tabedit term://task edit " .. selection.value.uuid)
          end)

          map({ "n", "i" }, default_action_maps.task_info , function()
            require("my-telescope-spartan-plugin.actions").task_info_and_worklog_comments(prompt_bufnr)
          end)

          map({ "n", "i" }, default_action_maps.task_edit, function()
            require("my-telescope-spartan-plugin.actions").task_edit(prompt_bufnr)
          end)

          map({ "n", "i" }, default_action_maps.task_terminal, function()
            require("my-telescope-spartan-plugin.actions").task_terminal(prompt_bufnr)
          end)

          map({ "n", "i" }, default_action_maps.task_start, function()
            require("my-telescope-spartan-plugin.actions").task_start(prompt_bufnr)
          end)

          map({ "n", "i" }, default_action_maps.task_stop, function()
            require("my-telescope-spartan-plugin.actions").task_stop(prompt_bufnr)
          end)

          map({ "n", "i" }, default_action_maps.task_annotate, function()
            require("my-telescope-spartan-plugin.actions").task_annotate(prompt_bufnr)
          end)

          map({ "n", "i" }, default_action_maps.task_browse, function()
            require("my-telescope-spartan-plugin.actions").task_browse(prompt_bufnr)
          end)

          map({ "n", "i" }, default_action_maps.tasks_weekly_log, function()
            require("my-telescope-spartan-plugin.actions").tasks_weekly_log(prompt_bufnr)
          end)

          map({ "n", "i" }, default_action_maps.task_send_to_harpoon, function()
            require("my-telescope-spartan-plugin.actions").task_send_to_harpoon_one_off(prompt_bufnr)
          end)

          return true -- WARNING: THIS WILL not map default telescope bindings if false
        end,
        previewer = previewers.new_buffer_previewer({
          title = "Task Details",
          define_preview = function(self, entry)
            vim.api.nvim_buf_set_lines(
              self.state.bufnr,
              0,
              0,
              true,
              vim.tbl_flatten({
                "# Task ID",
                "**" .. tostring(entry.value.id) .. "**",
                entry.value.description,
                "```lua",
                vim.split(vim.inspect(entry.value), "\n"),
                "```",
              })
            )
            utils.highlighter(self.state.bufnr, "markdown")
          end,
        }),
      })
      :find()

  end
  return f
end

  -- tasks(require("telescope.themes").get_dropdown{})
  -- NOTE: tasks() calls the picker

  return M
