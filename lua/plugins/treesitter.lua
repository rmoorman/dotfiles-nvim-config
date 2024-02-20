return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    local setup = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        -- install all available languages for less hassle
        -- install them automatically
        -- and install as many at once as possible
        ensure_installed = "all",
        ignore_install = {},
        auto_install = true,
        sync_install = false,

        -- enable highlighting and indenting based on treesitter
        highlight = { enable = true },
        indent = { enable = true },

        -- custom modules to use
        modules = {},
      })
    end

    -- Defer setup until after the first render to improve startup time when
    -- editing a file directly (e.g. `nvim example_file.py`)
    vim.defer_fn(setup, 0)
  end
}
