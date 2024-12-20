vim.api.nvim_create_user_command("MyFirstFunction", require("my-telescope-spartan-plugin").hello, {})
print("loading my-telescope-spartan-plugin")
