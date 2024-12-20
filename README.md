# Neovim plugin for better taskwarrior/timewarrior workflow

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

## Installation

> [!HINT]
> Depends on taskwarrior and telescope plugin for neovim
> I am using `taskwarrior 3.2.0`


- Lazy
```lua
-- add as telescope dependency
{
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    -- or                              , branch = '0.1.x',
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        -- "nvim-telescope/telescope-dap.nvim",
        -- INFO: my first plugin extension wohoo!
        "hrutvikyadav/my-telescope-spartan-plugin",
    },
    opts = {
        extensions = {
            ["my-telescope-spartan-plugin"] = {
                features = {
                    "Task",
                    -- "Time", WARN: yet to be implemented
                    -- "Bug",  WARN: yet to be implemented
                },
            },
        },
    }
    -- somewhere after setup, preferrably in config function :
    config = function()
        -- load 

        -- Use with `Telescope my-telescope-spartan-plugin taskwarrior`
        -- OR
        -- set a key map
        vim.keymap.set("n", "<leader>sst", "<cmd>Telescope my-telescope-spartan-plugin taskwarrior<cr>", { desc = "Taskwarrior Tasks" })

        -- NOTE: also possible to use with lua ->
        -- vim.keymap.set("n", "<leader>sst", function()
        --     local config_opts = {} -- optional config for picker
        --     -- example config ->
        --     -- config_opts = require("telescope.themes").get_dropdown{}
        --     require("telescope").extensions["my-telescope-spartan-plugin"].taskwarrior(config_opts)
        -- end
    end
}
```

```diff
diff --git a/lua/plugins/telescope.lua b/lua/plugins/telescope.lua
index a56a125..a3e468b 100644
--- a/lua/plugins/telescope.lua
+++ b/lua/plugins/telescope.lua
@@ -6,6 +6,8 @@ local M = {
         "nvim-lua/plenary.nvim",
         { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
         -- "nvim-telescope/telescope-dap.nvim",
+        -- INFO: my first plugin extension wohoo!
+        { dir = "~/pers/my-telescope-spartan-plugin" },
     },
 }
 
@@ -24,12 +26,21 @@ function M.config()
             ["ui-select"] = {
                 require("telescope.themes").get_dropdown(),
             },
+            ["my-telescope-spartan-plugin"] = {
+                features = {
+                    "Task",
+                    -- "Time",
+                    -- "Bug",
+                },
+            },
         },
     })
 
     require("telescope").load_extension("fzf")
     pcall(require("telescope").load_extension, "ui-select")
     -- require('telescope').load_extension('dap')
+    require("telescope").load_extension("my-telescope-spartan-plugin")
+
 
     local builtin = require("telescope.builtin")
     vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "TELESCOPE [s]earch pwd [f]iles" })
@@ -67,6 +78,9 @@ function M.config()
     vim.keymap.set("n", "<leader>sn", function()
         builtin.find_files({ cwd = vim.fn.stdpath("config") })
     end, { desc = "[S]earch [N]eovim files" })
+
+    vim.keymap.set("n", "<leader>sst", "<cmd>Telescope my-telescope-spartan-plugin taskwarrior<cr>", { desc = "Taskwarrior Tasks" })
+
 end
 
 return M
```

## TODO
### Actions for
- [ ] start and stop tasks along with time tracking
- [ ] reports
- [ ] some other utilities I wrote for logging weekly work and so on...
