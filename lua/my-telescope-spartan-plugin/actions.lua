local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local transform_mod = require("telescope.actions.mt").transform_mod

local mod = {}

-- Edit selected task with your editor (configured inside taskrc)
mod.task_edit = function(prompt_bufnr)
  -- your code goes here
  -- You can access the picker/global state as described above in (1).
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()

  vim.cmd("tabedit term://task edit " .. selection.value.uuid)
end

-- Show task info and KEEP terminal to run further commands
mod.task_terminal = function(prompt_bufnr)
  -- your code goes here
  actions.close(prompt_bufnr)
  -- local selection = action_state.get_selected_entry()
  -- print(vim.inspect(selection))
  vim.cmd("tabedit term://zsh")
  print(vim.fn.expand("%"))
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
  print("Task ID: ", selection.value.uuid)
  vim.cmd("edit term://task " .. selection.value.uuid)
  -- vim.api.nvim_put({ selection.display }, "", false, true)
end

mod.task_start = function(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()

    vim.cmd("edit term://task start " .. selection.value.uuid .. " && task_refresh.sh")
end

mod.task_stop = function(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()

    vim.cmd("edit term://task stop " .. selection.value.uuid .. " && task_refresh.sh")
end

mod.task_annotate = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  -- EXPERIMENTAL : start
  -- local annotation = vim.fn.input("\nYour annotation> ")
  -- print(annotation)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf})
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf})

  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, buf)

  vim.notify_once("Type your annotation here and press <leader>w to save it", vim.log.levels.INFO)

  local function save_annotation()
    local lines = vim.api.nvim_buf_get_lines(buf, 0 , -1, false)
    local annotation = table.concat(lines, "\n")
    print(annotation)
    vim.api.nvim_win_close(0, true)

    -- vim.cmd("edit term://task " .. selection.value.id .. " annotate '" .. annotation .. "'")

    vim.cmd("tabedit term://zsh")

    vim.defer_fn(function()
      local job_id = vim.b.terminal_job_id
      if job_id then
        local c1 = "task " .. selection.value.uuid .. " annotate '" .. annotation .. "'"

        vim.fn.chansend(job_id, c1)

      else
        print("No terminal job found!")
      end
    end, 100)
  end

  vim.api.nvim_buf_set_keymap(buf, "n", "<leader>w", "", {
    callback = save_annotation,
    noremap = true,
    silent = true,
    desc = "write and quit scratch buffer"
  })

  --
  -- EXPERIMENTAL : end

  -- vim.cmd("edit term://task " .. selection.value.id .. " annotate '" .. annotation .. "'")
  -- task 67 annotate ""
end

mod.tasks_weekly_log = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  -- local selection = action_state.get_selected_entry()

  vim.cmd("tabedit term://zsh")

  vim.defer_fn(function()
    local job_id = vim.b.terminal_job_id
    if job_id then
      local c1 = "weekly-worklog\n"
      local c2 = "weekly-timelog\n"

      vim.fn.chansend(job_id, c1)

      vim.fn.chansend(job_id,c2)

    else
      print("No terminal job found!")
    end
  end, 100)
end

mod.task_info_and_worklog_comments = function (prompt_bufnr)
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()

  vim.cmd("edit term://task " .. selection.value.uuid .. " && worklog-comments.sh " .. selection.value.uuid)
  -- vim.cmd("!task " .. selection.value.id .. " export | !jq -r '.annotations[] | .description' | clip.exe")
end

mod.task_browse = function (prompt_bufnr)
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()

  vim.cmd("!browse-jira-task.sh " .. selection.value.uuid)
end

mod = transform_mod(mod)

return mod
-- Now the following is possible. This means that actions a2 will be executed
-- after action a1. You can chain as many actions as you want.
-- local action = mod.a1 + mod.a2
-- action(bufnr)
