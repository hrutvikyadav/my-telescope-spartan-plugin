---@class TelescopeTaskwarriorConfig
---@field features string[]
---@field keymaps? table<string, string>

---@class TelescopeTaskwarriorModule
local M = {}

---@type TelescopeTaskwarriorConfig
M.config = {
  features = { "Task" },
  keymaps = {},
}

---Setup the plugin with user configuration
---@param opts? TelescopeTaskwarriorConfig
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

---Get the current configuration
---@return TelescopeTaskwarriorConfig
function M.get_config()
  return M.config
end

return M
