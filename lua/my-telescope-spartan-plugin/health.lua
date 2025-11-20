local M = {}

local health = vim.health

function M.check()
    health.start("telescope-taskwarrior")

    -- Check for required dependencies
    if vim.fn.executable("task") == 1 then
        health.ok("taskwarrior found")
    else
        health.error("taskwarrior not found", { "Install taskwarrior: https://taskwarrior.org/download/" })
    end

    if vim.fn.executable("timew") == 1 then
        health.ok("timewarrior found")
    else
        health.warn("timewarrior not found", { "Some features require timewarrior: https://timewarrior.net/" })
    end

    -- Check for telescope
    local has_telescope, _ = pcall(require, "telescope")
    if has_telescope then
        health.ok("telescope.nvim found")
    else
        health.error(
            "telescope.nvim not found",
            { "Install telescope: https://github.com/nvim-telescope/telescope.nvim" }
        )
    end

    -- Check for plenary
    local has_plenary, _ = pcall(require, "plenary")
    if has_plenary then
        health.ok("plenary.nvim found")
    else
        health.error("plenary.nvim not found", { "Install plenary: https://github.com/nvim-lua/plenary.nvim" })
    end

    -- Check for optional harpoon
    local has_harpoon, _ = pcall(require, "harpoon")
    if has_harpoon then
        health.ok("harpoon found (optional)")
    else
        health.info("harpoon not found", { "Optional: Install for task_send_to_harpoon feature" })
    end

    -- Check external scripts
    local scripts = {
        "task_refresh.sh",
        "weekly-worklog",
        "weekly-timelog",
        "worklog-comments.sh",
        "browse-jira-task.sh",
    }

    for _, script in ipairs(scripts) do
        if vim.fn.executable(script) == 1 then
            health.ok(script .. " found")
        else
            health.info(script .. " not found in PATH", { "Some actions may not work without this script" })
        end
    end
end

return M
