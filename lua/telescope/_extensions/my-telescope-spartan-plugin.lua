local picker_exports = {}

return require("telescope").register_extension {
  setup = function(ext_config, config)
    -- access extension config and user config
    if ext_config.features[1] == "Task" then
        picker_exports.taskwarrior = require("my-telescope-spartan-plugin.taskwarrior").taskwarrior
    end
  end,
  exports = picker_exports,
}
