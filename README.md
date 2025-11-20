# telescope-taskwarrior

A Neovim Telescope extension for taskwarrior/timewarrior workflow integration.

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/hrutvikyadav/my-telescope-spartan-plugin/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

## Requirements

- Neovim >= 0.8.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [taskwarrior](https://taskwarrior.org/) (tested with 3.2.0)
- [timewarrior](https://timewarrior.net/) (optional, for time tracking features)
- [harpoon](https://github.com/ThePrimeagen/harpoon) (optional, for task_send_to_harpoon)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrutvikyadav/my-telescope-spartan-plugin",
  },
  opts = {
    extensions = {
      ["my-telescope-spartan-plugin"] = {
        features = {
          "Task",
        },
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("my-telescope-spartan-plugin")
  end,
}
```

## Usage

Use with Telescope command:

```vim
:Telescope my-telescope-spartan-plugin taskwarrior
```

Or with a keymap:

```lua
vim.keymap.set("n", "<leader>sst", "<cmd>Telescope my-telescope-spartan-plugin taskwarrior<cr>", { desc = "Taskwarrior Tasks" })
```

Or programmatically:

```lua
vim.keymap.set("n", "<leader>sst", function()
  require("telescope").extensions["my-telescope-spartan-plugin"].taskwarrior()
end)
```

## Keymaps

The picker provides these default keymaps:

| Key | Action | Description |
|-----|--------|-------------|
| `<CR>` | select_default | Show task info in terminal |
| `<C-t>` | task_terminal | Open interactive terminal |
| `<C-i>` | task_info | Show task info with worklog comments |
| `<C-e>` | task_edit | Edit task in your configured editor |
| `<C-s>` | task_start | Start task |
| `<C-x>` | task_stop | Stop task |
| `<C-a>` | task_annotate | Add annotation to task |
| `<C-b>` | task_browse | Open task in Jira browser |
| `<C-l>` | tasks_weekly_log | Show weekly work/time log |
| `<C-h>` | task_send_to_harpoon | Send task to harpoon one_off list |

## External Scripts

Some actions depend on external scripts that should be in your PATH:

- `task_refresh.sh` - Refresh task state after start/stop
- `weekly-worklog` - Generate weekly work log
- `weekly-timelog` - Generate weekly time log
- `worklog-comments.sh` - Get worklog comments for a task
- `browse-jira-task.sh` - Open task in Jira browser

## Health Check

Run `:checkhealth my-telescope-spartan-plugin` to verify your setup.

## License

MIT
