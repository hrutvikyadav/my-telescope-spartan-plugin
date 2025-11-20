# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Neovim Telescope extension for taskwarrior/timewarrior workflow integration. Allows browsing, searching, and managing taskwarrior tasks directly from Telescope.

## Commands

### Run Tests
```bash
make test
```

Tests use plenary.nvim's busted test framework in headless Neovim.

## Architecture

### Entry Point
- `lua/telescope/_extensions/my-telescope-spartan-plugin.lua` - Telescope extension registration; conditionally exports the `taskwarrior` picker based on config

### Core Modules
- `lua/my-telescope-spartan-plugin/taskwarrior.lua` - Main picker implementation using `task export` JSON output; defines entry maker, sorter, previewer, and key mappings
- `lua/my-telescope-spartan-plugin/actions.lua` - All custom Telescope actions (task_edit, task_start, task_stop, task_annotate, task_browse, task_send_to_harpoon, etc.)

### Key Bindings (defaults)
- `<C-i>` - Task info with worklog comments
- `<C-e>` - Edit task
- `<C-t>` - Open terminal
- `<C-s>` - Start task
- `<C-x>` - Stop task
- `<C-a>` - Annotate task
- `<C-b>` - Browse (open in Jira)
- `<C-l>` - Weekly log
- `<C-h>` - Send to harpoon

### Dependencies
- taskwarrior (tested with 3.2.0)
- timewarrior
- telescope.nvim
- plenary.nvim
- harpoon (for task_send_to_harpoon action)

### External Scripts Expected
Some actions call external shell scripts: `task_refresh.sh`, `weekly-worklog`, `weekly-timelog`, `worklog-comments.sh`, `browse-jira-task.sh`
